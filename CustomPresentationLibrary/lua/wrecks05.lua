--[[ * Copyright 2023 Esri
 *
 * Licensed under the Apache License Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ]]

--Wrecks05.lua is new at 11.4. New point symbols K1_Obstruction4mm_InDepthRangeWk.svg ,  K1_Obstruction4mm_shoalWk.svg and K1_Obstruction4mm_DryWk.svg
--Add the WRECKS05 function for points and area geometry to the CustomSymbolMap.xml to enable this script.
-- This script is simliar to WRECKS05 ConditionalSymbologyProcedure 13.2.20 of the S52 Presentation library S-52 Annex A, Part I

require 'sndfrm04' 
require 'symbolize_depth'

-- Get the least depth value 
local function getLeastDepth(feature, watlev, catwrk)
	local depth = 0
	if (catwrk == 1) then
		depth = 20.1
		if (feature.has_seabed_depth) then
			local least_depth = feature.seabed_depth - 66
			if (least_depth > 20.1) then
				depth = least_depth
			end
		end
	else
		if (watlev == 3 or watlev == 5) then 
			depth = 0
		else
			depth = -15
		end
	end
	return depth
end

function wrecks05(feature, context, symbology)
	-- Get the properties from the feature object
	local collection = symbology.collections[1]
	local watlev = tonumber(feature.attributes.WATLEV) or nil
	local catwrk = tonumber(feature.attributes.CATWRK) or nil
	local least_depth = feature.least_depth
	local has_valsou = false
	local valsou = tonumber(feature.attributes.VALSOU) or nil
	local has_greatest_depth = feature.has_greatest_depth
	local greatest_depth = feature.greatest_depth
	local swept_depth = feature.swept_depth
	local uncertained_depth = feature.uncertain_depth 
	local prim = feature.prim
	local low_accuracy = feature.low_accuracy
	local acronym = feature.acronym

	-- Check if the value of the attribute 'VALSOU' is given
	-- If so, set the least_depth to be valsou
	-- Otherwise, call getLeastDepth function to get the least_depth
	if (valsou) then
		has_valsou = true
		least_depth = valsou
	else
		if(not feature.has_least_depth) then 
			least_depth = getLeastDepth(feature, watlev, catwrk)
		end
	end

	-- If the value of the attribute 'VALSOU' is given, perform the symbology sub-procedure 'SNDFRM04',
	-- set the viewing group to be 34051 and call pre_symbolize_depth function from symbolize_depth.lua
	if (has_valsou) then
		-- arguments[0] is swept_depth, arguments[1] is uncertained_depth
		arguments_sndfrm04={feature.swept_depth, feature.uncertain_depth}
		sndfrm04_pre_symbolize(feature, arguments_sndfrm04)
		swept_depth = arguments_sndfrm04[0]
		uncertain_depth = arguments_sndfrm04[1]
		collection.ViewGroup = 34051
		pre_symbolize_depth(feature, valsou, symbology)
	end
	
	-- Call post_symbolize
	local arguments = {LEASTDEPTH=least_depth, HASGREATESTDEPTH=has_greatest_depth, GREATESTDEPTH=greatest_depth,
	WATLEV=watlev, CATWRK=catwrk, PRIM=prim, HASVALSOU=has_valsou, VALSOU=valsou, SWEPTDEPTH=swept_depth, 
	UNCERTAINDEPTH=uncertained_depth, BLOWACCURACY=low_accuracy, ACRONYM=acronym}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='wrecks05:post_symbolize', arguments=arguments})
	return true
end


function post_symbolize(arguments, context, symbology)
	local least_depth = arguments['LEASTDEPTH']
	local has_greatest_depth = arguments['HASGREATESTDEPTH']
	local greatest_depth = arguments['GREATESTDEPTH']
	local watlev = arguments['WATLEV']
	local catwrk = arguments['CATWRK']
	local prim = arguments['PRIM']
	local has_valsou = arguments['HASVALSOU']
	local valsou = arguments['VALSOU']
	local swept_depth = arguments['SWEPTDEPTH']
	local uncertain_depth = arguments['UNCERTAINDEPTH']
	local low_accuracy = arguments['BLOWACCURACY']
	local acronym=arguments['ACRONYM']

	local isolated_danger, isolated_danger_symbology = udwhaz05(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev)
	
	-- If it is point feature, call ContinuationA
	-- If it is area feature, call ContinuationB
	if(prim == 1) then
		return ContinuationA(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev, catwrk, has_valsou, valsou, swept_depth, uncertain_depth, low_accuracy, acronym)
	elseif(prim == 3) then
		return ContinuationB(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev, has_valsou, valsou, swept_depth, uncertain_depth, low_accuracy, acronym)
	end 

	return false
