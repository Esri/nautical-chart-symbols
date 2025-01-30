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
function depare03(feature, context, symbology)
	local collection = symbology.collections[1]

	local arguments = {DRVAL1=feature.attributes.DRVAL1, DRVAL2=feature.attributes.DRVAL2}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='depare01',arguments=arguments})
-- DRGARE script is moved to drgare02.lua, therefore the instruction below is commented out
	-- if(feature.acronym == 'DRGARE') then
		-- --collection:add_symbology_instruction({type="AreaPattern", PatternName='DRGARE01'})
		-- collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DASH', width=.32})
	-- end

	if(feature.low_accuracy) then
		collection:add_symbology_instruction({type="SimpleLine", color='DEPSC', style='DASH', width=.64, paint='LOWACC,SAFCON'})
	end

	collection:add_symbology_instruction({type="SimpleLine", color='DEPSC', style='SOLID', width=.64, paint='HIGHACC,SAFCON'})

	return true
end