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

Units =
{
	meters = 1,
	millimeters = 2,
	inches = 3,
	feet = 4,
	yards = 5,
	fathoms = 6,
	kilometers = 7,
	statute_miles = 8,
	nautical_miles = 9,
	degrees = 10,
	S52_display_units = 11,
	points = 12,
	pixels = 13,
	factors =
	{
		1.0,	-- meters
		1000.0,	-- millimeters
		39.37007874015748031496062992126,	-- inches
		3.2808399,	-- feet
		1.09361,	-- yards
		0.546806649,	-- fathoms
		0.001,	-- kilometers
		0.000621371,	-- statute miles
		0.000539957,	-- nautical miles
		8.9831528411952143512750125646572e-6, -- degrees in WGS-84 meters
		100000.0,	-- S52 display units (.01 millimeters)
		2834.6438836888921644773767071643,	-- points
		3779.5275590551185863971727943456	-- pixels (@ 96 dpi)	
	}
}

Units.__index = Units

setmetatable(Units, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Units.new(...)
  local self = setmetatable({}, Units)
	self:set_value(...)
  return self
end

-- the : syntax here causes a "self" arg to be implicitly added before any other args
function Units:set_value(newval, type)
	self.value = 0
	if newval then
		self.value = newval / Units.factors[type or Units.meters]
	end
end

function Units:get_value(type)
  return self.value * Units.factors[type or Units.meters]
end
