function contains(value, array)
	if type(value) == 'table' then
		for i = 1, #array do
			if value[array[i]] then
					return true
			end
		end
	else
		for i = 1, #array do
			if array[i] == value then
				return true
			end
		end
	end

	return false
end

