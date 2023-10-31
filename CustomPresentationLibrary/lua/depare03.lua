function depare03(feature, context, symbology)
	local collection = symbology.collections[1]

	local arguments = {DRVAL1=feature.attributes.DRVAL1, DRVAL2=feature.attributes.DRVAL2}
	collection:add_symbology_instruction({type="ConditionalSymbologyProcedure", postExecute='depare01',arguments=arguments})
-- DRGARE script is moved to drgare02.lua, therefore the instruction below is commented out
	-- if(feature.acronym == 'DRGARE') then
		-- --collection:add_symbology_instruction({type="AreaPattern", PatternName='DRGARE01'})
		-- collection:add_symbology_instruction({type="SimpleLine", color='CHBLK', style='DASH', width=.32})
	-- end

	if(feature.low_accuracy) then
		collection:add_symbology_instruction({type="SimpleLine", color='DEPSC', style='DASH', width=.64, paint='LOWACC,SAFCON'})
	end

	collection:add_symbology_instruction({type="SimpleLine", color='DEPSC', style='SOLID', width=.64, paint='HIGHACC,SAFCON'})

	return true
end