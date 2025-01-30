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

function sndfrm04(feature, context, symbology)
	arguments_pre_symbolize = {feature.swept_depth, feature.uncertain_depth}
	return sndfrm04_pre_symbolize(featue, arguments_pre_symbolize)
end

function sndfrm04_pre_symbolize(feature, arguments)
	-- arguments[0] is swept_depth, arguments[1] is uncertained_depth
	local tecsou = feature.attributes:get_list_attribute('TECSOU')
	arguments[0] = false
	-- If the attribute 'TECSOU' include '4' (found by diver) or '6' (swept depth), set the swept_depth to be true
	if contains(tecsou, {4, 6}) then
		arguments[0] = true
	end
	local quasou = feature.attributes:get_list_attribute('QUASOU')
	arguments[1] = false
	-- If the value of the attribute 'QUASOU' is given and it include s'3','4','5','8' or '9', set uncertained_depth to be true
	if contains(quasou, {3, 4, 5, 8, 9}) then
		arguments[1] = true
	end
	if (arguments[1] == false) then
		local status = feature.attributes:get_list_attribute('STATUS')
		-- If uncertained_depth is false and the value of the attribute 'STATUS' includes 18, set uncertained_depth to be true
		if contains(status, {18}) then
			arguments[1] = true
		end
	end
	if (arguments[1] == false and feature.low_accuracy) then
		-- If the low positional accuracy is associated with the feature, set the uncertained_depth to be true
		arguments[1] = true
	end
	return true
end

-- Set the halo color for different cases
local function set_halo_color(depth, context)
	local color = '#d6dbc9' --'DEPIT'
	if (depth >= 0) then
		color = '#d1deef'; --'DEPVS'
	end
	if (depth >= context.shallow_contour) then
		color = '#ddebf7';--'DEPMS'
	end
	if (depth >= context.safety_contour) then
		color = '#ffffff'; --'DEPMD'
	end
	if (depth >= context.deep_contour) then 
		color = '#ffffff'; --'DEPDW'
	end
	local halo_color = color
	return halo_color
end

function sndfrm04_post_symbolize(arguments, context, symbology)
	local collection = symbology.collections[1]
	local depth = tonumber(arguments['DEPTH']) or 0
	local swept_depth = arguments['SWEPTDEPTH']
	local uncertain_depth = arguments['UNCERTAINDEPTH']
	local isolated_danger = arguments['ISOLATEDDANGER']
	local acronym = arguments['ACRONYM']
	if (isolated_danger and (not context.isolated_dangers_off)) then
		return true
	end
	local halo_color = set_halo_color(depth, context)
	local safety_depth = context.safety_depth;
	local depth_units = context.depth_units
	local is_sounding = (acronym == "SOUNDG")
	
	if (is_sounding and (depth > safety_depth) and (not context.display_safe_soundings)) then
		return true
	end

	local symbol_prefix = "SOUNDG"
	if (depth <= safety_depth) then
		symbol_prefix = "SOUNDS";
	end
	
	-- If the swept_depth is true, draw the symbol as below
	if (swept_depth) then
		collection:add_symbology_instruction({type = 'Symbol', Name = 'K27_SweptDepth.svg'}) --symbol_prefix.."B1" swepth depth
	end

	-- If the uncertain_depth is true, draw the symbol as below
	if (uncertain_depth) then
		collection:add_symbology_instruction({type = 'Symbol', Name = symbol_prefix.."C2"}) -- sounding of low accuracy 
	end

	return true
end
