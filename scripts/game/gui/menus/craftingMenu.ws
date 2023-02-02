/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



class CR4CraftingMenu extends CR4ListBaseMenu
{	
	private var m_definitionsManager	: CDefinitionsManagerAccessor;
	private var bCouldCraft				: bool;
	protected var _inv       			: CInventoryComponent;
	private var _playerInv    	   		: W3GuiPlayerInventoryComponent;
	
	private var m_craftingManager		: W3CraftingManager;
	private var m_schematicList			: array< name >;
	private var m_npc		 			: CNewNPC;
	private var m_npcInventory  	    : CInventoryComponent;
	private var m_shopInvComponent 	    : W3GuiShopInventoryComponent;
	private var m_lastSelectedTag		: name;
	
	private var _craftsmanComponent		: W3CraftsmanComponent;	
	private var _quantityPopupData	    : QuantityPopupData;
	
	private var m_fxSetCraftingEnabled	: CScriptedFlashFunction;
	private var m_fxSetCraftedItem 		: CScriptedFlashFunction;
	private var m_fxHideContent	 		: CScriptedFlashFunction;
	private var m_fxSetFilters			: CScriptedFlashFunction;
	private var m_fxSetPinnedRecipe		: CScriptedFlashFunction;
	private var m_fxSetMerchantCheck	: CScriptedFlashFunction;
		
	default bCouldCraft 			= false;
	
	default DATA_BINDING_NAME			= "crafting.list";
	default DATA_BINDING_NAME_SUBLIST	= "crafting.sublist.items";
	default DATA_BINDING_NAME_DESCRIPTION	= "crafting.item.description";
	
	var itemsQuantity 						: array< int >;
	
	event  OnConfigUI()
	{	
		var commonMenu 				: CR4CommonMenu;
		var l_obj		 			: IScriptable;
		
		var l_initData				: W3InventoryInitData;
		var l_craftingFilters		: SCraftingFilters;
		var pinnedTag				: int;
		
		dontAutoCallOnOpeningMenuInOnConfigUIHaxxor = true;
		
		super.OnConfigUI();
		
		m_initialSelectionsToIgnore = 2;
		
		_inv = thePlayer.GetInventory();
		m_definitionsManager = theGame.GetDefinitionsManager();
		
		_playerInv = new W3GuiPlayerInventoryComponent in this;
		_playerInv.Initialize( _inv );
		
		l_obj = GetMenuInitData();
		l_initData = (W3InventoryInitData)l_obj;
		if (l_initData)
		{
			m_npc = (CNewNPC)l_initData.containerNPC;
		}
		else
		{
			m_npc = (CNewNPC)l_obj;
		}
		_craftsmanComponent = (W3CraftsmanComponent)m_npc.GetComponentByClassName('W3CraftsmanComponent');
		
		
		if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())		
		{
			theGame.GetTutorialSystem().uiHandler.OnOpeningMenu(GetMenuName());
		}
		
		m_craftingManager = new W3CraftingManager in this;
		m_craftingManager.Init(_craftsmanComponent);		
		m_schematicList = GetWitcherPlayer().GetCraftingSchematicsNames();
		
		m_fxSetCraftedItem = m_flashModule.GetMemberFlashFunction("setCraftedItem");
		m_fxSetCraftingEnabled = m_flashModule.GetMemberFlashFunction("setCraftingEnabled");
		m_fxHideContent = m_flashModule.GetMemberFlashFunction("hideContent");
		m_fxSetFilters = m_flashModule.GetMemberFlashFunction("SetFiltersValue");
		m_fxSetPinnedRecipe = m_flashModule.GetMemberFlashFunction("setPinnedRecipe");
		m_fxSetMerchantCheck = m_flashModule.GetMemberFlashFunction("setMerchantTypeCheck");
		
		if(_craftsmanComponent)
		{
			m_npcInventory = m_npc.GetInventory();
			bCouldCraft = true;
			UpdateMerchantData(m_npc);
			
			m_shopInvComponent = new W3GuiShopInventoryComponent in this;
			m_shopInvComponent.Initialize( m_npcInventory );
		}
		
