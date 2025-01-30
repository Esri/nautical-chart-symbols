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
function bridge02(feature, context, symbology)
	local collection = symbology.collections[1]

	local catbrg = feature.attributes:get_list_attribute('CATBRG')
	if contains(catbrg, {2,3,4,5,7,8}) then
		local arguments = {label='VERCCL', value=feature.attributes.VERCCL, xoffset=1, yoffset=0}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})
		local arguments = {label='VERCOP', value=feature.attributes.VERCOP, xoffset=1, yoffset=1}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})
	else
		local params = 
		{
			type='Text',
			fontName='HelveticaNeueLT Pro 55 Roman',
			fontWeight='medium',
			fontSize=10,
			color='black',
			hjust='left',
			vjust='bottom',
			xoffset=1,
			yoffset=0,
			textGroup=21,
			text=feature.attributes.OBJNAM
		}
		collection:add_symbology_instruction(params)

		local arguments = {label='VERCLR', value=feature.attributes.VERCLR, xoffset=1, yoffset=1}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})
	end

	collection.RemoveText = true

	return true
end
