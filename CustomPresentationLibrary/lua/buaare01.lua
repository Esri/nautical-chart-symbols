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
--LANDA;brown;0.3500;0.3900;50.000;244;232;193;0.455222  
--LANDF;brown;0.4500;0.4200;15.000;154;111; 55;0.289818
-- runs during scenc build, don't expect to change based on display settings

function buaare01(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="AreaFill", color='#efd8a3', transparency=0})
end