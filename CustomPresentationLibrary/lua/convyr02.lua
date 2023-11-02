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
function convyr02(feature, context, symbology)
	local collection = symbology.collections[1]

	local verclr = feature.attributes.VERCLR

	if(verclr == nil) then
		return true
	end

	local collection = symbology.collections[1]
	local arguments = {label='VERCLR', value=verclr, xoffset=1, yoffset=0}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})

	collection.RemoveText = true

	return true
end