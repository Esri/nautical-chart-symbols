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
require 'light_functions'

local function doSymbol2(collection, colors, rotation, rotationField)
	local symbol

	if contains(colors, {4}) then
		symbol = 'P1_Light_green.svg'
	elseif contains(colors, {3}) then
		symbol = 'P1_Light_red.svg'
	elseif contains(colors, { 1, 6, 9, 11 }) then
		symbol = 'P1_Light_white.svg'
	else
		symbol = 'P1_Light.svg'
	end

	if(rotationField) then
		collection:add_symbology_instruction({type='Symbol', Name=symbol, rotation=rotation, rotationField=rotationField})
	else
		collection:add_symbology_instruction({type='Symbol', Name=symbol, rotation=rotation})
	end
end

local function doSymbol(collection, COLOUR, rotation, rotationField)
	local symbol
	local color = tonumber(COLOUR)
	if color == 4 then
		symbol = 'Light_Flare_green.svg'
	elseif color == 3 then
		symbol = 'Light_Flare_red.svg'
	elseif color == 1 or color == 6 or color == 9 or color == 11 then
		symbol = 'Light_Flare_white.svg'
	else
		symbol = 'Light_Flare.svg'
	end

	if(rotationField) then
		collection:add_symbology_instruction({type='Symbol', Name=symbol, rotation=rotation, rotationField=rotationField})
	else
		collection:add_symbology_instruction({type='Symbol', Name=symbol, rotation=rotation})
	end
end

local function LightCompare2(light1, light2)
	local string1 = light1.CATLIT or '' .. light1.LITCHR or '' .. light1.SIGPER or '' ..  light1.HEIGHT or ''
	local string2 = light2.CATLIT or '' .. light2.LITCHR or '' .. light2.SIGPER or '' ..  light2.HEIGHT or ''

	return string1 < string2
end

local function LightCompare(light1, light2)
	local string1 = light1.attributes.CATLIT or '' .. light1.attributes.LITCHR or '' .. light1.attributes.SIGPER or '' ..  light1.attributes.HEIGHT or ''
	local string2 = light2.attributes.CATLIT or '' .. light2.attributes.LITCHR or '' .. light2.attributes.SIGPER or '' ..  light2.attributes.HEIGHT or ''

	return string1 < string2
end

local function getNavlneOrient(feature)
	local shared_features = feature.other_features
	for v = 1, #shared_features, 1 do
		local shared_feature = shared_features[v]
		if(shared_feature.acronym == 'NAVLNE') then
			return shared_feature.attributes.ORIENT;
		end
	end
end

local function GetCoincidentLights2(feature, CATLIT, LITCHR, SIGGRP, SIGPER, VALNMR, COLOUR, HEIGHT, MLTYLT, STATUS, SIGGEN)
	local shared_features = feature.other_features

	local light_table = {}
	local light_count = 0;
	local light_number = 0;

	for v = 1, #shared_features, 1 do
		local shared_feature = shared_features[v]
		if(shared_feature.acronym == 'LIGHTS') then
			light_count = light_count + 1
			light_table[light_count] = shared_feature.attributes
			if shared_feature.rcid == feature.rcid then
				light_number = light_count
			end
		end
	end

	table.sort(light_table, LightCompare)

	for v = 1, #light_table, 1 do
		local attributes = light_table[v]
		CATLIT[v] = attributes.CATLIT or ''
		LITCHR[v] = attributes.LITCHR
		SIGGRP[v] = attributes.SIGGRP
		SIGPER[v] = attributes.SIGPER
		VALNMR[v] = tonumber(attributes.VALNMR) or 0
		COLOUR[v] = attributes.COLOUR
		HEIGHT[v] = attributes.HEIGHT or ''
		MLTYLT[v] = attributes.MLTYLT
		STATUS[v] = attributes.STATUS
		SIGGEN[v] = attributes.SIGGEN
	end

	return light_number
end

