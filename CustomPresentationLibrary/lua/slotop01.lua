function set(...)
	local ret = {}
	for _,k in ipairs({...}) do ret[k] = true end
	return ret
end

function slotop01(feature, context, symbology)
	local collection = symbology.collections[1]

	--local catslo = feature.attributes:get_list_attribute('CATSLO')
	local catslo = tonumber(feature.attributes.CATSLO)
	if set(4,5,6)[catslo] then
		collection:add_symbology_instruction({type='ComplexLine', Name='C3_Cliffs.svg'})
	elseif catslo == 1 then
		collection:add_symbology_instruction({type='ComplexLine', Name='D14_Cutting.svg'})
	elseif catslo == 2 then
		collection:add_symbology_instruction({type='ComplexLine', Name='D15_Embankment.svg'})
	elseif catslo == 3 then
		collection:add_symbology_instruction({type='ComplexLine', Name='C8_Dunes.svg'})
	elseif catslo == 7 then
		collection:add_symbology_instruction({type='ComplexLine', Name='Scree.svg'})

	end

	return true
end
