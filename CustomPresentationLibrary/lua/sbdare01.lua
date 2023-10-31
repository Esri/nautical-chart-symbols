function sbdare01(feature, context, symbology)
	local collection = symbology.collections[1]

	local natsur = feature.attributes:get_list_attribute('NATSUR')
	local watlev = tonumber(feature.attributes.WATLEV)
	if contains(natsur, {9,11,14}) and watlev == 4 then
		collection:add_symbology_instruction({type='ComplexLine', Name='rock_ledge.svg'})
		collection.RemoveSymbols = true
		collection.DisplayPriority = 5
		collection.DisplaySubPriority = 1
	end

	return true
end
