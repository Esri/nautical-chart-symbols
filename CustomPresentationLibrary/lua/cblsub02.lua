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
function cblsub02(feature, context, symbology)
	local collection = symbology.collections[1]
	local status = feature.attributes:get_list_attribute('STATUS') --list attribute
	local catcbl = tonumber(feature.attributes.CATCBL) --enumerated attribute
	
	
	if contains(status,{4}) then --Disused Submerged Cable, Abandoned
			collection:add_symbology_instruction({type="ComplexLine", Name='L32_DisusedCable.svg'})
	
	elseif contains(catcbl, {1}) then -- power cable, comment out these two lines to use L30_Cable.svg
		collection:add_symbology_instruction({type="ComplexLine", Name='L31_1_PowerCable.svg'})
	
	elseif contains(catcbl, {6}) then -- mooring cable
		collection:add_symbology_instruction({type="SimpleLine", color='#db4996', style='DASH', width=.16})
	
	else --Submerged Cable (Default)
		collection:add_symbology_instruction({type="ComplexLine", Name='L30_Cable.svg'})
		
	end
	
	return true
end