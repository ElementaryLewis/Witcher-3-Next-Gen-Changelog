/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
struct SItemGenericStat
{
	var statName   : string;
	var value	   : float;
	var comparence : string;
}
	
class W3TooltipComponent 
{
	protected var m_playerInv	        : CInventoryComponent;
	protected var m_itemInv		        : CInventoryComponent;
	protected var m_shopInv			    : CInventoryComponent;
	protected var m_flashValueStorage   : CScriptedFlashValueStorage;	
	protected var m_enchantmentManager 	: W3EnchantmentManager;
	
	public function initialize( inventory : CInventoryComponent, flashValueStorage : CScriptedFlashValueStorage ) : void
	{
		m_playerInv = inventory;
		m_flashValueStorage = flashValueStorage;
		
		m_enchantmentManager = new W3EnchantmentManager in this;
		m_enchantmentManager.Init(NULL);
	}
	
	public function setCurrentInventory( invComponent : CInventoryComponent ):void
	{
		m_itemInv = invComponent;
	}
	
	public function setShopInventory( invComponent : CInventoryComponent ):void
	{
		m_shopInv = invComponent;
	}
	
	public function setCrafter(craftsmanComponent : W3CraftsmanComponent):void
	{
		
	}
	
	
	
	public function GetEmptySlotData( equipID : int ) : CScriptedFlashObject
	{
		var tooltipData : CScriptedFlashObject;
		tooltipData = m_flashValueStorage.CreateTempFlashObject();
		tooltipData.SetMemberFlashString("ItemType", GetLocStringByKeyExt(GetLocNameFromEquipSlot(equipID)) );
		tooltipData.SetMemberFlashString("Description", GetLocStringByKeyExt("panel_inventory_tooltip_empty_slot") );
		return tooltipData;
	}
	
	public function GetEmptyPreparationSlotData( equipID : int, isLocked : bool ) : CScriptedFlashObject
	{
		var tooltipData : CScriptedFlashObject;
		tooltipData = m_flashValueStorage.CreateTempFlashObject();
		
		if (isLocked)
		{
			tooltipData.SetMemberFlashString("Description", GetLocStringByKeyExt("panel_inventory_tooltip_locked_slot"));
		}
		else
		{
			tooltipData.SetMemberFlashString("Description", GetLocStringByKeyExt("panel_inventory_tooltip_empty_slot"));
		}
		
		
		if (equipID == EES_SilverSword || equipID == EES_SteelSword)
		{
			tooltipData.SetMemberFlashString("ItemType", GetLocStringByKeyExt("panel_inventory_paperdoll_slotname_oils") );
		}
		else
		{
			tooltipData.SetMemberFlashString("ItemType", GetLocStringByKeyExt(GetLocNameFromEquipSlot(equipID)) );
		}
		
		return tooltipData;
	}
	
	
	
