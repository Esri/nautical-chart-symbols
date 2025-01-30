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

function navlne01(feature, context, symbology)
	local collection = symbology.collections[1]
    local orient = tostring(feature.attributes.ORIENT) 
	collection:add_symbology_instruction({type="ComplexLine", Name="M1_NavigationLine.svg"})

    collection.RemoveSymbols = true
    

    local params =
    {
        type='Text',
        hjust='right',
        vjust='baseline',
        fontName='Arial',
        fontWeight='medium',
        fontSize=10,
        xoffset=0,
        yoffset=-1,
        color='CHBLK',
        textGroup=20,
		rotateWithFeature=true,
    }
    params.text = orient..'�'

    collection:add_symbology_instruction(params)
    collection.RemoveText = true


    return true
end 


	