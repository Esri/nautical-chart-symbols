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

function set(...)
	local ret = {}
	for _,k in ipairs({...}) do ret[k] = true end
	return ret
end

function pipsol01(feature, context, symbology)
	local collection = symbology.collections[1]

	local catpip = tonumber(feature.attributes.CATPIP)
	if set(2,3,4)[catpip] then
		collection:add_symbology_instruction({type='ComplexLine', Name='L41_pipeline_outfall_intake.svg'})
	else
		collection:add_symbology_instruction({type='ComplexLine', Name='L40_pipeline_supply.svg'})
	end

	return true
end
