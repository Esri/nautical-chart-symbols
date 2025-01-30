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
require 'quapos01'

function coalne01(feature, context, symbology)
	local prim = feature.prim
	local collection = symbology.collections[1]
	local catcoa = tonumber(feature.attributes.CATCOA) or 0

	-- if the feature is line
	if prim == 2 then
		-- if CATCOA value is 6,7,8 or 10, symbolize line segment LS(DASH,1,CSTLN) (see COALNE part in lsymref.dic)
		if catcoa == 6 or catcoa == 7 or catcoa == 8 or catcoa == 10  then
			collection:add_symbology_instruction({type="SimpleLine", color='CSTLN', style='DASH', width=.32})
		-- if CATCOA doesn't euqal to 6,7,8 or 10, call quapos01
		else
			return quapos01(feature, context, symbology)
		end
	end

	return true
end

			