		m_fxSetCraftingEnabled.InvokeSelfOneArg(FlashArgBool(bCouldCraft));
		
		l_craftingFilters = GetWitcherPlayer().GetCraftingFilters();
		m_fxSetFilters.InvokeSelfSixArgs(FlashArgString(GetLocStringByKeyExt("gui_panel_filter_has_ingredients")), FlashArgBool(l_craftingFilters.showCraftable), 
										 FlashArgString(GetLocStringByKeyExt("gui_panel_filter_elements_missing")), FlashArgBool(l_craftingFilters.showMissingIngre), 
										 FlashArgString(GetLocStringByKeyExt("panel_crafting_exception_wrong_craftsman_type") + " / " + GetLocStringByKeyExt("panel_crafting_exception_too_low_craftsman_level")), FlashArgBool(l_craftingFilters.showAlreadyCrafted));
		
		pinnedTag = NameToFlashUInt(theGame.GetGuiManager().PinnedCraftingRecipe);
		m_fxSetPinnedRecipe.InvokeSelfOneArg(FlashArgUInt(pinnedTag));
		
		PopulateData();
		
		
		SelectFirstModule();
		
		m_fxSetTooltipState.InvokeSelfTwoArgs( FlashArgBool( thePlayer.upscaledTooltipState ), FlashArgBool( true ) );
	}

	event  OnClosingMenu()
	{
		super.OnClosingMenu();
		theGame.GetGuiManager().SetLastOpenedCommonMenuName( GetMenuName() );
		
		if (_quantityPopupData)
		{
			delete _quantityPopupData;
		}
	}

	event  OnCloseMenu() 
	{
		var commonMenu : CR4CommonMenu;
		
		commonMenu = (CR4CommonMenu)m_parentMenu;
		if(commonMenu)
		{
			commonMenu.ChildRequestCloseMenu();
		}
		
		theSound.SoundEvent( 'gui_global_quit' ); 
		CloseMenu();
	}

	event  OnEntryRead( tag : name )
	{
		
		
		
	}
	
	event  OnStartCrafting()
	{
		OnPlaySoundEvent("gui_crafting_craft_item");
	}
	
	event  OnCraftItem( tag : name )
	{
		GetWitcherPlayer().StartInvUpdateTransaction();
		CreateItem(tag);
		GetWitcherPlayer().FinishInvUpdateTransaction();
	}
	
	event  OnEntryPress( tag : name )
	{
		
	}
	
	event  OnCraftingFiltersChanged( showHasIngre : bool, showMissingIngre : bool, showAlreadyCrafted : bool )
	{
		GetWitcherPlayer().SetCraftingFilters(showHasIngre, showMissingIngre, showAlreadyCrafted);
	}
	
	event  OnEmptyCheckListCloseFailed()
	{
		showNotification(GetLocStringByKeyExt("gui_missing_filter_error"));
		OnPlaySoundEvent("gui_global_denied");
	}
	
	event  OnChangePinnedRecipe( tag : name )
	{
		if (tag != '')
		{
			showNotification(GetLocStringByKeyExt("panel_shop_pinned_recipe_action"));
		}
		theGame.GetGuiManager().SetPinnedCraftingRecipe(tag);
	}

	event   OnEntrySelected( tag : name ) 
	{
		var craftBuy : W3TutorialManagerUIHandlerStateCraftingBuy;
		var i : int;
	
		if (tag != '')
		{
			m_fxHideContent.InvokeSelfOneArg(FlashArgBool(true));
			super.OnEntrySelected(tag);			
		}
		else
		{		
			lastSentTag = '';
			currentTag = '';
			m_fxHideContent.InvokeSelfOneArg(FlashArgBool(false));
		}
		
		
		if( ShouldProcessTutorial( 'TutorialCraftingBuy' ) )
		{
			for( i=0; i<itemsNames.Size(); i+=1 )
			{
				if( m_npcInventory.GetItemQuantityByName( itemsNames[i] ) > 0 )
				{
					craftBuy = (W3TutorialManagerUIHandlerStateCraftingBuy) theGame.GetTutorialSystem().uiHandler.GetCurrentState();
					if( craftBuy )
					{
						craftBuy.OnCanSellSomething();
					}
					break;
				}
			}
		}
	}
	
	event  OnShowCraftedItemTooltip( tag : name )
	{
	}
	
	event  OnBuyIngredient( item : int, isLastItem : bool ) : void
	{
		var vendorItemId   : SItemUniqueId;	
		var vendorItems    : array< SItemUniqueId >;
		
		
		var reqQuantity    : int;
		var itemName       : name;
		var newItemID      : SItemUniqueId;
		
		if( m_npcInventory )
		{
			itemName = itemsNames[ item - 1 ];
			vendorItems = m_npcInventory.GetItemsByName( itemName );
			
			if( vendorItems.Size() > 0 )
			{
				vendorItemId = vendorItems[0];
				
				
				
				
				BuyIngredient( vendorItemId, 1, isLastItem );
				OnPlaySoundEvent( "gui_inventory_buy" );
			}
		}
	}
	
	event OnCategoryOpened( categoryName : name, opened : bool )
	{
		var player : W3PlayerWitcher;

		player = GetWitcherPlayer();
		if ( !player )
		{
			return false;
		}
		if ( opened )
		{
			player.AddExpandedCraftingCategory( categoryName );
		}
		else
		{
			player.RemoveExpandedCraftingCategory( categoryName );
		}

		
		super.OnCategoryOpened( categoryName, opened );
	}
	
	public function BuyIngredient( itemId : SItemUniqueId, quantity : int, isLastItem : bool ) : void
	{
		var newItemID   : SItemUniqueId;
		var result 		: bool;
		var itemName	: name;
		var notifText	: string;
		var itemLocName : string;
		
		itemLocName = GetLocStringByKeyExt( m_npcInventory.GetItemLocalizedNameByUniqueID( itemId ) );
		itemName = m_npcInventory.GetItemName( itemId );
		theTelemetry.LogWithLabelAndValue( TE_INV_ITEM_BOUGHT, itemName, quantity );
		result = m_shopInvComponent.GiveItem( itemId, _playerInv, quantity, newItemID );
		
		if( result )
		{
			notifText = GetLocStringByKeyExt("panel_blacksmith_items_added") + ":" + quantity + " x " + itemLocName;
			
			if (isLastItem)
			{
				PopulateData();
			}
		}
		else
		{
			notifText = GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" );
		}
		
		showNotification( notifText );
		
		UpdateMerchantData(m_npc);
		UpdateItemsCounter();
		
		if (m_lastSelectedTag != '')
		{
			UpdateItems(m_lastSelectedTag);
		}
	}
	
	private function OpenQuantityPopup( itemId : SItemUniqueId, reqValue: int, maxValue : int )
	{
		var invItem : SInventoryItem;
		
		if ( _quantityPopupData )
		{
			delete _quantityPopupData;
		}
		
		_quantityPopupData = new QuantityPopupData in this;
		_quantityPopupData.itemId = itemId;		
		_quantityPopupData.currentValue = reqValue;
		_quantityPopupData.maxValue = maxValue;
		_quantityPopupData.craftingRef = this;
		_quantityPopupData.actionType = QTF_Buy;
		
		RequestSubMenu( 'PopupMenu', _quantityPopupData );
	}
	
	
	public function FillItemInformation(flashObject : CScriptedFlashObject, index:int) : void
	{		
		super.FillItemInformation( flashObject, index );
		
		if( m_npcInventory )
		{
			flashObject.SetMemberFlashInt( "vendorQuantity", m_npcInventory.GetItemQuantityByName( itemsNames[index] ) );
		}
		
		flashObject.SetMemberFlashInt( "reqQuantity", itemsQuantity[index] );
	}
	
	
	protected function GetTooltipData(item : int, compareItemType : int, out resultData : CScriptedFlashObject ) : void
	{
		var vendorItemId   : SItemUniqueId;		
		var vendorItems    : array< SItemUniqueId >;
		var vendorQuantity : int;
		var vendorPrice    : int;
		var itemName       : name;
		var language 	   : string;
		var audioLanguage  : string;
		var locStringBuy   : string;
		var locStringPrice : string;
		theGame.GetGameLanguageName( audioLanguage, language);	
		
		super.GetTooltipData( item, compareItemType, resultData );
		
		if( m_npcInventory )
		{
			itemName = itemsNames[ item - 1 ];
			
			vendorItems = m_npcInventory.GetItemsByName( itemName );
			
			if( vendorItems.Size() > 0 )
			{
				vendorItemId = vendorItems[0];
				vendorQuantity = m_npcInventory.GetItemQuantity( vendorItemId );
				vendorPrice = m_npcInventory.GetItemPriceModified( vendorItemId, false );
				
				resultData.SetMemberFlashNumber( "vendorQuantity", vendorQuantity );
				resultData.SetMemberFlashNumber( "vendorPrice", vendorPrice );
				
				locStringBuy = GetLocStringByKeyExt( "panel_inventory_quantity_popup_buy" );
				
				if( language != "AR")
				{
					resultData.SetMemberFlashString( "vendorInfoText", locStringBuy + " (" +  vendorPrice + ")" );
				}
				else
				{
					locStringPrice = " *" +  vendorPrice + "*" ;
					resultData.SetMemberFlashString( "vendorInfoText", locStringPrice + locStringBuy  );
				}
			}
		}
	}

	function CreateItem( schematic : name  )
	{
		var item : SItemUniqueId;
		var result : ECraftingException;
		var craftedItemNameLoc : string;
		var actualSchematic : SCraftingSchematic;
		
		result = ECE_CookNotAllowed;
		
		if( bCouldCraft )
		{
			result = m_craftingManager.Craft( schematic, item );
			
			if (result == ECE_NoException)
			{
				OnPlaySoundEvent("gui_crafting_craft_item_complete");
				
				PopulateData();
				UpdateItems(schematic);
				m_craftingManager.GetSchematic(schematic, actualSchematic);
				craftedItemNameLoc = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(actualSchematic.craftedItemName));
				showNotification(GetLocStringByKeyExt("panel_crafting_successfully_crafted") + ": " + craftedItemNameLoc);
				if (m_npc)
				{
					UpdateMerchantData(m_npc);
				}
				UpdateItemsCounter();
			}
		}
		
		if (result != ECE_NoException)
		{
			showNotification(GetLocStringByKeyExt(CraftingExceptionToString(result)));
			OnPlaySoundEvent("gui_global_denied");
		}
	}
	
	private function UpdateItemsCounter()
	{		
		var commonMenu 	: CR4CommonMenu;
		
		commonMenu = (CR4CommonMenu)m_parentMenu;
		if( commonMenu )
		{
			commonMenu.UpdateItemsCounter();
			commonMenu.UpdatePlayerOrens();
		}
	}

	private function PopulateData()
	{
		var l_DataFlashArray		: CScriptedFlashArray;
		var l_DataFlashObject 		: CScriptedFlashObject;
		
		var wrongCraftsmanItems		: array<CScriptedFlashObject>;
		var schematic				: SCraftingSchematic;
		var schematicName			: name;		
		var i, length				: int;		
		var l_Title					: string;
		var l_Tag					: name;
		var l_IconPath				: string;
		var l_GroupTitle			: string;
		var l_GroupTag				: name;
		var l_IsNew					: bool;
		var canCraftResult			: ECraftingException;
		
		
		var cookableType			: name;
		var cookable				: SCraftable;
		var cookables				: array<SCraftable>;
		var exists					: bool;
		var j, cookableCount		: int;
		var minQuality, maxQuality  : int;
		var itemLevel				: int;
		var itemLevelString			: string;
		var lvlDiff 				: int;
		var reqLevelColor			:string;
		var playerLevel 			: int;
		
		var expandedCraftingCategories : array< name >;
		
		expandedCraftingCategories = GetWitcherPlayer().GetExpandedCraftingCategories();
		
		l_DataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		length = m_schematicList.Size();
		
		
		for(i=0; i<length; i+=1)
		{
			if(m_craftingManager.CanCraftSchematic(m_schematicList[i], bCouldCraft) == ECE_NoException && m_craftingManager.GetSchematic(m_schematicList[i],schematic))
			{
				exists = false;
				cookableType = m_definitionsManager.GetItemCategory( schematic.craftedItemName );
				
				for(j=0; j<cookables.Size(); j+=1)
				{
					if(cookables[j].type == cookableType)
					{
						cookables[j].cnt += 1;
						exists = true;
						break;
					}					
				}
				
				if(!exists)
				{
					cookable.type = cookableType;
					cookable.cnt = 1;
					cookables.PushBack(cookable);
				}				
			}
		}
		
		
		for( i = 0; i < length; i+= 1 )
		{	
			schematicName = m_schematicList[ i ];
			
			if(	m_craftingManager.GetSchematic(schematicName,schematic) )
			{
				l_GroupTag = m_definitionsManager.GetItemCategory( schematic.craftedItemName );
				l_GroupTitle = GetLocStringByKeyExt(  "item_category_" + l_GroupTag  );
			
				l_Title = GetLocStringByKeyExt( m_definitionsManager.GetItemLocalisationKeyName( schematic.craftedItemName ) ) ;	
				l_IconPath = m_definitionsManager.GetItemIconPath(schematic.craftedItemName);
				l_IsNew	= false;
				l_Tag = schematic.schemName;
			
				
				cookableCount = 0;
				for(j=0; j<cookables.Size(); j+=1)
				{
					if(cookables[j].type == l_GroupTag)
					{
						cookableCount = cookables[j].cnt;
						break;
					}
				}
				
				
				
				l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
				
				if(cookableCount > 0)
				{
					l_DataFlashObject.SetMemberFlashString(  "categoryPostfix", " | " + cookableCount + " |" );
				}
				else
				{
					l_DataFlashObject.SetMemberFlashString(  "categoryPostfix", "" );
				}
				
				thePlayer.inv.GetItemQualityFromName( schematic.craftedItemName, minQuality, maxQuality );
				
				if( m_definitionsManager.IsItemAnyArmor( schematic.craftedItemName ) || m_definitionsManager.IsItemWeapon( schematic.craftedItemName ) )
				{
					itemLevel = m_definitionsManager.GetItemLevelFromName( schematic.craftedItemName );
					
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
					
					playerLevel = thePlayer.GetLevel();
					lvlDiff = itemLevel - thePlayer.GetLevel();
					if 		( lvlDiff > 0 ) { reqLevelColor = "<font color='#d61010'>";  }
					else if ( lvlDiff >= -5 )  { reqLevelColor = "<font color='#ffffff'>";  }
					else	{ reqLevelColor = "<font color='#969696'>"; }	
					
					itemLevelString = reqLevelColor + itemLevel + "</font>";
				}
				else
				{
					itemLevelString = "";
				}

				l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt(l_Tag) );
				l_DataFlashObject.SetMemberFlashString(  "dropDownLabel", l_GroupTitle );
				l_DataFlashObject.SetMemberFlashUInt(  "dropDownTag",  NameToFlashUInt(l_GroupTag) );
				l_DataFlashObject.SetMemberFlashBool(  "dropDownOpened",  expandedCraftingCategories.Contains( l_GroupTag ) );
				l_DataFlashObject.SetMemberFlashString(  "dropDownIcon", "icons/monsters/ICO_MonsterDefault.png" );
				
				l_DataFlashObject.SetMemberFlashBool( "isNew", l_IsNew );
				
				if ( m_guiManager.GetShowItemNames() )
				{
					l_Title = l_Title + "<br><font color=\"#FFDB00\">'" + schematic.schemName + "'</font>";
				}
				l_DataFlashObject.SetMemberFlashString(  "label", l_Title );
				l_DataFlashObject.SetMemberFlashString(  "iconPath", l_IconPath );
				l_DataFlashObject.SetMemberFlashInt( "rarity", minQuality );
				l_DataFlashObject.SetMemberFlashString(  "itemLevel", itemLevelString );
				canCraftResult = m_craftingManager.CanCraftSchematic(schematicName, bCouldCraft);
				
				if (canCraftResult != ECE_NoException)
				{
					l_DataFlashObject.SetMemberFlashString( "cantCookReason", GetLocStringByKeyExt(CraftingExceptionToString(canCraftResult)) );
				}
				else
				{
					l_DataFlashObject.SetMemberFlashString( "cantCookReason", "" );
				}
				
				l_DataFlashObject.SetMemberFlashBool( "isSchematic", true );
				l_DataFlashObject.SetMemberFlashInt( "canCookStatus", canCraftResult);
				
				
				
				
				
					l_DataFlashArray.PushBackFlashObject(l_DataFlashObject); 
			}
		}
		
		
		
		
		
		
		
		if( l_DataFlashArray.GetLength() > 0 )
		{
			m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME, l_DataFlashArray );
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(true));
		}
		else
		{
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(false));
		}
	}
	
	function UpdateMerchantData( targetNpc : CNewNPC ) : void
	{
		var l_merchantData	: CScriptedFlashObject;
		
		l_merchantData = m_flashValueStorage.CreateTempFlashObject();
		GetNpcInfo((CGameplayEntity)targetNpc, l_merchantData);
		m_flashValueStorage.SetFlashObject("crafting.merchant.info", l_merchantData);
	}

	function  UpdateDescription( tag : name )
	{
		var description : string;
		var title : string;
		
		var schematic : SCraftingSchematic;
		
		
		
		m_lastSelectedTag = tag;
		m_craftingManager.GetSchematic(tag,schematic);
		
		title = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(schematic.craftedItemName));	
		description = m_definitionsManager.GetItemLocalisationKeyDesc(schematic.craftedItemName);	
		if(description == "" || description == "<br>" || description == "#")
		{
			description = "panel_journal_quest_empty_description";
		}
		description = GetLocStringByKeyExt(description) + "BBBBBBB";	
		
		m_flashValueStorage.SetFlashString(DATA_BINDING_NAME_DESCRIPTION+".title",title);
		m_flashValueStorage.SetFlashString(DATA_BINDING_NAME_DESCRIPTION+".text",description);	
	}	
	
	function  UpdateItems( tag : name )
	{
		var itemsFlashArray			: CScriptedFlashArray;
		var i : int;
		var schematic : SCraftingSchematic;
		m_craftingManager.GetSchematic(tag,schematic);
		
		itemsNames.Clear();
		itemsQuantity.Clear();
		
		for( i = 0; i < schematic.ingredients.Size(); i += 1 )
		{
			itemsNames.PushBack(schematic.ingredients[i].itemName); 
			itemsQuantity.PushBack(schematic.ingredients[i].quantity); 
		}
		
		itemsFlashArray = CreateItems(itemsNames);
		
		if( itemsFlashArray )
		{
			m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME_SUBLIST, itemsFlashArray );
		}
		
		ShowSelectedItemInfo(tag);
	}
	
	protected function ShowSelectedItemInfo( tag : name ):void
	{
		var schematic 			: SCraftingSchematic;
		var l_DataFlashObject	: CScriptedFlashObject;
		var itemNameLoc			: string;
		var imgPath				: string;
		var canCraft			: bool;
		var itemType 			: EInventoryFilterType;
		var gridSize			: int;
		var itemName			: name;
		var itemCost			: int;
		var priceStr			: string;
		var crafterDesc			: string;
		var levelColor			: string;
		var crafterRequirements : string;
		var rarity				: int;
		var enhancementSlots	: int;
		var canCraftResult		: ECraftingException;
		var wrongCraftsmanLevel : bool;
		var wrongCraftsmanType  : bool;
		
		m_craftingManager.GetSchematic(tag, schematic);
		itemName = schematic.craftedItemName;
		
		CraftsmanTypeToLocalizationKey(schematic.requiredCraftsmanType);
		CraftsmanLevelToLocalizationKey(schematic.requiredCraftsmanLevel);
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		_playerInv.GetCraftedItemInfo(itemName, l_DataFlashObject);
		
		canCraftResult = m_craftingManager.CanCraftSchematic(tag, bCouldCraft);
		canCraft = canCraftResult == ECE_NoException;
		
		crafterRequirements = GetLocStringByKeyExt( CraftsmanTypeToLocalizationKey( schematic.requiredCraftsmanType ) );
		
		wrongCraftsmanLevel = false;
		wrongCraftsmanType = false;
		if (bCouldCraft)
		{
			if(canCraftResult == ECE_TooLowCraftsmanLevel)
			{
				levelColor = "<font color='#E34040'>";
				wrongCraftsmanLevel = true;
			}
			else
			{
				levelColor = "<font color='#949494'>";
			}
			if (canCraftResult == ECE_WrongCraftsmanType)
			{
				wrongCraftsmanType = true;
			}
			crafterRequirements += (" / " + levelColor + GetLocStringByKeyExt( CraftsmanLevelToLocalizationKey( schematic.requiredCraftsmanLevel ) ) + "</font>" );
		}
		else
		{
			crafterRequirements += (" / " + GetLocStringByKeyExt( CraftsmanLevelToLocalizationKey( schematic.requiredCraftsmanLevel ) ) );
		}
		
		m_fxSetMerchantCheck.InvokeSelfTwoArgs(FlashArgBool(wrongCraftsmanLevel), FlashArgBool(wrongCraftsmanType));
		
		crafterDesc = l_DataFlashObject.GetMemberFlashString("itemDescription");
		l_DataFlashObject.SetMemberFlashString("crafterRequirements", crafterRequirements);
		l_DataFlashObject.SetMemberFlashString("itemDescription", crafterDesc);
		
		rarity = l_DataFlashObject.GetMemberFlashInt("rarityId");
		enhancementSlots = l_DataFlashObject.GetMemberFlashInt("enhancementSlots");
		
		m_flashValueStorage.SetFlashObject("blacksmithing.menu.crafted.item.tooltip", l_DataFlashObject);
		
		itemNameLoc = GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(itemName));
		imgPath = m_definitionsManager.GetItemIconPath(itemName);
		itemType = m_definitionsManager.GetFilterTypeByItem(itemName);
		
		if (itemType == IFT_Weapons || itemType == IFT_Armors)
		{
			gridSize = 2;
		}
		else
		{
			gridSize = 1;
		}
		
		if (bCouldCraft)
		{
			itemCost = m_craftingManager.GetCraftingCost(tag);
			
			if (thePlayer.GetMoney() < itemCost)
			{
				priceStr += "<font color=\"#d31717\">" + itemCost + "</font>";
			}
			else
			{
				priceStr += "<font color=\"#ffffff\">" + itemCost + "</font>";
			}
		}
		else
		{
			priceStr = "";
		}
		
		m_fxSetCraftedItem.InvokeSelfEightArgs(FlashArgUInt(NameToFlashUInt(schematic.schemName)), FlashArgString(itemNameLoc), FlashArgString(imgPath), FlashArgBool(canCraft), FlashArgInt(gridSize), FlashArgString(priceStr), FlashArgInt(rarity), FlashArgInt(enhancementSlots));
	}	
	
	public final function GetCraftsmanComponent() : W3CraftsmanComponent
	{
		return _craftsmanComponent;
	}
	
	event  OnSetMouseInventoryComponent(moduleBinding : string, slotId:int)
	{
	}
	
	function PlayOpenSoundEvent()
	{
		
		
	}
}
