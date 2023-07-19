/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




abstract class W3GuiBaseInventoryComponent
{
	public var autoCleanNewMark:bool;
	default autoCleanNewMark = false;
	
	protected var _inv : CInventoryComponent;
	
	
	protected var highlightedItems : array< name >;
	
	private var ITEM_NEED_REPAIR_DISPLAY_VALUE : int;
		
	public function Initialize( inv : CInventoryComponent )
	{
		ITEM_NEED_REPAIR_DISPLAY_VALUE = theGame.params.ITEM_DAMAGED_DURABILITY;
		_inv = inv;
	}
	
	
	protected function InvalidateItems( items : array<SItemUniqueId> )
	{
	}
	
	
		
	public function GetInventoryComponent() : CInventoryComponent
	{
		return _inv;
	}

	public function GetItemName(item : SItemUniqueId):name
	{
		return _inv.GetItemName(item);
	}
	
	public function GiveItem( itemId: SItemUniqueId, customer : W3GuiBaseInventoryComponent, optional quantity : int, optional out newItemID : SItemUniqueId ) : bool
	{
		var invalidatedItems : array< SItemUniqueId >;
		
		var success: bool;
		
		if( quantity  < 1 )
		{
			quantity = 1;
		}
		
		success = false;
		
		if ( customer.ReceiveItem( itemId, this, quantity, newItemID ) )
		{
			success = true;
			invalidatedItems.PushBack( itemId ); 
			InvalidateItems( invalidatedItems );
		}
		
		return success;
	}
	
	public function ReceiveItem( itemId : SItemUniqueId, giver : W3GuiBaseInventoryComponent, optional quantity : int, optional out newItemID : SItemUniqueId ) : bool
	{
		var invalidatedItems : array< SItemUniqueId >;
		var success: bool;
		
		success = false;
		if( quantity  < 1 )
		{
			quantity = 1;
		}
		
		newItemID = giver._inv.GiveItemTo( _inv, itemId, quantity, true );
		if ( newItemID != GetInvalidUniqueId() )
		{
			invalidatedItems.PushBack( newItemID );
			InvalidateItems( invalidatedItems );
			success = true;
		}
		
		return success;
	}
	
	public function CanDrop( item : SItemUniqueId ):bool
	{
		var canDrop : bool;
		
		canDrop = !_inv.ItemHasTag(item, 'NoDrop') && !_inv.ItemHasTag(item, 'Quest');
		
		
		
		if(canDrop && FactsQuerySum("tut_forced_preparation") > 0 && _inv.GetItemName(item) == 'Thunderbolt 1')
		{
			canDrop = false;
		}
		
		return canDrop;
	}
	
	public function DropItem( item : SItemUniqueId, quantity : int ) 
	{
		var invalidatedItems : array< SItemUniqueId >;
		if( CanDrop(item ) ) 
		{
				_inv.DropItemInBag(item, quantity);
				invalidatedItems.PushBack( item );
				InvalidateItems( invalidatedItems );
		}
	}	
		
	public function ClearItemIsNewFlag( item : SItemUniqueId )
	{
		var invalidatedItems : array< SItemUniqueId >;
		var uiData : SInventoryItemUIData;
		 
		uiData = _inv.GetInventoryItemUIData( item );
		uiData.isNew = false;
		_inv.SetInventoryItemUIData( item, uiData );
		
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}
	
	
	
	
	
	public var maxItemLimit : int;
	default maxItemLimit = 9999;
	
	
	public function GetInventoryFlashArray( out flashArray : CScriptedFlashArray, flashObject : CScriptedFlashObject ) : void
	{
		var i : int;
		var item : SItemUniqueId;
		var rawItems : array< SItemUniqueId >;
		var l_flashObject : CScriptedFlashObject;
		var itemCount : int; 
		
		_inv.GetAllItems( rawItems );
		
		
		for ( i = 0; i < rawItems.Size(); i += 1 )
		{		
			item = rawItems[i];
			
			if ( ShouldShowItem( item ) && itemCount < maxItemLimit ) 
			{
				
				l_flashObject = flashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
				SetInventoryFlashObjectForItem( item, l_flashObject );
				flashArray.PushBackFlashObject(l_flashObject);
				
				itemCount += 1; 
			}
		}
	}	
	
