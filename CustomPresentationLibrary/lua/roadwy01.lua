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

function roadwy01(feature, context, symbology)
	local collection = symbology.collections[1]

	local catrod = tonumber(feature.attributes.CATROD)
	if set(1,2,3)[catrod] then
		collection:add_symbology_instruction({type='ComplexLine', Name='D11_Roadway.svg'})
	elseif catrod == 4 then
		collection:add_symbology_instruction({type="SimpleLine", color='black', style='DASH', width=.2})
	else
		collection:add_symbology_instruction({type="ComplexLine", Name='D11_Roadway.svg'})
	end

	return true
end
