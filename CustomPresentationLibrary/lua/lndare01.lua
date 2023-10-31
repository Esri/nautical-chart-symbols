require 'quapos01'

function lndare01(feature, context, symbology)
	local collection = symbology.collections[1]
	-- if the feature is point, SY(LNDARE01) and TX(OBJNAM,1,2,2,'15110',0,1,CHBLK,26); CS(QUAPOS01) (see LNDARE part in psymrefs.dic)
	-- here we changed the symbol to K10_LandPoint.svg
	if feature.prim == 1 then  
		collection:add_symbology_instruction({type='Symbol', Name='K10_LandPoint.svg'})
		local params =
		{
			type='Text',
			hjust='center',
			vjust='center',
			fontSize=10,
			xoffset=0,
			yoffset=1,
			color='CHBLK',
			textGroup=26,
		}
		params.text = feature.attributes.OBJNAM
		collection:add_symbology_instruction(params)
		return quapos01(feature, context, symbology)
	-- if the feature is line, CS(QUAPOS01);TX(OBJNAM,1,1,2,'15110',0,1,CHBLK,26) (see LNDARE part in lsymref.dic)
	elseif feature.prim == 2 then 
		quapos01(feature, context, symbology)
		local params =
		{
			type='Text',
			hjust='center',
			vjust='bottom',
			fontSize=10,
			xoffset=0,
			yoffset=1,
			color='CHBLK',
			textGroup=26,
		}
		params.text = feature.attributes.OBJNAM
		collection:add_symbology_instruction(params)
	-- if the feature is area, AC(LANDA);TX(OBJNAM,1,2,3,'15110',-1,-1,CHBLK,26) (see LNDARE part in asymrefpb.dic)
	-- here we changed the color from LANDA to #f4e8c1
	else
		collection:add_symbology_instruction({type="AreaFill", color='#f4e8c1', transparency=0})
		local params =
		{
			type='Text',
			hjust='center',
			vjust='center',
			fontSize=10,
			xoffset=-1,
			yoffset=-1,
			color='CHBLK',
			textGroup=26,
		}
		params.text = feature.attributes.OBJNAM
		collection:add_symbology_instruction(params)
	end
	
	collection.RemoveText = true
	collection.RemoveSymbols = true

	return true
end