	public function HasNewFlagOnItem( optional out hasVisibleItems : bool ) : bool
	{
		var i : int;
		var item : SItemUniqueId;
		var rawItems : array< SItemUniqueId >;
		var uiData : SInventoryItemUIData;
		
		_inv.GetAllItems( rawItems );
		
		
		hasVisibleItems = false;
		
		for ( i = 0; i < rawItems.Size(); i += 1 )
		{
			item = rawItems[i];
			
			if ( ShouldShowItem( item ) )
			{
				hasVisibleItems = true;
				uiData = _inv.GetInventoryItemUIData( item );
				
				if (uiData.isNew)
				{
					return true;
					break;
				}
			}
		}
		
		return false;
	}
	
	public function ShouldShowItem( item : SItemUniqueId ) : bool
	{
		var itemTags : array<name>;
		
		_inv.GetItemTags( item, itemTags );
		
		
		if ( itemTags.Contains( theGame.params.TAG_DONT_SHOW) )
		{
			return false;
		}
		
		if ( _inv.GetItemName( item ) == 'Crowns' ) return false; 
		
		if(_inv.GetEntity() == thePlayer && itemTags.Contains( theGame.params.TAG_DONT_SHOW_ONLY_IN_PLAYERS))
		{
			return false;
		}
		
		return true;
	}
	
	
	public function GetItemActionType( item : SItemUniqueId, optional bGetDefault : bool ) : EInventoryActionType
	{
		var actionType : EInventoryActionType;
		var itemCategory : name;
		var tags : array<name>;
		var debugi:int;
		
		actionType = IAT_None;
		itemCategory = _inv.GetItemCategory( item );
		_inv.GetItemTags(item, tags);
		
		if(tags.Contains('NoUse'))
		{
			actionType = IAT_None;
		}
		
		
		
		
		
		
		
		
		
		else if(
				tags.Contains('Weapon') || tags.Contains('Armor') ||
			    tags.Contains('QuickSlot') || tags.Contains('Potion') || tags.Contains('Petard') || 			    
			    tags.Contains('PlayerSilverWeapon') || tags.Contains('PlayerSteelWeapon') || tags.Contains('PlayerSecondaryWeapon') || tags.Contains('PlayerRangedWeapon') || tags.Contains('bolt'))
		{
			actionType = IAT_Equip;
		}
		else if ( itemCategory == 'oil')
		{
			if ( tags.Contains(theGame.params.TAG_STEEL_OIL) && tags.Contains(theGame.params.TAG_SILVER_OIL) )
			{
				actionType = IAT_UpgradeWeapon;
			}
			else if ( tags.Contains(theGame.params.TAG_STEEL_OIL) )
			{
				actionType = IAT_UpgradeWeaponSteel;
			}
			else if ( tags.Contains(theGame.params.TAG_SILVER_OIL) )
			{
				actionType = IAT_UpgradeWeaponSilver;
			}
			else
			{
				actionType = IAT_UpgradeWeapon; 
			}
		}
		else if ( tags.Contains('Edibles' ) || tags.Contains('Drinks' ))
		{
			actionType = IAT_Consume;
		}
		else if (tags.Contains('ReadableItem'))
		{
			actionType = IAT_Read;
		}
		else if(tags.Contains('SingletonItem'))
		{
			actionType = IAT_Socket;
		}
		
			
		
				
		if ( actionType == IAT_None )
		{
			LogChannel('GuiDebug', "GetItemActionType AT=0 for " +  _inv.GetItemName( item )  + " Cat=" + itemCategory );			
			for ( debugi = 0; debugi < tags.Size(); debugi += 1 )
			{
				LogChannel('GuiDebug', "Tag: " + tags[debugi]);
			}
			LogChannel('GuiDebug', " GetItemActionType END ---------");
			
		}
		return actionType;
	}
	
	protected function GridPositionEnabled() : bool
	{
		return true;
	}
	
	public function clearGridPosition( item : SItemUniqueId ) : void
	{
		var uiData : SInventoryItemUIData;
		uiData = _inv.GetInventoryItemUIData( item );
		uiData.gridPosition = -1;
		_inv.SetInventoryItemUIData( item, uiData );
	}
	
