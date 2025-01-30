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
-- DEPDW;white;0.2800;0.3100;80.000;255;255;255;0.292854  
-- DEPMD;pale_blue;0.2600;0.2900;65.000;255;255;255;0.287164  
-- DEPMS;light_blue;0.2300;0.2500;55.000;221;235;247;0.664280  
-- DEPVS;medium_blue;0.2100;0.2200;45.000;209;222;239;1.191311  
-- DEPIT;yellow-green;0.2600;0.3600;35.000;214;219;201;0.378606  


function depare01(arguments, context, symbology)
	local drval1 = tonumber(arguments['DRVAL1']) or -1.0
	local drval2 = tonumber(arguments['DRVAL2']) or drval1 + .01


	local two_shades = context.two_shades
	local shallow = true

	if two_shades then
		if drval1 < 0 then
			color = '#d6dbc9'
		elseif drval1 >= 0 and drval2 > 0 then
			color = '#d1deef' --'DEPVS' shallow water tint 1
		end

		local safety_contour = context.safety_contour
		if drval1 >= safety_contour and drval2 > safety_contour then
			color = '#ffffff' --'DEPDW' white background
			shallow = false
		end
	else
		if drval1 < 0 then
			color = '#d6dbc9' -- DEPIT Green foreshore
		elseif drval1 >= 0 and drval2 > 0 then
			color = '#d1deef' --'DEPVS' shallow water tint 1 
		end

		local shallow_contour = context.shallow_contour
		if drval1 >= shallow_contour and drval2 > shallow_contour then
			color = '#ddebf7' --'DEPMS' shallow water tint 2 
		end
		
		local safety_contour = context.safety_contour
		if drval1 >= safety_contour and drval2 > safety_contour then
			color = '#f5f5f5' -- white smoke 
			shallow = false
		end
		
		deep_contour = context.deep_contour
		if drval1 >= deep_contour and drval2 > deep_contour then
			color = '#ffffff' --'DEPDW' white background
			shallow = false
		end
	end

	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="AreaFill", color=color, transparency=0})

	if shallow and context:getViewingGroupDisplay(23010) then
		collection = symbology:add_symbology_collection({ViewGroup=23010, DisplayPriority=3, DisplayCategory='STANDARD'})
		collection:add_symbology_instruction({type='AreaPattern', PatternName='DIAMOND1'})
	end

	return true

end