	public function GetBaseItemData( item : SItemUniqueId, itemInvComponent : CInventoryComponent, optional isShopItem : bool, optional compareWithItem : SItemUniqueId, optional compareItemInv : CInventoryComponent ) : CScriptedFlashObject
	{
		var wplayer		     : W3PlayerWitcher;
		var tooltipData  	 : CScriptedFlashObject;
		var genericStatsList : CScriptedFlashArray;
		var statsList        : CScriptedFlashArray;
		var propsList	     : CScriptedFlashArray;
		var socketsList	     : CScriptedFlashArray;
		
		var itemName 			: name;
		var itemLabel			: string;
		var itemSlot     		: EEquipmentSlots;
		var equipedItem 		: SItemUniqueId;
		var equipedItemName		: name;
		var equipedItemStats	: array<SAttributeTooltip>;
		
		var weightAttribute		  : SAbilityAttributeValue;
		var categoryName		  : name;
		var categoryLabel		  : string;
		var typeString			  : string;
		var typeDesc			  : string;
		var weightValue 		  : float;	
		
		var primaryStatLabel       : string;
		var primaryStatValue       : float;
		var primaryStatOriginValue : float;
		
		var primaryStatDiff     		 : string;
		var primaryStatDiffValue		 : float;
		var primaryStatDiffStr  		 : string;
		var eqPrimaryStatLabel  		 : string;
		var eqPrimaryStatValue  		 : float;
		var primaryStatDurabilityPenalty : float;
		var durMult 					 : float;
		
		var uniqueDescription	: string;
		var durabilityValue		: int;
		var durabilityStrValue	: string;
		var durabilityLabel 	: string;
		var durabilityRatio     : float;
		
		var armorType			: string;
		
		
		
		var itemStats 			: array<SAttributeTooltip>;
		var compStats			: array<SAttributeTooltip>;
		var isWeaponOrArmor		: bool;
		
		var isArmorOrWeapon		: bool;
		var tmpStr				: string;
		
		var invItem : SInventoryItem;
		var invItemPrice : int;
		var invItemPriceString : string;
		
		var allItems	: array< SItemUniqueId >;
		var i,j : int;
		var m_schematicList, m_recipeList : array< name >;
		var itemCategory : name;
		
		var requiredLevel		  : string;
		var additionalDescription : string;
		var alchRecipe            : SAlchemyRecipe;
		
		var craftSchematic        : SCraftingSchematic;
		var craftItemName	      : name;
		var craftItemCategory     : name;
		
		
		var ignorePrimaryStat	  : bool;
		var itemAttributePrefix	  : string;
		
		var rarityColor : string;
		var canBeCompared  : bool;		
		var itemLevel, craftedItemLevel : int;
		
		var armorTypeGlyphWordBonus : bool;
		var armorEnumType : EArmorType;
		
		var ammo, ammoBonus : float;
		var additionalRarityDescription : string;
		
		var definitionsMgr : CDefinitionsManagerAccessor;
		
		if (!IsInited())
		{
			LogChannel('GUI_Tooltip', "W3TooltipComponent is not initialized, can't get tooltip data");
			return NULL;
		}
		if( !itemInvComponent.IsIdValid(item) )
		{
			LogChannel('GUI_Tooltip', "W3TooltipComponent.GetBaseItemData incorrect item ID");
			return NULL;
		}		
		
		
		
		
		if (!compareItemInv)
		{
			compareItemInv = m_playerInv;
		}
		
		definitionsMgr = theGame.GetDefinitionsManager();
		wplayer = GetWitcherPlayer();
		tooltipData = m_flashValueStorage.CreateTempFlashObject();
		propsList = tooltipData.CreateFlashArray();
		socketsList = tooltipData.CreateFlashArray();
		statsList = tooltipData.CreateFlashArray();
		
		isArmorOrWeapon = itemInvComponent.IsItemAnyArmor(item) || itemInvComponent.IsItemWeapon(item) ;		
		itemName = itemInvComponent.GetItemName(item);		
		itemLabel = GetLocStringByKeyExt(itemInvComponent.GetItemLocalizedNameByUniqueID(item));
		itemSlot = itemInvComponent.GetSlotForItemId(item);
		
		
		
		categoryName =  itemInvComponent.GetItemCategory(item);
		additionalDescription = "";
		craftItemName = '';
		
		if (categoryName == 'crafting_schematic')
		{
			craftSchematic = GetSchematicDataFromXML(itemName); 
			craftItemName = craftSchematic.craftedItemName;
		}
		else
		if (categoryName == 'alchemy_recipe')
		{
			alchRecipe = GetRecipeDataFromXML(itemName);
			craftItemName = alchRecipe.cookedItemName;
		}
		if (craftItemName != '')
		{
			
			craftItemCategory = definitionsMgr.GetItemCategory(craftItemName);
			itemInvComponent.GetItemStatsFromName(craftItemName, itemStats);
			if ( FactsQuerySum("NewGamePlus") > 0 )
			{
				IncreaseNGPPrimaryStatValue( craftItemCategory, itemStats );
			}
			wplayer.GetItemEquippedOnSlot(GetSlotForItemByCategory(craftItemCategory), equipedItem);
			additionalDescription = "<br/><br/><font size = '21' color = '#B58D45'>";
			additionalDescription += StrUpperUTF(GetLocStringByKeyExt(m_playerInv.GetItemLocalizedNameByName(craftItemName))) + "</font>";
			
			if (categoryName == 'crafting_schematic' && craftItemCategory != 'upgrade' && craftItemCategory != 'junk' && !definitionsMgr.ItemHasTag(craftItemName, 'CraftingIngredient'))
			{
				craftedItemLevel = definitionsMgr.GetItemLevelFromName( craftItemName );
				if ( FactsQuerySum("NewGamePlus") > 0 )
				{
					if ( theGame.params.NewGamePlusLevelDifference() > 0 )
					{
						craftedItemLevel += theGame.params.NewGamePlusLevelDifference();
						if ( craftedItemLevel > GetWitcherPlayer().GetMaxLevel() ) 
						{
							craftedItemLevel = GetWitcherPlayer().GetMaxLevel();
						}
					}
				}
				additionalDescription += "<br/>";
				additionalDescription += itemInvComponent.GetItemLevelColor( craftedItemLevel ) + GetLocStringByKeyExt( 'panel_inventory_item_requires_level' ) + " " + craftedItemLevel + "</font><br>"; 
			}
			
			ignorePrimaryStat = false;
			itemAttributePrefix = "";
		}
		else
		{
			itemInvComponent.GetItemBaseStats(item, itemStats);
			
			if (itemInvComponent.IsItemPotion(item) || itemInvComponent.IsItemFood(item) )
			{
				itemInvComponent.GetPotionAttributesForTooltip(item, itemStats);
			}
			if (compareItemInv.IsIdValid(compareWithItem))
			{
				equipedItem = compareWithItem;
			}
			else
			{
				wplayer.GetItemEquippedOnSlot(itemSlot, equipedItem);
			}
			ignorePrimaryStat = isArmorOrWeapon;
			if (isArmorOrWeapon)
			{
				itemAttributePrefix = "+";
			}
		}
		
		if (categoryName == 'gwint')
		{
			additionalDescription += GetGwintCardDescription(GetWitcherPlayer().GetGwentCardIndex(itemName));
		}
		
		if (itemInvComponent.ItemHasTag(item, 'ReadableItem') && itemInvComponent.IsBookRead(item))
		{
			additionalDescription += "<br/><font color=\"#19D900\">" + GetLocStringByKeyExt("book_already_known") + "</font>";
		}
		
		if( isShopItem )
		{
			addRecipeInfo( item, itemInvComponent, additionalDescription );
		}
		
		
		
		AddItemStats(itemStats, statsList, tooltipData, ignorePrimaryStat, itemAttributePrefix, isArmorOrWeapon);
		AddBuffStats(item, itemInvComponent, statsList, tooltipData);
		
		
		
		primaryStatDiff = "none";
		primaryStatDiffValue = 0;
		primaryStatDiffStr = "";
		eqPrimaryStatValue = 0;
		
		if( compareItemInv.IsIdValid( equipedItem ) && !( equipedItem == item && compareItemInv == itemInvComponent ) )
		{
			equipedItemName = compareItemInv.GetItemName(equipedItem);
			
			if (compareItemInv.GetItemCategory(equipedItem) == 'crossbow')
			{
				GetCrossbowPrimatyStat(equipedItem, compareItemInv, eqPrimaryStatLabel, eqPrimaryStatValue);
			}
			else
			{
				compareItemInv.GetItemPrimaryStat(equipedItem, eqPrimaryStatLabel, eqPrimaryStatValue);
				if( compareItemInv.ItemHasTag( equipedItem, 'Aerondight' ) )
				{
					if( compareItemInv.GetItemModifierFloat( equipedItem, 'PermDamageBoost' ) >= 0.f )
					{
						eqPrimaryStatValue += compareItemInv.GetItemModifierFloat( equipedItem, 'PermDamageBoost' );
					}
				}
			}
			
			canBeCompared = isArmorOrWeapon;
		}
		else
		{		
			canBeCompared = false;
		}
		
		if (categoryName == 'crossbow')
		{
			GetCrossbowPrimatyStat(item, itemInvComponent, primaryStatLabel, primaryStatOriginValue);
		}
		else
		{
			itemInvComponent.GetItemPrimaryStat(item, primaryStatLabel, primaryStatOriginValue);
		}
		
		if( itemInvComponent.IsItemSingletonItem( item ) && ( itemInvComponent.SingletonItemGetMaxAmmo(item) > 0 ) )
		{
			if( itemInvComponent.IsItemOil( item ) )
			{
				ammo = CalculateAttributeValue( itemInvComponent.GetItemAttributeValue(item, 'ammo') );
				
				if( thePlayer.CanUseSkill( S_Alchemy_s06 ) )
				{
					ammoBonus = CalculateAttributeValue( thePlayer.GetSkillAttributeValue( S_Alchemy_s06, 'ammo_bonus', false, false ) );
					ammoBonus = ammo * (1 + ammoBonus * thePlayer.GetSkillLevel( S_Alchemy_s06 ) ) - ammo;
					tooltipData.SetMemberFlashString( "charges", RoundF( ammo ) + " ( +" + RoundF( ammoBonus ) + " ) " + GetLocStringByKeyExt( "inventory_tooltip_charges" ) );
				}
				else
				{
					tooltipData.SetMemberFlashString( "charges", RoundF( ammo ) + " " + GetLocStringByKeyExt( "inventory_tooltip_charges" ) );
				}
			}
			else
			{
				tooltipData.SetMemberFlashString( "charges", itemInvComponent.SingletonItemGetAmmo( item ) + "/" + itemInvComponent.SingletonItemGetMaxAmmo( item )+ " " + GetLocStringByKeyExt( "inventory_tooltip_charges" ) );
			}
		}
		else if( itemInvComponent.GetItemName( item ) == 'q705_tissue_extractor' )
		{
			tooltipData.SetMemberFlashString( "charges", thePlayer.GetTissueExtractorChargesCurr() + "/" + thePlayer.GetTissueExtractorChargesMax() + " " + GetLocStringByKeyExt( "inventory_tooltip_charges" ) );
		}
		
		
		if( itemInvComponent.ItemHasTag( item, 'Aerondight' ) )
		{
			if( itemInvComponent.GetItemModifierFloat( item, 'PermDamageBoost' ) >= 0.f )
			{
				primaryStatOriginValue += itemInvComponent.GetItemModifierFloat( item, 'PermDamageBoost' );
			}
		}
		
		if (isArmorOrWeapon)
		{
			primaryStatValue = RoundMath(primaryStatOriginValue);
			
			if (canBeCompared)
			{
				eqPrimaryStatValue = RoundMath(eqPrimaryStatValue);
			}
			else
			{
				eqPrimaryStatValue = primaryStatValue;
			}
			
			primaryStatDiff = GetStatDiff(primaryStatValue, eqPrimaryStatValue);
			primaryStatDiffValue = primaryStatValue - eqPrimaryStatValue;
			
			if (primaryStatDiffValue > 0)
			{
				primaryStatDiffStr = "<font color=\"#19D900\">+" + NoTrailZeros(primaryStatDiffValue) + "</font>";
			}
			else if (primaryStatDiffValue < 0)
			{
				primaryStatDiffStr = "<font color=\"#E00000\">" + NoTrailZeros(primaryStatDiffValue) + "</font>";
			}
			
			if (itemInvComponent.IsItemEnchanted(item))
			{
				AddEnchantmentData(item, itemInvComponent, tooltipData);
			}
		}
		
		if( ( isArmorOrWeapon || categoryName == 'mask' ) && itemInvComponent.IsItemSetItem( item ) )
		{
			AddSetAttributes( item, itemInvComponent, tooltipData );
		}		
		
		if (itemInvComponent.IsItemWeapon(item))
		{
			tooltipData.SetMemberFlashNumber("PrimaryStatDelta", .1);
		}
		else
		{
			tooltipData.SetMemberFlashNumber("PrimaryStatDelta", 0);
		}
		
		
		
		weightValue = itemInvComponent.GetItemEncumbrance( item );

		if (categoryName == 'horse_bag' || categoryName == 'horse_blinder' || categoryName == 'horse_saddle' )
		{
			categoryLabel = GetLocStringByKeyExt("item_category_misc");
		}
		else if (itemInvComponent.ItemHasTag(item, 'SecondaryWeapon'))
		{
			categoryLabel = GetLocStringByKeyExt("item_category_secondary");
		}
		else
		{
			categoryLabel = GetLocStringByKeyExt("item_category_" + categoryName);
		}
		typeString = GetLocStringByKeyExt(GetFilterTypeName( itemInvComponent.GetFilterTypeByItem(item) ));
		
		uniqueDescription = "";
		if (!isArmorOrWeapon)
		{
			uniqueDescription = GetLocStringByKeyExt( itemInvComponent.GetItemLocalizedDescriptionByUniqueID(item) );
		}
		if ( theGame.GetGuiManager().GetShowItemNames() )
		{
			uniqueDescription = "<font color=\"#FFDB00\">Item name: '" + itemName + "'</font><br>" + uniqueDescription;
		}
		
		if (itemInvComponent.ItemHasTag(item, 'OlgierdSabre'))
		{
			uniqueDescription = GetLocStringByKeyExt( "attribute_name_double_strike" );
		}
		
		
		if( itemInvComponent.ItemHasTag( item, 'Aerondight' ) )
		{
			uniqueDescription = GetAerondightTooltipDescription( itemInvComponent, item );
		}
		
		
		if( itemInvComponent.ItemHasTag( item, 'sq304_unique_sword' ) )
		{
			uniqueDescription = GetLocStringByKeyExt( 'item_desc_sq304_sword' );
		}
		
		
		if( itemInvComponent.ItemHasTag( item, 'q402_unique_sword' ) )
		{
			uniqueDescription =  GetLocStringByKeyExt( 'item_desc_sq304_sword' );
		}
		
		uniqueDescription += additionalDescription;
		
		if (categoryName == 'armor'|| categoryName == 'pants' || categoryName == 'boots' || categoryName == 'gloves')
		{
			armorType = "";
			
			armorTypeGlyphWordBonus = (thePlayer.HasAbility('Glyphword 2 _Stats', true) || thePlayer.HasAbility('Glyphword 3 _Stats', true) || thePlayer.HasAbility('Glyphword 4 _Stats', true)) && GetWitcherPlayer().IsItemEquipped(item);
			armorEnumType = itemInvComponent.GetArmorType(item);
			
			switch (armorEnumType)
			{
				case EAT_Light:
					armorType = GetLocStringByKeyExt("item_type_light_armor");
					break;
				case EAT_Medium:
					armorType = GetLocStringByKeyExt("item_type_medium_armor");
					break;
				case EAT_Heavy:
					armorType = GetLocStringByKeyExt("item_type_heavy_armor");
					break;
			}
			
			tooltipData.SetMemberFlashBool("hasEnchantedType", armorTypeGlyphWordBonus);
			typeDesc = armorType;
		} 
		else
		{
			typeDesc = categoryLabel;
		}
		
		if ( itemInvComponent.IsItemAnyArmor(item) || itemInvComponent.IsItemBolt(item) || itemInvComponent.IsItemWeapon(item) )
		{
			itemLevel = itemInvComponent.GetItemLevel( item );
			requiredLevel = itemInvComponent.GetItemLevelColorById( item ) + GetLocStringByKeyExt( 'panel_inventory_item_requires_level' ) + " " + itemLevel + "</font>";
		}
		else
		{
			requiredLevel = "";
		}
		
		tooltipData.SetMemberFlashString("RequiredLevel", requiredLevel);
		
		if (categoryName == 'alchemy_recipe' )
		{
			
			m_recipeList     = GetWitcherPlayer().GetAlchemyRecipes();
			itemInvComponent.GetAllItems( allItems );
			for( j = 0; j < m_recipeList.Size(); j+= 1 )
			{	
				if ( itemInvComponent.GetItemName(item) == m_recipeList[j] )
				{
					typeDesc = "<font color='#FF0000'>" + GetLocStringByKeyExt("item_recipe_known");
					break;
				}
			}
			
			categoryLabel = GetLocStringByKeyExt("item_category_misc");
		}
		else if (categoryName == 'crafting_schematic' )
		{
			
			m_schematicList = GetWitcherPlayer().GetCraftingSchematicsNames();			
			itemInvComponent.GetAllItems( allItems );
			for( j = 0; j < m_schematicList.Size(); j+= 1 )
			{	
				if ( itemInvComponent.GetItemName(item) == m_schematicList[j] )
				{
					typeDesc = "<font color='#FF0000'>" + GetLocStringByKeyExt("item_schematic_known");
					break;
				}
			}
		}
		
		
		
		AddOilInfo(item, itemInvComponent, tooltipData);
		AddSocketsInfo(item, itemInvComponent, socketsList);
		
		tmpStr = FloatToStringPrec( weightValue, 2 );
		addGFxItemStat(propsList, "weight", tmpStr, "attribute_name_weight");
		
		durMult = 1;
		if ( isArmorOrWeapon && !itemInvComponent.IsItemBolt( item ) )
		{
			durabilityRatio = itemInvComponent.GetItemDurabilityRatio(item);
			if( durabilityRatio != -1 )
			{
				durabilityValue = RoundMath( durabilityRatio * 100);
				durabilityStrValue = IntToString(durabilityValue) + " %";
				durabilityLabel = GetLocStringByKeyExt("panel_inventory_tooltip_durability");
				if (durabilityValue < 100)
				{
					durabilityStrValue = "<font color='#E70000'>" + durabilityStrValue + "</font>";
					durabilityLabel = "<font color='#E70000'>" + durabilityLabel + "</font>";
					tooltipData.SetMemberFlashString("DurabilityDescription", GetLocStringByKeyExt("tooltip_durability_description"));
				}
				addGFxItemStat(propsList, "repair", durabilityStrValue, durabilityLabel, true);
				
				durMult = theGame.params.GetDurabilityMultiplier( durabilityRatio, itemInvComponent.IsItemWeapon(item));
				if (durMult < 1)
				{
					primaryStatDurabilityPenalty = primaryStatValue - RoundMath( primaryStatOriginValue * durMult );
				}
			}
		}
		if ( m_shopInv )
		{
			if ( isShopItem == true )
			{
				invItemPrice = m_shopInv.GetItemPriceModified( item, false );
				
				invItemPriceString = invItemPrice;
				
				if (m_shopInv.GetItemQuantity(item) > 1)
				{
					invItemPriceString += " (" + (m_shopInv.GetItemQuantity(item) * invItemPrice) + ")";
				}
				
				addGFxItemStat( propsList, "price", "<font color ='#FFFFFF' font face=\"$BoldFont\">" + invItemPriceString + "</font>", "panel_inventory_item_price" );
			}
			else
			{
				invItem = m_playerInv.GetItem( item );
				invItemPrice = m_shopInv.GetInventoryItemPriceModified( invItem, true );
				
				if ( invItemPrice < 0 || m_playerInv.ItemHasTag(item, 'Quest'))
				{
					tooltipData.SetMemberFlashString("WarningMessage", GetLocStringByKeyExt("panel_shop_not_for_sale"));
					addGFxItemStat( propsList, "notforsale", " ");
				}
				else
				{
					invItemPriceString = invItemPrice;
					
					if (m_playerInv.GetItemQuantity(item) > 1)
					{
						invItemPriceString += " (" + (m_playerInv.GetItemQuantity(item) * invItemPrice) + ")";
					}
					addGFxItemStat( propsList, "price", "<font color ='#FFFFFF'>" + invItemPriceString + "</font>", "panel_inventory_item_price" );
				}
			}
		}
		else
		{
			invItemPrice = itemInvComponent.GetItemPriceModified( item, true );
			invItemPriceString = invItemPrice;
			
			if (itemInvComponent.GetItemQuantity(item) > 1)
			{
				invItemPriceString += " (" + (itemInvComponent.GetItemQuantity(item) * invItemPrice) + ")";
			}
			
			addGFxItemStat( propsList, "price", "<font color ='#FFFFFF'>" + invItemPriceString + "</font>", "panel_inventory_item_price" );
		}
		
		
		
		if( compareItemInv.IsIdValid( compareWithItem ) )
		{
			tooltipData.SetMemberFlashString( "EquippedTitle", GetLocStringByKeyExt( "panel_blacksmith_equipped" ) );
		}	
		
		tooltipData.SetMemberFlashUInt("ItemId", ItemToFlashUInt(item));
		tooltipData.SetMemberFlashString("ItemType", typeDesc);
		tooltipData.SetMemberFlashString("ItemRarity", GetItemRarityDescription(item, itemInvComponent, rarityColor ) + additionalRarityDescription );
		tooltipData.SetMemberFlashInt("ItemRarityIdx", itemInvComponent.GetItemQuality(item));
		tooltipData.SetMemberFlashString("ItemName", rarityColor + itemLabel + "</font>");
		tooltipData.SetMemberFlashString("IconPath", itemInvComponent.GetItemIconPathByUniqueID(item) );
		tooltipData.SetMemberFlashString("ItemCategory", categoryLabel);		
		tooltipData.SetMemberFlashString("Description", uniqueDescription);
		
		tooltipData.SetMemberFlashArray("SocketsList", socketsList);
		tooltipData.SetMemberFlashArray("StatsList", statsList);
		tooltipData.SetMemberFlashArray("PropertiesList", propsList);
		
		tooltipData.SetMemberFlashString("PrimaryStatLabel", primaryStatLabel);
		tooltipData.SetMemberFlashString("PrimaryStatDiff", primaryStatDiff);
		tooltipData.SetMemberFlashString("PrimaryStatDiffStr", primaryStatDiffStr);
		tooltipData.SetMemberFlashNumber("PrimaryStatValue", primaryStatValue);
		tooltipData.SetMemberFlashNumber("PrimaryStatDurabilityPenalty", primaryStatDurabilityPenalty);
		
		tooltipData.SetMemberFlashBool("CanBeCompared", canBeCompared);
		tooltipData.SetMemberFlashBool("EnableFullScreenInfo", isArmorOrWeapon);
		
		return tooltipData;
	}
	