local function GetCoincidentLights(feature, CATLIT, LITCHR, SIGGRP, SIGPER, VALNMR, COLOUR, HEIGHT, MLTYLT, STATUS, SIGGEN)
	local shared_features = feature.other_features

	local light_table = {}
	local light_count = 0;
	local light_number = 0;

	for v = 1, #shared_features, 1 do
		local shared_feature = shared_features[v]
		if(shared_feature.acronym == 'LIGHTS') then
			light_count = light_count + 1
			light_table[light_count] = shared_feature
			if shared_feature.rcid == feature.rcid then
				light_number = light_count
			end
		end
	end

	table.sort(light_table, LightCompare)

	for v = 1, #light_table, 1 do
		local shared_feature = light_table[v]
		CATLIT[v] = shared_feature.attributes.CATLIT or ''
		LITCHR[v] = shared_feature.attributes.LITCHR
		SIGGRP[v] = shared_feature.attributes.SIGGRP
		SIGPER[v] = shared_feature.attributes.SIGPER
		VALNMR[v] = tonumber(shared_feature.attributes.VALNMR) or 0
		COLOUR[v] = shared_feature.attributes.COLOUR
		HEIGHT[v] = shared_feature.attributes.HEIGHT or ''
		MLTYLT[v] = shared_feature.attributes.MLTYLT
		STATUS[v] = shared_feature.attributes.STATUS
		SIGGEN[v] = shared_feature.attributes.SIGGEN
	end

	return light_number, light_count
end

local function GetCoincidentLights3(feature, CATLIT, LITCHR, SIGGRP, SIGPER, VALNMR, COLOUR, HEIGHT, MLTYLT, STATUS, SIGGEN)
	local shared_features = feature.other_features

	local light_count = 0;
	local light_number = 0;

	for v = 1, #shared_features, 1 do
		local shared_feature = shared_features[v]
		if(shared_feature.acronym == 'LIGHTS') then
			light_count = light_count + 1
			CATLIT[v] = shared_feature.attributes.CATLIT or ''
			LITCHR[v] = shared_feature.attributes.LITCHR
			SIGGRP[v] = shared_feature.attributes.SIGGRP
			SIGPER[v] = shared_feature.attributes.SIGPER
			VALNMR[v] = tonumber(shared_feature.attributes.VALNMR) or 0
			COLOUR[v] = shared_feature.attributes.COLOUR
			HEIGHT[v] = shared_feature.attributes.HEIGHT or ''
			MLTYLT[v] = shared_feature.attributes.MLTYLT
			STATUS[v] = shared_feature.attributes.STATUS
			SIGGEN[v] = shared_feature.attributes.SIGGEN
			if shared_feature.rcid == feature.rcid then
				light_number = light_count
			end
		end
	end

	return light_number
end

local function IsMajorLight(feature)
	local catlit = feature.attributes:get_list_attribute('CATLIT')
	local litchr = tonumber(feature.attributes.LITCHR or '0')
	local valnmr = tonumber(feature.attributes.VALNMR or '0')
	Debug.log('IsMajorLight:' .. tostring(valnmr >= 10) .. ' ' .. tostring(not (catlit[5] or catlit[6])) .. ' ' .. tostring(litchr ~= 12))
--	return (valnmr >= 10 and (not (catlit[5] or catlit[6])) and litchr ~= 12)
	return false
end

function lights01(feature, context, symbology)
	local CATLIT2 = {}
	local LITCHR2 = {}
	local SIGGRP2 = {}
	local SIGPER2 = {}
	local VALNMR2 = {}
	local COLOUR2 = {}
	local HEIGHT2 = {}
	local MLTYLT2 = {}
	local STATUS2 = {}
	local SIGGEN2 = {}

--	GetCoincidentLights(feature, CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

--	local strLight = MergeLights(CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

	local light_info = ConcatenateLightInfo(feature.attributes.CATLIT, feature.attributes.LITCHR, feature.attributes.SIGGRP, feature.attributes.SIGPER,
		feature.attributes.VALNMR, feature.attributes.COLOUR, feature.attributes.HEIGHT, feature.attributes.MLTYLT, feature.attributes.STATUS, feature.attributes.SIGGEN)

	local strLight = light_info.text

	local collection = symbology.collections[1]

	local params = 
	{
		type='Text',
		fontName='HelveticaNeueLT Pro 55 Roman',
		fontWeight='bold',
		fontSize=8,
		color='black',
		hjust='left',
		vjust='top',
		xoffset=1, --changed from 3 at 11.2
		yoffset=0.5, --changed from 1 at 11.2
		textGroup=23,
		text=strLight
	}

	local arguments = {params=params, height=light_info.height}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='dynamic_light_string', arguments=arguments})
	collection.RemoveText = true

