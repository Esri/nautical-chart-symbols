--LANDA;brown;0.3500;0.3900;50.000;244;232;193;0.455222  
--LANDF;brown;0.4500;0.4200;15.000;154;111; 55;0.289818
-- runs during scenc build, don't expect to change based on display settings

function buaare01(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type="AreaFill", color='#efd8a3', transparency=0})
end