	private function addRecipeInfo( item: SItemUniqueId, itemInvComponent : CInventoryComponent, out description : string )
	{
		var schematic 		 	 : SCraftingSchematic;		
		var recipe 			 	 : SAlchemyRecipe;
		var enchantment			 : SEnchantmentSchematic;
		var pinnedRecipe         : name;
		var locPinnedRecipeName	 : name;
		var itemName			 : name;
		var text 				 : string;
		var index	 			 : int;
		var count	 			 : int;
		var curItemPart			 : SItemParts;
		var ingredients			 : array<SItemParts>;
		var resultString		 : string;
		var i 					 : int;
		var itemQuantity		 : int;
		var tempLocName			 : string;
		var title				 : string;
		var fontColor	 		 : string;

		pinnedRecipe = theGame.GetGuiManager().PinnedCraftingRecipe;
		
		if (pinnedRecipe)
		{
			itemName = itemInvComponent.GetItemName( item );
			schematic = getCraftingSchematicFromName(pinnedRecipe);
			
			if(schematic.schemName != '')
			{
				ingredients = schematic.ingredients;
				locPinnedRecipeName = schematic.craftedItemName;
			}			
			else 
			{
				recipe = getAlchemyRecipeFromName(pinnedRecipe);
				if(recipe.recipeName != '')
				{
					ingredients = recipe.requiredIngredients;
					locPinnedRecipeName = recipe.cookedItemName;
				}
				else
				{
					enchantment = getEnchantmentSchematicFromName(pinnedRecipe);
					if(enchantment.schemName != '')
					{
						ingredients = enchantment.ingredients;
						locPinnedRecipeName = enchantment.schemName;
					}
				}
			}
			
			count = ingredients.Size();
			for( i = 0; i < count; i += 1 )
			{
				curItemPart = ingredients[i];
				
				if( curItemPart.itemName == itemName)
				{
					title = "<font color=\"#FBEDCF\">" + GetLocStringByKeyExt("panel_shop_title_pinned_recipe")+ "</font>";
					
					
					tempLocName = GetLocStringByKeyExt( m_playerInv.GetItemLocalizedNameByName( locPinnedRecipeName ) );
					itemQuantity = m_playerInv.GetItemQuantityByName(itemName);
					if(curItemPart.quantity > itemQuantity)
					{
						fontColor = "<font color=\"#FF0000\">";
					}
					else
					{
						fontColor = "<font color=\"#00FF00\">";
					}
					description = description+ "<br/>" + "<br/>" + title  + "<br/>" + tempLocName + "<br/>" + fontColor + itemQuantity+ " / " + curItemPart.quantity + " " + GetLocStringByKeyExt( m_playerInv.GetItemLocalizedNameByName(curItemPart.itemName ) ) + "</font>";
					
					return;
				}
			}
		}
	}
	
	
	private final function IncreaseNGPPrimaryStatValue( category : name, out itemStats : array<SAttributeTooltip> )
	{
		var min, max : SAbilityAttributeValue;
		var i : int;
		
		if ( category == 'steelsword' ) 
		{	
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_steel_dmg', 'SlashingDamage', min, max);
			for (i=0; i < itemStats.Size(); i+=1)
			{
				if ( itemStats[i].originName == 'SlashingDamage' )
				{
					itemStats[i].value += RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
					break;
				}
			}
		}
		else if ( category == 'silversword' ) 
		{
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_silver_dmg', 'SilverDamage', min, max);
			for (i=0; i < itemStats.Size(); i+=1)
			{
				if ( itemStats[i].originName == 'SilverDamage' )
				{
					itemStats[i].value += RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
					break;
				}
			}
		}
		else if ( category == 'armor' ) 
		{	
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_armor_armor', 'armor', min, max);
			for (i=0; i < itemStats.Size(); i+=1)
			{
				if ( itemStats[i].originName == 'armor' )
				{
					itemStats[i].value += RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
					break;
				}
			}
			
		}
		else if ( category == 'boots' || category == 'pants' ) 
		{				
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_pants_armor', 'armor', min, max);
			for (i=0; i < itemStats.Size(); i+=1)
			{
				if ( itemStats[i].originName == 'armor' )
				{
					itemStats[i].value += RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
					break;
				}
			}
		}
		else if ( category == 'gloves' ) 
		{			
			theGame.GetDefinitionsManager().GetAbilityAttributeValue('autogen_fixed_gloves_armor', 'armor', min, max);
			for (i=0; i < itemStats.Size(); i+=1)
			{
				if ( itemStats[i].originName == 'armor' )
				{
					itemStats[i].value += RoundMath((theGame.params.GetNewGamePlusLevel() - theGame.params.NEW_GAME_PLUS_MIN_LEVEL) * max.valueBase);
					break;
				}
			}
		}	
	}
	
	private function AddEnchantmentData(itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out flashDataObj : CScriptedFlashObject):void
	{
		var enchantmentName : name;
		var schematic : SEnchantmentSchematic;
		var description : string;
		
		var enchantmentParamsInt:array<int>;
		var enchantmentParamsFloat:array<float>;
		var enchantmentParamsStr:array<string>;
		
		if (m_enchantmentManager)
		{			
			enchantmentName = itemInvComponent.GetEnchantment(itemId);
			m_enchantmentManager.GetSchematic(enchantmentName, schematic);
			
			itemInvComponent.GetParamsForRunewordTooltip(schematic.schemName, enchantmentParamsInt, enchantmentParamsFloat, enchantmentParamsStr);
			description = GetLocStringByKeyExtWithParams(schematic.localizedDescriptionName, enchantmentParamsInt, enchantmentParamsFloat, enchantmentParamsStr);
			
			flashDataObj.SetMemberFlashString("appliedEnchantmentInfo", "<font face=\"$BoldFont\">" + GetLocStringByKeyExt(schematic.localizedName) + ":</font> " + description);
		}
	}
	
