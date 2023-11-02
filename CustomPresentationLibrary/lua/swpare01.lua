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

function swpare01(feature, context, symbology)
	local depth = tonumber(feature.attributes.DRVAL1)

	if(depth == nil) then
		return true
	end

	local collection = symbology.collections[1]

	local arguments = {depth=depth}

	collection:add_symbology_instruction({type='Symbol', Name='K2_SweptDepth_magenta.svg'})
	collection:add_symbology_instruction({type="SimpleLine", color='#db4996', style='DASH', width=.32})
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='swpare01:post_symbolize', arguments=arguments})

	collection.RemoveText = true

	return true
	
end

function post_symbolize(arguments, context, symbology)
	local depth = arguments['depth']

	local collection = symbology.collections[1]

	local params = 
	{
		type='Text',
		fontSize=9,
		fontWeight='italic',
		color='#db4996',
		hjust='right',
		vjust='baseline',
		xoffset=1,
		yoffset=0,
		textGroup=20,
	}

	--local text = 'Swept to '
	local units = Units(depth, Units.meters)
	local format = '%4.1f'

	if context.depth_units == 2 then	-- feet
		depth = math.floor(units:get_value(Units.feet))	-- convert meters to feet and trucate fractional portion
		format = '%d ft'
	elseif context.depth_units == 3 then	-- fathoms
		depth = units:get_value(Units.fathoms)
		format = '%4.1f fm'
	end
	
	params.text = string.format('Swept to'..format, depth)

	collection:add_symbology_instruction(params)

	return true
end
