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
--New at 11.4
function fairwy01(feature, context, symbology)
    local collection = symbology.collections[1]
    collection:add_symbology_instruction({type = 'ComplexLine', Name = 'N1_1_RecommendedTrack.svg'})
	
	local params = 
	{
			type='Text',
			hjust='center',
			vjust='center',
			fontSize=7,
			xoffset=3,
			yoffset=-3,
			color='CHBLK',
			textGroup=100,
			rotateWithFeature = true, 
		}
		params.text = feature.attributes.OBJNAM
		collection:add_symbology_instruction(params)
    
    return true
end
