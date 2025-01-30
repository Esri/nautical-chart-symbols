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
local colours =
{
	[1]  = '',
	[2]  = 'Bl',
	[3]  = 'R',
	[4]  = 'G',
	[5]  = 'Bu',
	[6]  = 'Y',
	[7]  = 'Gr',
	[8]  = 'Br',
	[9]  = 'Am',
	[10] = 'Vi',
	[11] = 'Or',
	[12] = 'Ma',
	[13] = 'Pi'
}

local categoryOfLights =
{
	[5] = 'Aero ',
	[7] = 'Fog Det Lt',
	[19] = '(hor)',
	[20] = '(vert)'
}

local lightCharacteristics = 
{
	[1]  = 'F',               -- Fixed
	[2]  = 'Fl',              -- Flashing
	[3]  = 'LFl',             -- long-flashing
	[4]  = 'Q',               -- quick-flashing
	[5]  = 'VQ',              -- very quick-flashing
	[6]  = 'UQ',              -- ultra quick-flashing
	[7]  = 'Iso',             -- Isophased
	[8]  = 'Oc',              -- Occulting
	[9]  = 'IQ',              -- interrupted quick-flashing
	[10] = 'IVQ',             -- interrupted very quick-flashing
	[11] = 'IUQ',             -- interrupted ultra quick-flashing
	[12] = 'Mo',              -- Morse
	[13] = 'FFI',             -- fixed/flashing
	[14] = 'LFI',							-- flash/long-flash
	[15] = 'OcFl',            -- occulting/flashing
	[16] = 'FLFI',            -- fixed/long-flash
	[17] = 'OcAI',            -- occulting alternating
	[18] = 'LFIAI',           -- long-flash alternating 
	[19] = 'FLAI',            -- flash alternating 
	[20] = 'AI',              -- group alternating
	[25] = 'LQ',							-- quick-flash plus long-flash
	[26] = 'LVQ',						  -- very quick-flash plus long-flash
	[27] = 'LUQ',							-- ultra quick-flash plus long-flash
	[28] = 'AI',              -- Alternating
	[29] = 'FAL',		          -- fixed and alternating flashing
}