	private function AddSetAttributes( itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out flashDataObj : CScriptedFlashObject ):bool
	{
		var setAttributesList : CScriptedFlashArray;
		var setAttribute  	  : CScriptedFlashObject;
		var currentCount	  : int;
		var requiredCount	  : int;
		var desc1			  : string;
		var desc2			  : string;
		var counterText		  : string;
		var isActive1		  : bool;
		var isActive2		  : bool;
		var setType			  : EItemSetType;
		
		setType = GetWitcherPlayer().GetSetBonusStatus( itemId, desc1, desc2, isActive1, isActive2 );
		
		if( setType != EIST_Undefined && setType != EIST_Viper ) 
		{
			currentCount = GetWitcherPlayer().GetSetPartsEquipped( setType );
			requiredCount = theGame.params.ITEMS_REQUIRED_FOR_MAJOR_SET_BONUS;
			
			counterText = currentCount + "/" + requiredCount;
			
			flashDataObj.SetMemberFlashString( "SetCounter", counterText);
			
			setAttributesList = flashDataObj.CreateFlashArray();
			
			if ( !itemInvComponent.ItemHasTag( itemId, theGame.params.ITEM_SET_TAG_BONUS ) )
			{
				setAttribute = flashDataObj.CreateFlashObject();
				setAttribute.SetMemberFlashString( "value", "" );
				setAttribute.SetMemberFlashString( "name", GetLocStringByKeyExt( "tooltip_set_bonus_not_avilable_yet" ) );
				setAttribute.SetMemberFlashBool( "active", true );
				setAttributesList.PushBackFlashObject( setAttribute );
			}
			
			
			setAttribute = flashDataObj.CreateFlashObject();
			setAttribute.SetMemberFlashString( "value", theGame.params.ITEMS_REQUIRED_FOR_MINOR_SET_BONUS );
			setAttribute.SetMemberFlashString( "name", desc1 );
			setAttribute.SetMemberFlashBool( "active", isActive1 );
			setAttributesList.PushBackFlashObject( setAttribute );
			
			if( desc2 != "" )
			{
				
				setAttribute = flashDataObj.CreateFlashObject();
				setAttribute.SetMemberFlashString( "value", theGame.params.ITEMS_REQUIRED_FOR_MAJOR_SET_BONUS );
				setAttribute.SetMemberFlashString( "name", desc2 );
				setAttribute.SetMemberFlashBool( "active", isActive2 );
				setAttributesList.PushBackFlashObject( setAttribute );
			}
			
			flashDataObj.SetMemberFlashArray( "SetStatsList", setAttributesList );
			
			return true;
		}
		
		return false;
	}
	