	function SetInventoryFlashObjectForItem( item : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
	{
		var uiData : SInventoryItemUIData;
		var slotType : EEquipmentSlots;
		var curr, max : float;
		var gridSize : int;
		var equipped : int;
		var isQuest	 : bool;
		var canDrop	 : bool;
		var maxAmmo  : int;
		var charges  : string;
		var cantEquip : bool;
		var weight : float;
		var durability : float;
		var price : int;
		var colorName:name;
		
		var i : int;
		var highlightedItemsCount : int;
		var itemName : name;
		var quantity : int;
		var bRead : bool;
		var tmp: bool;
		var chargesCount:int;
		
		uiData = _inv.GetInventoryItemUIData( item );
		slotType = GetItemEquippedSlot( item );
		equipped = GetCurrentSlotForItem( item );
		isQuest = _inv.ItemHasTag(item,'Quest');
		canDrop = !isQuest && !_inv.ItemHasTag(item, 'NoDrop');
			
		if( slotType == EES_Quickslot2 && !_inv.IsItemMask( item ) ) 
		{
			slotType = EES_Quickslot1;
		}
		
		
		if( slotType == EES_Petard2 ) 
		{
			slotType = EES_Petard1;
		}
		
		
		flashObject.SetMemberFlashInt( "id", ItemToFlashUInt(item) );
		
		if (!_inv.IsItemOil(item))
		{
			if(_inv.IsItemSingletonItem(item))
			{
				if( thePlayer.inv.SingletonItemGetMaxAmmo(item) > 0 )
				{
					chargesCount = thePlayer.inv.SingletonItemGetAmmo(item);
					
					if( chargesCount <= 0 )
					{
						charges = "<font color=\"#CC0000\">" +  chargesCount + " " +"</font>";
					}
					else
					{
						charges = "<font color=\"#DEDEDE\">" +  chargesCount +  " " +"</font>";
					}
				}
				else
				{
					charges = "";
				}
				
				flashObject.SetMemberFlashString( "charges",  charges);
				flashObject.SetMemberFlashInt( "quantity", quantity);
			}
			else
			{
				quantity = _inv.GetItemQuantity(item);
				flashObject.SetMemberFlashInt( "quantity", quantity);
			}
		}
		
		itemName = _inv.GetItemName(item); 
		
		highlightedItemsCount = highlightedItems.Size();
		if (highlightedItemsCount > 0)
		{
			itemName = _inv.GetItemName(item);
			
			for (i = 0; i < highlightedItemsCount; i += 1)
			{
				if (highlightedItems[i] == itemName)
				{
					flashObject.SetMemberFlashBool( "highlighted", true );
				}
			}
		}		
		
		if( _inv.ItemHasTag( item, 'ReadableItem' ) && !isItemSchematic( item ) )
		{
			bRead = _inv.IsBookRead(item);
			
			flashObject.SetMemberFlashBool( "isReaded", bRead );
		}
		
		durability = _inv.GetItemDurability(item) / _inv.GetItemMaxDurability(item);
		weight = _inv.GetItemEncumbrance( item );
		price = _inv.GetItemQuantity(item) * _inv.GetItemPrice(item);
		flashObject.SetMemberFlashNumber("durability", durability); 
		flashObject.SetMemberFlashNumber("weight", weight); 
		flashObject.SetMemberFlashInt( "price", price); 
		flashObject.SetMemberFlashString( "iconPath",  _inv.GetItemIconPathByUniqueID(item) );
		if (GridPositionEnabled())
		{
			flashObject.SetMemberFlashInt( "gridPosition", uiData.gridPosition );
		}
		else
		{
			flashObject.SetMemberFlashInt( "gridPosition", -1 );
		}
		gridSize =  Clamp( uiData.gridSize, 1, 2 ); 
		
		if( _inv.IsItemColored( item ) )
		{
			colorName = _inv.GetItemColor( item );
			flashObject.SetMemberFlashString( "itemColor", NameToString( colorName ) );
		}
		
		flashObject.SetMemberFlashInt( "gridSize", gridSize );
		flashObject.SetMemberFlashInt( "slotType", slotType );
		flashObject.SetMemberFlashBool( "isNew", uiData.isNew );
		
		if( autoCleanNewMark && uiData.isNew )
		{
			uiData.isNew = false;
			_inv.SetInventoryItemUIData( item, uiData );
		}
		
		flashObject.SetMemberFlashBool( "isOilApplied", _inv.ItemHasAnyActiveOilApplied(item) && !_inv.IsItemOil( item ) );
		flashObject.SetMemberFlashInt( "equipped", equipped );
		
		flashObject.SetMemberFlashInt( "quality", _inv.GetItemQuality( item ) );
		flashObject.SetMemberFlashInt( "socketsCount", _inv.GetItemEnhancementSlotsCount( item ) );
		flashObject.SetMemberFlashInt( "socketsUsedCount", _inv.GetItemEnhancementCount( item ) );
		flashObject.SetMemberFlashInt( "groupId", -1);
		
		
		flashObject.SetMemberFlashBool( "isSilverOil", _inv.ItemHasTag(item, 'SilverOil') );
		flashObject.SetMemberFlashBool( "isSteelOil", _inv.ItemHasTag(item, 'SteelOil') );
		flashObject.SetMemberFlashBool( "isArmorUpgrade", _inv.ItemHasTag(item, 'ArmorUpgrade') );
		flashObject.SetMemberFlashBool( "isWeaponUpgrade",  _inv.ItemHasTag(item, 'WeaponUpgrade') );
		flashObject.SetMemberFlashBool( "isArmorRepairKit", _inv.ItemHasTag(item, 'ArmorReapairKit') );
		flashObject.SetMemberFlashBool( "isWeaponRepairKit", _inv.ItemHasTag(item, 'WeaponReapairKit') );
		flashObject.SetMemberFlashBool( "isDye", _inv.IsItemDye( item ) );
		flashObject.SetMemberFlashBool( "isMask", _inv.IsItemMask( item ) ); 
		
		
		flashObject.SetMemberFlashBool( "canBeDyed", !_inv.ItemHasTag(item, 'noDye') );
		
		flashObject.SetMemberFlashBool( "showExtendedTooltip", true );
		
		tmp = _inv.IsItemEnchanted(item);
		flashObject.SetMemberFlashBool( "enchanted", tmp);
		
		if( _inv.HasItemDurability(item) )
		{
			
			curr = RoundMath( _inv.GetItemDurability(item) / _inv.GetItemMaxDurability(item) * 100);
			
			
			flashObject.SetMemberFlashNumber( "durability", curr );
			
			if( curr <= ITEM_NEED_REPAIR_DISPLAY_VALUE )
			{
				flashObject.SetMemberFlashBool( "needRepair", true );
			}
			else
			{
				flashObject.SetMemberFlashBool( "needRepair", false );				
			}
		}
		else
		{
			flashObject.SetMemberFlashBool( "needRepair", false );
			flashObject.SetMemberFlashNumber( "durability", 1);
		}
		
		if( thePlayer.IsInCombatAction() && IsUnequipSwordIsAlllowed(item))
		{
			flashObject.SetMemberFlashInt( "actionType", IAT_None );	
		}
		else
		{
			flashObject.SetMemberFlashInt( "actionType", GetItemActionType( item ) );
		}
		
		
		if(thePlayer.HasBuff(EET_WolfHour))
		{
			cantEquip = (_inv.GetItemLevel(item) - 2) > thePlayer.GetLevel();
		}
		else
		{
			cantEquip = _inv.GetItemLevel(item) > thePlayer.GetLevel();
		}
		flashObject.SetMemberFlashBool( "cantEquip", cantEquip );
		
		
		
		
		
		
		
		
		flashObject.SetMemberFlashString( "category", _inv.GetItemCategory(item) );
		
	}
	
	public function GetItemQuantity( item : SItemUniqueId ):int
	{
		if (_inv.IsIdValid(item))
		{
			return _inv.GetItemQuantity(item);
		}
		return 0;
	}
	
	protected function IsUnequipSwordIsAlllowed( item : SItemUniqueId ) : bool
	{
		var tags : array<name>;
		var equipedItem : SItemUniqueId;
		
		equipedItem = _inv.GetItemFromSlot('r_weapon');
		if( _inv.IsIdValid(equipedItem) )
		{
			if(( _inv.IsItemSteelSwordUsableByPlayer(equipedItem) && _inv.IsItemSteelSwordUsableByPlayer(item) ) 
			|| ( _inv.IsItemSilverSwordUsableByPlayer(equipedItem) && _inv.IsItemSilverSwordUsableByPlayer(item) ))
			{
				return true;
			}
		}
		return false;
	}
	
	public function isHorseItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemHorseItem(item);
	}
	
