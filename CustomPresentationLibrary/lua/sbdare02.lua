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

function sbdare02(feature, context, symbology)

	-- get the string of NATQUA and NATSUR from the feature attribute
	local natqua = tostring(feature.attributes.NATQUA)
	local natsur = tostring(feature.attributes.NATSUR)

	-- there could be three values seperated by comma for natqua/natsur, and get each of the values
	local natqua_arr = {}
	local natsur_arr = {}
	for natqua_val in natqua:gmatch('([^,]*)') do
		natqua_arr[#natqua_arr+1] = natqua_val
	end
	for natsur_val in natsur:gmatch('([^,]*)') do
		natsur_arr[#natsur_arr+1] = natsur_val
	end

	-- define the dictionaries for natqua and natsur: attribute ID->ECDIS abbreviation
	local natqua_dict = {["1"]="f",["2"]="m",["3"]="c",["4"]="bk",["5"]="sy",["6"]="so",["7"]="sf",["8"]="v",["9"]="ca",["10"]="h"}
	local natsur_dict = {["1"]="M",["2"]="Cy",["3"]="Si",["4"]="S",["5"]="St",["6"]="G",["7"]="P",["8"]="Cb",["9"]="R",["11"]="La",["14"]="Co",["17"]="Sh",["18"]="Bo"}

	-- combine natqua and natsur string: the format will be 1st value of natqua + 1st value of natsur + " " + 2nd value of natqua + 2nd value of natsur + " " + 3rd value of natqua + 3rd value of natsur
	local qua_sur = ""
	for i=1,3
	do
		nat_qua_sur_pair = ""	
		if (natqua_arr[i] ~= "" and natqua_arr[i] ~= nil and natqua_dict[natqua_arr[i]] ~= nil) then
			nat_qua_sur_pair = nat_qua_sur_pair .. natqua_dict[natqua_arr[i]]
		end
		if (natsur_arr[i] ~= "" and natsur_arr[i] ~= nil and natsur_dict[natsur_arr[i]] ~= nil) then
			nat_qua_sur_pair = nat_qua_sur_pair .. natsur_dict[natsur_arr[i]]
		end
		if (nat_qua_sur_pair ~= "") then
			if (qua_sur == "") then
				qua_sur = nat_qua_sur_pair
			else
				qua_sur = qua_sur .. " " .. nat_qua_sur_pair
			end
		end
	end

	-- add the text symbology
	local collection = symbology.collections[1]
	local params = 
	{
		type='Text',
		fontSize=10,
		fontWeight='italic',
		color='CHBLK',
		hjust='left',
		vjust='center',
		xoffset=0,
		yoffset=0,
		textGroup=28,
	}
	params.text = qua_sur
	collection:add_symbology_instruction(params)

	-- remove the s52 text 
	collection.RemoveText = true

	return true
end

	