--	collection:add_symbology_instruction(params)

	Debug.log(strLight)

	if not IsMajorLight(feature) then
		local rotation = 135
		local ORIENT = feature.attributes.ORIENT
		if not ORIENT then
			ORIENT = getNavlneOrient(feature)
		end
		if(ORIENT and #ORIENT > 0) then
			rotation = tonumber(ORIENT) - 180
			if rotation < 0 then
				rotation = rotation + 360
			end
			doSymbol(collection, feature.attributes.COLOUR, rotation, 'ORIENT')
		else
			doSymbol(collection, feature.attributes.COLOUR, rotation)
		end
	end

	return true
end

function lights02(feature, context, symbology)

	local CATLIT2 = {}
	local LITCHR2 = {}
	local SIGGRP2 = {}
	local SIGPER2 = {}
	local VALNMR2 = {}
	local COLOUR2 = {}
	local HEIGHT2 = {}
	local MLTYLT2 = {}
	local STATUS2 = {}
	local SIGGEN2 = {}

--	GetCoincidentLights(feature, CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

	local light_info = ConcatenateLightInfo(feature.attributes.CATLIT, feature.attributes.LITCHR, feature.attributes.SIGGRP, feature.attributes.SIGPER,
		feature.attributes.VALNMR, feature.attributes.COLOUR, feature.attributes.HEIGHT, feature.attributes.MLTYLT, feature.attributes.STATUS, feature.attributes.SIGGEN)

	local strLight = light_info.text

	local collection = symbology.collections[1]
--floating lights
	local params = 
	{
		type='Text',
		fontName='HelveticaNeueLT Pro 55 Roman',
		fontWeight='bold|italic',
		fontSize=8,
		color='black',
		hjust='left',
		vjust='top',
		xoffset=1,
		yoffset=0.5,
		textGroup=23,
		text=strLight
	}
	local arguments = {params=params, height=light_info.height}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='dynamic_light_string', arguments=arguments})
	collection.RemoveText = true

--	collection:add_symbology_instruction(params)

--	Debug.log(strLight)

	doSymbol(collection, feature.attributes.COLOUR, 135)

	return true
end

function lights03(feature, context, symbology)

	local CATLIT2 = {}
	local LITCHR2 = {}
	local SIGGRP2 = {}
	local SIGPER2 = {}
	local VALNMR2 = {}
	local COLOUR2 = {}
	local HEIGHT2 = {}
	local MLTYLT2 = {}
	local STATUS2 = {}
	local SIGGEN2 = {}

	local lightnumber = GetCoincidentLights(feature, CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

	if lightnumber == 1 then
		local light_info = MergeLights(CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

		local strLight = light_info.text

		local collection = symbology.collections[1]
--sector lights
		local params = 
		{
			type='Text',
			fontName='HelveticaNeueLT Pro 55 Roman',
			fontWeight='bold', -- changed from medium at 11.2
			fontSize=8,
			color='black',
			hjust='left',
			vjust='top',
			xoffset=1, -- changed from 3 at 11.2
			yoffset=0.5, --changed from 1 at 11.2
			textGroup=23,
			text=strLight
		}
		local arguments = {params=params, height=light_info.height}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='dynamic_light_string', arguments=arguments})
		collection.RemoveText = true

--		collection:add_symbology_instruction(params)
		if feature.rcid == 508 then
			Debug.log('lights03: ' .. 'rcid=' .. tostring(feature.rcid) .. ' ' .. 'color=' .. COLOUR2[1] .. ' ' .. strLight)
		end
	end
-- WRGWRG.8-6M
	return true
end

function lights04(feature, context, symbology)
	local CATLIT2 = {}
	local LITCHR2 = {}
	local SIGGRP2 = {}
	local SIGPER2 = {}
	local VALNMR2 = {}
	local COLOUR2 = {}
	local HEIGHT2 = {}
	local MLTYLT2 = {}
	local STATUS2 = {}
	local SIGGEN2 = {}

	local lightnumber, lightcount = GetCoincidentLights(feature, CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)
	Debug.log("GetCoincidentLights:" .. tostring(lightnumber) .. '/' .. tostring(lightcount))

	local light_info = {}
	if lightcount > 1 then
		if lightnumber == 1 then
			light_info = MergeLights(CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)
		end
	else
		light_info = ConcatenateLightInfo(feature.attributes.CATLIT, feature.attributes.LITCHR, feature.attributes.SIGGRP, feature.attributes.SIGPER,
			feature.attributes.VALNMR, feature.attributes.COLOUR, feature.attributes.HEIGHT, feature.attributes.MLTYLT, feature.attributes.STATUS, feature.attributes.SIGGEN)
	end

	local strLight = light_info.text

	local collection = symbology.collections[1]
