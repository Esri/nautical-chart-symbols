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

function lndelv01(feature, context, symbology)
	local elevation = tonumber(feature.attributes.ELEVAT)

	if(elevation == nil) then
		return true
	end

	local collection = symbology.collections[1]

	local arguments = {elevation=elevation}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='lndelv01:post_symbolize', arguments=arguments})

	collection.RemoveText = true

	return true
end

function post_symbolize(arguments, context, symbology)
	local elevation = arguments['elevation']

	local collection = symbology.collections[1]

	local params = --Modifed hjust, vjust, xoffset, yoffset at 11.2
	{
		type='Text',
		fontSize=7,
		color='CHBLK',
		hjust='right',
		vjust='center',
		xoffset=-1,
		yoffset=0,
		textGroup=28,
	}

	local units = Units(elevation, Units.meters)
	local format = '%4.1f m'

	if context.depth_units ~= 1 then
		elevation = math.ceil(units:get_value(Units.feet))	-- convert meters to feet rounded to next higher foot and trucate fractional portion
		format = '%d ft'
	end

	params.text = string.format(format, elevation)

	collection:add_symbology_instruction(params)

	return true
end
--New function at 11.2 for land elevation contours from s-52 brown to black
--New at 11.4 land contour elevation label with text rotation.
function lndelv02(feature, context, symbology)
	 local elevat = feature.attributes.ELEVAT
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="SimpleLine", color='black', style='SOLID', width=.2})
	
	if (elevat == nil) then return true end
	
	local label = {
        type = 'Text',
        hjust = 'center',
        vjust = 'center',
        xoffset = 0,
        yoffset = 0,
        linked = true,
        fontSize = 7,
        haloColor = '#f4e8c1',
        rotateWithFeature=true,
    }
    label.text = elevat

    collection:add_symbology_instruction(label)

    return true
end