require 'quapos01'

function coalne01(feature, context, symbology)
	local prim = feature.prim
	local collection = symbology.collections[1]
	local catcoa = tonumber(feature.attributes.CATCOA) or 0

	-- if the feature is line
	if prim == 2 then
		-- if CATCOA value is 6,7,8 or 10, symbolize line segment LS(DASH,1,CSTLN) (see COALNE part in lsymref.dic)
		if catcoa == 6 or catcoa == 7 or catcoa == 8 or catcoa == 10  then
			collection:add_symbology_instruction({type="SimpleLine", color='CSTLN', style='DASH', width=.32})
		-- if CATCOA doesn't euqal to 6,7,8 or 10, call quapos01
		else
			return quapos01(feature, context, symbology)
		end
	end

	return true
end

			