--non-sectored lights (land)
	if strLight and #strLight > 0 then
		local params = 
		{
			type='Text',
			fontName='HelveticaNeueLT Pro 55 Roman',
			fontWeight='bold', --changed from medium at 11.2
			fontSize=8,
			color='black',
			hjust='left',
			vjust='top',
			xoffset=1, --changed from 3 at 11.2
			yoffset=0.5, --changed from 1 at 11.2
			textGroup=23,
			text=strLight
		}
		local arguments = {params=params, height=light_info.height}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='dynamic_light_string', arguments=arguments})
		collection.RemoveText = true

--		collection:add_symbology_instruction(params)

		Debug.log(strLight)
	end

	if feature.rcid == 1155 then
		Debug.log('lights04: ' .. 'rcid=' .. tostring(feature.rcid) .. ' ' .. 'color=' .. feature.attributes.COLOUR .. ' ' .. tostring(strLight))
	end

	if not IsMajorLight(feature) then
		local rotation = 135
		local colors = feature.attributes:get_list_attribute('COLOUR')
		if lightcount > 1 then
			if contains(colors, { 1, 6, 9, 11 }) then
				rotation = 45
			end
		end

		local ORIENT = feature.attributes.ORIENT
		if not ORIENT then
			ORIENT = getNavlneOrient(feature)
		end
		if(ORIENT and #ORIENT > 0) then
			rotation = tonumber(ORIENT) - 180
			if rotation < 0 then
				rotation = rotation + 360
			end
			doSymbol2(collection, colors, rotation, 'ORIENT')
		else
			doSymbol2(collection, colors, rotation)
		end
	else
--		error("Major light!")
	end

	return true
end

function IsSectorLight(feature, context)
	local SECTR1 = feature.attributes.SECTR1
	return SECTR1 and #SECTR1 > 0
end

local function HasMultipleLights(feature)
	local shared_features = feature.other_features

	local light_count = 0;
	local light_number = 0;

	for v = 1, #shared_features, 1 do
		local shared_feature = shared_features[v]
		if(shared_feature.acronym == 'LIGHTS') then
			light_count = light_count + 1
			if shared_feature.rcid == feature.rcid then
				light_number = light_count
			end
		end
	end
	return light_count > 1
end

function LightString(feature, context, symbology)

	local CATLIT2 = {}
	local LITCHR2 = {}
	local SIGGRP2 = {}
	local SIGPER2 = {}
	local VALNMR2 = {}
	local COLOUR2 = {}
	local HEIGHT2 = {}
	local MLTYLT2 = {}
	local STATUS2 = {}
	local SIGGEN2 = {}

	local lightnumber = GetCoincidentLights(feature, CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

	if lightnumber == 1 then
		local light_info = MergeLights(CATLIT2, LITCHR2, SIGGRP2, SIGPER2, VALNMR2, COLOUR2, HEIGHT2, MLTYLT2, STATUS2, SIGGEN2)

		local strLight = light_info.text

		local collection = symbology.collections[1]
--OSFPLF and Flood Light see customsymbolmap.xml file
		local params = 
		{
			type='Text',
			fontName='HelveticaNeueLT Pro 55 Roman',
			fontWeight='bold',
			fontSize=8,--changed from 10 at 11.2
			color='black',
			hjust='left',
			vjust='top',
			xoffset=1, --changed from 3 at 11.2
			yoffset=0.5, --changed from 1 at 11.2
			textGroup=23,
			text=strLight
		}
		local arguments = {params=params, height=light_info.height}
		collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='dynamic_light_string', arguments=arguments})
		collection.RemoveText = true

--		collection:add_symbology_instruction(params)
		Debug.log('LightString: ' .. 'rcid=' .. tostring(feature.rcid) .. ' ' .. strLight)
	end
	return true
end