	private function GetCrossbowPrimatyStat(itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out primaryStatLabel : string, out primaryStatValue : float):void
	{
		var itemOnSlot 			  : SItemUniqueId;
		var crossbowPower         : SAbilityAttributeValue;
		var crossbowStatValueMult : float;
		
		crossbowPower = itemInvComponent.GetItemAttributeValue(itemId, 'attack_power');
		crossbowStatValueMult = crossbowPower.valueMultiplicative;
		if (crossbowStatValueMult == 0)
		{
			
			crossbowStatValueMult = 1;
		}
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt, itemOnSlot);
		if (itemInvComponent.IsIdValid(itemOnSlot))
		{
			itemInvComponent.GetItemPrimaryStat(itemOnSlot, primaryStatLabel, primaryStatValue);
			primaryStatValue = primaryStatValue * crossbowStatValueMult;
		}
		else
		{
			itemInvComponent.GetItemStatByName('Bodkin Bolt', 'PiercingDamage', primaryStatValue);
			primaryStatValue = primaryStatValue * crossbowStatValueMult;
		}
		primaryStatLabel = GetLocStringByKeyExt("panel_inventory_tooltip_damage");
	}
	
	
	private function AddSocketsInfo(itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out flashDataObj : CScriptedFlashArray):void
	{
		var socketsCount		: int;
		var usedSocketsCount	: int;
		var emptySocketsCount	: int;
		var socketItems			: array<name>;
		var idx  				: int;
		var curUpgradeName		: name;
		var curUpgradeLocName   : string;
		
		var upgradeBonusDesc  : string;
		var upgradeBonusValue : string;
		var upgradeBonus 	  : float;
		var upgradeStats 	  : array<SAttributeTooltip>;
		var upgradeStatFirst  : SAttributeTooltip;
		
		var tmpDataObject : CScriptedFlashObject;
		
		socketsCount = itemInvComponent.GetItemEnhancementSlotsCount( itemId );
		usedSocketsCount = itemInvComponent.GetItemEnhancementCount( itemId );
		emptySocketsCount = socketsCount - usedSocketsCount;		
		itemInvComponent.GetItemEnhancementItems(itemId, socketItems);
		
		for (idx = 0; idx < socketItems.Size(); idx+=1)
		{
			curUpgradeName = socketItems[idx];
			curUpgradeLocName = GetLocStringByKeyExt(itemInvComponent.GetItemLocalizedNameByName(curUpgradeName));
			itemInvComponent.GetItemStatsFromName(curUpgradeName, upgradeStats);
			
			tmpDataObject = m_flashValueStorage.CreateTempFlashObject();
			
			if( upgradeStats.Size() > 0 )
			{
				upgradeStatFirst = upgradeStats[0];
				
				if( upgradeStatFirst.attributeName != "" )
				{
					if( upgradeStatFirst.percentageValue )
					{
						upgradeBonusValue = "<font color=\"#fcda63\">+" + RoundMath(upgradeStatFirst.value * 100) + " %</font>";
					}
					else
					{
						upgradeBonusValue = "<font color=\"#fcda63\">+" + RoundMath(upgradeStatFirst.value) + "</font>";
					}
					
					upgradeBonusDesc = upgradeStatFirst.attributeName + "<br/><font color=\"#7e785f\">" + curUpgradeLocName + "</font>";
					tmpDataObject.SetMemberFlashString("value", upgradeBonusValue);
					tmpDataObject.SetMemberFlashString("name", upgradeBonusDesc);
				}
			}
			else
			{
				tmpDataObject.SetMemberFlashString("value", "");
				tmpDataObject.SetMemberFlashString("name", "<font color=\"#7e785f\">" + curUpgradeLocName + "</font>");
			}
			
			tmpDataObject.SetMemberFlashString("type", "equipped");
			flashDataObj.PushBackFlashObject(tmpDataObject);
		}
		
		upgradeBonusValue = "<font color=\"#5e5946\">" + GetLocStringByKeyExt("panel_blacksmith_empty_socket") + "</font>";
		
		for (idx = 0; idx < emptySocketsCount; idx+=1)
		{
			tmpDataObject = m_flashValueStorage.CreateTempFlashObject();
			tmpDataObject.SetMemberFlashString("type", "empty");
			tmpDataObject.SetMemberFlashString("value", upgradeBonusValue);
			flashDataObj.PushBackFlashObject(tmpDataObject);
		}
	}
	
	
	private function AddOilInfo(itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out flashDataObj : CScriptedFlashObject):void
	{
		var oilName		  : name;
		var oilLocName	  : string;
		var oilCharges 	  : int;
		var oilMaxCharges : int;
		var oilBonus 	  : float;
		var oilStats 	  : array<SAttributeTooltip>;
		var oilStatFirst  : SAttributeTooltip;
		var oilBonusValue : string;
		var i, count	  : int;
		
		var appliedOilsList : array< W3Effect_Oil >;
		var appliedOil    	: W3Effect_Oil;
		
		appliedOilsList = itemInvComponent.GetOilsAppliedOnItem( itemId );
		count = appliedOilsList.Size();
		
		for( i = 0; i < count; i+=1 )
		{
			appliedOil = appliedOilsList[i];
			oilName = appliedOil.GetOilItemName();
			
			if (oilName != '')
			{
				oilLocName = GetLocStringByKeyExt( itemInvComponent.GetItemLocalizedNameByName( oilName ) );
				oilCharges = appliedOil.GetAmmoCurrentCount();
				oilMaxCharges = appliedOil.GetAmmoMaxCount();		
				itemInvComponent.GetItemStatsFromName( oilName, oilStats );
				
				if (oilStats.Size() > 0)
				{
					oilStatFirst = oilStats[0];
					if( oilStatFirst.percentageValue )
					{
						oilBonusValue = "+" + RoundMath(oilStatFirst.value * 100) + " %";
					}
					else
					{
						oilBonusValue = "+" + RoundMath(oilStatFirst.value);
					}
				}
				
				if(oilCharges <=0)
				{
					oilBonusValue = "<font color=\"#FF0000\">" + oilBonusValue +  " " + oilStatFirst.attributeName + " (" + oilLocName + ")(" + oilCharges + "/" + oilMaxCharges + ")"+ "</font>";
				}
				
				else if (GetWitcherPlayer().CanUseSkill(S_Alchemy_s06) && GetWitcherPlayer().GetSkillLevel(S_Alchemy_s06) > 2)
				{
					oilBonusValue = oilBonusValue +  " " + oilStatFirst.attributeName + " (" + oilLocName + ")";
				}
				
				else
				{
					oilBonusValue = oilBonusValue +  " " + oilStatFirst.attributeName + " (" + oilLocName + ")(" + oilCharges + "/" + oilMaxCharges + ")";
				}
				
				flashDataObj.SetMemberFlashString("appliedOilInfo" +(string)(i + 1), oilBonusValue);
			}
		}
	}
	
	
	private function AddItemStats(itemStats : array<SAttributeTooltip>, out resultGFxArray : CScriptedFlashArray, rootGFxObject : CScriptedFlashObject, ignorePrimaryStat : bool, defaultPrefix : string, isArmorOrWeapon : bool):void
	{
		var l_flashObject : CScriptedFlashObject;
		var currentStat	  : SAttributeTooltip;
		var i, statsCount : int;
		var maxToxicity   : int;
		var valuePrefix	  : string;
		var valuePostfix  : string;
		var valueString   : string;
		
		statsCount= itemStats.Size();
		for( i = 0; i < statsCount; i += 1) 
		{
			currentStat = itemStats[i];
			if (!ignorePrimaryStat || !currentStat.primaryStat)
			{
				
				if (currentStat.originName == 'toxicity_offset')
				{
					currentStat.attributeName = GetAttributeNameLocStr('toxicity', false);
					currentStat.originName = 'toxicity';
					currentStat.percentageValue = false;
				}
				if (currentStat.originName == 'toxicity')
				{
					if (!isArmorOrWeapon)
					{
						maxToxicity = RoundMath(thePlayer.GetStatMax( BCS_Toxicity ));
						valuePrefix = "";
						valuePostfix = "/" + maxToxicity;
					}
					else
					{
						valuePrefix = "+";
						valuePostfix = "";
						currentStat.attributeName = GetLocStringByKeyExt("panel_common_statistics_tooltip_current_maximum");
					}
				}
				else
				if (currentStat.originName == 'duration')
				{
					valuePrefix = "";
					valuePostfix = " " + GetLocStringByKeyExt("per_second");
				}				
				else
				{
					valuePrefix = defaultPrefix;
					valuePostfix = "";
				}
				
				if(currentStat.originName == 'slow_motion')
				{
					currentStat.attributeName = GetLocStringByKey('attribute_name_SlowdownEffect');
				}
				else if(currentStat.originName == 'focus')
				{
					currentStat.attributeName = GetLocStringByKey('focus');
				}
				else if(currentStat.originName == 'air')
				{
					currentStat.attributeName = GetLocStringByKey('panel_hud_breath');
				}
				else if(currentStat.originName == 'vitalityCombatRegen')
				{
					currentStat.attributeName = GetLocStringByKey('panel_common_statistics_tooltip_incombat_regen');
				}
				else if(currentStat.originName == 'returned_damage')
				{
					currentStat.attributeName = GetLocStringByKey('attribute_name_return_damage');
				}
				
				if( currentStat.percentageValue )
				{
					valueString = NoTrailZeros( RoundMath( currentStat.value * 100 ) ) + " %";
				}
				else if(currentStat.originName == 'focus_gain')
				{
					valueString = NoTrailZeros(currentStat.value);
				}
				else
				{
					valueString = NoTrailZeros( RoundMath( currentStat.value ) );
				}
				
				l_flashObject = rootGFxObject.CreateFlashObject();
				l_flashObject.SetMemberFlashString("id", NameToString(currentStat.originName));
				l_flashObject.SetMemberFlashString("name", currentStat.attributeName);
				l_flashObject.SetMemberFlashString("color", currentStat.attributeColor);				
				l_flashObject.SetMemberFlashString("value", valuePrefix + valueString + valuePostfix);
				l_flashObject.SetMemberFlashString("valuePrefix", valuePrefix);
				l_flashObject.SetMemberFlashBool("isPercentageValue", currentStat.percentageValue);
				l_flashObject.SetMemberFlashNumber("floatValue", currentStat.value);
				resultGFxArray.PushBackFlashObject(l_flashObject);
			}
		}
	}
	
	
	private function AddBuffStats(itemId : SItemUniqueId, itemInvComponent : CInventoryComponent, out resultGFxArray : CScriptedFlashArray, rootGFxObject : CScriptedFlashObject) : void
	{
		var min, max 		 : SAbilityAttributeValue;
		var curFlashObject   : CScriptedFlashObject;
		var buffDuration     : float;
		var idx, len         : int;
		var curBufValue      : float;
		var curBufValueStr   : string;
		var additionalBufStr : string;
		
		var isEdibles : bool;
		var isDrinks  : bool;
		
		var t1:int;
		var t2:int;
		
		isEdibles = itemInvComponent.ItemHasTag(itemId, 'Edibles');
		isDrinks = itemInvComponent.ItemHasTag(itemId, 'Drinks');
		
		if (isEdibles || isDrinks || itemInvComponent.IsItemBomb(itemId))
		{
			buffDuration = GetBuffDuration(itemId, itemInvComponent);
		}
		
		if (buffDuration > 0 )
		{
			len = resultGFxArray.GetLength();
			
			for (idx = 0; idx < len; idx+=1)
			{
				curFlashObject = resultGFxArray.GetElementFlashObject(idx);
				
				if (curFlashObject.GetMemberFlashString("id") == NameToString('duration'))
				{
					curBufValue = 0;
					
					if (isEdibles || isDrinks)
					{
						resultGFxArray.RemoveElement(idx);
						continue;
					}
					
					curBufValue = curFlashObject.GetMemberFlashNumber("floatValue");
					
					curBufValue += buffDuration;
					curBufValueStr = NoTrailZeros( RoundMath( curBufValue) ) + " " + GetLocStringByKeyExt("per_second");
					
					curFlashObject.SetMemberFlashString("value",  curBufValueStr);
					curFlashObject.SetMemberFlashNumber("floatValue", curBufValue);
					
					return;
				}
			}
			
			curFlashObject = rootGFxObject.CreateFlashObject();
			if (isEdibles && GetWitcherPlayer().HasRunewordActive('Runeword 6 _Stats') && GetWitcherPlayer().IsItemEquipped(itemId))
			{
				theGame.GetDefinitionsManager().GetAbilityAttributeValue('Runeword 6 _Stats', 'runeword6_duration_bonus', min, max);
				curBufValueStr = "<font color='#E67E0B'>" + NoTrailZeros ( RoundMath( buffDuration * (1 + min.valueMultiplicative) )) + " " + GetLocStringByKeyExt("per_second") + "</font>";
				curFlashObject.SetMemberFlashString("name", "<font color='#E67E0B'>" + GetAttributeNameLocStr('duration', false) + "</font>");
				curFlashObject.SetMemberFlashBool("enchanted", true);
			}
			else
			{
				curBufValueStr = NoTrailZeros( RoundMath( buffDuration) ) + " " + GetLocStringByKeyExt("per_second");
				curFlashObject.SetMemberFlashString("name", GetAttributeNameLocStr('duration', false));
			}
			
			curFlashObject.SetMemberFlashString("value", curBufValueStr);
			curFlashObject.SetMemberFlashNumber("floatValue", buffDuration);
			resultGFxArray.PushBackFlashObject(curFlashObject);
		}
	}
	
	
	
	public function GetExItemData( item : SItemUniqueId, optional isShopItem : bool ) : CScriptedFlashObject
	{
		var tooltipData:CScriptedFlashObject;
		
		if (!IsInited())
		{
			LogChannel('GUI_Tooltip', "W3TooltipComponent is not initialized, can't get tooltip data");
			return NULL;
		}
		return GetBaseItemData(item, m_itemInv, isShopItem);
	}
	
	
	
	public function GetTooltipData( itemId : SItemUniqueId, isShopItem : bool, compareItem : bool) : CScriptedFlashObject
	{
		var wplayer		     : W3PlayerWitcher;
		var itemSlot     	 : EEquipmentSlots;
		var equipedItemId 	 : SItemUniqueId;
		var horseManager	 : W3HorseManager;
		var horseInv		 : CInventoryComponent;
		var selectedItemData : CScriptedFlashObject;
		var equippedItemData : CScriptedFlashObject;
		var isArmorOrWeapon	 : bool;
		
		if (!IsInited())
		{
			LogChannel('GUI_Tooltip', "W3TooltipComponent is not initialized, can't get tooltip data");
			return NULL;
		}
		
		selectedItemData = GetBaseItemData(itemId, m_itemInv, isShopItem);
		
		if (compareItem && m_itemInv.CanBeCompared(itemId))
		{
			if (m_itemInv.IsItemHorseItem(itemId))
			{
				itemSlot = m_itemInv.GetSlotForItemId(itemId);
				horseManager = GetWitcherPlayer().GetHorseManager();
				if (horseManager)
				{
					equipedItemId = horseManager.GetItemInSlot(itemSlot);
					horseInv = horseManager.GetInventoryComponent();
					
					if (horseInv.IsIdValid(equipedItemId))
					{
						if (isShopItem)
						{
							equippedItemData = GetBaseItemData(equipedItemId, horseInv, isShopItem, itemId, m_shopInv);
						}
						else
						{
							equippedItemData = GetBaseItemData(equipedItemId, horseInv, isShopItem, itemId, m_playerInv);
						}
						selectedItemData.SetMemberFlashObject("equippedItemData", equippedItemData);
					}
				}
			}
			else
			{
				itemSlot = m_itemInv.GetSlotForItemId(itemId);
				wplayer = GetWitcherPlayer();
				wplayer.GetItemEquippedOnSlot(itemSlot, equipedItemId);
				if (m_playerInv.IsIdValid(equipedItemId) && equipedItemId != itemId)
				{
					isArmorOrWeapon = m_playerInv.IsItemAnyArmor(equipedItemId) || m_playerInv.IsItemWeapon(equipedItemId);	
					if (isArmorOrWeapon)
					{
						if (isShopItem)
						{
							equippedItemData = GetBaseItemData(equipedItemId, m_playerInv, isShopItem, itemId, m_shopInv);
						}
						else
						{
							equippedItemData = GetBaseItemData(equipedItemId, m_playerInv, isShopItem, itemId, m_playerInv);
						}
						selectedItemData.SetMemberFlashObject("equippedItemData", equippedItemData);
					}
				}
			}
		}
		
		return selectedItemData;
	}
	
	
	
	protected function GetGenStatsGFxData( itemStats : array<SItemGenericStat>, comparingItemsStats : array<SItemGenericStat>, enableCompare : bool) : CScriptedFlashArray
	{
		var curStatData	   : CScriptedFlashObject;
		var statListData   : CScriptedFlashArray;
		var curStat		   : SItemGenericStat;
		var compValue	   : string;
		var i, j		   : int;
		var statsCount	   : int;
		var compStatsCount : int;
		var foundComp      : bool;
		
		var maxToxicity	    : int;
		var durationPostfix : string;
		
		statListData = m_flashValueStorage.CreateTempFlashArray();
		statsCount = itemStats.Size();
		compStatsCount = comparingItemsStats.Size();
		
		for (i = 0; i < statsCount; i += 1)
		{		
			foundComp = false;
			curStat = itemStats[i];
			
			if (!((curStat.statName == "duration" || curStat.statName == "toxicity" ) && RoundMath(curStat.value) <= 1))
			{
				compValue = "none";
				if (enableCompare)
				{
					for (j = 0; j < compStatsCount; j += 1)
					{
						if (curStat.statName == comparingItemsStats[i].statName)
						{
							compValue = GetStatDiff(curStat.value, comparingItemsStats[i].value);
							foundComp = true;
							break;
						}
					}
					if (!foundComp)
					{
						compValue = "wayBetter";
					}
				}
				curStatData = m_flashValueStorage.CreateTempFlashObject();
				if ( curStat.statName == "toxicity_offset" ) 
					curStatData.SetMemberFlashString("type", "toxicity"); else
					curStatData.SetMemberFlashString("type", curStat.statName); 
				
				
				if (curStat.statName == "toxicity" || curStat.statName == "toxicity_offset" )
				{
					maxToxicity = RoundMath(thePlayer.GetStatMax( BCS_Toxicity ));		
					if ( curStat.statName == "toxicity_offset" ) 
						curStatData.SetMemberFlashString("value", RoundMath(curStat.value * 100) + "/" + maxToxicity);
					else
						curStatData.SetMemberFlashString("value", RoundMath(curStat.value) + "/" + maxToxicity);
				}
				else if (curStat.statName == "duration")
				{				
					durationPostfix = GetLocStringByKeyExt("per_second");
					curStatData.SetMemberFlashString("value", RoundMath(curStat.value) + " " + durationPostfix);
				}
				else
				{
					curStatData.SetMemberFlashString("icon", compValue); 
				}
				statListData.PushBackFlashObject(curStatData);
			}
		}
		return statListData;
	}
	
	protected function GetMutagenGenStatsGFxData():CScriptedFlashArray
	{
		var curStatData	   : CScriptedFlashObject;
		var statListData   : CScriptedFlashArray;
		
		statListData = m_flashValueStorage.CreateTempFlashArray();
		curStatData = m_flashValueStorage.CreateTempFlashObject();
		curStatData.SetMemberFlashString("type", "toxicity");
		curStatData.SetMemberFlashString("value", GetLocStringByKeyExt("panel_tooltip_mutagen_toxicity_warning"));
		statListData.PushBackFlashObject(curStatData);
		return statListData;
	}
	
	protected function GetBuffDuration( itemId : SItemUniqueId, inv: CInventoryComponent ):float
	{
		var buffs      : array<SEffectInfo>;
		var i 	  	   : int;
		var min, max   : SAbilityAttributeValue;
		var dValue	   : float;
		
		inv.GetItemBuffs(itemId, buffs);
		for(i = 0; i < buffs.Size(); i += 1)
		{
			theGame.GetDefinitionsManager().GetAbilityAttributeValue(buffs[i].effectAbilityName, 'duration', min, max);
			dValue = CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
			if (dValue > 0) return dValue;
		}
		return 0;
	}
	
	protected function GetGenericStats( item : SItemUniqueId, inv: CInventoryComponent ) : array<SItemGenericStat>
	{
		var curStat		  : SAttributeTooltip;
		var i, j, count	  : int;
		var settingsSize  : int;
		var attrListSize  : int;
		var attributes 	  : array<name>;
		var attrName	  : string;
		var attrType	  : string;
		var attrValue	  : float;
		var attrMult	  : float;		
		var genStats	  : array<SItemGenericStat>;
		var curGenStat	  : SItemGenericStat;
		
		inv.GetItemAttributes(item, attributes);
		attrListSize = attributes.Size();
		settingsSize = theGame.tooltipSettings.GetNumRows();
		AppendDefaultGenericStats(genStats, item, inv);
		
		for (i = 0; i < settingsSize; i += 1)
		{
			for (j = 0; j < attrListSize; j += 1)
			{
				attrName = theGame.tooltipSettings.GetValueAt(0, i);
				attrType = theGame.tooltipSettings.GetValueAt(3, i);
				if ( ( attrName == NameToString(attributes[j]) ) && ( attrType != "" ) )
				{
					attrMult = (float)theGame.tooltipSettings.GetValueAt(4, i);
					attrValue = GetAttributeValue(item, attributes[j], inv) * attrMult;
					
					if (attrType == "duration") 
					{
						AppendGenericStat(genStats, attrType, attrValue, true);
					}
					else
					{
						AppendGenericStat(genStats, attrType, attrValue);
					}
					break;
				}
			}
		}
		return genStats;
	}
	
	protected function AppendDefaultGenericStats(out statsList : array<SItemGenericStat>, item : SItemUniqueId, inv: CInventoryComponent) : void
	{
		var buffDuration:float;
		
		if (inv.ItemHasTag(item, 'Edibles') || inv.ItemHasTag(item, 'Drinks'))
		{
			buffDuration = GetBuffDuration(item, inv);
			AddGenericStat(statsList, 'toxicity', 0);
			AddGenericStat(statsList, 'duration', buffDuration);		
		}
		else if (inv.IsItemBomb(item))
		{
			buffDuration = GetBuffDuration(item, inv);
			AddGenericStat(statsList, 'duration', buffDuration);
		}
		else if (inv.IsItemPotion(item))
		{
			AddGenericStat(statsList, 'toxicity', 0);
			AddGenericStat(statsList, 'duration', 0);
		}
		else if (inv.IsItemAnyArmor(item) || inv.IsItemWeapon(item))
		{
			AddGenericStat(statsList, 'attack', 0);
			AddGenericStat(statsList, 'defence', 0);
			AddGenericStat(statsList, 'magic', 0);
			AddGenericStat(statsList, 'vitality', 0);	
		}
	}
	
	protected function AddGenericStat(out statsList : array<SItemGenericStat>, statName : string, statValue : float) : void
	{
		var newStat : SItemGenericStat;
		newStat.statName = statName;
		newStat.value = statValue;
		statsList.PushBack(newStat);
	}
	
	protected function AppendGenericStat(out statsList : array<SItemGenericStat>, statName : string, statValue : float, optional resetValue:bool) : void
	{
		var i, len  : int;
		var newStat : SItemGenericStat;
		
		len = statsList.Size();
		for (i = 0; i < len; i += 1)
		{
			if (statsList[i].statName == statName)
			{
				if (resetValue)
				{
					statsList[i].value = statValue;
				}
				else
				{
					statsList[i].value += statValue;
				}
				return;
			}
		}
	}
	
	protected function GetAttributeValue(item : SItemUniqueId, statName : name, inv : CInventoryComponent) : float
	{
		var statValue	 : float;
		var attributeVal : SAbilityAttributeValue;
		
		attributeVal = inv.GetItemAttributeValue(item, statName);
		if(attributeVal.valueBase != 0)
		{
			statValue = attributeVal.valueBase;
		}
		if(attributeVal.valueMultiplicative != 0)
		{
			statValue = attributeVal.valueMultiplicative;
		}
		if(attributeVal.valueAdditive != 0)
		{
			statValue = attributeVal.valueAdditive;
		}
		
		return statValue;
	}
	
	
	
	protected function IsInited():bool
	{
		return m_itemInv && m_playerInv && m_flashValueStorage;
	}
	
	private function addGFxItemStat(out targetArray:CScriptedFlashArray, type:string, value:string, optional label:string, optional isHtml:bool):void
	{
		var resultData : CScriptedFlashObject;
		var labelLoc   : string;
		
		resultData = m_flashValueStorage.CreateTempFlashObject();
		resultData.SetMemberFlashString("type", type);
		resultData.SetMemberFlashString("value", value);
		if (label != "")
		{
			if (!isHtml)
			{
				labelLoc = GetLocStringByKeyExt(label);
			}
			else
			{
				labelLoc = label;
			}
			resultData.SetMemberFlashString("label", labelLoc);
		}
		targetArray.PushBackFlashObject(resultData);
	}
	
	function GetItemRarityDescription( item : SItemUniqueId, tooltipInv : CInventoryComponent, optional out htmlColor : string ) : string
	{
		var itemQuality  : int;
		var resultString : string;
		
		itemQuality = tooltipInv.GetItemQuality(item);
		
		switch(itemQuality)
		{
			case 1:
				htmlColor = "<font color='#a2a2a2'>"; 
				return htmlColor + GetLocStringByKeyExt("panel_inventory_item_rarity_type_common")+"</font>";
			case 2:
				htmlColor = "<font color='#2b7bff'>"; 
				return htmlColor + GetLocStringByKeyExt("panel_inventory_item_rarity_type_masterwork")+"</font>";
			case 3:
				htmlColor = "<font color='#e1d401'>";
				return htmlColor + GetLocStringByKeyExt("panel_inventory_item_rarity_type_magic")+"</font>";
			case 4:
				htmlColor = "<font color='#ca610c'>";
				return htmlColor + GetLocStringByKeyExt("panel_inventory_item_rarity_type_relic")+"</font>";
			case 5:
				htmlColor = "<font color='#01b701'>";
				return htmlColor + GetLocStringByKeyExt("panel_inventory_item_rarity_type_set")+"</font>";
			default:
				return "";
		}
	}
	
	
	
	
	
	private function CompareItemsStats(itemStats : array<SAttributeTooltip>, compareItemStats : array<SAttributeTooltip>, out compResult : CScriptedFlashArray, rootGFxObject : CScriptedFlashObject, optional dontCompare : bool, optional extendedData:bool )
	{
		CalculateStatsComparance(itemStats, compareItemStats, rootGFxObject, compResult, true, dontCompare, extendedData);
	}
	
	
	private function getCategoryDescription(itemCategory : name):string
	{
		switch (itemCategory)
		{
			case 'steelsword':
			case 'silversword':
			case 'crossbow':
			case 'secondary':
			case 'armor':
			case 'pants':
			case 'gloves':
			case 'boots':
			case 'armor':
			case 'bolt':
				return GetLocStringByKeyExt("item_category_" + itemCategory + "_desc");
				break;
			default:
				return "";
				break;
		}
		return "";
	}
	
	private function GetGwintCardDescription(cardIndex:int):string
	{
		var cardString : string;
		var gwintManager : CR4GwintManager;
		var cardDefinition : SCardDefinition;
		var tempStr : string;
		var abilityName : string;
		var abilityDescription : string;
		
		gwintManager = theGame.GetGwintManager();
		cardDefinition = gwintManager.GetCardDefinition(cardIndex);
		
		if (cardDefinition.index == -1)
		{
			return "Failed to get card definition";
		}
		
		cardString += GetLocStringByKeyExt("gwint_tooltip_faction_header") + ": ";
		
		switch (cardDefinition.faction)
		{
		case GwintFaction_Neutral:
			cardString += "<font color='#7b7877'>" + GetLocStringByKeyExt("gwint_faction_name_neutral") + "</font>"; 
			break;
		case GwintFaction_NoMansLand:
			cardString +=  "<font color='#5B0302'>" + GetLocStringByKeyExt("gwint_faction_name_no_mans_land") + "</font>";
			break;
		case GwintFaction_Nilfgaard:
			cardString += "<font color='#BCAE3C'>" + GetLocStringByKeyExt("gwint_faction_name_nilfgaard") + "</font>";
			break;
		case GwintFaction_NothernKingdom:
			cardString += "<font color='#495382'>" + GetLocStringByKeyExt("gwint_faction_name_northern_kingdom") + "</font>";
			break;
		case GwintFaction_Scoiatael:
			cardString += "<font color='#076807'>" + GetLocStringByKeyExt("gwint_faction_name_scoiatael") + "</font>";
			break;
		case GwintFaction_Skellige:
			cardString += "<font color='#076807'>" + GetLocStringByKeyExt("gwint_faction_name_skellige") + "</font>";
			break;
		}
		
		cardString += "<br/>" + GetLocStringByKeyExt("gwint_tooltip_card_type") + ": ";
		
		if (cardDefinition.index >= 1000) 
		{
			cardString += "<font color='#7b7877'>" + GetLocStringByKeyExt("gwint_tooltip_card_type_leader") + "</font>";
			
			if (cardDefinition.effectFlags.Size() == 1 && cardDefinition.effectFlags[0] != GwintEffect_None)
			{
				switch (cardDefinition.effectFlags[0])
				{
				case GwintEffect_MeleeScorch:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_melee_scorch_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_melee_scorch");
					break;
				case GwintEffect_11thCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_eleventh_card_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_eleventh_card");
					break;
				case GwintEffect_ClearWeather:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_clear_weather_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_clear_weather");
					break;
				case GwintEffect_PickWeatherCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_weather_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_weather");
					break;
				case GwintEffect_PickRainCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_rain_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_rain");
					break;
				case GwintEffect_PickFogCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_fog_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_fog");
					break;
				case GwintEffect_PickFrostCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_frost_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_pick_frost");
					break;
				case GwintEffect_View3EnemyCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_view_enemy_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_view_enemy");
					break;
				case GwintEffect_ResurectCard:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_resurect_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_resurect");
					break;
				case GwintEffect_ResurectFromEnemy:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_resurect_enemy_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_resurect_enemy");
					break;
				case GwintEffect_Bin2Pick1:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_bin_pick_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_bin_pick");
					break;
				case GwintEffect_MeleeHorn:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_melee_horn_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_melee_horn");
					break;
				case GwintEffect_RangedHorn:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_range_horn_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_range_horn");
					break;
				case GwintEffect_SiegeHorn:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_siege_horn_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_siege_horn");
					break;
				case GwintEffect_SiegeScorch:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_siege_scorch_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_siege_scorch");
					break;
				case GwintEffect_CounterKingAbility:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_ldr_counter_king_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_ldr_counter_king");
					break;
				}
			}
		}
		else if ((cardDefinition.typeFlags & GwintType_Creature) == GwintType_Creature)
		{
			if ((cardDefinition.typeFlags & GwintType_Hero) == GwintType_Hero)
			{
				cardString += "<font color='#7b7877'>" + GetLocStringByKeyExt("gwint_card_tooltip_hero_title") + "</font>";
			}
			else
			{
				cardString += "<font color='#7b7877'>" + GetLocStringByKeyExt("gwint_tooltip_card_type_creature") + "</font>";
			}
			
			cardString += "<br/>" + GetLocStringByKeyExt("gwint_tut_unitcardrange_title") + ": ";
			
			if ((cardDefinition.typeFlags & GwintType_Melee) == GwintType_Melee)
			{
				tempStr = GetLocStringByKeyExt("gwint_tutorial_unit_range_close");
				tempStr = StrReplaceAll(tempStr, "<br>", "");
				cardString += "<font color='#7b7877'>" + tempStr;
				
				if ((cardDefinition.typeFlags & GwintType_Ranged) == GwintType_Ranged) 
				{
					tempStr = GetLocStringByKeyExt("gwint_tutorial_unit_range_long");
					tempStr = StrReplaceAll(tempStr, "<br>", "");
					cardString += ", " + tempStr + "</font>";
				}
				else
				{
					cardString += "</font>";
				}
			}
			else if ((cardDefinition.typeFlags & GwintType_Ranged) == GwintType_Ranged)
			{
				tempStr = GetLocStringByKeyExt("gwint_tutorial_unit_range_long");
				tempStr = StrReplaceAll(tempStr, "<br>", "");
				cardString += "<font color='#7b7877'>" + tempStr + "</font>";
			}
			else if ((cardDefinition.typeFlags & GwintType_Siege) == GwintType_Siege)
			{
				tempStr = GetLocStringByKeyExt("gwint_tutorial_unit_range_siege");
				tempStr = StrReplaceAll(tempStr, "<br>", "");
				cardString += "<font color='#7b7877'>" + tempStr + "</font>";
			}
			
			cardString += "<br/>" + GetLocStringByKeyExt("gwint_tut_unitcardstrength_title") + ": " + "<font color='#7b7877'>" + cardDefinition.power + "</font>";
			
			if (cardDefinition.effectFlags.Size() == 1 && cardDefinition.effectFlags[0] != GwintEffect_None)
			{
				switch (cardDefinition.effectFlags[0])
				{
				case GwintEffect_MeleeScorch:
					
					
					
					break;
				case GwintEffect_SummonClones:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_summon_clones_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_summon_clones");
					break;
				case GwintEffect_Nurse:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_nurse_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_nurse");
					break;
				case GwintEffect_Draw2:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_spy_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_spy");
					break;
				case GwintEffect_SameTypeMorale:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_same_type_morale_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_same_type_morale");
					break;
				case GwintEffect_ImproveNeightbours:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_improve_neightbours_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_improve_neightbours");
					break;
				case GwintEffect_Horn:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_horn_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_horn");
					break;
				}
			}
			else if ((cardDefinition.typeFlags & GwintType_Ranged) == GwintType_Ranged && (cardDefinition.typeFlags & GwintType_Melee) == GwintType_Melee)
			{
				abilityName = GetLocStringByKeyExt("gwint_card_tooltip_agile_title");
				abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_agile");
			}
			else if ((cardDefinition.typeFlags & GwintType_Hero) == GwintType_Hero)
			{
				abilityName = GetLocStringByKeyExt("gwint_card_tooltip_hero_title");
				abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_hero");
			}
		}
		else
		{
			cardString += "<font color='#7b7877'>" + GetLocStringByKeyExt("gwint_tooltip_card_type_special");
			
			if ((cardDefinition.typeFlags & GwintType_Weather) == GwintType_Weather)
			{
				cardString += ", " + GetLocStringByKeyExt("gwint_tooltip_card_type_weather");
			}
			
			cardString += "</font>";
			
			if (cardDefinition.effectFlags.Size() == 1 && cardDefinition.effectFlags[0] != GwintEffect_None)
			{
				switch (cardDefinition.effectFlags[0])
				{
				case GwintEffect_Melee:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_frost_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_frost");
					break;
				case GwintEffect_Ranged:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_fog_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_fog");
					break;
				case GwintEffect_Siege:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_rain_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_rain");
					break;
				case GwintEffect_ClearSky:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_clearsky_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_clearsky");
					break;
				case GwintEffect_UnsummonDummy:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_dummy_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_dummy");
					break;
				case GwintEffect_Horn:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_horn_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_horn");
					break;
				case GwintEffect_Scorch:
					abilityName = GetLocStringByKeyExt("gwint_card_tooltip_scorch_title");
					abilityDescription = GetLocStringByKeyExt("gwint_card_tooltip_scorch");
					break;
				}
			}
		}
		
		if (abilityName != "" && abilityDescription != "")
		{
			cardString += "<br/>" + GetLocStringByKeyExt("gwint_tut_unitcardspecialability_title") + ": " + "<font color='#7b7877'>" + abilityName + "<br/>" + abilityDescription + "</font>";
		}
		
		if (gwintManager.HasCardInCollection(cardIndex))
		{
			cardString += "<br/><font color = '#1E8823'>" + GetLocStringByKeyExt("panel_alchemy_exception_already_cooked") + "</font>";
		}
		
		return cardString;
	}
	
	public function GetSchematicDataFromXML(schematicName:name):SCraftingSchematic
	{
		var curSchematicName  : name;
		var i, j, k, tmpInt	  : int;
		var ing 			  : SItemParts;
		var schem			  : SCraftingSchematic;
		var dm  			  : CDefinitionsManagerAccessor;
		var main, ingredients : SCustomNode;
		
		dm = theGame.GetDefinitionsManager();
		main = dm.GetCustomDefinition('crafting_schematics');
		
		for(i=0; i<main.subNodes.Size(); i+=1)
		{
			dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'name_name', curSchematicName);
			if (curSchematicName == schematicName)
			{
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'craftedItem_name', curSchematicName))
					schem.craftedItemName = curSchematicName;
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'craftsmanType_name', curSchematicName))
					schem.requiredCraftsmanType = ParseCraftsmanTypeStringToEnum(curSchematicName);
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'craftsmanLevel_name', curSchematicName))
					schem.requiredCraftsmanLevel = ParseCraftsmanLevelStringToEnum(curSchematicName);
				if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'price', tmpInt))
					schem.baseCraftingPrice = tmpInt;
				 
				
				ingredients = dm.GetCustomDefinitionSubNode(main.subNodes[i],'ingredients');					
				for(k=0; k<ingredients.subNodes.Size(); k+=1)
				{
					ing.itemName = '';
					ing.quantity = -1;
					
					if(dm.GetCustomNodeAttributeValueName(ingredients.subNodes[k], 'item_name', curSchematicName))						
						ing.itemName = curSchematicName;
					if(dm.GetCustomNodeAttributeValueInt(ingredients.subNodes[k], 'quantity', tmpInt))
						ing.quantity = tmpInt;
						
					schem.ingredients.PushBack(ing);						
				}
				schem.schemName = curSchematicName;
				return schem;
			}
		}
		return schem;
	}
	
	
	
	public function GetRecipeDataFromXML(recipeName:name):SAlchemyRecipe
	{
		var dm : CDefinitionsManagerAccessor;
		var main, ingredients : SCustomNode;
		var tmpBool : bool;
		var tmpName : name;
		var tmpString : string;
		var tmpInt : int;
		var ing : SItemParts;
		var i,k : int;
		var rec : SAlchemyRecipe;
		
		dm = theGame.GetDefinitionsManager();
		main = dm.GetCustomDefinition('alchemy_recipies');
		
		for(i=0; i<main.subNodes.Size(); i+=1)
		{
			dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'name_name', tmpName);
			
			if (tmpName == recipeName)
			{
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'cookedItem_name', tmpName))
					rec.cookedItemName = tmpName;
				if(dm.GetCustomNodeAttributeValueName(main.subNodes[i], 'type_name', tmpName))
					rec.typeName = tmpName;
				if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'level', tmpInt))
					rec.level = tmpInt;	
				if(dm.GetCustomNodeAttributeValueString(main.subNodes[i], 'cookedItemType', tmpString))
					rec.cookedItemType = AlchemyCookedItemTypeStringToEnum(tmpString);
				if(dm.GetCustomNodeAttributeValueInt(main.subNodes[i], 'cookedItemQuantity', tmpInt))
					rec.cookedItemQuantity = tmpInt;
				
				
				ingredients = dm.GetCustomDefinitionSubNode(main.subNodes[i],'ingredients');					
				for(k=0; k<ingredients.subNodes.Size(); k+=1)
				{		
					ing.itemName = '';
					ing.quantity = -1;
				
					if(dm.GetCustomNodeAttributeValueName(ingredients.subNodes[k], 'item_name', tmpName))						
						ing.itemName = tmpName;
					if(dm.GetCustomNodeAttributeValueInt(ingredients.subNodes[k], 'quantity', tmpInt))
						ing.quantity = tmpInt;
						
					rec.requiredIngredients.PushBack(ing);						
				}
				
				rec.recipeName = recipeName;
				
				
				rec.cookedItemIconPath			= dm.GetItemIconPath( rec.cookedItemName );
				rec.recipeIconPath				= dm.GetItemIconPath( rec.recipeName );
				break;
			}
		}
		return rec;
	}
	
	public function GetAerondightTooltipDescription( itemInvComponent : CInventoryComponent, sword : SItemUniqueId ) : string
	{
		var uniqueDesc		: string;
		var argsString		: array<string>;
		var val_1, val_2	: float;
		var min, max		: SAbilityAttributeValue;
		var dm				: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		
		dm.GetAbilityAttributeValue( 'AerondightEffect', 'dmg_bonus', min, max );		
		argsString.PushBack( NoTrailZeros( RoundF( min.valueMultiplicative * 100 ) ) );
		uniqueDesc = GetLocStringByKeyExtWithParams( "attribute_name_aerondight",,, argsString );
		
		argsString.Clear();
		
		
		val_1 = itemInvComponent.GetItemModifierFloat( sword, 'PermDamageBoost' );
		
		
		if( val_1 > 0 )
		{
			argsString.PushBack( "<font color='#ffffff'>" + FloatToString( val_1 ) + "</font>" );
		}
		else
		{
			argsString.PushBack( "<font color='#ffffff'>" + FloatToString( 0 ) + "</font>" );
		}
		
		
		val_2 = thePlayer.GetLevel() - itemInvComponent.GetItemLevel( sword ) + 1;
		
		dm.GetAbilityAttributeValue( 'AerondightEffect', 'stacks_per_level', min, max );		
		val_2 *= min.valueAdditive;
		
		dm.GetAbilityAttributeValue( 'AerondightEffect', 'perm_dmg_boost', min, max );		
		val_2 *= min.valueAdditive;
		
		argsString.PushBack( "<font color='#ffffff'>" + FloatToString( val_2 ) + "</font>" );
		
		
		uniqueDesc += "<br>" + "<br>";
		
		uniqueDesc += GetLocStringByKeyExtWithParams( "attribute_name_aerondight_counter",,,argsString );
		
		return uniqueDesc;
	}
	
}




