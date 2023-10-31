require 'symbolize_depth'

function sounding(feature, context, symbology)
	local depth = tonumber(feature.attributes.Depth)

	if(depth == nil) then
		return true
	end

	pre_symbolize_depth(feature, depth, symbology)

	return true
end
