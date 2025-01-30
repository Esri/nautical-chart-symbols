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
 
function sbdare01(feature, context, symbology)
	local collection = symbology.collections[1]

	local natsur = feature.attributes:get_list_attribute('NATSUR')
	local watlev = tonumber(feature.attributes.WATLEV)
	if contains(natsur, {9,11,14}) and watlev == 4 then
		collection:add_symbology_instruction({type='ComplexLine', Name='rock_ledge.svg'})
		collection.RemoveSymbols = true
		collection.DisplayPriority = 5
		collection.DisplaySubPriority = 1
	end

	return true
end