	protected function GetCurrentSlotForItem( item : SItemUniqueId ) : int
	{
		return (int)(GetWitcherPlayer().GetItemSlot( item ));
	}
	
	protected function GetItemEquippedSlot( item : SItemUniqueId ) : EEquipmentSlots
	{
		return _inv.GetSlotForItemId(item);
	}

	protected function GetTooltipText(item : SItemUniqueId) : string
	{
		return GetItemTooltipText(item, _inv);
	}
	
	public function CanBeUpgradedBy(targetItem:SItemUniqueId, upgradeItem:SItemUniqueId):bool
	{
		var socketsCount		: int;
		var usedSocketsCount	: int;
		var emptySocketsCount	: int;
		var targetTag			: name;
		
		socketsCount = _inv.GetItemEnhancementSlotsCount( targetItem );
		usedSocketsCount = _inv.GetItemEnhancementCount( targetItem );
		emptySocketsCount = socketsCount - usedSocketsCount;
		
		if (emptySocketsCount <= 0 || _inv.GetEnchantment( targetItem ) != '')
		{
			return false;
		}
		if (_inv.ItemHasTag(upgradeItem, 'WeaponUpgrade'))
		{
			targetTag = 'sword1h';
		}
		else if (_inv.ItemHasTag(upgradeItem, 'ArmorUpgrade'))
		{
			targetTag = 'Armor';
		}
		return _inv.ItemHasTag(targetItem, targetTag);
	}
	
