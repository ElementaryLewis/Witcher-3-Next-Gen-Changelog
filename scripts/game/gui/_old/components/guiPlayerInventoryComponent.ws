/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class W3GuiPlayerInventoryComponent extends W3GuiBaseInventoryComponent
{
	private var _shopInvCmp:W3GuiShopInventoryComponent;
	private var _filterType : EInventoryFilterType;
	default _filterType = IFT_Weapons;
	private var _currentItemCategoryType : name;
	default _currentItemCategoryType = '';

	public var stashMode : bool;
	default stashMode = false;	
	
	public var bPaperdoll : bool;
	default bPaperdoll = false;	

	public var currentDefaultItemAction : EInventoryActionType;
	default currentDefaultItemAction = IAT_None;
	
	public var ignorePosition : bool;
	default ignorePosition = false;
	
	public var filterTagList : array<name>;
	public var filterForbiddenTagList : array<name>;

	public var overrideQuestItemFilters : bool;
	default overrideQuestItemFilters = false;
	
	public var previewItems    : array<SItemUniqueId>;
	public var dyePreviewSlots : array<SItemUniqueId>;
	
	protected function InvalidateItems( items : array<SItemUniqueId> ) 
	{
	}
	
	public function SetOverrideQuestItemFilters( enable : bool )
	{	
		overrideQuestItemFilters = enable;
	}
	
	public function SetShopInvCmp(targetShopInvCmp:W3GuiShopInventoryComponent):void
	{
		_shopInvCmp = targetShopInvCmp;
	}
	
	public function SetFilterType( filterType : EInventoryFilterType )
	{
		_filterType = filterType;
	}	

	public function GetFilterType() : EInventoryFilterType
	{
		return _filterType;
	}	

	public function SetItemCategoryType( cat : name )
	{
		_currentItemCategoryType = cat;
	}
	
	
	public function SwapItems( gridItem : SItemUniqueId, paperdollItem : SItemUniqueId )
	{
		var invalidatedItems : array< SItemUniqueId >;
		var uiDataPaperdoll : SInventoryItemUIData;
		var uiDataGrid : SInventoryItemUIData;
		var mountToHand, result : bool;
		
		uiDataGrid = _inv.GetInventoryItemUIData( gridItem );
		uiDataPaperdoll = _inv.GetInventoryItemUIData( paperdollItem );
		
		uiDataPaperdoll.gridPosition = uiDataGrid.gridPosition;
		uiDataGrid.gridPosition = -1;
		
		_inv.SetInventoryItemUIData( paperdollItem, uiDataPaperdoll );
		_inv.SetInventoryItemUIData( gridItem, uiDataGrid );
		
		mountToHand = _inv.IsItemHeld( paperdollItem );
		result = GetWitcherPlayer().UnequipItem(paperdollItem);
		if(result)
			result = GetWitcherPlayer().EquipItem(gridItem, EES_Quickslot1, mountToHand);		
		
		
		
		invalidatedItems.PushBack( gridItem );
		invalidatedItems.PushBack( paperdollItem );
		InvalidateItems( invalidatedItems );
	}	
	
	public function EquipItem( item : SItemUniqueId, slot : int)
	{
		var invalidatedItems : array< SItemUniqueId >;
				
		GetWitcherPlayer().EquipItem(item, slot);
		
		thePlayer.SetUpdateQuickSlotItems(true);
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}	
	
	public function EquipItemInGivenSlot( item : SItemUniqueId, slot : int)
	{
		var invalidatedItems : array< SItemUniqueId >;
				
		GetWitcherPlayer().EquipItemInGivenSlot(item, slot, false);
		
		thePlayer.SetUpdateQuickSlotItems(true);
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}	
	
	public function UnequipItem( item : SItemUniqueId )
	{
		var invalidatedItems : array<SItemUniqueId>;
	
		GetWitcherPlayer().UnequipItem(item);
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}
	
	public function DropItem( item : SItemUniqueId, quantity : int )
	{	
		GetWitcherPlayer().DropItem(item, quantity);
		super.DropItem( item, quantity );
	}
	
	
	
	public function UpgradeItem( item : SItemUniqueId, upgrade : SItemUniqueId )
	{
		var invalidatedItems : array< SItemUniqueId >;
		
		GetWitcherPlayer().ApplyOil(upgrade, item );
		
		
			_inv.RemoveItem( upgrade, 1 );
			
			invalidatedItems.PushBack( item );
			invalidatedItems.PushBack( upgrade );
			InvalidateItems( invalidatedItems );
		
	}
	
	public function ConsumeItem( item : SItemUniqueId )
	{
		var invalidatedItems : array< SItemUniqueId >;
		var itemCategory : name;
		
		itemCategory = _inv.GetItemCategory( item );
		
		thePlayer.ConsumeItem( item ); 
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}	
	
	public function MoveItem( item : SItemUniqueId, moveToIndex : int )
	{
		var invalidatedItems : array< SItemUniqueId >;
		var uiDataGrid : SInventoryItemUIData;
		
		uiDataGrid = _inv.GetInventoryItemUIData( item );
		
		uiDataGrid.gridPosition = moveToIndex;
		
		_inv.SetInventoryItemUIData( item, uiDataGrid );
		
		invalidatedItems.PushBack( item );
		InvalidateItems( invalidatedItems );
	}

	public function MoveItems( item : SItemUniqueId, moveToIndex : int, itemSecond : SItemUniqueId, moveSecondToIndex : int )
	{
		var invalidatedItems : array< SItemUniqueId >;
		var uiDataGrid : SInventoryItemUIData;
		var uiDataGridSecond : SInventoryItemUIData;
		
		uiDataGrid = _inv.GetInventoryItemUIData( item );
		uiDataGridSecond = _inv.GetInventoryItemUIData( itemSecond );
		
		uiDataGrid.gridPosition = moveToIndex;
		uiDataGridSecond.gridPosition = moveSecondToIndex;
		
		_inv.SetInventoryItemUIData( item, uiDataGrid );
		_inv.SetInventoryItemUIData( itemSecond, uiDataGridSecond );
		
		invalidatedItems.PushBack( item );
		invalidatedItems.PushBack( itemSecond );
		InvalidateItems( invalidatedItems );
	}
	
	public function CleanupItemsGridPosition() : void
	{
		var i, len : int;
		var curItemId   : SItemUniqueId;
		var itemsList   : array< SItemUniqueId >;
		var currentUiData : SInventoryItemUIData;
		
		_inv.GetAllItems( itemsList );
		
		len = itemsList.Size();
		for ( i = 0; i < len; i += 1 )
		{
			curItemId = itemsList[i];
			currentUiData = _inv.GetInventoryItemUIData( curItemId );
			currentUiData.gridPosition = -1;
			_inv.SetInventoryItemUIData(curItemId, currentUiData);
		}
	}
	
	public function ReadBook( item : SItemUniqueId )
	{
		
		_inv.ReadBook( item );
		
		
	}
	
	public function IsBookRead( item : SItemUniqueId ) : bool
	{
		
		return _inv.IsBookRead( item );
	}
	
	public function UpdateTooltip(item : SItemUniqueId, secondItem : SItemUniqueId)
	{
	}
	
	public function GetItemName(item : SItemUniqueId):name
	{
		return _inv.GetItemName(item);
	}
	
	public function GetCraftedItemInfo(craftedItemName:name, targetObject:CScriptedFlashObject) : void
	{
		var playerInv			: CInventoryComponent;
		var wplayer		        : W3PlayerWitcher;
		var dm 					: CDefinitionsManagerAccessor;
		var htmlNewline			: string;
		var minQuality 			: int;
		var maxQuality 			: int;
		var color				: string;
		var itemType 			: EInventoryFilterType;
		var minWeightAttribute 	: SAbilityAttributeValue;
		var maxWeightAttribute 	: SAbilityAttributeValue;
		var i					: int;
		var attributes			: array<SAttributeTooltip>;
		
		var itemName			: string;
		var itemDesc			: string;
		var rarity				: string;
		var rarityId			: int;
		var type				: string;
		var weightValue			: float;
		var weight				: string;
		var enhancementSlots 	: int;
		var attributesStr		: string;
		var tmpStr				: string;
		
		var requiredLevel		: string;
		var primaryStatDiff     : string;
		var primaryStatLabel    : string;
		var primaryStatValue    : float;
		var primaryStatDiffValue: float;
		var primaryStatDiffStr  : string;
		var eqPrimaryStatLabel  : string;
		var eqPrimaryStatValue  : float;
		var primaryStatName	    : name;
		var itemCategory		: name;
		var dontCompare			: bool;
		var itemSlot 			: EEquipmentSlots;
		var equipedItemId		: SItemUniqueId;
		var equipedItemStats	: array<SAttributeTooltip>;
		var attributesList      : CScriptedFlashArray;
		var addDescription		: string;
		var itemLevel			: int;
		
		var isSetBonus1Active	 : bool;
		var isSetBonus2Active	 : bool;
		var setBonusDescription1 : string;
		var setBonusDescription2 : string;
		var setBonusText	     : string;
		var setBonusText2		 : string;
		var paramString			 : array<string>;
		
		var setAttribute 	  : CScriptedFlashObject;
		var setAttributesList : CScriptedFlashArray;
		
		htmlNewline = "&#10;";
		
		wplayer = GetWitcherPlayer();
		dm = theGame.GetDefinitionsManager();
		_inv.GetItemStatsFromName(craftedItemName, attributes);
		_inv.GetItemQualityFromName(craftedItemName, minQuality, maxQuality);
		itemType = dm.GetFilterTypeByItem(craftedItemName);
		
		itemCategory = dm.GetItemCategory(craftedItemName);
		
		dm.GetItemAttributeValueNoRandom(craftedItemName, true, 'weight', minWeightAttribute, maxWeightAttribute);
		weightValue = minWeightAttribute.valueBase;
		
		if ( itemCategory == 'usable' || itemCategory == 'upgrade' || itemCategory == 'junk' )
		{
			weightValue = 0.01 + weightValue * 0.2;
		}
		else if ( dm.ItemHasTag(craftedItemName, 'CraftingIngredient'))
		{
			weightValue = 0.0;
		}
		else
		{
			weightValue = 0.01 + weightValue * 0.5;
		}
		
		tmpStr = FloatToStringPrec( weightValue, 2 );
		weight = GetLocStringByKeyExt("attribute_name_weight") + "  " + tmpStr;
		
		itemName = GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(craftedItemName));
		itemDesc = GetLocStringByKeyExt(_inv.GetItemLocalizedDescriptionByName(craftedItemName));
		
		rarityId = minQuality;
		rarity = GetItemRarityDescriptionFromInt(minQuality);
		type = GetLocStringByKeyExt("item_category_" + dm.GetItemCategory(craftedItemName));
		
		setBonusText = "";
		setBonusText2 = "";
		
		if ( dm.IsItemSetItem( craftedItemName ) ) 
		{
			GetWitcherPlayer().GetSetBonusStatusByName( craftedItemName, setBonusDescription1, setBonusDescription2, isSetBonus1Active, isSetBonus2Active );
			
			if( setBonusDescription1!="" && setBonusDescription2!="" )
			{				
				if ( !dm.ItemHasTag( craftedItemName, 'SetBonusPiece' ) )
				{
					setBonusText = setBonusText + "<font color='#FF0000'>" + GetLocStringByKeyExt( "tooltip_set_bonus_not_avilable_yet" ) + "</font><br/>";
				}
				
				setBonusText = setBonusText + "<font color='#b7ae8c'>" + StrUpperUTF( GetLocStringByKeyExt( "crafting_bonus_title" ) ) + "</font><br/><br/>";
				
				paramString.PushBack( (string)( theGame.params.ITEMS_REQUIRED_FOR_MINOR_SET_BONUS ) );
				setBonusText = setBonusText + "<font color='#9f977a'>" + GetLocStringByKeyExtWithParams( "crafting_bonus_set_title",,, paramString ) + ":</font><br/>";
				setBonusText = setBonusText + "<font color='#818181'>" + setBonusDescription1 + "</font>";
				
				if( setBonusDescription2 != "" )
				{
					paramString.Clear();
					paramString.PushBack( (string)( theGame.params.ITEMS_REQUIRED_FOR_MAJOR_SET_BONUS ) );
					setBonusText2 ="<font color='#9f977a'>" + GetLocStringByKeyExtWithParams( "crafting_bonus_set_title",,, paramString ) + ":</font><br/>";
					setBonusText2 = setBonusText2 + "<font color='#818181'>" + setBonusDescription2 + "</font>";
				}
				
				targetObject.SetMemberFlashString( "SetBonusDescription", setBonusText );
				targetObject.SetMemberFlashString( "SetBonusDescription2", setBonusText2 );
			}
		}
		
		enhancementSlots = dm.GetItemEnhancementSlotCount( craftedItemName );
		itemSlot = GetSlotForItemByCategory(itemCategory);
		wplayer.GetItemEquippedOnSlot(itemSlot, equipedItemId);
		playerInv = thePlayer.GetInventory();
		
		eqPrimaryStatValue = 0;
		if (playerInv.IsIdValid(equipedItemId))
		{
			playerInv.GetItemStats(equipedItemId, equipedItemStats);
			playerInv.GetItemPrimaryStat(equipedItemId, eqPrimaryStatLabel, eqPrimaryStatValue);

			if( playerInv.ItemHasTag( equipedItemId, 'Aerondight' ) )
			{
				if( playerInv.GetItemModifierFloat( equipedItemId, 'PermDamageBoost' ) >= 0.f )
				{
					eqPrimaryStatValue += playerInv.GetItemModifierFloat( equipedItemId, 'PermDamageBoost' );
				}
			}
		}
		
		dontCompare = itemCategory == 'potion' || itemCategory == 'petard' || itemCategory == 'oil';
		playerInv.GetItemPrimaryStatFromName(craftedItemName, primaryStatLabel, primaryStatValue, primaryStatName);
		
		if ( FactsQuerySum("NewGamePlus") > 0 )
		{
			if ( theGame.params.NewGamePlusLevelDifference() > 0 )
			{
				primaryStatValue += IncreaseNGPPrimaryStatValue(itemCategory);
			}
		}
		
		primaryStatDiff = "none";
		primaryStatDiffValue = 0;
		primaryStatDiffStr = "";
		
		if ( !dontCompare )
		{
			primaryStatDiff = GetStatDiff(primaryStatValue, eqPrimaryStatValue);
			primaryStatDiffValue = RoundMath(primaryStatValue) - RoundMath(eqPrimaryStatValue);
			if (primaryStatDiffValue > 0)
			{
				primaryStatDiffStr = "<font color=\"#19D900\"> +" + NoTrailZeros(primaryStatDiffValue) + "</font>";
			}
			else if (primaryStatDiffValue < 0)
			{
				primaryStatDiffStr = "<font color=\"#E00000\"> " + NoTrailZeros(primaryStatDiffValue) + "</font>";
			}
			
			if (dm.IsItemWeapon(craftedItemName))
			{
				targetObject.SetMemberFlashNumber("PrimaryStatDelta", .1);
			}
			else
			{
				targetObject.SetMemberFlashNumber("PrimaryStatDelta", 0);
			}
		}
		
		if ( dm.IsItemAnyArmor(craftedItemName) || dm.IsItemBolt(craftedItemName) || dm.IsItemWeapon(craftedItemName) )
		{
			itemLevel = theGame.GetDefinitionsManager().GetItemLevelFromName( craftedItemName );
			if ( FactsQuerySum("NewGamePlus") > 0 )
			{
				if ( theGame.params.NewGamePlusLevelDifference() > 0 )
				{
					itemLevel += theGame.params.NewGamePlusLevelDifference();
					if ( itemLevel > GetWitcherPlayer().GetMaxLevel() ) 
					{
						itemLevel = GetWitcherPlayer().GetMaxLevel();
					}
				}
			}
			requiredLevel = _inv.GetItemLevelColor( itemLevel ) + GetLocStringByKeyExt( 'panel_inventory_item_requires_level' ) + " " + itemLevel + "</font>";
			targetObject.SetMemberFlashString("requiredLevel", requiredLevel);
		}
		
		attributesList = targetObject.CreateFlashArray();		
		CalculateStatsComparance(attributes, equipedItemStats, targetObject, attributesList, true,  dontCompare);
		
		attributesStr = "";
		for (i = 0; i < attributes.Size(); i += 1)
		{
			
			color = attributes[i].attributeColor;
			attributesStr += "<font color=\"#" + color + "\">";
			attributesStr += attributes[i].attributeName + ": ";
			if( attributes[i].percentageValue )
			{
				attributesStr += RoundMath( attributes[i].value * 100 ) + " %";
			}
			else
			{
				attributesStr += RoundMath( attributes[i].value );
			}
			attributesStr += "</font>" + htmlNewline;
		}

		addDescription = "";
		if (maxQuality > 1 && maxQuality < 4) 
		{
			addDescription += "<font color=\"#AAFFFC\">" + (minQuality - 1) + " - " + (maxQuality - 1) + " " + GetLocStringByKeyExt("panel_crafting_number_random_attributes") + "</font>";
		}
		
		if ( theGame.GetGuiManager().GetShowItemNames() )
		{
			itemDesc = "<font color=\"#FFDB00\">Item Name: '" + craftedItemName + "'</font><br><br>" + itemDesc;
		}
		
		targetObject.SetMemberFlashString("additionalDescription", addDescription);
		targetObject.SetMemberFlashString("itemName", itemName);
		targetObject.SetMemberFlashString("itemDescription", itemDesc);
		targetObject.SetMemberFlashString("rarity", rarity);
		targetObject.SetMemberFlashInt("rarityId", rarityId);
		targetObject.SetMemberFlashString("type", type);
		targetObject.SetMemberFlashInt("enhancementSlots", enhancementSlots );
		targetObject.SetMemberFlashString("weight", weight);
		targetObject.SetMemberFlashString("attributes", attributesStr);
		targetObject.SetMemberFlashArray("attributesList", attributesList);
		targetObject.SetMemberFlashString("PrimaryStatLabel", primaryStatLabel);
		targetObject.SetMemberFlashNumber("PrimaryStatValue", primaryStatValue);
		targetObject.SetMemberFlashString("PrimaryStatDiff", primaryStatDiff);
		targetObject.SetMemberFlashString("PrimaryStatDiffStr", primaryStatDiffStr);
	}
	
	private final function IncreaseNGPPrimaryStatValue( category : name ) : int
	{
		var min, max : SAbilityAttributeValue;
		
		if ( category == 'steelsword' ) 
		{	
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_steel_dmg', 'SlashingDamage', min, max);
			return RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
		}
		else if ( category == 'silversword' ) 
		{
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_silver_dmg', 'SilverDamage', min, max);
			return RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
		}
		else if ( category == 'armor' ) 
		{	
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_armor_armor', 'armor', min, max);
			return RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
		}
		else if ( category == 'boots' || category == 'pants' ) 
		{				
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_pants_armor', 'armor', min, max);
			return RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
		}
		else if ( category == 'gloves' ) 
		{			
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_gloves_armor', 'armor', min, max);
			return RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
		}	
		return 0;
	}
	
	
	
	protected function isEquipped( item : SItemUniqueId ) : bool
	{
		return GetWitcherPlayer().IsItemEquipped(item);
	}
	
	protected function getQuickslotId( item : SItemUniqueId ) : int
	{
		return (int)GetWitcherPlayer().GetItemSlot(item);
	}	
	
	public  function SetInventoryFlashObjectForItem( itemId : SItemUniqueId, out flashObject : CScriptedFlashObject) : void
	{
		var equipped 			  : int;
		var slotType 			  : EEquipmentSlots;
		var itemCategory		  : name;
		var itemName			  : name;
		var invItem 			  : SInventoryItem;
		var itemCost			  : int;
		var itemNotForSale	      : bool;
		var isDefaultBolt		  : bool;
		var canDrop				  : bool;
		var dropBlockedByTutorial : bool;
		var isQuest				  : bool;
		var transferBlocked		  : bool;
		var targetGridSection     : int;
		var uiData 				  : SInventoryItemUIData;
		var iconPath			  : string;
		var pos, curr, max		  : int;
		
		super.SetInventoryFlashObjectForItem( itemId, flashObject );
		
		isDefaultBolt = _inv.IsItemBolt(itemId) && _inv.ItemHasTag(itemId, theGame.params.TAG_INFINITE_AMMO);
		
		itemName = _inv.GetItemName(itemId);
		
		slotType = GetItemEquippedSlot( itemId );
		equipped = (int)GetWitcherPlayer().GetItemSlot( itemId );
		
		flashObject.SetMemberFlashInt( "equipped", equipped );
		flashObject.SetMemberFlashBool( "cantUnequip", isDefaultBolt );
		itemCategory = _inv.GetItemCategory( itemId );
		
		if (_shopInvCmp)
		{
			invItem = GetInventoryComponent().GetItem( itemId );
			itemCost = _shopInvCmp.GetInventoryComponent().GetInventoryItemPriceModified( invItem, true );
			
			if ( itemCost <= 0  || _inv.ItemHasTag(itemId,'Quest'))
			{
				itemNotForSale = true;
			}
			canDrop = false;
		}
		else
		{
			
			
			dropBlockedByTutorial = FactsQuerySum("tut_forced_preparation") > 0 && _inv.GetItemName(itemId) == 'Thunderbolt 1';
			canDrop = !_inv.ItemHasTag(itemId, 'NoDrop') && !_inv.ItemHasTag(itemId,'Quest') && !dropBlockedByTutorial && !isDefaultBolt;
		}
		
		if ( ignorePosition )
		{
			flashObject.SetMemberFlashInt( "gridPosition", -1 );
		}
		
		if ( previewItems.Size() > 0 )
		{
			flashObject.SetMemberFlashBool( "isPreviewItem", previewItems.Contains( itemId ) );
		}
		
		if( itemName == 'q705_tissue_extractor' )
		{
			curr = thePlayer.GetTissueExtractorChargesCurr();
			max = thePlayer.GetTissueExtractorChargesMax();
			iconPath = _inv.GetItemIconPathByUniqueID(itemId);
			
			if( curr >= max )
			{			
				pos = StrFindLast( iconPath, "." );
				iconPath = StrLeft( iconPath, pos );
				iconPath += "_full.png";
			}
			
			flashObject.SetMemberFlashString( "iconPath", iconPath );
		}
		
		flashObject.SetMemberFlashBool( "canDrop", canDrop );
		
		if (stashMode)
		{
			transferBlocked = _inv.IsItemQuest( itemId ) || _inv.IsItemAlchemyItem( itemId ); 
			flashObject.SetMemberFlashBool( "disableAction", transferBlocked );
		}
		else
		{
			flashObject.SetMemberFlashBool( "disableAction", itemNotForSale );
		}
		
		isQuest = _inv.IsItemQuest( itemId );
		
		
		if( ( _inv.IsItemAnyArmor( itemId ) || _inv.ItemHasTag( itemId, 'ArmorUpgrade' ) || _inv.ItemHasTag( itemId, 'ArmorReapairKit' ) || _inv.IsItemDye( itemId ) ) && !isQuest )
		{
			targetGridSection = 1;
		}
		else
		if( _inv.IsItemWeapon( itemId ) || _inv.ItemHasTag( itemId, 'WeaponUpgrade' ) || _inv.ItemHasTag( itemId, 'WeaponReapairKit' ) || _inv.IsItemBolt( itemId ) ||  _inv.IsItemUsable( itemId ) || _inv.IsQuickSlotItem( itemId ) )
		{
			targetGridSection = 0;
		}
		
		else if( _inv.IsItemOil( itemId ) )
		{
			targetGridSection = 0;
		}
		else if( _inv.IsItemPotion( itemId ) && !_inv.IsItemFood(itemId ) )
		{
			targetGridSection = 1;
		}
		else if( _inv.IsItemBomb( itemId ) )
		{
			targetGridSection = 2;
		}
		
		else if( isQuest && !_inv.IsItemTrophy( itemId ) )
		{
			targetGridSection = 0;
		}
		
		else if( _inv.IsItemFood( itemId ) )
		{
			targetGridSection = 0;
		}
		else if( _inv.IsItemHorseItem( itemId ) || _inv.IsItemTrophy( itemId ) )
		{
			targetGridSection = 1;
		}
		
		else if( _inv.ItemHasTag( itemId, 'AlchemyIngredient' ) )
		{
			targetGridSection = 1;
			
			if ( _inv.ItemHasTag( itemId, 'MutagenIngredient' ) )
			{
				flashObject.SetMemberFlashInt( "sortGroup", 1);
			}
			else
			{
				flashObject.SetMemberFlashInt( "sortGroup", 0);
			}
		}
		else if ( _inv.ItemHasTag( itemId, 'CraftingIngredient' ) )
		{
			targetGridSection = 0;
		}
		
		else
		{
			targetGridSection = 1;
			
		}
		
		if( _inv.ItemHasTag( itemId, 'Painting' ) )
		{
			flashObject.SetMemberFlashInt( "sortGroup", 1);
		}
		else
		if( _inv.ItemHasTag( itemId, 'ReadableItem' ) )
		{
			flashObject.SetMemberFlashInt( "sortGroup", 2);
		}
		
		flashObject.SetMemberFlashInt( "sectionId", targetGridSection );
		
		if( itemName == 'q705_tissue_extractor' && thePlayer.GetTissueExtractorChargesCurr() >= thePlayer.GetTissueExtractorChargesMax() )
		{
			
			
			
			
			flashObject.SetMemberFlashBool( "isNew", true );
		}
	}
	
	function GetOnlyMiscItems( out items : array<SItemUniqueId> ) : void
	{
		var tempItems : array<SItemUniqueId>;
		var tempItemsToRemove : array<SItemUniqueId>;
		var i : int;
		_inv.GetAllItems(tempItems);
		tempItemsToRemove = _inv.GetItemsByTag( 'AlchemyIngridient' );
		for( i = 0; i < tempItemsToRemove.Size(); i += 1 )
		{
			tempItems.Remove(tempItemsToRemove[i]);
		}
		LogChannel('MISC_ITEMS',"tempItems - alchemy size "+tempItems.Size());
		tempItemsToRemove = _inv.GetItemsByTag( 'CraftingIngridient' );
		for( i = 0; i < tempItemsToRemove.Size(); i += 1 )
		{
			tempItems.Remove(tempItemsToRemove[i]);
		}
		LogChannel('MISC_ITEMS',"tempItems - crafting size "+tempItems.Size());	
		tempItemsToRemove = _inv.GetItemsByTag( 'Quest' );
		for( i = 0; i < tempItemsToRemove.Size(); i += 1 )
		{
			tempItems.Remove(tempItemsToRemove[i]);
		}
		LogChannel('MISC_ITEMS',"tempItems - quests size "+tempItems.Size());	

		LogChannel('MISC_ITEMS',"tempItems - crafting size "+tempItems.Size());	
		tempItemsToRemove = _inv.GetAllWeapons();
		for( i = 0; i < tempItemsToRemove.Size(); i += 1 )
		{
			tempItems.Remove(tempItemsToRemove[i]);
		}
		LogChannel('MISC_ITEMS',"tempItems - wepons size "+tempItems.Size());
		
		for( i = tempItems.Size()-1; i > -1; i -= 1 )
		{
			if(_inv.IsItemAnyArmor(tempItems[i]))
			{
				tempItems.Erase(i);
			}
		}
		LogChannel('MISC_ITEMS',"tempItems - armors size "+tempItems.Size());
		items = tempItems;
	}
	
	
	
	public function ShouldShowItem( item : SItemUniqueId ):bool
	{
		var itemCategory : name;
		var itemName : name;
		
		if( bPaperdoll )
		{
			return super.ShouldShowItem( item );
		}
		
		if ( ! super.ShouldShowItem( item ) )
		{
			return false;
		}
		
		if ( ! filterByTagsList( item ) )
		{
			return false;
		}
		
		if ( ! filterByForbiddenTagsList( item ) )
		{
			return false;
		}		
		
		if ( !overrideQuestItemFilters && _filterType != IFT_QuestItems && _inv.ItemHasTag( item, 'Quest' ) && !isHorseItem(item) ) 
		{
			return false;
		}			
		
		itemName = _inv.GetItemName(item);
		itemCategory = _inv.GetItemCategory( item );
		if ( itemCategory == 'schematic' ) 
		{
			return false;
		}
		
		
			if ( isEquipped( item ) )
			{
				return false; 
			}
			return CheckIfShouldShowItem( item );
		
	}
	
	
	private function filterByTagsList( item : SItemUniqueId ):bool
	{
		var i, len:int;
		len = filterTagList.Size();
		for (i = 0; i < len; i+=1)
		{
			if (!_inv.ItemHasTag(item, filterTagList[i]))
			{
				return false;
			}
		}
		return true;
	}

	
	private function filterByForbiddenTagsList( item : SItemUniqueId ):bool
	{
		var i, len:int;
		len = filterForbiddenTagList.Size();
		for (i = 0; i < len; i+=1)
		{
			if (_inv.ItemHasTag(item, filterForbiddenTagList[i]))
			{
				return false;
			}
		}
		return true;
	}	
	
	private function CheckShowItemByCategory( item : SItemUniqueId, itemCategory : name ) : bool 
	{
		var itemName : name;
		
		itemName = _inv.GetItemName(item);
	
		if( _filterType != IFT_Default )
		{
			return CheckIfShouldShowItem( item );
		}
		else
		{
			if( _inv.GetSlotForItemId(item) != EES_InvalidSlot && _currentItemCategoryType != '' )
			{
				if( _inv.IsItemQuickslotItem(item) )
				{
					switch( _currentItemCategoryType )
					{
						case 'quick1':
						case 'quick2':
						
							return true;
					}
				}
				else if( itemCategory == _currentItemCategoryType )
				{
					return true;
				}
				else if( _inv.IsItemSteelSwordUsableByPlayer(item) && _currentItemCategoryType == 'steel' )
				{
					return true;
				}
				else if( _inv.IsItemSilverSwordUsableByPlayer(item) && _currentItemCategoryType == 'silver' )
				{
					return true;
				}
			}
			else if( _inv.GetSlotForItemId(item) == EES_InvalidSlot && _currentItemCategoryType == '' )
			{
				return CheckIfShouldShowItem( item );
			}
		}
		return false;
	}
	
	public function GetNewFlagForTabs( filters : array <EInventoryFilterType> ) : array<bool>
	{
		var i, iCount    : int;
		var j, jCount    : int;
		var newFlags     : array<bool>;
		var curItem      : SItemUniqueId;
		var curFilter 	 : EInventoryFilterType;
		var rawItems   	 : array<SItemUniqueId>;
		var uiData   	 : SInventoryItemUIData;
		var cachedFilter : EInventoryFilterType;
		
		_inv.GetAllItems( rawItems );
		newFlags.Resize( EnumGetMax( 'EInventoryFilterType' ) + 1 );
		iCount = rawItems.Size();
		jCount = filters.Size();
		
		cachedFilter = _filterType;
		
		for( i = 0; i < iCount; i += 1 )
		{
			curItem = rawItems[i];
			
			for( j = 0; j < jCount; j += 1 )
			{
				_filterType = filters[j];
				
				if( ShouldShowItem( curItem ) )
				{
					uiData = _inv.GetInventoryItemUIData( curItem );
					
					if( uiData.isNew )
					{
						newFlags[_filterType] = true;
						jCount-=1;
						filters.Erase( j );
						
						if( filters.Size() > 0 )
						{
							break;
						}
						else
						{
							return newFlags;
						}
					}
				}
			}
		}
		
		_filterType = cachedFilter;
		
		return newFlags;
	}
	
	private function CheckIfShouldShowItem( item : SItemUniqueId ) : bool
	{
		var shouldShow : bool;
		var isJunk     : bool;
		var isTrophy   : bool;
		
		shouldShow = false;
		
		isTrophy = _inv.IsItemTrophy( item );
		isJunk = ( !isItemReadable(item) && !isFoodItem(item) && ! isIngredientItem( item ) && !isWeaponItem( item ) && ! isArmorItem( item ) && ! isAlchemyItem( item ) && !isUpgradeItem( item ) && !isItemSchematic( item ) && !isToolItem(item) && !isHorseItem( item ) && !isTrophy );
		
		switch( _filterType )
		{
			case IFT_QuestItems:
				shouldShow =  ( isJunk || isQuestItem( item ) || ( isItemReadable( item )  ) ) && ( !isQuickslotItem( item ) || isQuestItem( item ) ) && !isTrophy;
				break;
			case IFT_Default:
				shouldShow = isFoodItem( item ) || isHorseItem( item );
				break;
			case IFT_Ingredients:
				shouldShow = isIngredientItem( item ) && !IsItemDye( item );
				break;
			case IFT_Weapons:
				shouldShow = isWeaponItem( item ) || isArmorItem( item ) || isUpgradeItem( item ) || isToolItem( item ) || isItemUsable( item ) || isQuickslotItem( item ) || IsItemDye( item );
				break;
			case IFT_Books:
				shouldShow = !isQuestItem( item ) && isItemReadable( item );
				break;
			case IFT_AlchemyItems:
				shouldShow = isAlchemyItem( item ) && !isFoodItem( item ) && !isItemUsable( item ) && !IsItemDye( item );
				break;
			case IFT_AllExceptHorseItem:
				shouldShow = !isHorseItem( item );
				break;
			case IFT_HorseItems:
				shouldShow = isHorseItem( item );
				break;
			case IFT_Armors:
				shouldShow = ( ( isArmorItem( item ) && _inv.GetItemCategory( item ) == '' ) || ( isArmorItem( item ) && _inv.GetItemCategory( item ) == _currentItemCategoryType ) );
				break;
			case IFT_None:
				shouldShow = true;
				break;
			default:
				break;		
		}
			
		return shouldShow;
	}	
		
	protected function HAXIsMiscItem( item : SItemUniqueId ) : bool 
	{
		return ! _inv.ItemHasTag( item, 'CraftingIngredient' ) && ! isQuestItem( item ) && _inv.GetSlotForItemId(item) == EES_InvalidSlot;
	}
	
	
	
	protected function GetItems( out items : array<SItemUniqueId> )
	{
		
		
		switch ( _filterType )
		{
			case IFT_Default:
			case IFT_Weapons:
			case IFT_Armors:
			case IFT_Ingredients:
			case IFT_AlchemyItems:
			case IFT_Books:
				_inv.GetAllItems( items );
				break;
			case IFT_QuestItems:
				items = _inv.GetItemsByTag( 'Quest' );
				break;
			default:
				break;
		}
	}
	
	public function GetItemActionType( item : SItemUniqueId, optional bGetDefault : bool ) : EInventoryActionType
	{
		if( !bGetDefault && currentDefaultItemAction != IAT_None )
		{
			return currentDefaultItemAction;
		}
		else
		{
			return super.GetItemActionType( item );
		}
	}
}

function GetItemRarityDescriptionFromInt( quality : int ) : string
{
	switch(quality)
	{
		case 1:													  
			return "<font color='#7b7877'>"+GetLocStringByKeyExt("panel_inventory_item_rarity_type_common")+"</font>";
		case 2:
			return "<font color='#3661dc'>"+GetLocStringByKeyExt("panel_inventory_item_rarity_type_masterwork")+"</font>";
		case 3:
			return "<font color='#959500'>"+GetLocStringByKeyExt("panel_inventory_item_rarity_type_magic")+"</font>";
		case 4:
			return "<font color='#934913'>"+GetLocStringByKeyExt("panel_inventory_item_rarity_type_relic")+"</font>";	
		case 5:
			return "<font color='#197319'>"+GetLocStringByKeyExt("panel_inventory_item_rarity_type_set")+"</font>";
		default:
			return "";
	}
}
