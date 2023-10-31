function convyr02(feature, context, symbology)
	local collection = symbology.collections[1]

	local verclr = feature.attributes.VERCLR

	if(verclr == nil) then
		return true
	end

	local collection = symbology.collections[1]
	local arguments = {label='VERCLR', value=verclr, xoffset=1, yoffset=0}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='vertical_clearance', arguments=arguments})

	collection.RemoveText = true

	return true
end