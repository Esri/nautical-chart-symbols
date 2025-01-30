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
function rectrc01(feature, context, symbology)
    local collection = symbology.collections[1]

    local cattrk = tonumber(feature.attributes.CATTRK)
    local trafic = tonumber(feature.attributes.TRAFIC)
	local orient = tostring(feature.attributes.ORIENT)

	if(orient == nil) then
		return true
	end
	
    if cattrk == 2 and trafic == 4 then
        collection:add_symbology_instruction({type = 'ComplexLine', Name = 'M4_RecommendedTrack2.svg'})
    elseif cattrk == 2 then
        collection:add_symbology_instruction({type = 'ComplexLine', Name = 'M4_RecommendedTrack1.svg'})
    else
        collection:add_symbology_instruction({type="SimpleLine", color='black', style='SOLID', width=.20})
    end


    local params =
    {
        type='Text',
        hjust='center',
        vjust='top',
        fontName='Arial',
        fontWeight='medium',
        fontSize=10,
        xoffset=0,
        yoffset=-1,
        color='black',
        textGroup=20,
		rotateWithFeature=true,
    }
    params.text= orient..'�'

    collection:add_symbology_instruction(params)
    collection.RemoveText = true

    return true
end
