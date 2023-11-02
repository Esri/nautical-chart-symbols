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

--New function and file at 11.2 (06June2023)
function obstnare01(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="AreaFill", color='#d1deef', transparency=0}) -- fill color matches shallow water tint 1 in depare01.lua
	collection:add_symbology_instruction({type="SimpleLine", color='#4B4B4B', style='DOT', width=.32})
	
end