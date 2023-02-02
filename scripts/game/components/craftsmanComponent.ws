/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




struct SCraftsman
{
	editable var type : ECraftsmanType;
	editable var level : ECraftsmanLevel;
	editable var noCraftingCost : Bool;
}

class W3CraftsmanComponent extends W3MerchantComponent
{
	editable var craftsmanData : array<SCraftsman>;

	public function GetMapPinType() : name
	{
		var i, size : int;		
		size = craftsmanData.Size();
		for ( i = 0; i < size; i += 1 )
		{
			if ( craftsmanData[i].level == ECL_Arch_Master )
			{
				return 'Archmaster';
			}
		}
		return super.GetMapPinType();
	}
	
	public function GetCraftsmanLevel( type : ECraftsmanType ) : ECraftsmanLevel
	{
		var i, size : int;		
		
		size = craftsmanData.Size();

		for ( i = 0; i < size; i += 1 )
		{
			if ( craftsmanData[i].type == type )
			{
				return craftsmanData[i].level;
			}
			else if ( ECT_Crafter == type && ( craftsmanData[i].type == ECT_Smith || craftsmanData[i].type == ECT_Armorer ) )
			{
				return craftsmanData[i].level;
			}
		}
		return ECL_Undefined;
	}

	public function IsCraftsmanType( type : ECraftsmanType ) : bool
	{
		var i, size : int;		
		
		size = craftsmanData.Size();

		for ( i = 0; i < size; i += 1 )
		{
			if ( craftsmanData[i].type == type )
			{
				return true;
			}
			else if ( ECT_Crafter == type && ( craftsmanData[i].type == ECT_Smith || craftsmanData[i].type == ECT_Armorer || craftsmanData[i].type == ECT_Enchanter ) )
			{
				return true;
			}
		}
	
		return false;
	}

	public function CalculateCostOfCrafting( craftedItemName : name ) : int
	{
		var i, size, craftingCost : int;		
		var invItem : SInventoryItem;
		var owner : W3MerchantNPC;
		var items : array<SItemUniqueId>;

		if ( craftsmanData.Size() > 0 )
		{
			if ( true == craftsmanData[0].noCraftingCost )
			{
				return 0;
			}
		}

		owner = (W3MerchantNPC) this.GetEntity();
		if ( owner )
		{
			if ( owner.invComp )
			{
				items = owner.invComp.AddAnItem( craftedItemName, 1 );
				if ( items.Size() > 0 )
				{
					craftingCost = owner.invComp.GetItemPriceCrafting( owner.invComp.GetItem( items[ 0 ] ) );
					owner.invComp.RemoveItem( items[ 0 ], 1 );
					return craftingCost;
				}
			}
		}

		return -1;
	}

	event OnComponentAttachFinished()
	{
		var owner : W3MerchantNPC;
		var crafterType : ECraftsmanType;
		var crafterLevel : ECraftsmanLevel;
		
		owner = (W3MerchantNPC) this.GetEntity();
		
		
		owner.RemoveTag( 'Blacksmith' );
		owner.RemoveTag( 'Armorer' );
		owner.RemoveTag( 'Apprentice' );
		owner.RemoveTag( 'Specialist' );
		owner.RemoveTag( 'Master' );
		owner.RemoveTag( 'type_enchanter' );
		
		if( owner )
		{
			if( IsCraftsmanType( ECT_Smith ) )
			{
				owner.AddTag( 'Blacksmith' );
				SetCrafterLevelTag( ECT_Smith );
			}
			
			if( IsCraftsmanType( ECT_Armorer ) )
			{
				owner.AddTag( 'Armorer' );
				SetCrafterLevelTag( ECT_Armorer );
			}
			
			if( IsCraftsmanType( ECT_Enchanter ) )
			{
				owner.AddTag( 'type_enchanter' );
				SetCrafterLevelTag( ECT_Enchanter );
			}

		}
		
	}
	
	function SetCrafterLevelTag( type : ECraftsmanType )
	{
		var level :  ECraftsmanLevel;
		var owner : W3MerchantNPC;
		
		owner = (W3MerchantNPC) this.GetEntity();
		level = GetCraftsmanLevel( type );
		
		switch( level )
		{
			case ECL_Journeyman:
				owner.AddTag('Apprentice');
			break;
			
			case ECL_Master:
				owner.AddTag('Specialist');
			break;
			
			case ECL_Grand_Master:
				owner.AddTag('Master');
			break;
				
			case ECL_Arch_Master:
				owner.AddTag('Archmaster');
			break;
		}
	}
	
	protected function LoadSchematicsXMLData() : array<SEnchantmentSchematic>
	{
		var dm : CDefinitionsManagerAccessor;
		var main, ingredients : SCustomNode;
		var tmpName : name;
		var tmpInt : int;
		var schem : SEnchantmentSchematic;
		var i : int;
		var schematics : array<SEnchantmentSchematic>;
		
		dm = theGame.GetDefinitionsManager();
		main = dm.GetCustomDefinition('crafting_schematics');
		
		for(i=0; i<main.subNodes.Size(); i+=1)
		{
			dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'name_name', tmpName);
			
			if(!StrContains(NameToString(tmpName), "Runeword") && !StrContains(NameToString(tmpName), "Glyphword"))
				continue;
				
			schem.schemName = tmpName;
			
			if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'level', tmpInt))
				schem.level = tmpInt;	
				
			schematics.PushBack(schem);		
			
			
			schem.level = -1;
			schem.schemName = '';
			tmpName = '';
		}
		
		return schematics;
	}
	
	function GetEnchanterItems(addRuneword : bool, addGlyphword : bool) : array< CName >
	{		
		var level   	: ECraftsmanLevel;
		var resultList  : array< CName >;
		var schematics	: array<SEnchantmentSchematic>;
		var i 			: int;
		var isRuneword	: bool;
		
		level = GetCraftsmanLevel( ECT_Enchanter );
		
		
		
		
		schematics = LoadSchematicsXMLData();
		
		for(i=0; i<schematics.Size(); i+=1)
		{
			if(schematics[i].level > level)
				continue;
				
			isRuneword = StrStartsWith(NameToString(schematics[i].schemName), "Runeword");
			
			if((isRuneword && addRuneword) || (!isRuneword && addGlyphword))
				resultList.PushBack(schematics[i].schemName);
		}
		
		return resultList;
	}
}
