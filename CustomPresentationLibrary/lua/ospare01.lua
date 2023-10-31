--New function and file at 11.2 (06June2023)
function ospare01(feature, context, symbology)
	local collection = symbology.collections[1]
	collection:add_symbology_instruction({type='ComplexLine', Name='N1_Limit_general.svg'})
	
end