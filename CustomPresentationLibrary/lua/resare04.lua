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

function resare04(feature, context, symbology)
	local restriction = feature.attributes:get_list_attribute('RESTRN')
	local categoryOfRestrictedArea = feature.attributes:get_list_attribute('CATREA')

	local collection = symbology.collections[1]

	if restriction then
		if contains(restriction, { 7, 8, 14 }) then
			-- Continuation A.  Entry restricted or prohibited

			collection.DisplayPriority = 6
-- 08June2023 11.2 release. Enabled SVG symbol in the center of an area. New symbols N2_2_EntryProhibitedPoint.svg and N2_2_EntryProhibited.svg
			if contains(restriction, { 1, 2, 3, 4, 5, 6, 13, 16, 17, 23, 24, 25, 26, 27 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ENTRES61'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N2_2_EntryProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, { 1, 8, 9, 12, 14, 18, 19, 21, 24, 25, 26 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ENTRES61'})--S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N2_2_EntryProhibitedPoint.svg'})
			elseif contains(restriction, { 9, 10, 11, 12, 15, 18, 19, 20, 21, 22 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ENTRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N2_2_EntryProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, {4, 5, 6, 7, 10, 20, 22, 23 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ENTRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N2_2_EntryProhibitedPoint.svg'})
			else
				--collection:add_symbology_instruction({type='Symbol', Name='ENTRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N2_2_EntryProhibitedPoint.svg'})
			end

			if context.plain_boundaries then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
			else
				--collection:add_symbology_instruction({type='ComplexLine', Name='ENTRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='ComplexLine', Name='N2_2_EntryProhibited.svg'})
			end

		 elseif contains(restriction, { 1, 2 }) then
			-- Continuation B.  Anchoring restricted or prohibited

			-- collection.DisplayPriority = 6
-- 08June2023 11.2 release. Enabled SVG symbol in the center of an area.  New symbols N20_AnchoringProhibitedPoint and N20_AnchoringProhibited
			if contains(restriction, { 3, 4, 5, 6, 13, 16, 17, 23, 24, 25, 26, 27 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ACHRES61'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N20_AnchoringProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, { 1, 8, 9, 12, 14, 18, 19, 21, 24, 25, 26 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ACHRES61'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N20_AnchoringProhibitedPoint.svg'})
			elseif contains(restriction, { 9, 10, 11, 12, 15, 18, 19, 20, 21, 22 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ACHRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N20_AnchoringProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, {4, 5, 6, 7, 10, 20, 22, 23 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='ACHRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N20_AnchoringProhibitedPoint.svg'})
			else
				--collection:add_symbology_instruction({type='Symbol', Name='ACHRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N20_AnchoringProhibitedPoint.svg'})
			end

			if context.plain_boundaries then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
			else
				--collection:add_symbology_instruction({type='ComplexLine', Name='ACHRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='ComplexLine', Name='N20_AnchoringProhibited.svg'}) -- area line symbol
			end

		elseif contains(restriction, { 3, 4, 5, 6, 24 }) then
			-- Continuation C.  Fishing restricted or prohibited

			collection.DisplayPriority = 6
--08June2023 11.2 release. Enabled SVG symbol in the center of an area. New symbols N21_1_Fishing_ProhibitedPoint.svg and N21_1_Fishing_Prohibited.svg
			if contains(restriction, { 13, 16, 17, 23, 24, 25, 26, 27 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='FSHRES61'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N21_1_Fishing_ProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, { 1, 8, 9, 12, 14, 18, 19, 21, 24, 25, 26 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='FSHRES61'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N21_1_Fishing_ProhibitedPoint.svg'})
			elseif contains(restriction, { 9, 10, 11, 12, 15, 18, 19, 20, 21, 22 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='FSHRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N21_1_Fishing_ProhibitedPoint.svg'})
			elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, {4, 5, 6, 7, 10, 20, 22, 23 }) then
				--collection:add_symbology_instruction({type='Symbol', Name='FSHRES71'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N21_1_Fishing_ProhibitedPoint.svg'})
			else
				--collection:add_symbology_instruction({type='Symbol', Name='FSHRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='Symbol', Name='N21_1_Fishing_ProhibitedPoint.svg'})
			end

			if context.plain_boundaries then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
			else
				--collection:add_symbology_instruction({type='ComplexLine', Name='FSHRES51'}) --S52 symbol
				collection:add_symbology_instruction({type='ComplexLine', Name='N21_1_Fishing_Prohibited.svg'})
			end

		elseif contains(restriction, { 13, 16, 17, 23, 25, 26, 27 }) then
			-- Continuation D.  Own ship restrictions

			collection.DisplayPriority = 6
---------- uncomment the below code if you want to draw a symbol in the center of the visible part of the object area ----------
			--------------------------------------------------------------------------------------------------------------------------------
			-- if contains(restriction, { 9, 10, 11, 12, 15, 18, 19, 20, 21, 22 }) then
				-- collection:add_symbology_instruction({type='Symbol', Name='CTYARE71'})
			-- elseif categoryOfRestrictedArea and contains(categoryOfRestrictedArea, { 4, 5, 6, 7, 10, 20, 22, 23 }) then
				-- collection:add_symbology_instruction({type='Symbol', Name='CTYARE71'})
			-- else
				-- collection:add_symbology_instruction({type='Symbol', Name='CTYARE51'})
			-- end

			if context.plain_boundaries then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
			else
				collection:add_symbology_instruction({type='ComplexLine', Name='N1_Limit_general.svg'}) --NGA Change 06222022: from CTYARE51
			end

		else
		---------- uncomment the below code if you want to draw a symbol in the center of the visible part of the object area ----------
			--------------------------------------------------------------------------------------------------------------------------------
			-- if contains(restriction, {9, 10, 11, 12, 15, 18, 19, 20, 21, 22 }) then
				-- collection:add_symbology_instruction({type='Symbol', Name='INFARE51'})
			-- else
				-- collection:add_symbology_instruction({type='Symbol', Name='RSRDEF51'})
			-- end

			if context.plain_boundaries then
				collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
			else
				collection:add_symbology_instruction({type='ComplexLine', Name='N2_1_RestrictedArea.svg'}) --NGA Change 06222022: from CTYARE51
			end
		end
	else
		-- Continuation E.  No restriction applies
---------- uncomment the below code if you want to draw a symbol in the center of the visible part of the object area ----------
		--------------------------------------------------------------------------------------------------------------------------------
		-- if categoryOfRestrictedArea then
			-- if contains(categoryOfRestrictedArea, { 1, 8, 9, 12, 14, 18, 19, 21, 24, 25, 26 }) then
				-- if contains(categoryOfRestrictedArea, { 4, 5, 6, 7, 10, 20, 22, 23 }) then
					-- collection:add_symbology_instruction({type='Symbol', Name='CTYARE71'})
				-- else
					-- collection:add_symbology_instruction({type='Symbol', Name='CTYARE51'})
				-- end
			-- else
				-- if contains(categoryOfRestrictedArea, { 4, 5, 6, 7, 10, 20, 22, 23 }) then
					-- collection:add_symbology_instruction({type='Symbol', Name='INFARE51'})
				-- else
					-- collection:add_symbology_instruction({type='Symbol', Name='RSRDEF51'})
				-- end
			-- end
		-- else
			-- collection:add_symbology_instruction({type='Symbol', Name='RSRDEF51'})
		-- end

		if context.plain_boundaries then
			collection:add_symbology_instruction({type="SimpleLine", color='CHMGD', style='DASH', width=.64})
		else
			collection:add_symbology_instruction({type='ComplexLine', Name='N1_Limit_general.svg'}) --from CTYARE51
		end
	end
end