end

function udwhaz05(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev)
	local collection = symbology.collections[1]
	local safety_contour = context.safety_contour
	local isolated_danger = false
	local shallow_iso_danger = false
	local isolated_danger_symbology = false

	if(least_depth <= safety_contour) then
		if (has_greatest_depth and greatest_depth >= safety_contour) then
			isolated_danger = true
		elseif(context.show_shallow_dangers and has_greatest_depth and greatest_depth >= 0) then
			shallow_iso_danger = true
		end
	end

	if (isolated_danger) then
		-- If isolated_danger is true and the 'WATLEV' value is 1 or 2, do the below setting for the collection object
		if(watlev == 1 or watlev == 2) then 
			isolated_danger = false
			collection.ViewGroup = 14050
			collection.DisplayCategory = 'DISPLAYBASE'
			collection.DisplayPriority = 8
		else -- If isolated_danger is true and the 'WATLEV' value is not 1 or 2, do the below setting for the collection object
			collection.Scamin = 0x7fffffff
			collection.ViewGroup = 14010
			collection.DisplayCategory = 'DISPLAYBASE'
			collection.DisplayPriority = 8
			isolated_danger_symbology = true
		end
	elseif (shallow_iso_danger) then
		-- If isolated_danger is false & shallow_iso_danger is true & the 'WATLEV' value is 1 or 2, do the below setting for the collection object
		if (watlev == 1 or watlev == 2) then 
			shallow_iso_danger = false
			collection.ViewGroup = 24050
			collection.DisplayCategory = 'STANDARD'
			collection.DisplayPriority = 8
		else -- If isolated_danger is false & shallow_iso_danger is true & the 'WATLEV' value is not 1 or 2, do the below setting for the collection object
			collection.ViewGroup = 24020
			collection.DisplayCategory = 'STANDARD'
			collection.DisplayPriority = 8
			isolated_danger_symbology = true
		end
    end

	return((isolated_danger or shallow_iso_danger) and (not context.isolated_dangers_off)), isolated_danger_symbology
end

function ContinuationA(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev, catwrk, has_valsou, valsou, swept_depth, uncertain_depth, low_accuracy, acronym)
	local collection = symbology.collections[1]
	-- Call udwhaz05 to get isolated_danger and isolated_danger_symbology
	local isolated_danger, isolated_danger_symbology = udwhaz05(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev)
	-- If isolated_danger is true, set the symbol to be ISODGR01
	if(isolated_danger) then
		collection:add_symbology_instruction({type='Symbol', Name='ISODGR01'})--magenta x symbol
	else
		-- If isolated_danger is false and VALSOU value is not given, set the symbol as below
		if(not has_valsou) then
			local sym = "K25_Wreck_danger_no_depth.svg" --WRECKS05
			if(catwrk == 1 and watlev == 3) then
				sym = "K29_Wreck_notdangerous.svg" --WRECKS04
			elseif(catwrk == 2 and watlev == 3) then
				sym = "K25_Wreck_danger_no_depth.svg" --WRECKS05
			elseif(catwrk == 4) then
				sym = "K24_Wreck_showing_hull.svg" --WRECKS01
			elseif(catwrk == 5) then
				sym = "K24_Wreck_showing_hull.svg" --WRECKS01
			elseif(watlev >= 1 and watlev <= 4) then
				sym = "K24_Wreck_showing_hull.svg" --WRECKS01
			end
			collection:add_symbology_instruction({type='Symbol', Name=sym})
		else
			-- If isolated_danger is false and VALSOU value is given, set the symbol as below
			local sym = ""
			if(valsou < 0) then
				sym = "K1_Obstruction4mm_DryWk.svg"
			elseif(valsou <= context.safety_depth) then
				sym = "K1_Obstruction4mm_shoalWk.svg" --DANGER01
			else
				sym = "K1_Obstruction4mm_InDepthRangeWk.svg" --DANGER02
			end
			collection:add_symbology_instruction({type='Symbol', Name=sym})

			-- Call sndfrm04_post_symbolize from sndfrm04.lua
			local arguments = {DEPTH=valsou, SWEPTDEPTH=swept_depth, UNCERTAINDEPTH=uncertain_depth, ISOLATEDDANGER=isolated_danger_symbology, ACRONYM=acronym}
			sndfrm04_post_symbolize(arguments, context, symbology)
		end
	end
	if(low_accuracy) then
		-- Draw the low accuracy symbol
		local collection2 = symbology:add_symbology_collection({ViewGroup=31011, DisplayPriority=collection.DisplayPriority, DisplayCategory=collection.DisplayCategory})
	end
	return true
