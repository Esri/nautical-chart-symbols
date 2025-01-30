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

function dynamic_light_string(arguments, context, symbology)
	local params = arguments['params']
	local height = tonumber(arguments['height']) or 0

	local collection = symbology.collections[1]

	local units = Units(height, Units.meters)
	local format = params.text

	if context.depth_units ~= 1 then
		height = math.floor(units:get_value(Units.feet) + .5)	-- convert meters to feet
		format = '%dft'
	else
		format = '%dm'
	end

	height = math.floor(height + .5)
	local height_string = string.format(format, height)
	if(height == 0) then
		height_string = ''
	end

	Debug.log(params.text .. ' ' .. height_string)

	params.text = string.format(params.text, height_string)

	collection:add_symbology_instruction(params)

	return true
end
