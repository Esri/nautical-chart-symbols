function set(...)
	local ret = {}
	for _,k in ipairs({...}) do ret[k] = true end
	return ret
end

function roadwy01(feature, context, symbology)
	local collection = symbology.collections[1]

	local catrod = tonumber(feature.attributes.CATROD)
	if set(1,2,3)[catrod] then
		collection:add_symbology_instruction({type='ComplexLine', Name='D11_Roadway.svg'})
	elseif catrod == 4 then
		collection:add_symbology_instruction({type="SimpleLine", color='black', style='DASH', width=.2})
	else
		collection:add_symbology_instruction({type="ComplexLine", Name='D11_Roadway.svg'})
	end

	return true
end