	public function isQuestItem( item : SItemUniqueId ) : bool
	{
		return _inv.ItemHasTag( item, 'Quest' );
	}
	
	public function isItemReadable( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemReadable(item);
	}
	
	public function isQuickslotItem( item : SItemUniqueId ) : bool
	{
		return _inv.ItemHasTag( item, 'QuickSlot' );
	}

	public function isWeaponItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemWeapon( item );
	}

	public function isArmorItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemAnyArmor( item );
	}
	
	public function isUpgradeItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemUpgrade( item );
	}
	
	public function isToolItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemTool( item );
	}

	public function isPotionItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemPotion( item );
	}

	public function isOilItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemOil( item );
	}
	
	public function isPetardItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemBomb( item ); 
	}
		
	public function isAlchemyItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemAlchemyItem( item );
	}
	
	public function isFoodItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemFood( item );
	}
		
	public function isIngredientItem( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemIngredient( item );
	}
	
	public function isItemSchematic( item : SItemUniqueId ) : bool
	{
		return _inv.GetItemCategory( item ) == 'crafting_schematic' || _inv.GetItemCategory( item ) == 'alchemy_recipe';
	}
	
	public function isItemUsable( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemUsable( item );
	}
	
	public function IsItemDye( item : SItemUniqueId ) : bool
	{
		return _inv.IsItemDye( item );
	}
	
	public function GetFilterTypeByItem( item : SItemUniqueId) : EInventoryFilterType
	{
		var filterType : EInventoryFilterType;
		
		if (( !isFoodItem( item ) && !isIngredientItem( item ) && !isWeaponItem( item ) && 
			  !isArmorItem( item ) && ! isAlchemyItem( item ) && !isUpgradeItem( item ) && !isItemSchematic( item ) && 
			  !isToolItem( item ) && !isHorseItem( item )) && !isQuickslotItem( item ) && !isItemUsable( item ) || isQuestItem( item ) )
		{
			return IFT_QuestItems;
		}
		else
		if (isFoodItem( item ) || isHorseItem( item ))
		{
			return IFT_Default;
		}
		else
		if( isIngredientItem( item ) && !IsItemDye( item ) )
		{
			return IFT_Ingredients;
		}
		else
		if( isWeaponItem( item ) || isArmorItem( item ) || isUpgradeItem( item ) || isToolItem( item ) || isItemUsable( item ) || isQuickslotItem( item ) )
		{
			return IFT_Weapons;
		}
		else
		if (!isQuestItem( item ) && isItemReadable( item ))
		{
			return IFT_Books;
		}
		else
		if (isAlchemyItem( item ) && !isFoodItem(item))
		{
			return IFT_AlchemyItems;
		}
		else
		if (isHorseItem( item ))
		{
			return IFT_HorseItems;
		}
		else
		{
			return IFT_Default;
		}
	}
	
	public final function GetAllItems() : array<SItemUniqueId>
	{
		var items : array<SItemUniqueId>;
		
		_inv.GetAllItems(items);
		return items;
	}
	
	public function GetBookText(item : SItemUniqueId):string
	{
		if (_inv.GetItemCategory(item) == 'alchemy_recipe')
		{
			return GetAlchemyBookText(item);
		}
		else if (_inv.GetItemCategory(item) == 'crafting_schematic')
		{
			return GetSchematicBookText(item);
		}
		else
		{
			return _inv.GetBookText(item);
		}
	}
	
	public function GetAlchemyBookText(item : SItemUniqueId):string
	{
		var dm 					: CDefinitionsManagerAccessor;
		var finalString			: string;
		var tempString			: string;
		var recipe				: SAlchemyRecipe;
		var currentIngredient	: SItemParts;
		var htmlNewline			: string;
		var itemType 			: EInventoryFilterType;
		var i					: int;
		var craftedItemName		: name;
		var color				: string;
		var attributes			: array<SAttributeTooltip>;
		var minWeightAttribute 	: SAbilityAttributeValue;
		var maxWeightAttribute 	: SAbilityAttributeValue;
		var minQuality 			: int;
		var maxQuality 			: int;
		
		htmlNewline = "&#10;";
		
		recipe = getAlchemyRecipeFromName(_inv.GetItemName(item));
		dm = theGame.GetDefinitionsManager();
		craftedItemName = recipe.cookedItemName;
		_inv.GetItemStatsFromName(craftedItemName, attributes);
		_inv.GetItemQualityFromName(craftedItemName, minQuality, maxQuality);
		dm.GetItemAttributeValueNoRandom(craftedItemName, true, 'weight', minWeightAttribute, maxWeightAttribute);
		itemType = dm.GetFilterTypeByItem(craftedItemName);
		
		finalString = GetLocStringByKeyExt("panel_crafting_book_start") + ":" + htmlNewline;
		finalString += GetItemRarityDescriptionFromInt(minQuality) + htmlNewline;
		
		finalString += "<font color=\"#C4B7AA\">" + GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(craftedItemName)) + "</font>" + htmlNewline;
		
		tempString = GetLocStringByKeyExt(GetFilterTypeName( itemType )) + " / " + GetLocStringByKeyExt("item_category_" + dm.GetItemCategory(craftedItemName));
		finalString += "<font color=\"#FF8832\">" + tempString + "</font>" + htmlNewline;
		
		finalString += htmlNewline;
		finalString += "<font color=\"#C49560\">" + GetLocStringByKeyExt(_inv.GetItemLocalizedDescriptionByName(craftedItemName)) + "</font>" + htmlNewline;
		
		finalString += htmlNewline;
		for (i = 0; i < attributes.Size(); i += 1)
		{
			
			color = attributes[i].attributeColor;
			tempString = "<font color=\"#" + color + "\">";
			tempString += attributes[i].attributeName + ": ";
			if( attributes[i].percentageValue )
			{
				tempString += NoTrailZeros(attributes[i].value * 100 ) +" %";
			}
			else
			{
				tempString += NoTrailZeros(attributes[i].value);
			}
			tempString += "</font>" + htmlNewline;
			finalString += tempString;
		}
		
		if (minWeightAttribute.valueBase > 0)
		{
			finalString += htmlNewline + GetLocStringByKeyExt("attribute_name_weight") + ": " + NoTrailZeros(minWeightAttribute.valueBase) + htmlNewline;
		}
		
		finalString += GetLocStringByKeyExt("panel_crafting_ingredients_start") + ":" + htmlNewline;
		
		for (i = 0; i < recipe.requiredIngredients.Size(); i += 1)
		{
			currentIngredient = recipe.requiredIngredients[i];
			tempString = GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(currentIngredient.itemName));
			finalString += currentIngredient.quantity + "x " + tempString + htmlNewline;
		}
		
		return finalString;
	}
	
	public function GetSchematicBookText(item : SItemUniqueId):string
	{
		var dm 					: CDefinitionsManagerAccessor;
		var finalString			: string;
		var tempString			: string;
		var htmlNewline			: string;
		var craftingSchematic	: SCraftingSchematic;
		var craftedItemName		: name;
		var currentIngredient	: SItemParts;
		var i					: int;
		var color				: string;
		var attributes			: array<SAttributeTooltip>;
		var minWeightAttribute 	: SAbilityAttributeValue;
		var maxWeightAttribute 	: SAbilityAttributeValue;
		var minQuality 			: int;
		var maxQuality 			: int;
		var itemType 			: EInventoryFilterType;
		
		var delimiter			: string;
		var prefix				: string;
		var language 	  		: string;
		var audioLanguage 		: string;
		
		theGame.GetGameLanguageName(audioLanguage,language);
		if (language == "AR")
		{
			delimiter = "";
			prefix = "&nbsp;";
		}
		else
		{
			delimiter = ": ";
			prefix = "";
		}
		
		htmlNewline = "&#10;";
		dm = theGame.GetDefinitionsManager();
		craftingSchematic = getCraftingSchematicFromName(_inv.GetItemName(item));
		craftedItemName = craftingSchematic.craftedItemName;
		_inv.GetItemStatsFromName(craftedItemName, attributes);
		_inv.GetItemQualityFromName(craftedItemName, minQuality, maxQuality);
		itemType = dm.GetFilterTypeByItem(craftedItemName);
		dm.GetItemAttributeValueNoRandom(craftedItemName, true, 'weight', minWeightAttribute, maxWeightAttribute);
		
		finalString = GetLocStringByKeyExt("panel_crafting_book_start") + htmlNewline;
		
		finalString += "<font color=\"#C4B7AA\">" + GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(craftedItemName)) + "</font>" + htmlNewline;
		finalString += GetItemRarityDescriptionFromInt(minQuality) + htmlNewline;
		
		tempString = GetLocStringByKeyExt(GetFilterTypeName( itemType )) + " / " + GetLocStringByKeyExt("item_category_" + dm.GetItemCategory(craftedItemName));
		finalString += "<font color=\"#FF8832\">" + tempString + "</font>" + htmlNewline;
		
		finalString += htmlNewline;
		finalString += "<font color=\"#C49560\">" + GetLocStringByKeyExt(_inv.GetItemLocalizedDescriptionByName(craftedItemName)) + "</font>" + htmlNewline;
		
		finalString += htmlNewline;
		finalString += _inv.GetItemLevelColor( theGame.GetDefinitionsManager().GetItemLevelFromName( craftedItemName ) ) + GetLocStringByKeyExt( 'panel_inventory_item_requires_level' ) + " " + theGame.GetDefinitionsManager().GetItemLevelFromName( craftedItemName ) + "</font><br>"; 

		finalString += htmlNewline;
		for (i = 0; i < attributes.Size(); i += 1)
		{
			
			color = attributes[i].attributeColor;
			tempString = "<font color=\"#" + color + "\">";
			tempString += (attributes[i].attributeName + delimiter);
			if( attributes[i].percentageValue )
			{
				tempString += (NoTrailZeros(attributes[i].value * 100 ) +" %" + prefix);
			}
			else
			{
				tempString += (NoTrailZeros(attributes[i].value) + prefix);
			}
			tempString += "</font>" + htmlNewline;
			finalString += tempString;
		}
		
		if (maxQuality > 1 && maxQuality < 4) 
		{
			if (minQuality != maxQuality)
			{
				finalString += ("<font color=\"#AAFFFC\">" + GetLocStringByKeyExt("panel_crafting_number_random_attributes") + delimiter +  (minQuality - 1)  + " - " + (maxQuality-1) + prefix + " </font>" + htmlNewline);
			}
			else
			{
				finalString += ("<font color=\"#AAFFFC\">" + GetLocStringByKeyExt("panel_crafting_number_random_attributes") + delimiter + (minQuality - 1)  + prefix + " </font>" + htmlNewline);
			}
		}
		
		if (minWeightAttribute.valueBase > 0)
		{
			finalString += (htmlNewline + GetLocStringByKeyExt("attribute_name_weight") + delimiter + NoTrailZeros(minWeightAttribute.valueBase) + prefix + htmlNewline);
		}
		
		finalString += GetLocStringByKeyExt("panel_crafting_ingredients_start") + htmlNewline;
		
		for (i = 0; i < craftingSchematic.ingredients.Size(); i += 1)
		{
			currentIngredient = craftingSchematic.ingredients[i];
			tempString = GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(currentIngredient.itemName));
			finalString += currentIngredient.quantity + "x " + tempString + htmlNewline;
		}
		
		return finalString;
	}
	
	public function highlightItems(itemsList : array<name>):void
	{
		highlightedItems = itemsList;
	}
	
}