end

function ContinuationB(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev, has_valsou, valsou, swept_depth, uncertain_depth, low_accuracy, acronym)
	local collection = symbology.collections[1]
	local isolated_danger, isolated_danger_symbology = udwhaz05(context, symbology, least_depth, has_greatest_depth, greatest_depth, watlev)

	if(low_accuracy) then
		-- Draw the low accuracy symbol
		collection:add_symbology_instruction({type='ComplexLine', Name='LOWACC41', paint='LOWACC'})
	end

	if(isolated_danger) then
		-- If the isolcated_danger is true, draw the symbol as below
		collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DOT', width=.32, paint='HIGHACC'})
	else
		if(has_valsou) then
			if(valsou <= context.safety_depth) then 
				-- If the isolated_danger is false && VALSOU value is given && valsou <= context.safety_depth, draw the symbol as below
				collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DOT', width=.32, paint='HIGHACC'})
			else
				-- If the isolated_danger is false && VALSOU value is given && valsou > context.safety_depth, draw the symbol as below
				collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DASH', width=.32, paint='HIGHACC'})
			end
		else
			-- If the isolated_danger is false && VALSOU value is not given, draw the symbol as below
			local line_style = 'DOT'
			if (watlev==1 or watlev==2) then
				line_style = 'SOLID' 
			end 
			if (watlev==4) then
				line_style = 'DASH' 
			end 
			if (watlev==5 or watlev==3) then
				line_style = 'DOT' 
			end 
			collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style=line_style, width=.32, paint='HIGHACC'})
		end
	end

	if(has_valsou) then
		if(isolated_danger) then
			-- If VALSOU value is given and isolated_danger is true, draw the symbol as below
			collection:add_symbology_instruction({type='Symbol', Name='ISODGR01'})
		else
			-- If VALSOU value is given and isolated_danger is false, call sndfrm04_post_symbolize function
			local arguments = {DEPTH=valsou, SWEPTDEPTH=swept_depth, UNCERTAINDEPTH=uncertain_depth, ISOLATEDDANGER=isolated_danger_symbology, ACRONYM=acronym}
			sndfrm04_post_symbolize(arguments, context, symbology)
		end
	else
		-- If VALSOU value is not given, draw the symbol as below
		local color = '#d1deef' --'DEPVS'
		if(watlev == 1 or watlev == 2) then 
			color = '#f4e8c1' --'CHBRN'
		end
		if(watlev == 4) then 
			color = '#d6dbc9' --'DEPIT'
		end
		if(watlev == 5 or watlev == 3) then 
			color = '#d1deef' --'DEPVS'
		end
		collection:add_symbology_instruction({type="AreaFill", color=color, transparency=0})

		if(isolated_danger) then
			-- If VALSOU value is not given and isolated_danger is true, draw the symbol as below
			collection:add_symbology_instruction({type='Symbol', Name='ISODGR01'})
		end
	end

	if(low_accuracy) then
		-- Draw the low accuracy symbol
		local collection2 = symbology:add_symbology_collection({ViewGroup=31011, DisplayPriority=collection.DisplayPriority, DisplayCategory=collection.DisplayCategory})
		collection2:add_symbology_instruction({type='Symbol', Name='LOWACC01'})
	end

	return true
end