local function IsNone(value)
	return (value == nil or #value == 0)
end

local function COLOURToString(COLOUR)
	local strCOLOUR = ''
	if COLOUR == '1,4' then
		strCOLOUR = 'WG'
	elseif COLOUR == '1,3' then
		strCOLOUR = 'WR'
	else
		local color = tonumber(COLOUR)
		if colours[color] then
			strCOLOUR = colours[color]
		end
	end
	return strCOLOUR
end

local function MLTYLTToString(MLTYLT)
	local strMLTYLT = ''
	if not IsNone(MLTYLT) then
		strMLTYLT = MLTYLT
	end
	return strMLTYLT
end

local function CATLITToString(CATLIT)
	local strCATLIT = ''
	if not IsNone(CATLIT) then 
		local catlit = tonumber(CATLIT)
		if categoryOfLights[catlit] then
			strCATLIT = categoryOfLights[catlit]
		end
	end
	return strCATLIT
end

local function LITCHRToString(LITCHR)
	local strLITCHR = ''
	if not IsNone(LITCHR) then
		local litchr = tonumber(LITCHR)
		if lightCharacteristics[litchr] then
			strLITCHR = lightCharacteristics[litchr]
		end
	end
	return strLITCHR
end

local function SIGGRPToString(SIGGRP)
	local strSIGGRP = ''
	if not IsNone(SIGGRP) and SIGGRP ~= '(1)' and SIGGRP ~= '()' then
		strSIGGRP = SIGGRP
	end
	return strSIGGRP
end

local function SIGPERToString(SIGPER)
	local	strSIGPER = ''
	if not IsNone(SIGPER) then
			strSIGPER = SIGPER .. 's'
--			strSIGPER = strSIGPER.gsub('.',',') .. 's'
	end
	return strSIGPER
end

local function HEIGHTToString(HEIGHT)
	local strHEIGHT = ''
	if not IsNone(HEIGHT) then
		local height = tonumber(HEIGHT)
		if(height) then
			height = math.floor(height + .05)
			strHEIGHT = tostring(height) .. 'm'
			strHEIGHT = '%s'
		end
	end
	return strHEIGHT
end

local function VALNMRToString(VALNMR)
	local strVALNMR = ''
	if not IsNone(VALNMR) then
		local valnmr = tonumber(VALNMR)
		if(valnmr) then
			valnmr = math.floor(valnmr)
			strVALNMR = tostring(valnmr) .. 'M'
		end
	end
	return strVALNMR
end

local function SIGGENToString(SIGGEN)
	local	strSIGGEN = ''
	local siggen = tonumber(SIGGEN)
	if siggen == 3 then
		strSIGGEN = ' (man - see Note)'
	end
	return strSIGGEN
end

function ConcatenateLightInfo(CATLIT, LITCHR, SIGGRP, SIGPER, VALNMR, COLOUR, HEIGHT, MLTYLT, STATUS, SIGGEN)
	local strCATLIT = CATLITToString(CATLIT)
	local strLITCHR = LITCHRToString(LITCHR)
	local strSIGGRP = SIGGRPToString(SIGGRP)
	local strCOLOUR = COLOURToString(COLOUR)
	local strSIGPER = SIGPERToString(SIGPER)
	local strHEIGHT = HEIGHTToString(HEIGHT)
	local strVALNMR = VALNMRToString(VALNMR)
	local strMLTYLT = MLTYLTToString(MLTYLT)
	local strSIGGEN = SIGGENToString(SIGGEN)

	local strLight = ''
	if(#strCOLOUR > 0 and (#strCATLIT > 0 or #strSIGPER > 0 or #strHEIGHT > 0 or #strVALNMR > 0)) then
		strCOLOUR = strCOLOUR .. "."
	end

	if (#strLITCHR > 0 and #strSIGGRP == 0) then
		strLITCHR = strLITCHR .. '.'
	end

	if CATLIT == '6' then
		if(#strHEIGHT == 0) then
			strLight = '(' .. strCOLOUR .. ' Lts)'
		else
			strLight = '(' .. strCOLOUR .. ' Lts)' .. '\n' .. '(' .. strHEIGHT .. ')'
		end
--		strLight = '(' .. strCOLOUR .. 'Lts)' .. '\n' .. '(' .. strHEIGHT .. ')'
	elseif CATLIT == '20' then
		strLight = strMLTYLT .. strLITCHR .. strSIGGRP .. strCOLOUR .. strCATLIT .. strSIGPER .. strHEIGHT .. strVALNMR .. strSIGGEN
	elseif STATUS == '11' then
		strLight = ''
	else
		strLight = strMLTYLT .. strCATLIT .. strLITCHR .. strSIGGRP .. strCOLOUR .. strSIGPER .. strHEIGHT .. strVALNMR .. strSIGGEN
	end

	return {text=strLight, height=HEIGHT}
--	return strLight
end

local function LengthofFirstSeq(VALUES)
	local i = 0
	for v = 1, #VALUES-1, 1 do
		if VALUES[v] == VALUES[v+1] then
			i = i + 1
		else
			break
		end
	end
	return i+1
end

local function VALNMRArrayToString(VALUES, count)
	local set = {}
	local AggregateValues = {}
	for v = 1, count, 1 do
		local value = math.floor(VALUES[v])
		if not set[value] and value > 0 then
			AggregateValues[#AggregateValues + 1] = value
			set[value] = true
		end
	end

	local strReturn = ''
	if #AggregateValues == 1 then
		strReturn = tostring(AggregateValues[1]) .. 'M'
	elseif #AggregateValues == 2 then
		strReturn = tostring(math.max(table.unpack(AggregateValues))) .. '/' .. tostring(math.min(table.unpack(AggregateValues))) .. 'M'
	elseif #AggregateValues > 2 then
		strReturn = tostring(math.max(table.unpack(AggregateValues))) .. '-' .. tostring(math.min(table.unpack(AggregateValues))) .. 'M'
	end

	return strReturn
end

function MergeLights(CATLIT, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)
	local strLight = ''
	local strCATLIT = CATLITToString(CATLIT[1])

	local numCoincidentLights = math.min(LengthofFirstSeq(CATLIT), LengthofFirstSeq(LITCHR2), LengthofFirstSeq(SIGPER2),LengthofFirstSeq(HEIGHT2))
	local strLITCHR = LITCHRToString(LITCHR2[1])
	local strSIGGRP = SIGGRPToString(SIGGRP2[1])
	local strSIGGEN = SIGGENToString(SIGGEN2[1])

	local strCOLOUR = ''
	local set = {}
	for v = 1, numCoincidentLights, 1 do
		colour = COLOUR2[v]
		if colour and not set[colour] then
			if colour =='1' then
				strCOLOUR = strCOLOUR .. 'W'
			else
				strCOLOUR = strCOLOUR .. COLOURToString(colour)
			end
			set[colour] = true
		end
	end

	local strSIGPER = SIGPERToString(SIGPER2[1])
	local strHEIGHT = HEIGHTToString(HEIGHT2[1])
--	local strVALNMR = VALNMRToString(VALNMR2[1])
	local strMLTYLT = MLTYLTToString(MLTYLT2[1])

	local strVALNMR = VALNMRArrayToString(VALNMR2, numCoincidentLights)
	
	if(#strCOLOUR > 0 and (#strCATLIT > 0 or #strSIGPER > 0 or #strHEIGHT > 0 or #strVALNMR > 0)) then
		strCOLOUR = strCOLOUR .. "."
	end

	if (#strLITCHR > 0 and #strSIGGRP == 0) then
		strLITCHR = strLITCHR .. '.'
	end

	if CATLIT[1] == '6' then
		if(#strHEIGHT == 0) then
			strLight = '(' .. strCOLOUR .. ' Lts)'
		else
			strLight = '(' .. strCOLOUR .. ' Lts)' .. '\n' .. '(' .. strHEIGHT .. ')'
		end
	elseif CATLIT[1] == '20' then
		strLight = strMLTYLT .. strLITCHR .. strSIGGRP .. strCOLOUR .. strCATLIT .. strSIGPER .. strHEIGHT .. strVALNMR .. strSIGGEN
	elseif STATUS2[1] == '11' then
		strLight = ''
	else
		strLight = strMLTYLT .. strCATLIT .. strLITCHR .. strSIGGRP .. strCOLOUR .. strSIGPER .. strHEIGHT .. strVALNMR .. strSIGGEN
	end

	return {text=strLight, height=HEIGHT2[1]}
--	return strLight
end
