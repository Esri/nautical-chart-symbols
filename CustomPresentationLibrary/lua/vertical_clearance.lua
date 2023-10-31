function vertical_clearance(arguments, context, symbology)
	local label = arguments['label']
	local value = tonumber(arguments['value'])
	local xo = arguments['xoffset']
	local yo = arguments['yoffset']

	if(value == nil) then
		return true
	end

	local format = '%4.1f'
	if context.depth_units ~= 1 then
		value = math.floor(value * 3.2808399)	-- convert meters to feet and truncate fractional portion
		format = '%d ft'
	end

	local params = {type='Text',color='', textGroup=11, xoffset=2, yoffset=1}--offsets changed from x and y = 0

	local collection = symbology.collections[1]

	if label == 'VERCLR' then
		--collection:add_symbology_instruction({type='Symbol', Name='D22_Vert_clr.svg'})
		params.text = string.format(format,value)
		collection:add_symbology_instruction(params)
	elseif label == 'VERCOP' then
		collection:add_symbology_instruction({type='Symbol', Name='D22_Vert_clr.svg'})
		params.text = string.format(format, value)--edit from 'clr op '
		collection:add_symbology_instruction(params)
	elseif label == 'VERCCL' then
		--collection:add_symbology_instruction({type='Symbol', Name='D22_Vert_clr.svg'})
		params.text = string.format(format, value) --edit from 'clr cl'
		collection:add_symbology_instruction(params)
	elseif label == 'VERCSA' then
		local params = {type='Text',color='#db4996', textGroup=11, xoffset=2, yoffset=1}-- Safe vertical clearance magenta text
		collection:add_symbology_instruction({type='Symbol', Name='D26_2_SafeVertClearance.svg'})
		params.text = string.format(format, value)
		collection:add_symbology_instruction(params)
	elseif label == 'HORCLR' then
		params.text = string.format('hor clr ' .. format, value)
	end

	return true
end
