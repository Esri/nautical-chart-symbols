function set(...)
	local ret = {}
	for _,k in ipairs({...}) do ret[k] = true end
	return ret
end

function pipsol01(feature, context, symbology)
	local collection = symbology.collections[1]

	local catpip = tonumber(feature.attributes.CATPIP)
	if set(2,3,4)[catpip] then
		collection:add_symbology_instruction({type='ComplexLine', Name='L41_pipeline_outfall_intake.svg'})
	else
		collection:add_symbology_instruction({type='ComplexLine', Name='L40_pipeline_supply.svg'})
	end

	return true
end
