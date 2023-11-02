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

function slotop01(feature, context, symbology)
	local collection = symbology.collections[1]

	--local catslo = feature.attributes:get_list_attribute('CATSLO')
	local catslo = tonumber(feature.attributes.CATSLO)
	if set(4,5,6)[catslo] then
		collection:add_symbology_instruction({type='ComplexLine', Name='C3_Cliffs.svg'})
	elseif catslo == 1 then
		collection:add_symbology_instruction({type='ComplexLine', Name='D14_Cutting.svg'})
	elseif catslo == 2 then
		collection:add_symbology_instruction({type='ComplexLine', Name='D15_Embankment.svg'})
	elseif catslo == 3 then
		collection:add_symbology_instruction({type='ComplexLine', Name='C8_Dunes.svg'})
	elseif catslo == 7 then
		collection:add_symbology_instruction({type='ComplexLine', Name='Scree.svg'})

	end

	return true
end
