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

-- Conditional Symbology Procedure QUAPOS01
-- It applies to (1) S-57 Object Class "land area" (LNDARE), as point and line (2) S-57 Object Class coast line” (COALNE), line only
function quapos01(feature, context, symbology)
	local collection = symbology.collections[1]

	-- if the feature is point, check if it is low-accuracy feature. If it is, draw the low accuracy symbol 'LOWACC01' in the viewing group 31011 (see QUAPNT02)
	if feature.prim == 1 then
		if feature.low_accuracy then
			local collection2 = symbology:add_symbology_collection({ViewGroup=31011, DisplayPriority=collection.DisplayPriority, DisplayCategory=collection.DisplayCategory})
			collection2:add_symbology_instruction({type='Symbol', Name='LOWACC01'})
		end
	-- if the feature is not point, follow the precedures of QUALIN01
	else 
		-- if it is low-accuracy feature, symbolize line segment LC(LOWACC21)
		if feature.low_accuracy then
			collection:add_symbology_instruction({type='ComplexLine', Name='LOWACC21', paint='LOWACC'}) 
		end

		-- if it is COALNE object
		if feature.acronym == 'COALNE' then
			local conrad = tonumber(feature.attributes.CONRAD) or 0
			-- if it has CONRAD value and if the value is 1, symbolize line segment LS(SOLD, 3, CHMGF)
			if conrad == 1 then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGF', style='SOLID', width=.96, paint='HIGHACC'})
			end
		end
		-- symbolize line segment LS(SOLD, 1, CSTLN)
		collection:add_symbology_instruction({type="SimpleLine", color='CSTLN', style='SOLID', width=.32, paint='HIGHACC'})
	end
	collection.RemoveSymbols = true
	collection.RemoveCSPs = true
	return true
end 


	