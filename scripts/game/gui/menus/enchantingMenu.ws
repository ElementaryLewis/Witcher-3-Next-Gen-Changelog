/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CR4EnchantingMenu extends CR4MenuBase
{
	private var m_fxEnableRemovingEnchantment : CScriptedFlashFunction;
	private var m_fxEnableEnchantment 		  : CScriptedFlashFunction;
	private var m_fxSetFilters				  : CScriptedFlashFunction;
	private var m_fxSetLocalization			  : CScriptedFlashFunction;
	private var m_fxStartApplying			  : CScriptedFlashFunction;
	private var m_fxStartRemoving			  : CScriptedFlashFunction;
	private var m_fxSelectFirstEnchantment	  : CScriptedFlashFunction;
	private var m_fxSetPinnedRecipe			  : CScriptedFlashFunction;
	
	private var m_definitionsManager	      : CDefinitionsManagerAccessor;
	
	private var m_tooltipDataProvider	: W3TooltipComponent;
	private var m_playerInvComponent	: W3GuiEnchantingInventoryComponent;
	private var m_playerInventory		: CInventoryComponent;
	private var m_enchanterInventory 	: CInventoryComponent;
	private var m_enchanterNpc	     	: CNewNPC;
	private var m_craftsmanComponent	: W3CraftsmanComponent;
	private var m_enchantmentManager 	: W3EnchantmentManager;
	
	private var m_runewordsList  : array <CName>;
	private var m_glyphwordsList : array <CName>;
	private var m_allWordsList   : array <CName>;
	
	private var m_runewordsData  : CScriptedFlashArray;	
	private var m_glyphwordsData : CScriptedFlashArray;
	private var m_allwordsData   : CScriptedFlashArray;
	
	private var m_initDataConfirmation 	: EnchantingConfirmationPopupData;
	
	private var m_selectedEnchantment:name;
	private var m_readonly:bool;
	private var m_notEnoughSlots:bool;
	private var m_prevItem:SItemUniqueId;
	
	private const var TYPE_RUNEWORD:int;
			  default TYPE_RUNEWORD = 0;
	private const var TYPE_GLYPHWORD:int;
			  default TYPE_RUNEWORD = 1;
	
	private var tutorialTriggered:bool;
	
	event  OnConfigUI()
	{
		var initData		   : IScriptable;
		var inventoryInitData  : W3InventoryInitData;
		var enchanterEntity	   : CGameplayEntity;
		var currentFilters	   : SEnchantmentFilters;
		var pinnedTag		   : int;
		
		super.OnConfigUI();
		
		m_notEnoughSlots = false;
		m_readonly = false;
		initData = GetMenuInitData();
		inventoryInitData = (W3InventoryInitData)initData;
		
		m_playerInventory = thePlayer.GetInventory();
		m_playerInvComponent = new W3GuiEnchantingInventoryComponent in this;
		m_playerInvComponent.Initialize( m_playerInventory );
		
		m_tooltipDataProvider = new W3TooltipComponent in this;
		m_tooltipDataProvider.initialize(m_playerInventory, m_flashValueStorage);
		m_tooltipDataProvider.setCurrentInventory(m_playerInventory);
		
		m_definitionsManager = theGame.GetDefinitionsManager();
		m_fxEnableRemovingEnchantment = m_flashModule.GetMemberFlashFunction("enableRemovingEnchantment");
		m_fxEnableEnchantment = m_flashModule.GetMemberFlashFunction("enableEnchantment");
		m_fxSetFilters = m_flashModule.GetMemberFlashFunction("setFiltersData");
		m_fxSetLocalization = m_flashModule.GetMemberFlashFunction("setLocalization");
		
		m_fxStartApplying = m_flashModule.GetMemberFlashFunction("startEnchanting");
		m_fxStartRemoving = m_flashModule.GetMemberFlashFunction("startRemovingEnchantments");
		
		m_fxSelectFirstEnchantment = m_flashModule.GetMemberFlashFunction("selectFirstEnchantment");
		m_fxSetPinnedRecipe = m_flashModule.GetMemberFlashFunction("setPinnedRecipe");
		
		if (inventoryInitData)
		{
			enchanterEntity = inventoryInitData.containerNPC;
		}
		else
		{
			enchanterEntity = (CGameplayEntity)initData;
		}
		
		if (!enchanterEntity)
		{
			CloseMenu();
		}
		
		m_enchanterNpc = (CNewNPC)enchanterEntity;
		m_enchanterInventory = enchanterEntity.GetInventory();
		m_craftsmanComponent = (W3CraftsmanComponent)m_enchanterNpc.GetComponentByClassName( 'W3CraftsmanComponent' );		
		m_tooltipDataProvider.setCrafter(m_craftsmanComponent);
		
		m_enchantmentManager = new W3EnchantmentManager in this;
		m_enchantmentManager.Init(m_craftsmanComponent);
		
		
		
		m_runewordsList = m_craftsmanComponent.GetEnchanterItems(true, false);
		m_glyphwordsList = m_craftsmanComponent.GetEnchanterItems(false, true);
		m_allWordsList = m_craftsmanComponent.GetEnchanterItems(true, true);
		
		populateData();
		
		currentFilters = theGame.GetGuiManager().GetEnchantmentFilters();
		
		m_fxSetLocalization.InvokeSelfFiveArgs( FlashArgString(GetLocStringByKeyExt("gui_panel_filter_has_ingredients")),
										FlashArgString(GetLocStringByKeyExt("gui_panel_filter_elements_missing")),
										FlashArgString(GetLocStringByKeyExt("panel_enchanting_filter_level_1_enchant")),
										FlashArgString(GetLocStringByKeyExt("panel_enchanting_filter_level_2_enchant")),
										FlashArgString(GetLocStringByKeyExt("panel_enchanting_filter_level_3_enchant")) );
											    
		m_fxSetFilters.InvokeSelfFiveArgs( FlashArgBool(currentFilters.showHasIngredients), 
										   FlashArgBool(currentFilters.showMissingIngredients), 
										   FlashArgBool(currentFilters.showLevel1), 
										   FlashArgBool(currentFilters.showLevel2), 
										   FlashArgBool(currentFilters.showLevel3) );
		
		pinnedTag = NameToFlashUInt(theGame.GetGuiManager().PinnedCraftingRecipe);
		m_fxSetPinnedRecipe.InvokeSelfOneArg(FlashArgUInt(pinnedTag));
		
		populateItemList();
		UpdateMerchantData();
	}
	
	event  OnChangePinnedRecipe( tag : name )
	{
		if (tag != '')
		{
			showNotification(GetLocStringByKeyExt("panel_shop_pinned_recipe_action"));
		}
		theGame.GetGuiManager().SetPinnedCraftingRecipe(tag);
	}
	
	private function UpdateMerchantData() : void
	{
		var l_merchantData			: CScriptedFlashObject;
		l_merchantData = m_flashValueStorage.CreateTempFlashObject();
		GetNpcInfo((CGameplayEntity)m_enchanterNpc, l_merchantData);
		m_flashValueStorage.SetFlashObject("blacksmith.merchant.info", l_merchantData);
	}
	
	private function populateData():void
	{
		m_runewordsData = m_flashValueStorage.CreateTempFlashArray();
		m_glyphwordsData = m_flashValueStorage.CreateTempFlashArray();
		m_allwordsData = m_flashValueStorage.CreateTempFlashArray();
		
		getEnchantmentsListData(m_runewordsList, TYPE_RUNEWORD, m_runewordsData);
		getEnchantmentsListData(m_glyphwordsList, TYPE_GLYPHWORD, m_glyphwordsData);
		
		appendArray(m_allwordsData, m_runewordsData);
		appendArray(m_allwordsData, m_glyphwordsData);
	}
	
	private function appendArray(target:CScriptedFlashArray, source:CScriptedFlashArray):void
	{
		var len, i:int;
		
		len = source.GetLength();
		for (i = 0; i < len; i = i+1)
		{
			target.PushBackFlashObject( source.GetElementFlashObject(i) );
		}
	}
	
	private function getEnchantmentsListData(nameList : array<CName>, type:int, out enchantmentsList:CScriptedFlashArray):void
	{
		var i, j : int;
		var itemsCount : int;
		var ingredientsCount : int;		
		
		var schematic          		: SEnchantmentSchematic;
		var curSchematicName   		: CName;
		var curIngredientName  	    : CName;
		var schematicLocName   		: string;
		var schematicLocDescription : string;
		var ingredientLocName  		: string;
		var canApply 		   	    : bool;
		
		var ingredientsList  : CScriptedFlashArray;
		var enchantmentData  : CScriptedFlashObject;
		var ingredientData   : CScriptedFlashObject;
		
		var availableIngredientsCount : int;
		var requiredIngredientsCount  : int;
		
		var enchantmentParamsInt:array<int>;
		var enchantmentParamsFloat:array<float>;
		var enchantmentParamsStr:array<string>;
		
		var minQuality	: int;
		var maxQuality	: int;
		
		var levelName : string;
		
		var playerMoney:int;
		
		playerMoney = m_playerInventory.GetMoney();
		
		itemsCount = nameList.Size();
		
		for (i = 0; i < itemsCount; i=i+1)
		{
			enchantmentData = m_flashValueStorage.CreateTempFlashObject();
			
			curSchematicName = nameList[i];
			m_enchantmentManager.GetSchematic(curSchematicName, schematic);
			ingredientsCount = schematic.ingredients.Size();
			
			canApply = true;
			
			if (ingredientsCount > 0)
			{
				ingredientsList = m_flashValueStorage.CreateTempFlashArray();
				
				for (j = 0; j < ingredientsCount; j = j +1)
				{
					ingredientData = m_flashValueStorage.CreateTempFlashObject();
					curIngredientName  = schematic.ingredients[j].itemName;
					requiredIngredientsCount = schematic.ingredients[j].quantity;
					availableIngredientsCount = m_playerInventory.GetItemQuantityByName(curIngredientName);
					m_playerInventory.GetItemQualityFromName(curIngredientName, minQuality, maxQuality);
					ingredientLocName = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(curIngredientName));
					
					ingredientData.SetMemberFlashUInt("name", NameToFlashUInt(curIngredientName));
					ingredientData.SetMemberFlashString("txtName", ingredientLocName);
					ingredientData.SetMemberFlashString("imgLoc", m_definitionsManager.GetItemIconPath(curIngredientName));
					ingredientData.SetMemberFlashNumber("reqQuantity", requiredIngredientsCount);
					ingredientData.SetMemberFlashNumber("quantity", availableIngredientsCount);
					ingredientData.SetMemberFlashInt("gridSize", 1);
					ingredientData.SetMemberFlashInt("quality", minQuality);
					
					if (requiredIngredientsCount > availableIngredientsCount)
					{
						canApply = false;
					}
					
					ingredientsList.PushBackFlashObject(ingredientData);
				}
				
				enchantmentData.SetMemberFlashArray("ingredientsList", ingredientsList);
			}
			
			m_playerInventory.GetParamsForRunewordTooltip(schematic.schemName, enchantmentParamsInt, enchantmentParamsFloat, enchantmentParamsStr);
			schematicLocDescription = GetLocStringByKeyExtWithParams(schematic.localizedDescriptionName, enchantmentParamsInt, enchantmentParamsFloat, enchantmentParamsStr);
			
			schematicLocName = GetLocStringByKeyExt(schematic.localizedName);
			
			enchantmentData.SetMemberFlashUInt("name", NameToFlashUInt(schematic.schemName));
			enchantmentData.SetMemberFlashBool("canApply", canApply);		
			
			enchantmentData.SetMemberFlashBool("notEnoughSlots", m_notEnoughSlots);
			enchantmentData.SetMemberFlashString("localizedName", schematicLocName);
			enchantmentData.SetMemberFlashString("description", schematicLocDescription);
			enchantmentData.SetMemberFlashInt("price", schematic.baseCraftingPrice);
			enchantmentData.SetMemberFlashInt("level", schematic.level);
			enchantmentData.SetMemberFlashInt("type", type);
			
			switch (schematic.level)
			{
				case 1:
					levelName = GetLocStringByKeyExt("panel_enchanting_filter_level_1_enchant");
					break;
				case 2:
					levelName = GetLocStringByKeyExt("panel_enchanting_filter_level_2_enchant");
					break;
				case 3:
					levelName = GetLocStringByKeyExt("panel_enchanting_filter_level_3_enchant");
					break;
				default:
					levelName = GetLocStringByKeyExt("panel_enchanting_filter_level_1_enchant"); 
					break;
			}
			
			enchantmentData.SetMemberFlashString("levelName", levelName);
			enchantmentsList.PushBackFlashObject(enchantmentData);
		}
	}
	
	private function getEnchantmentData(enchantmentName : name, targetList : CScriptedFlashArray) : CScriptedFlashObject
	{
		var i, j 			: int;
		var itemsCount 		: int;
		var enchantmentData : CScriptedFlashObject;
		
		itemsCount = targetList.GetLength();
		for (i = 0; i < itemsCount; i = i + 1)
		{
			enchantmentData = targetList.GetElementFlashObject(i);
			if (enchantmentData.GetMemberFlashUInt("name") == NameToFlashUInt(enchantmentName))
			{
				return enchantmentData;
			}
		}
		
		return NULL;
	}
	
	
	public function EnchantingConfirmed(removeEnchantment:bool):void
	{
		if (removeEnchantment)
		{
			m_fxStartRemoving.InvokeSelf();
		}
		else
		{
			m_fxStartApplying.InvokeSelf();
		}
	}
	
	event  OnConfrimAction(itemId : SItemUniqueId, price : float, removing:bool):void
	{
		var confirmationText  : string = "";
		var confirmationTitle : string = "";
		
		if (removing)
		{
			confirmationTitle = "input_remove_enchant";
			confirmationText = "panel_enchanting_popup_message_warning_has_enchant";			
		}
		else
		if (m_playerInventory.GetEnchantment(itemId) != '')
		{
			confirmationTitle = "input_enchant_item";
			confirmationText = "panel_enchanting_popup_message_warning_has_enchant";
		}
		else
		if (m_playerInventory.GetItemEnhancementCount(itemId) > 0)
		{
			confirmationTitle = "input_enchant_item";
			confirmationText = "panel_enchanting_popup_message_warning_has_upgrades";
		}
		
		if (confirmationText != "")
		{
			m_initDataConfirmation = new EnchantingConfirmationPopupData in this;
			m_initDataConfirmation.menuRef = this;
			m_initDataConfirmation.BlurBackground = true;
			m_initDataConfirmation.removingEnchantment = removing;
			
			m_initDataConfirmation.SetMessageTitle( GetLocStringByKeyExt( confirmationTitle ) );
			m_initDataConfirmation.SetMessageText( GetLocStringByKeyExt( confirmationText ) );
			m_initDataConfirmation.SetPrice( price );
			
			RequestSubMenu( 'PopupMenu', m_initDataConfirmation );
		}
		else
		{
			
			m_fxStartApplying.InvokeSelf();
		}
	}
	
	event  OnNotEnoughSockets()
	{
		showNotification( GetLocStringByKeyExt( "panel_enchanting_warning_not_enough_sockets" ) );
		OnPlaySoundEvent( "gui_global_denied" );
	}
	
	event  OnNotEnoughMoney()
	{
		showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
		OnPlaySoundEvent( "gui_global_denied" );
	}
	
	event  OnUnexpectedError()
	{
		OnPlaySoundEvent("gui_global_denied");
	}
	
	event  OnPlayEnchantSound( removeSound : bool )
	{
		if(removeSound)
		{
			OnPlaySoundEvent("gui_enchanting_runeword_remove");
		}
		else
		{
			OnPlaySoundEvent("gui_enchanting_runeword_add");
		}
	}
	

	
	event  OnEnchantItem(itemId : SItemUniqueId, enchantmentName : name)
	{
		var curIngredient       : SItemParts;
		var enchantSchematic	: SEnchantmentSchematic;
		var enchantResult   	: bool;
		var schematicFound		: bool;
		
		var i, price : int;
		var playerMoney : int;
		var ingredientsCount : int;
		
		schematicFound = m_enchantmentManager.GetSchematic( enchantmentName, enchantSchematic );
		
		if (!schematicFound)
		{
			
			OnPlaySoundEvent("gui_global_denied");
			
			return false;
		}
		
		
		price = 0; 
		playerMoney = m_playerInventory.GetMoney();
		
		if (playerMoney < price)
		{
			showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
			
			
			return false;
		}
		
		m_playerInventory.UnenchantItem(itemId);
		enchantResult = m_playerInventory.EnchantItem( itemId, enchantmentName, getEnchamtmentStatName(enchantmentName) );
		
		if (enchantResult)
		{
			ingredientsCount = enchantSchematic.ingredients.Size();
  			
			for (i = 0; i < ingredientsCount; i=i+1 )
			{
				curIngredient = enchantSchematic.ingredients[i];
				m_playerInventory.RemoveItemByName(curIngredient.itemName, curIngredient.quantity);
			}
			
			
			
			
			
			UpdateItemsCounter();
			
			populateData();
			
			populateItemList();
			populateEnchantmentsList(itemId);
			populateIngredientsList(getEnchantmentData(enchantmentName, m_allwordsData));
			
			theGame.GetGuiManager().ShowNotification( GetLocStringByKeyExt("panel_enchanting_notification_enchant_done") + ": " + GetLocStringByKeyExt(enchantSchematic.localizedName) );
			
			
			UpdateMerchantData();
			
			m_playerInventory.NotifyEnhancedItem(itemId);
		}
		else
		{
			OnPlaySoundEvent("gui_global_denied");
		}
	}
	
	event  OnRemoveEnchantment(itemId : SItemUniqueId):void
	{
		var unenchantResult : bool;
		
		unenchantResult = m_playerInventory.UnenchantItem(itemId);
		if (unenchantResult)
		{
			theGame.GetGuiManager().ShowNotification(GetLocStringByKeyExt("panel_enchanting_notification_enchant_removed"));
			
			UpdateMerchantData();
			UpdateItemsCounter();
			populateItemList();
			populateEnchantmentsList(itemId);
			
			m_playerInventory.NotifyEnhancedItem(itemId);
			
			
		}
		else
		{
			OnPlaySoundEvent("gui_global_denied");
		}
	}
	
	event  OnShowAllEnchantments():void
	{
		m_prevItem = GetInvalidUniqueId();
		
		m_readonly = true;
		m_notEnoughSlots = false;
		m_flashValueStorage.SetFlashArray("populate.enchantments", m_allwordsData);
		
		m_fxEnableRemovingEnchantment.InvokeSelfThreeArgs( FlashArgBool(false), FlashArgNumber(0), FlashArgBool(false) );
		
		if(ShouldProcessTutorial('TutorialRunewords2') && !tutorialTriggered)
		{
			tutorialTriggered = true;
			m_fxSelectFirstEnchantment.InvokeSelf( );
		}
	}
	
	event  OnSelectItem(itemId : SItemUniqueId):void
	{
		var hasEnchantment:bool;
		var removeEnchantmentPrice:float;
		var invItem : SInventoryItem;
		var playerMoney:int;
		
		playerMoney = m_playerInventory.GetMoney();
		invItem = m_playerInventory.GetItem( itemId );
		
		m_notEnoughSlots = !m_playerInvComponent.CheckSlotsCount( itemId );
		m_readonly = false;
		
		m_selectedEnchantment = '';
		
		if (m_prevItem != itemId)
		{
			populateEnchantmentsList(itemId);
			m_prevItem = itemId;
		}
		
		hasEnchantment = m_playerInventory.IsItemEnchanted(itemId);
		removeEnchantmentPrice = 0; 
		
		m_fxEnableRemovingEnchantment.InvokeSelfThreeArgs(FlashArgBool(hasEnchantment), FlashArgNumber(removeEnchantmentPrice), FlashArgBool(removeEnchantmentPrice > playerMoney));
	}
	
	event  OnSelectEnchantment(EnchantmentName : name):void
	{
		var canApply:bool;
		var enchantmentPrice:int;
		var enchantmentData:CScriptedFlashObject;
		var playerMoney:int;
		
		if (m_selectedEnchantment != EnchantmentName)
		{
			m_selectedEnchantment = EnchantmentName;
			
			enchantmentData = getEnchantmentData(EnchantmentName, m_allwordsData);
			
			populateIngredientsList(enchantmentData);
			
			canApply = enchantmentData.GetMemberFlashBool("canApply");
			enchantmentPrice = 0; 
			
			playerMoney = m_playerInventory.GetMoney();
			
			if (m_readonly || m_notEnoughSlots || m_playerInventory.GetEnchantment(m_prevItem) == m_selectedEnchantment)
			{
				m_fxEnableEnchantment.InvokeSelfThreeArgs(FlashArgBool(false), FlashArgNumber(0), FlashArgBool(false));
			}
			else
			{
				m_fxEnableEnchantment.InvokeSelfThreeArgs(FlashArgBool(canApply), FlashArgNumber(enchantmentPrice), FlashArgBool(playerMoney < enchantmentPrice));
			}
		}
	}
	
	event  OnGetItemData(item : SItemUniqueId, compareItemType : int) : void
	{
		ShowItemTooltip(item);
	}
	
	event  OnFiltersChanged(showHasIngredients:bool, showMissingIngredients:bool, showLevel1:bool, showLevel2:bool, showLevel3:bool):void
	{
		theGame.GetGuiManager().SetEnchantmentFilters(showHasIngredients, showMissingIngredients, showLevel1, showLevel2, showLevel3);
	}
	
	event  OnCloseMenu()
	{
		CloseMenu();
		
		if( m_parentMenu )
		{
			m_parentMenu.ChildRequestCloseMenu();
		}
	}
	event  OnEmptyCheckListCloseFailed()
	{
		showNotification(GetLocStringByKeyExt("gui_missing_filter_error"));
		OnPlaySoundEvent("gui_global_denied");
	}
	
	event  OnEntryRead() {	 }
	event  OnEntrySelected( tag : name ) {	 }
	
	
	event  OnClosingMenu()
	{
		theGame.GetGuiManager().SetLastOpenedCommonMenuName( GetMenuName() );
		
		if (m_initDataConfirmation)
		{
			delete m_initDataConfirmation;
		}
		
		super.OnClosingMenu();		
	}
	
	private function populateItemList():void
	{
		var tempFlashObject  : CScriptedFlashObject;
		var tempFlashArray   : CScriptedFlashArray;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		tempFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		m_playerInvComponent.GetInventoryFlashArray(tempFlashArray, tempFlashObject);
		
		m_flashValueStorage.SetFlashArray("populate.items", tempFlashArray);
	}
	
	private function populateEnchantmentsList(itemId : SItemUniqueId):void
	{
		var tempFlashArray : CScriptedFlashArray;
		
		
		tempFlashArray = m_flashValueStorage.CreateTempFlashArray();
		m_flashValueStorage.SetFlashArray("populate.enchantments", tempFlashArray);
		
		if (m_playerInventory.IsItemAnyArmor( itemId ))
		{
			m_flashValueStorage.SetFlashArray("populate.enchantments", m_glyphwordsData);
		}
		else
		{
			m_flashValueStorage.SetFlashArray("populate.enchantments", m_runewordsData);
		}
	}
	
	private function populateIngredientsList(enchantmentData:CScriptedFlashObject):void
	{
		m_flashValueStorage.SetFlashObject("populate.ingredients", enchantmentData);
	}
	
	private function ShowItemTooltip(itemId : SItemUniqueId) : void
	{
		var tooltipData : CScriptedFlashObject;
		
		if (m_playerInventory.IsIdValid(itemId))
		{
			tooltipData = m_tooltipDataProvider.GetTooltipData(itemId, false, true);
			m_flashValueStorage.SetFlashObject("context.tooltip.data", tooltipData);
		}
	}
	
	private function UpdateItemsCounter():void
	{		
		var commonMenu 	: CR4CommonMenu;
		
		commonMenu = (CR4CommonMenu)m_parentMenu;
		if( commonMenu )
		{
			commonMenu.UpdateItemsCounter();
			commonMenu.UpdatePlayerOrens();
		}
	}

}

class EnchantingConfirmationPopupData extends ConfirmationPopupData
{
	public var removingEnchantment:bool;
	public var menuRef : CR4EnchantingMenu;
	
	private var m_Price : float;
	
	public  function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject
	{
		var l_flashObject : CScriptedFlashObject;
		
		l_flashObject = parentFlashValueStorage.CreateTempFlashObject();
		l_flashObject.SetMemberFlashString("ContentRef", GetContentRef());
		l_flashObject.SetMemberFlashString("TextContent", m_TextContent);
		l_flashObject.SetMemberFlashString("TextTitle", m_TextTitle);
		l_flashObject.SetMemberFlashNumber("ItempPrice", m_Price);
		return l_flashObject;
	}
	
	public function SetPrice( value : float ) : void
	{
		m_Price = value;
	}
	
	protected function GetContentRef() : string
	{
		return "PriceConfirmationPopupRef";
	}
	
	protected function OnUserAccept() : void
	{
		menuRef.EnchantingConfirmed(removingEnchantment);
		ClosePopup();
	}
	
	protected function OnUserDecline() : void
	{
		ClosePopup();
	}
}


exec function enchantingmenu()
{
	theGame.RequestMenuWithBackground( 'EnchantingMenu', 'CommonMenu' );
}
