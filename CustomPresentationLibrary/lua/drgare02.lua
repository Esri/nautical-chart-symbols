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
require 'depare01'
-- drgare02.lua is new at 11.2 and controls labels, unit conversion, color fill and dashed outline color
function drgare02(feature, context, symbology)
	local depth = tonumber(feature.attributes.DRVAL1)
	local maintained = feature.attributes:get_list_attribute('QUASOU')


	if(depth == nil) then
		return true
	end

	local collection = symbology.collections[1]
	local arguments = {depth=depth, DRVAL1=feature.attributes.DRVAL1, DRVAL2=feature.attributes.DRVAL2}
	
	if maintained then -- if QUASOU is 10 then execute label post_symbolize2 Dredged to
		if contains(maintained, { 10 }) then
	
			collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='drgare02:post_symbolize2', arguments=arguments})

			collection.RemoveText = true
		
		else -- Else use label post_symbolize Maintained depth
			collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='drgare02:post_symbolize', arguments=arguments})

			collection.RemoveText = true
		end
	end
--Uncomment block if to symbolize dredged areas with blue or white area fill based on DRVAL1
	-- if(feature.acronym == 'DRGARE' and feature.attributes.DRVAL1 <= 5) then
	-- if(depth <= 5) then
		-- collection:add_symbology_instruction({type="AreaFill", color='DEPVS', transparency=0})
	-- elseif(depth > 5 and depth <= 10) then
		-- collection:add_symbology_instruction({type="AreaFill", color='DEPMS', transparency=0})
	-- elseif(depth > 10) then
		-- collection:add_symbology_instruction({type="AreaFill", color='DEPDW', transparency=0})
	-- end

	collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DASH', width=.32})-- dashed outline of dredge area

	return true

end

function post_symbolize(arguments, context, symbology)
	local depth = arguments['depth']
	local collection = symbology.collections[1]

	local params = 
	{
		type='Text',
		fontSize=10,
		fontWeight='italic',
		color='CHBLK',
		hjust='right',
		haloColor= '#d1deef',
		--vjust='top',
		xoffset=2,
		--yoffset=-0,
		textGroup=20,
		rotateWithFeature=true --New at 11.4 rotateWithFeature. xoffset is the only parameter allowed with polygon geometry
	}

	local text = 'Dredged to '
	local units = Units(depth, Units.meters)
	local format = '%4.1f'

	if context.depth_units == 2 then	-- feet
		depth = math.floor(units:get_value(Units.feet))	-- convert meters to feet and trucate fractional portion
		format = '%d ft'
	elseif context.depth_units == 3 then	-- fathoms
		depth = units:get_value(Units.fathoms)
		format = '%4.1f fm'
	end

	--params.text = string.format('Dredged to ' .. format, depth) Modified at 11.4 to reduce label conflicts
	params.text = string.format(format, depth)
	collection:add_symbology_instruction(params)

	depare01(arguments, context, symbology)
end

function post_symbolize2(arguments, context, symbology)
	local depth = arguments['depth']
	local collection = symbology.collections[1]

	local params = 
	{
		type='Text',
		fontSize=10,
		fontWeight='italic',
		color='CHBLK',
		hjust='right',
		haloColor= '#d1deef',
		--vjust='top',
		xoffset=2,
		--yoffset=-0,
		textGroup=20,
		rotateWithFeature=true --New at 11.4 rotateWithFeature. xoffset is the only parameter allowed with polygon geometry
	}

	local text = 'Maintained depth '
	local units = Units(depth, Units.meters)
	local format = '%4.1f'

	if context.depth_units == 2 then	-- feet
		depth = math.floor(units:get_value(Units.feet))	-- convert meters to feet and trucate fractional portion
		format = '%d ft'
	elseif context.depth_units == 3 then	-- fathoms
		depth = units:get_value(Units.fathoms)
		format = '%4.1f fm'
	end

	--params.text = string.format('Maintained depth ' .. format, depth) Modified at 11.4 to reduce label conflicts
	params.text = string.format(format, depth)

	collection:add_symbology_instruction(params)

	depare01(arguments, context, symbology)
end