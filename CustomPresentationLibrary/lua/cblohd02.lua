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
local function IsNone(value) -- June2023 add function
	return (value == nil or #value == 0)
end

function cblohd02(feature, context, symbology)
	local collection = symbology.collections[1]

	local vercsa = feature.attributes.VERCSA
	local verclr = feature.attributes.VERCLR

	local arguments = {}
	


	if not IsNone(verclr) then --June2023 fix nil error message. Only verclr would symbolize.
		arguments = {label='VERCLR', value=feature.attributes.VERCLR, xoffset=1, yoffset=0}
	elseif vercsa then
		arguments = {label='VERCSA', value=feature.attributes.VERCSA, xoffset=1, yoffset=0}
	end

	if arguments then
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})
	end

	collection.RemoveText = true

	return true
end