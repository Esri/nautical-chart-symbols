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

require 'unit_conversion'

local function get_halo_color(context, depth)
	local color = '#d6dbc9' --'DEPIT'

	if depth >= 0 then
		color = '#d1deef' --'DEPVS'
	end

	local shallow_contour = context.shallow_contour
	if depth >= shallow_contour then
		color = '#ddebf7' --'DEPMS'
	end
		
	local safety_contour = context.safety_contour
	if depth >= safety_contour then
		color = '#ffffff' --'DEPMD'
	end
		
	deep_contour = context.deep_contour
	if depth >= deep_contour then
		color = '#ffffff' --'DEPMD'
	end

	return color
end

function pre_symbolize_depth(feature, depth, symbology)
	local swept_depth = false;
	local tecsou = feature.attributes:get_list_attribute('TECSOU')
	if contains(tecsou, {4,6}) then
		swept_depth = true
	end

	local uncertained_depth = false;
	local quasou = feature.attributes:get_list_attribute('QUASOU')
	if contains(quasou, {3,4,5,8,9}) then
		uncertained_depth = true
	end

	if uncertained_depth == false then
		local status = feature.attributes:get_list_attribute('STATUS')
		if contains(status, {18}) then
			uncertained_depth = true
		end
	end

	if feature.low_accuracy then
			uncertained_depth = true
	end

	local collection = symbology.collections[1]

	local arguments = {acronym=feature.acronym, swept_depth=swept_depth, uncertained_depth=uncertained_depth, depth=depth}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='symbolize_depth', arguments=arguments})

	collection.RemoveCSPs = true
end

function symbolize_depth(arguments, context, symbology)
	local acronym = arguments['acronym']
	local swept_depth = arguments['swept_depth']
	local uncertained_depth = arguments['uncertained_depth']
	local depth = arguments['depth']


--	Debug.log(tostring(swept_depth) .. ' ' .. tostring(uncertained_depth) .. ' ' .. tostring(depth))

	if(depth == nil) then
		return true
	end

	local sign = 1;
	if depth < 0 then
		sign = -1;
	end

	local color = 'SNDG1'
	if depth < context.safety_depth then
		color = 'SNDG2'
	end

	local halo_color = get_halo_color(context, depth)
--	Debug.log(tostring(depth) .. ' ' .. color .. ' ' .. halo_color)
	local weight = 'italic'
	local whole
	local fraction
	depth = math.abs(depth)
	local units = Units(depth, Units.meters)

	if context.depth_units == 1 then	-- meters
		whole = math.floor(depth)
		fraction = math.floor(depth * 10) % 10;
		if whole > 31 then	-- > 32 feet, don't display fraction
			fraction = 0
		end
	elseif context.depth_units == 2 then	-- feet
		whole = math.floor(units:get_value(Units.feet))	-- convert meters to feet and trucate fractional portion
		weight = 'medium'
		fraction = 0
	elseif context.depth_units == 3 then	-- fathoms and feet
		depth = units:get_value(Units.fathoms)	-- convert to fathoms
		whole = math.floor(depth)
		units:set_value(depth - whole, Units.fathoms) -- fractional fathoms
		fraction = math.floor(units:get_value(Units.feet)) 	-- convert fraction to feet
		if whole > 11 then	-- > 11 fathoms, don't display feet
			fraction = 0
		end
	end
	-- uncertained_depth is upright text, not italic (update 11.4)
	if uncertained_depth then
		weight = 'medium' 
	end


--	Debug.log(tostring(whole) .. ' ' .. tostring(fraction) .. ' ' .. tostring(depth).. ' ' .. tostring(sign))

	local collection = symbology.collections[1]

	if fraction == 0 then
		local params = {type='Text', textGroup=0, hjust='center', vjust='center', fontSize=10, linked=true, fontWeight=weight, color=color, haloColor=halo_color}
		if(sign < 0) then
			params.fontWeight = params.fontWeight .. '|underlined'
		end
		params.text = string.format('%d', whole)
		collection:add_symbology_instruction(params)
	else
		--Font parameters for sounding whole integer 
		local params = {type='Text', textGroup=0, hjust='right', vjust='baseline', fontSize=10, linked=true, fontWeight=weight, color=color, haloColor=halo_color}
		if(sign < 0) then
			params.fontWeight = params.fontWeight ..'|underlined' -- metric dry height is italic and underlined
		end
		params.text = string.format('%d', whole)
		collection:add_symbology_instruction(params)

		local params2 = {type='Text', textGroup=0, hjust='left', vjust='center', fontSize=8, linked=true, fontWeight=weight, color=color, haloColor=halo_color}
		params2.text = string.format('%d', fraction)
		collection:add_symbology_instruction(params2)
	end

	return true
end
