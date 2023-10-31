--New function and file at 11.2 (06June2023)
function obstnare01(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="AreaFill", color='#d1deef', transparency=0}) -- fill color matches shallow water tint 1 in depare01.lua
	collection:add_symbology_instruction({type="SimpleLine", color='#4B4B4B', style='DOT', width=.32})
	
end