require 'unit_conversion'

function lndelv01(feature, context, symbology)
	local elevation = tonumber(feature.attributes.ELEVAT)

	if(elevation == nil) then
		return true
	end

	local collection = symbology.collections[1]

	local arguments = {elevation=elevation}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='lndelv01:post_symbolize', arguments=arguments})

	collection.RemoveText = true

	return true
end

function post_symbolize(arguments, context, symbology)
	local elevation = arguments['elevation']

	local collection = symbology.collections[1]

	local params = --Modifed hjust, vjust, xoffset, yoffset at 11.2
	{
		type='Text',
		fontSize=10,
		color='CHBLK',
		hjust='right',
		vjust='center',
		xoffset=-1,
		yoffset=0,
		textGroup=28,
	}

	local units = Units(elevation, Units.meters)
	local format = '%4.1f m'

	if context.depth_units ~= 1 then
		elevation = math.ceil(units:get_value(Units.feet))	-- convert meters to feet rounded to next higher foot and trucate fractional portion
		format = '%d ft'
	end

	params.text = string.format(format, elevation)

	collection:add_symbology_instruction(params)

	return true
end
--New function at 11.2 for land elevation contours from s-52 brown to black
function lndelv02(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="SimpleLine", color='black', style='SOLID', width=.2})
end