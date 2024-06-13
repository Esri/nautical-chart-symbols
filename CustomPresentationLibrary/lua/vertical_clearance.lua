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

function vertical_clearance(arguments, context, symbology)
	local label = arguments['label']
	local value = tonumber(arguments['value'])
	local xo = arguments['xoffset']
	local yo = arguments['yoffset']

	if(value == nil) then
		return true
	end

	local format = '%4.1f'
	if context.depth_units ~= 1 then
		value = math.floor(value * 3.2808399)	-- convert meters to feet and truncate fractional portion
		format = '%d ft'
	end

	local params = {type='Text',color='', textGroup=11, xoffset=2, yoffset=1, linked=false}--offsets changed from x and y = 0 linked is false to separate the object name text from the vertical clearance text instruction. Update 11.2 patch1.

	local collection = symbology.collections[1]

	if label == 'VERCLR' then
		collection:add_symbology_instruction({type='Symbol', xoffset=2, yoffset=1, Name='D22_Vert_clr.svg'})
		params.text = string.format(format,value)
		collection:add_symbology_instruction(params)
	elseif label == 'VERCOP' then
		collection:add_symbology_instruction({type='Symbol', Name='D22_Vert_clr.svg'})
		params.text = string.format(format, value)--edit from 'clr op '
		collection:add_symbology_instruction(params)
	elseif label == 'VERCCL' then
		collection:add_symbology_instruction({type='Symbol', Name='D22_Vert_clr.svg'})
		params.text = string.format(format, value) --edit from 'clr cl'
		collection:add_symbology_instruction(params)
	elseif label == 'VERCSA' then
		local params = {type='Text',color='#db4996', textGroup=11, xoffset=2, yoffset=1}-- Safe vertical clearance magenta text
		collection:add_symbology_instruction({type='Symbol', Name='D26_2_SafeVertClearance.svg'})
		params.text = string.format(format, value)
		collection:add_symbology_instruction(params)
	elseif label == 'HORCLR' then
		params.text = string.format('hor clr ' .. format, value)
	end

	return true
end