function CalculateStatsComparance(itemStats : array<SAttributeTooltip>, compareItemStats : array<SAttributeTooltip>, rootGFxObject : CScriptedFlashObject, out compResult : CScriptedFlashArray, optional ignorePrimStat : bool, optional dontCompare : bool, optional extendedData:bool)
{
	var l_flashObject	: CScriptedFlashObject;
	var attributeVal 	: SAbilityAttributeValue;
	
	var strDifference 	: string;
	var strDiffPrefix   : string;
	var strDiffPostfix  : string;
	var strDiffValue	: string;
	var strValue		: string;
	
	var percentDiff 	: float;
	var nDifference 	: float;
	var i, j, price 	: int;
	var statsCount		: int;
	var comparedStats 	: array<SAttributeTooltip>;

	var valuePrefix	  : string;
	var valuePostfix  : string;
	
	var diffValue : string;
	var statToCompareExist : bool;

	statsCount = itemStats.Size();
	for( i = 0; i < statsCount; i += 1 ) 
	{
		if (!(itemStats[i].primaryStat && ignorePrimStat))
		{
			l_flashObject = rootGFxObject.CreateFlashObject();
			l_flashObject.SetMemberFlashString("name",itemStats[i].attributeName);
			l_flashObject.SetMemberFlashString("color",itemStats[i].attributeColor);
			
			strDifference = "better";
			strDiffPrefix = "";
			strDiffPostfix = "";
			strDiffValue = "";
			
			valuePrefix = "";
			valuePostfix = "";
			
			statToCompareExist = false;
			
			
			if (!dontCompare)
			{			
				for( j = 0; j < compareItemStats.Size(); j += 1 )
				{
					
					if( itemStats[i].attributeName == compareItemStats[j].attributeName )
					{
						statToCompareExist = true;
						
						if( itemStats[i].percentageValue )	
						{
							nDifference = RoundMath(itemStats[i].value * 100) - RoundMath(compareItemStats[j].value * 100);
							percentDiff = AbsF( nDifference / RoundMath(itemStats[i].value * 100) );
						}
						else
						{
							nDifference = RoundMath(itemStats[i].value) - RoundMath(compareItemStats[j].value);
							percentDiff = AbsF( nDifference / RoundMath(itemStats[i].value) );
						}
						
						
						if(nDifference > 0)
						{
							strDiffPrefix = "<font color=\"#19D900\"> +";
							strDiffPostfix = "</font>";
							
							strDifference = "better";
							
						}
						
						else if(nDifference < 0)
						{
							strDiffPrefix = "<font color=\"#E00000\"> ";
							strDiffPostfix = "</font>";
							
							strDifference = "worse";
							
						}
						else
						{
							strDifference = "none";
						}
						if (nDifference != 0)
						{
							if( itemStats[i].percentageValue )						
								strDiffValue = strDiffPrefix + RoundMath(nDifference) + " %" + strDiffPostfix;
							else
								strDiffValue = strDiffPrefix + RoundMath(nDifference) + strDiffPostfix;
						}
						
						else
						{
							strDiffPrefix = "";
							strDiffPostfix = "";
							strDiffValue = "";
						}
						compareItemStats.Remove(compareItemStats[j]);
						break;
					}
				}
				
				
				if (strDiffValue == "" && !statToCompareExist)
				{
					strDifference = "better";
					strDiffPrefix = "<font color=\"#19D900\"> +";
					strDiffPostfix = "</font>";
					if( itemStats[i].percentageValue )
					{
						strDiffValue = strDiffPrefix + RoundMath(itemStats[i].value *100) + " %" + strDiffPostfix;
					}
					else
					{
						strDiffValue = strDiffPrefix + RoundMath(itemStats[i].value) + strDiffPostfix;
					}
				}
			}
			else
			{
				strDifference = "none";
			}
			
			l_flashObject.SetMemberFlashString("icon", strDifference);
			l_flashObject.SetMemberFlashBool("primaryStat", itemStats[i].primaryStat);
			
			if (itemStats[i].originName == 'toxicity' || itemStats[i].originName == 'toxicity_offset')
			{
				valuePrefix = "";
				valuePostfix = "";
			}
			else
			if (itemStats[i].originName == 'duration')
			{
				valuePrefix = "";
				valuePostfix = " " + GetLocStringByKeyExt("per_second");
			}
			else
			if (ignorePrimStat) 
			{
				valuePrefix = "+";
				valuePostfix = "";
			}
			else
			{
				valuePrefix = "";
				valuePostfix = "";
			}
			
			if( itemStats[i].percentageValue )
			{
				l_flashObject.SetMemberFlashString("value", valuePrefix + RoundMath( itemStats[i].value * 100 ) + " %" + valuePostfix );
			}
			
			else
			{
				l_flashObject.SetMemberFlashString("value", valuePrefix + RoundMath( itemStats[i].value ) + valuePostfix );
			}
			
			l_flashObject.SetMemberFlashString("diffValue", strDiffValue);
			
			compResult.PushBackFlashObject(l_flashObject);
		}
	}
	
	
	if (!dontCompare)
	{
		if (ignorePrimStat) 
		{
			valuePrefix = "+";
		}
		else
		{
			valuePrefix = "";
		}
		
		for( j = 0; j < compareItemStats.Size(); j += 1 )
		{
			if (!(compareItemStats[j].primaryStat && ignorePrimStat))
			{
				l_flashObject = rootGFxObject.CreateFlashObject();
				l_flashObject.SetMemberFlashString("name",compareItemStats[j].attributeName);
				l_flashObject.SetMemberFlashString("color",compareItemStats[j].attributeColor);
				l_flashObject.SetMemberFlashString("icon", "worse");
				
				if( compareItemStats[j].percentageValue )
				{
					strValue = valuePrefix + "0 %";
					diffValue = "<font color=\"#E00000\"> -" + RoundMath( compareItemStats[j].value * 100 ) + " %</font>";
				}
				else
				{
					strValue = valuePrefix + "0";
					diffValue = "<font color=\"#E00000\"> -" + RoundMath(compareItemStats[j].value) + "</font>";
				}
				
				l_flashObject.SetMemberFlashString("value", strValue);
				l_flashObject.SetMemberFlashString("diffValue", diffValue);
				
				compResult.PushBackFlashObject(l_flashObject);
			}
		}
	}
}


function GetItemAttributeComparison(attrName:string, attrValue:float, equipedItemStats: array<SAttributeTooltip>):string
{
	var i, statsCount : int;
	statsCount = equipedItemStats.Size();
	for( i = 0; i < statsCount; i += 1 ) 
	{
		if (StrLower(attrName) == StrLower(equipedItemStats[i].attributeName))
		{
			return GetStatDiff(attrValue, equipedItemStats[i].value);
		}
	}
	return "better";
}



function GetStatDiff(a : float, b : float):string
{
	var nDifference   : float;
	var percentDiff   : float;
	var strDifference : string;
	
	nDifference = a - b;
	percentDiff = AbsF(nDifference/a);
	
	strDifference = "none";
	
	
	if(nDifference > 0)
	{
		strDifference = "better";
		
		
	}
	
	
	else if(nDifference < 0)
	{
		strDifference = "worse";
		
		
	}
	
	return strDifference;
}