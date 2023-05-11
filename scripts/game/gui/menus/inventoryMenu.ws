/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




enum EInventoryMenuState
{
	IMS_Player,
	IMS_Shop,
	IMS_Container,
	IMS_HorseInventory,
	IMS_Stash
}

enum InventoryMenuTabIndexes
{
	InventoryMenuTab_Weapons = 4,
	InventoryMenuTab_Potions = 3,
	InventoryMenuTab_Default = 2,
	InventoryMenuTab_QuestItems = 1,
	InventoryMenuTab_Ingredients = 0,
	InventoryMenuTab_Books = 5
};

enum InventoryMenuStashTabIndexes
{
	StashMenuTab_Weapons = 0,
	StashMenuTab_Default = 1
};


struct SentStatsData
{
	var statName : name;
	var statValue : string;
}

class CR4InventoryMenu extends CR4MenuBase
{
	private var _playerInv    	    : W3GuiPlayerInventoryComponent;
	private var _paperdollInv 	    : W3GuiPaperdollInventoryComponent;
	private var _containerInv 	    : W3GuiContainerInventoryComponent;
	private var _shopInv 	  	    : W3GuiShopInventoryComponent;
	private var _horseInv	        : W3GuiContainerInventoryComponent;
	private var _horsePaperdollInv  : W3GuiHorseInventoryComponent;
	
	private var _currentInv   	    : W3GuiBaseInventoryComponent;
	private var _currentMouseInv   	: W3GuiBaseInventoryComponent;
	
	private var _quantityPopupData	: QuantityPopupData;
	private var _statsContext		: W3PlayerStatsContext;
	private var _paperdollContext	: W3InventoryPaperdollContext;
	private var _invContext			: W3InventoryGridContext;
	private var _externGridContext	: W3ExternalGridContext;
	private var _bookPopupData		: BookPopupFeedback;
	private var _paintingPopupData  : PaintingPopup;
	private var _charStatsPopupData : CharacterStatsPopupData;
	private var _itemInfoPopupData	: ItemInfoPopupData;
	private var _destroyConfPopData	: W3DestroyItemConfPopup;

	private var drawHorse			: bool;
	
	private var m_player 			: CEntity;
	
	protected var _inv 	     			: CInventoryComponent;
	protected var _container 			: W3Container;
	protected var _shopNpc   			: CNewNPC;
	protected var _tooltipDataProvider	: W3TooltipComponent;
	protected var currentlySelectedTab	: int;
	
	protected var _defaultInventoryState:EInventoryMenuState;
	protected var _currentState : EInventoryMenuState;	
	private var optionsItemActions : array<EInventoryActionType>;
	private var _sentStats : array<SentStatsData>;
	
	private var _currentQuickSlot : EEquipmentSlots;
	default _currentQuickSlot = EES_InvalidSlot;

	private var _currentEqippedQuickSlot : EEquipmentSlots;

	private var MAX_ITEM_NR : int;
	default MAX_ITEM_NR = 64;
	private var currentItemsNr : int;
	default	currentItemsNr = 0;
	
	private var m_menuInited 	 : bool;
	private var m_isPadConnected : bool;
	private var m_isUsingPad 	 : bool;
	private var m_hidePaperdoll	 : bool;
	private var m_tagsFilter	 : array<name>;	
	private var m_ignoreSaveData : bool;
	private var m_hideSelection  : bool;
	default m_hideSelection = false;
	
	private var m_selectionModeActive : bool; default m_selectionModeActive = false;
	private var m_selectionModeItem : SItemUniqueId;
	
	private var m_dyePreviewMode  : bool;
	private var m_dyePreviewSlots : array<SItemUniqueId>;
	private var m_previewItems	  : array<SItemUniqueId>;
	private var m_previewSlots	  : array<bool>;
	
	private var m_lastSelectedModuleID : int;
	private var m_lastSelectedModuleBindingName : string;
	
	private var m_bookPopupItem : SItemUniqueId;
	var currentSelectedItem : SItemUniqueId;
	
	
	private var m_fxPaperdollRemoveItem   	 : CScriptedFlashFunction;
	private var m_fxInventoryRemoveItem   	 : CScriptedFlashFunction;
	private var m_fxInventoryUpdateFilter 	 : CScriptedFlashFunction;
	private var m_fxForceSelectItem		  	 : CScriptedFlashFunction;
	private var m_fxForceSelectPaperdollSlot : CScriptedFlashFunction;
	private var m_fxSetFilteringMode		 : CScriptedFlashFunction;
	private var m_fxRemoveContainerItem		 : CScriptedFlashFunction;
	private var m_fxHideSelectionMode		 : CScriptedFlashFunction;
	private var m_fxSetInventoryMode		 : CScriptedFlashFunction;
	private var m_fxSetNewFlagsForTabs		 : CScriptedFlashFunction;
	private var m_fxSetSortingMode			 : CScriptedFlashFunction;
	private var m_fxSetVitality				 : CScriptedFlashFunction;
	private var m_fxSetToxicity   			 : CScriptedFlashFunction;
	private var m_fxSetPreviewMode 			 : CScriptedFlashFunction;
	private var m_fxSetDefaultTab			 : CScriptedFlashFunction;
	
	event  OnConfigUI()
	{
		var l_flashPaperdoll		: CScriptedFlashSprite;
		var l_flashInventory		: CScriptedFlashSprite;
		var l_flashObject			: CScriptedFlashObject;
		var l_flashArray			: CScriptedFlashArray;
		var l_obj		 			: IScriptable;
		var l_containerNpc			: CNewNPC;
		var l_horse 				: CActor;
		var l_initData				: W3InventoryInitData;
		var l_craftIngredientsList	: array<name>;
		
		var merchantComponent : W3MerchantComponent;
		var pinTypeName 	  : name;
		var defaultTab        : int;
		var hasNewItems 	  : array<bool>;
		
		
		var tempItem, tempItem2 : SItemUniqueId;
		
		m_initialSelectionsToIgnore = 2;
		drawHorse = false;
		m_menuInited = false;
		
		super.OnConfigUI();
		
		l_obj = GetMenuInitData();
		_container = (W3Container)l_obj;
		l_containerNpc = (CNewNPC)l_obj;
		
		l_initData = (W3InventoryInitData) l_obj;
		if (l_initData)
		{
			_container = (W3Container)l_initData.containerNPC;
			if (!_container)
			{
				l_containerNpc = (CNewNPC)l_initData.containerNPC;
			}
			m_tagsFilter = l_initData.filterTagsList;
			m_ignoreSaveData = true;			
		}
		if (l_containerNpc)
		{
			if (l_containerNpc.HasTag('Merchant'))
			{
				m_initialSelectionsToIgnore = 3;
				_shopNpc = l_containerNpc;
				m_ignoreSaveData = true;
			}
		}
		
		m_flashModule = GetMenuFlash();
		m_fxSetSortingMode = m_flashModule.GetMemberFlashFunction("setSortingMode");
		m_fxSetFilteringMode = m_flashModule.GetMemberFlashFunction( "setFilteringMode" );
		m_fxPaperdollRemoveItem = m_flashModule.GetMemberFlashFunction( "paperdollRemoveItem" );
		m_fxInventoryRemoveItem = m_flashModule.GetMemberFlashFunction( "inventoryRemoveItem" );
		m_fxInventoryUpdateFilter = m_flashModule.GetMemberFlashFunction( "forceSelectTab" );
		m_fxForceSelectItem = m_flashModule.GetMemberFlashFunction( "forceSelectItem" );		
		m_fxForceSelectPaperdollSlot = m_flashModule.GetMemberFlashFunction( "forceSelectPaperdollSlot" );
		m_fxRemoveContainerItem = m_flashModule.GetMemberFlashFunction( "shopRemoveItem" );
		m_fxSetInventoryMode = m_flashModule.GetMemberFlashFunction( "setInventoryMode" );
		m_fxHideSelectionMode = m_flashModule.GetMemberFlashFunction( "hideSelectionMode" );
		m_fxSetNewFlagsForTabs = m_flashModule.GetMemberFlashFunction( "setNewFlagsForTabs" );
		m_fxSetVitality = m_flashModule.GetMemberFlashFunction( "setVitality" );
		m_fxSetToxicity = m_flashModule.GetMemberFlashFunction( "setToxicity" );
		m_fxSetPreviewMode = m_flashModule.GetMemberFlashFunction( "setPreviewMode" );
		m_fxSetDefaultTab = m_flashModule.GetMemberFlashFunction( "setDefaultTab" );
		m_fxSetPaperdollPreviewIcon = m_flashModule.GetMemberFlashFunction( "setPaperdollPreviewIcon" );
		
		m_fxSetSortingMode.InvokeSelfSixArgs(FlashArgInt(theGame.GetGuiManager().GetInventorySortingMode()),
											 FlashArgString(GetLocStringByKeyExt("gui_panel_filter_item_type")),
											 FlashArgString(GetLocStringByKeyExt("attribute_name_price")),
											 FlashArgString(GetLocStringByKeyExt("attribute_name_weight")),
											 FlashArgString(GetLocStringByKeyExt("attribute_name_durability")),
											 FlashArgString(GetLocStringByKeyExt("gui_panel_filter_item_rarity")));
		
		_inv = thePlayer.GetInventory();
				
		
		GetWitcherPlayer().UnequipItemFromSlot(EES_Petard2,true);		
		_inv.GetItemEquippedOnSlot( EES_Quickslot2, tempItem );
		if(_inv.IsIdValid(tempItem) && _inv.GetItemCategory(tempItem) != 'mask')
		{			
			GetWitcherPlayer().UnequipItemFromSlot(EES_Quickslot2,true);
		}	
		
		
		_inv.GetItemEquippedOnSlot( EES_Quickslot1, tempItem );
		_inv.GetItemEquippedOnSlot( EES_Quickslot2, tempItem2 );
		if(!_inv.IsIdValid(tempItem2) && _inv.IsIdValid(tempItem) && _inv.GetItemCategory(tempItem) == 'mask')
		{
			GetWitcherPlayer().EquipItemInGivenSlot(tempItem, EES_Quickslot2, true, false);
		}
		
			
		_playerInv = new W3GuiPlayerInventoryComponent in this;
		_playerInv.Initialize( _inv );
		_playerInv.filterTagList = m_tagsFilter;
		_playerInv.autoCleanNewMark = true;
		
		if (m_tagsFilter.Size() > 0)
		{
			_playerInv.SetFilterType(IFT_None);
		}
		
		_currentInv = _playerInv;
		
		_paperdollInv = new W3GuiPaperdollInventoryComponent in this;
		_paperdollInv.Initialize( _inv );
		
		_horseInv = new  W3GuiContainerInventoryComponent in this;
		_horseInv.Initialize(GetWitcherPlayer().GetHorseManager().GetInventoryComponent());
		_horsePaperdollInv = new  W3GuiHorseInventoryComponent in this;
		_horsePaperdollInv.Initialize(GetWitcherPlayer().GetHorseManager().GetInventoryComponent());
		
		_tooltipDataProvider = new W3TooltipComponent in this;
		_tooltipDataProvider.initialize(_inv, m_flashValueStorage);
		
		theGame.GetGuiManager().SetBackgroundTexture( LoadResource( "inventory_background" ) );
		
		m_flashValueStorage.SetFlashString("inventory.grid.paperdoll.pockets",GetLocStringByKeyExt("panel_inventory_paperdoll_slotname_quickitems"));
		m_flashValueStorage.SetFlashString("inventory.grid.paperdoll.potions",GetLocStringByKeyExt("panel_inventory_paperdoll_slotname_potions"));
		m_flashValueStorage.SetFlashString("inventory.grid.paperdoll.petards",GetLocStringByKeyExt("panel_inventory_paperdoll_slotname_petards"));
		m_flashValueStorage.SetFlashString("inventory.grid.paperdoll.masks",GetLocStringByKeyExt("item_category_mask")); 
		m_flashValueStorage.SetFlashString("playerstats.stats.name", GetLocStringByKeyExt("panel_common_statistics_name") );
		
		if( _container )
		{
			_containerInv = new W3GuiContainerInventoryComponent in this;
			_containerInv.Initialize( _container.GetInventory() );
			if( m_tagsFilter.Size() > 0 )
			{
				if( m_tagsFilter.FindFirst('HideOwnerInventory') != -1 )
				{
					_containerInv.HideAllItems();
				}
			}
			
			_playerInv.currentDefaultItemAction = IAT_Transfer;
			_paperdollInv.currentDefaultItemAction = IAT_Transfer;
			m_flashValueStorage.SetFlashString("inventory.grid.container.name",_container.GetDisplayName(false));
			_defaultInventoryState = IMS_Container;
		}
		else if( _shopNpc )
		{
			_shopInv = new W3GuiShopInventoryComponent in this;
			_shopNpc.GetInventory().UpdateLoot();
			_shopNpc.GetInventory().ClearGwintCards();
			_shopNpc.GetInventory().ClearTHmaps();
			_shopNpc.GetInventory().ClearKnownRecipes();
			_shopInv.Initialize( _shopNpc.GetInventory() );
			
			merchantComponent = (W3MerchantComponent)_shopNpc.GetComponentByClassName( 'W3MerchantComponent' );
			if( merchantComponent )
			{
				pinTypeName = merchantComponent.GetMapPinType();
				
				switch( pinTypeName )
				{
					case 'Alchemic':
					case 'Herbalist':
						defaultTab = 0;
						break;
					case 'Innkeeper':
						defaultTab = 2;
						break;
					default:
						defaultTab = -1;
				}
				
				m_fxSetDefaultTab.InvokeSelfOneArg( FlashArgInt( defaultTab ) );
			}
			
			
			
			_tooltipDataProvider.setShopInventory(_shopNpc.GetInventory());
			
			_playerInv.SetShopInvCmp( _shopInv );
			_playerInv.currentDefaultItemAction = IAT_Sell;
			m_flashValueStorage.SetFlashString("inventory.grid.container.name",_shopNpc.GetDisplayName(false));
			_defaultInventoryState = IMS_Shop;
			UpdateMerchantData();
			
			if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())		
			{
				theGame.GetTutorialSystem().uiHandler.OnOpeningMenu('ShopMenu');
			}
			
			l_craftIngredientsList = UpdatePinnedCraftingItemInfo();
			_shopInv.highlightItems(l_craftIngredientsList);			
		}
		else if( l_containerNpc )
		{
			_containerInv = new W3GuiContainerInventoryComponent in this;
			_containerInv.Initialize( l_containerNpc.GetInventory() );
			
			_playerInv.currentDefaultItemAction = IAT_Transfer;
			_paperdollInv.currentDefaultItemAction = IAT_Transfer;
			
			m_flashValueStorage.SetFlashString("inventory.grid.container.name",l_containerNpc.GetDisplayName(false));
			_defaultInventoryState = IMS_Container;
		}
		else if ( theGame.GameplayFactsQuerySum("stashMode") == 1 )
		{
			_defaultInventoryState = IMS_Stash;
		}
		else
		{
			_defaultInventoryState = IMS_Player;
		}
		
		defaultTab = SetInitialTabNewFlags( hasNewItems );
		if( _defaultInventoryState == IMS_Container )
		{
			
			m_fxSetDefaultTab.InvokeSelfOneArg( FlashArgInt( defaultTab ) );
		}
		
		PaperdollUpdateAll();
		UpdatePlayerStatisticsData();
		
		m_menuInited = true;
		if (m_menuState == '') m_menuState = 'CharacterInventory';
		ApplyMenuState(m_menuState);
		
		_currentEqippedQuickSlot = GetCurrentEquippedQuickSlot();
		SelectCurrentModule();	
		
		m_fxSetNewFlagsForTabs.InvokeSelfSixArgs( FlashArgBool(hasNewItems[0]), FlashArgBool(hasNewItems[1]), FlashArgBool(hasNewItems[2]), FlashArgBool(hasNewItems[3]), FlashArgBool(hasNewItems[4]), FlashArgBool(hasNewItems[5] ) );
		m_fxSetTooltipState.InvokeSelfTwoArgs( FlashArgBool( thePlayer.upscaledTooltipState ), FlashArgBool( true ) );
		
		m_dyePreviewSlots.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );
		m_previewSlots.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );		
	}
	
	event  OnSortingIndexChoosingStart()
	{
		var commonMenu 				: CR4CommonMenu;

		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if (commonMenu)
		{
			commonMenu.m_contextInputBlocked = true;
		}
	}
	
	event  OnSortingIndexChosen( sortIndex : int )
	{
		var commonMenu 				: CR4CommonMenu;

		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if (commonMenu)
		{
			commonMenu.m_contextInputBlocked = false;
		}
		theGame.GetGuiManager().SetInventorySortingMode(sortIndex);
		
		
	}
	
	event  OnGuiSceneEntitySpawned(entity : CEntity)
	{
		var arr : array< name >;
		
		Event_OnGuiSceneEntitySpawned();
		m_player = entity;
		arr.PushBack( 'Inventory' );
		m_player.ActivateBehaviorsSync( arr );
		
		((CActor)m_player).SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)PGMM_Inventory );
	}
	
	timer function GuiSceneEntityUpdate(dt : float, id : int)
	{
		
		
	}
	
	
	
	
	
	event  OnScaleCharRenderer(delta:float, isPad:bool)
	{
		var guiSceneController : CR4GuiSceneController;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		
		if ( !guiSceneController )
		{
			return 0;
		}
		
		guiSceneController.ZoomEntity(delta, isPad);
	}
	
	event  OnPlayAnimation(animationId:int)
	{
		var itemOnSlot : SItemUniqueId;
		
		switch (animationId)
		{
			case 0:
				GetWitcherPlayer().GetItemEquippedOnSlot( EES_SteelSword, itemOnSlot );
				if( _inv.IsIdValid( itemOnSlot ) )
				{
					PlayPaperdollAnimation( 'steelsword' );
				}
				break;
				
			case 1:
				GetWitcherPlayer().GetItemEquippedOnSlot( EES_SilverSword, itemOnSlot );
				if( _inv.IsIdValid( itemOnSlot ) )
				{
					PlayPaperdollAnimation( 'silversword' );
				}
				break;
				
			case 2:
				((CActor)m_player).SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)PGMM_Combat );
				m_player.RaiseEvent('CombatActionFriendlyEnd');
				break;
				
			default:
				break;
		}
	}
	
	event  OnFlashTick()
	{
		var guiSceneController : CR4GuiSceneController;
		var curRotation : EulerAngles;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		
		if ( guiSceneController )
		{
			
		}		
	}
	
	event  OnChangeCharRenderFocus(next:bool)
	{
		theGame.GetGuiManager().GetSceneController().OnChangeCharRenderFocus( next );
	}
	
	event  OnMoveCharRenderer(delta:float)
	{
		var guiSceneController : CR4GuiSceneController;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		
		if ( !guiSceneController )
		{
			return 0;
		}
		
		guiSceneController.MoveEntity(-delta);
	}
	
	event  OnRotateCharRenderer(delta:float)
	{
		var guiSceneController : CR4GuiSceneController;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		
		if ( !guiSceneController )
		{
			return 0;
		}
		
		guiSceneController.RotateEntity(-delta);
	}
	
	event  OnPlayerStatsShown()
	{
		if (m_currentContext)
		{
			m_currentContext.Deactivate();
		}
	}
	
	event  OnPlayerStatsHidden()
	{
		var tutorialStateNewGeekpage : W3TutorialManagerUIHandlerStateNewGeekpage;
		
		if (m_currentContext)
		{
			ActivateContext(m_currentContext);
			m_currentContext.UpdateContext();
		}
		
		if( theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'NewGeekpage' )
		{
			tutorialStateNewGeekpage = ( W3TutorialManagerUIHandlerStateNewGeekpage )theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateNewGeekpage.OnGeekpageClosed();
		}
	}
	
	event  OnResetPlayerPosition()
	{
		var guiSceneController : CR4GuiSceneController;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		
		if ( !guiSceneController )
		{
			return 0;
		}
		
		guiSceneController.ResetEntityPosition();
	}
	
	event  OnRequestStatsData()
	{
		var gfxData : CScriptedFlashObject;
		var tutorialStateNewGeekpage : W3TutorialManagerUIHandlerStateNewGeekpage;
		
		gfxData = GetPlayerStatsGFxData(m_flashValueStorage);
		
		m_flashValueStorage.SetFlashObject("inventory.player.stats", gfxData);
		
		if( ShouldProcessTutorial( 'TutorialGeekpageStats' ) && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'NewGeekpage' )
		{
			tutorialStateNewGeekpage = ( W3TutorialManagerUIHandlerStateNewGeekpage )theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateNewGeekpage.OnGeekpageOpened();
		}
	}
	
	event  OnTickEvent( delta : int )
	{
		
		if(m_hideSelection)
		{
			m_hideSelection = false;
			m_fxForceSelectItem.InvokeSelfOneArg( FlashArgInt(-1));
		}
	}
	
	
	
	
	event  OnGuiSceneEntityDestroyed()
	{
		Event_OnGuiSceneEntityDestroyed();
	}
	
	private function RestoreSaved() : void
	{
		var UIData : SInventoryItemUIData;
		
		
	}
	
	event  OnSortingRequested()
	{
		_playerInv.CleanupItemsGridPosition();
		updateCurrentTab();
		
		SetTabNewFlags();
	}
	
	event  OnTabDataRequested(tabIndex : int, isHorse:bool)
	{
		PopulateTabData(tabIndex);
	}
	
	event  OnTabChanged(tabIndex:int)
	{
		var tutStatePot : W3TutorialManagerUIHandlerStatePotions;
		var tutStateOil : W3TutorialManagerUIHandlerStateOils;
		var tutStateBooks : W3TutorialManagerUIHandlerStateBooks;
		var tutStateArmorUpgrades : W3TutorialManagerUIHandlerStateArmorUpgrades;
		var tutStateFood : W3TutorialManagerUIHandlerStateFood;
		var tutStateSecondPotionEquip : W3TutorialManagerUIHandlerStateSecondPotionEquip;
		var tutStateRecipeReading : W3TutorialManagerUIHandlerStateRecipeReading;
		
		currentlySelectedTab = tabIndex;
		
		if(tabIndex == InventoryMenuTab_Potions && ShouldProcessTutorial('TutorialPotionCanEquip2'))
		{
			tutStatePot = (W3TutorialManagerUIHandlerStatePotions)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStatePot)
			{
				tutStatePot.OnPotionTabSelected();
			}
		}
		if(tabIndex == InventoryMenuTab_Default && ShouldProcessTutorial('TutorialFoodSelectTab'))
		{
			tutStateFood = (W3TutorialManagerUIHandlerStateFood)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateFood)
			{
				tutStateFood.OnPotionTabSelected();
			}
		}
		if(tabIndex == InventoryMenuTab_Potions && ShouldProcessTutorial('TutorialOilCanEquip2'))
		{
			tutStateOil = (W3TutorialManagerUIHandlerStateOils)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateOil)
			{
				tutStateOil.OnOilTabSelected();
			}
		}		
		if(ShouldProcessTutorial('TutorialBooksSelectTab'))
		{
			tutStateBooks = (W3TutorialManagerUIHandlerStateBooks)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateBooks)
			{
				tutStateBooks.OnSelectedTab(tabIndex == InventoryMenuTab_Books);
			}
			else
			{
				tutStateRecipeReading = (W3TutorialManagerUIHandlerStateRecipeReading)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				if(tutStateRecipeReading)
				{
					tutStateRecipeReading.OnSelectedTab(tabIndex == InventoryMenuTab_Books);
				}
			}
		}		
		if(tabIndex == InventoryMenuTab_Weapons && ShouldProcessTutorial('TutorialArmorSocketsSelectTab'))
		{
			tutStateArmorUpgrades = (W3TutorialManagerUIHandlerStateArmorUpgrades)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateArmorUpgrades)
			{
				tutStateArmorUpgrades.OnTabSelected();
			}
		}
		if(tabIndex == InventoryMenuTab_Potions && ShouldProcessTutorial('TutorialPotionCanEquip1'))
		{
			tutStateSecondPotionEquip = (W3TutorialManagerUIHandlerStateSecondPotionEquip)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateSecondPotionEquip)
			{
				tutStateSecondPotionEquip.OnPotionTabSelected();
			}
		}
	}
	
	public function updateCurrentTab():void
	{
		if (currentlySelectedTab != -1)
		{
			PopulateTabData(currentlySelectedTab);
		}
	}
	
	public function PopulateTabData(tabIndex:int) : void
	{
		var l_flashObject  : CScriptedFlashObject;
		var l_flashArray   : CScriptedFlashArray;
		
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		l_flashArray = m_flashValueStorage.CreateTempFlashArray();
		
		
			switch (tabIndex)
			{
			case InventoryMenuTab_Weapons:
				_playerInv.SetFilterType( IFT_Weapons );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			case InventoryMenuTab_Potions:
				_playerInv.SetFilterType( IFT_AlchemyItems );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			case InventoryMenuTab_Ingredients:
				_playerInv.SetFilterType( IFT_Ingredients );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			case InventoryMenuTab_QuestItems:
				_playerInv.SetFilterType( IFT_QuestItems );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			case InventoryMenuTab_Default:
				_playerInv.SetFilterType( IFT_Default );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			case InventoryMenuTab_Books:
				_playerInv.SetFilterType( IFT_Books );
				_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);
				break;
			}
		
		
		PopulateDataForTab(tabIndex, l_flashArray);
	}
	
	private function PopulateDataForTab(tabIndex:int, entriesArray:CScriptedFlashArray):void
	{
		var l_flashObject : CScriptedFlashObject;
		
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		l_flashObject.SetMemberFlashInt("tabIndex", tabIndex);
		l_flashObject.SetMemberFlashArray("tabData", entriesArray);
		
		if( entriesArray.GetLength() > 0 )
		{
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(true));
		}
		else
		{
			m_fxShowSecondaryModulesSFF.InvokeSelfOneArg(FlashArgBool(false));
		}
		
		m_flashValueStorage.SetFlashObject( "player.inventory.menu.tabs.data" + tabIndex, l_flashObject );
	}
	
	public function SetInitialTabNewFlags( out hasNewItems : array< bool > ):int
	{
		var notEmptyTabIdx : int = -1;
		var hasItems : bool;
		var currentFilter : EInventoryFilterType;
		
		currentFilter = _playerInv.GetFilterType();
		
		_playerInv.SetFilterType( IFT_Ingredients );
		hasNewItems.PushBack( _playerInv.HasNewFlagOnItem( hasItems ) );
		if (hasItems) notEmptyTabIdx = 0;
		
		_playerInv.SetFilterType( IFT_QuestItems );
		hasNewItems.PushBack( _playerInv.HasNewFlagOnItem( hasItems ) );
		if (hasItems) notEmptyTabIdx = 1;
		
		_playerInv.SetFilterType( IFT_Default );
		hasNewItems.PushBack( _playerInv.HasNewFlagOnItem( hasItems ) );
		if (hasItems) notEmptyTabIdx = 2;
		
		_playerInv.SetFilterType( IFT_AlchemyItems );
		hasNewItems.PushBack( _playerInv.HasNewFlagOnItem( hasItems ) );
		if (hasItems) notEmptyTabIdx = 3;
		
		_playerInv.SetFilterType( IFT_Weapons );
		hasNewItems.PushBack( _playerInv.HasNewFlagOnItem( hasItems ) );
		if (hasItems) notEmptyTabIdx = 4;
		
		_playerInv.SetFilterType( currentFilter );		
		return notEmptyTabIdx;
	}
	
	public function SetTabNewFlags():void
	{
		var hasNewItems   : array< bool >;		
		var filtersToCheck : array <EInventoryFilterType>;
		
		filtersToCheck.PushBack( IFT_Ingredients );
		filtersToCheck.PushBack( IFT_QuestItems );
		filtersToCheck.PushBack( IFT_Default );
		filtersToCheck.PushBack( IFT_AlchemyItems );
		filtersToCheck.PushBack( IFT_Weapons );
		
		hasNewItems = _playerInv.GetNewFlagForTabs( filtersToCheck );
		
		m_fxSetNewFlagsForTabs.InvokeSelfSixArgs(FlashArgBool(hasNewItems[IFT_Ingredients]), FlashArgBool(hasNewItems[IFT_QuestItems]), FlashArgBool(hasNewItems[IFT_Default]), FlashArgBool(hasNewItems[IFT_AlchemyItems]), FlashArgBool(hasNewItems[IFT_Weapons]), FlashArgBool(hasNewItems[5]));
	}
	
	public function getTabFromItem(item:SItemUniqueId):int
	{
		var inventoryFilterType:EInventoryFilterType;
		
		inventoryFilterType = _playerInv.GetFilterTypeByItem(item);
		
		return getTabFromFilter(inventoryFilterType);
	}
	
	public function getTabFromFilter(inventoryFilterType:EInventoryFilterType):int
	{
		
			switch (inventoryFilterType)
			{
			case IFT_Weapons:
				return InventoryMenuTab_Weapons;
			case IFT_AlchemyItems:
				return InventoryMenuTab_Potions;
			case IFT_Ingredients:
				return InventoryMenuTab_Ingredients;
			case IFT_QuestItems:
				return InventoryMenuTab_QuestItems;
			case IFT_Default:
				return InventoryMenuTab_Default;
			case IFT_Books:
				return InventoryMenuTab_Books;
			}
		
		
		return InventoryMenuTab_Default;
	}
	
	public function UpdateEncumbranceInfo() : void
	{
		var encumbrance 	: int;
		var encumbranceMax  : int;
		var hasHorseUpgrade : bool;
		
		encumbrance = (int)GetWitcherPlayer().GetEncumbrance();
		encumbranceMax = (int)GetWitcherPlayer().GetMaxRunEncumbrance(hasHorseUpgrade);
		
		
		
		
		UpdateItemsCounter();
	}
	
	public function GetCurrentInventoryState():EInventoryMenuState
	{
		return _currentState;
	}
	
	private function SetInventoryState(targetMode : int) : void
	{
		drawHorse = false;
		_currentState = targetMode;
		m_fxSetInventoryMode.InvokeSelfOneArg(FlashArgInt(_currentState));
		switch (targetMode)
		{
			case IMS_Player:
				m_fxSetFilteringMode.InvokeSelfOneArg(FlashArgBool(false));
				UpdateEntityTemplate();
				break;
			case IMS_Shop:
				UpdateShop();
				m_fxSetFilteringMode.InvokeSelfOneArg(FlashArgBool(false));
				break;
			case IMS_Container:
				UpdateContainer();
				m_fxSetFilteringMode.InvokeSelfOneArg(FlashArgBool(m_tagsFilter.Size() > 0));
				break;
			case IMS_HorseInventory:
				drawHorse = true;
				UpdateHorseInventory();
				UpdateHorsePaperdoll();
				m_fxSetFilteringMode.InvokeSelfOneArg(FlashArgBool(false));
				break;
			case IMS_Stash:
				_playerInv.stashMode = true;
				_horseInv.dontShowEquipped = true;
				UpdateHorseInventory();
				break;
			default:
				break;
		}
	}
	
	private function UpdateEntityTemplate() : void
	{
		var templateFilename : string;
		var appearance : name;
		var environmentFilename : string;
		var environmentSunRotation : EulerAngles;
		var cameraLookAt : Vector;
		var cameraRotation : EulerAngles;
		var cameraDistance : float;
		var updateItems : bool;
		var fov : float;
		
		var guiSceneController : CR4GuiSceneController;
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		if ( !guiSceneController )
		{
			
			return;
		}
		
		if ( drawHorse )
		{
			templateFilename             = "HorseForUI";
			appearance                   = '';
			environmentSunRotation.Yaw   = 250;
			environmentSunRotation.Pitch = 10;
			cameraLookAt.Z               = 1;
			cameraRotation.Yaw           = 88.6;
			cameraRotation.Pitch         = 355;
			cameraDistance               = 3.17;
			fov 						 = 35.0f;
			updateItems                  = true;
		}
		else
		{
			
			
			templateFilename             = "GeraltForUI";
			appearance                   = '';
			environmentSunRotation.Yaw   = 0;
			environmentSunRotation.Pitch = 0;
			cameraLookAt.Z               = 0.92;
			cameraRotation.Yaw           = 190.71; 
			cameraRotation.Pitch         = 5;
			cameraDistance               = 3.2;
			fov							 = 35.0f;
			updateItems                  = true;
		}
		
		
		guiSceneController.SetEntityTemplate( templateFilename );
		guiSceneController.SetCamera( cameraLookAt, cameraRotation, cameraDistance, fov );
		guiSceneController.SetEnvironmentAndSunRotation( "DefaultEnvironmentForUI", environmentSunRotation );
		
		guiSceneController.SetEntityAppearance( appearance );
		guiSceneController.SetEntityItems( updateItems );
	}
	
	public  function SetMenuState(newState : name) : void
	{
		super.SetMenuState(newState);
		if (m_menuInited)
		{
			ApplyMenuState(newState);
		}
	}
	
	protected function ApplyMenuState(newState : name) : void
	{
		LogChannel('INVENTORY', "SetMenuState: " + newState);
		
		switch (newState)
		{
			case 'CharacterInventory':
				SetInventoryState(_defaultInventoryState);
				break;
			case 'HorseInventory':
				SetInventoryState(IMS_HorseInventory);
				break;
		}
	}
	
	function UpdateData()
	{
		updateCurrentTab();
		PaperdollUpdateAll();
		UpdateItemsCounter();
		UpdatePlayerStatisticsData();
	}
	
	function InventoryUpdateItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		if (!_inv.ItemHasTag(item, 'NoShow'))
		{
			tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
			itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
			_playerInv.SetInventoryFlashObjectForItem(item, itemDataObject);
			itemDataObject.SetMemberFlashInt("tabIndex", getTabFromFilter(_playerInv.GetFilterTypeByItem(item)));
			m_flashValueStorage.SetFlashObject( "inventory.grid.player.itemUpdate", itemDataObject );
		}
	}
	
	function ShopUpdateItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
		_shopInv.SetInventoryFlashObjectForItem(item, itemDataObject);
		itemDataObject.SetMemberFlashInt("tabIndex", GetTabIndexForSlot(getTabFromFilter(_shopInv.GetInventoryComponent().GetFilterTypeByItem(item))));
		m_flashValueStorage.SetFlashObject( "inventory.grid.container.itemUpdate", itemDataObject );
	}
	
	function InventoryUpdateItems( itemsList : array<SItemUniqueId>  )
	{
		var i					: int;
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		var itemsDataList		: CScriptedFlashArray;
		
		itemsDataList = m_flashValueStorage.CreateTempFlashArray();
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		for ( i = 0; i < itemsList.Size(); i += 1 )
		{
			itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");			
			_playerInv.SetInventoryFlashObjectForItem(itemsList[i], itemDataObject);
			itemDataObject.SetMemberFlashInt("tabIndex", getTabFromFilter(_playerInv.GetFilterTypeByItem(itemsList[i])));
			itemsDataList.PushBackFlashObject(itemDataObject);
		}
		m_flashValueStorage.SetFlashArray( "inventory.grid.player.itemsUpdate", itemsDataList );
	}
	
	function InventoryRemoveItem( item : SItemUniqueId, optional keepSelectionIdx : bool )
	{
		m_fxInventoryRemoveItem.InvokeSelfTwoArgs( FlashArgUInt(ItemToFlashUInt(item)), FlashArgBool(keepSelectionIdx) );
	
	}
	
	function ShopRemoveItem( item : SItemUniqueId )
	{
		m_fxRemoveContainerItem.InvokeSelfOneArg( FlashArgUInt( ItemToFlashUInt(item) ));
	}
	
	function PaperdollRemoveItem( item : SItemUniqueId )
	{
		m_fxPaperdollRemoveItem.InvokeSelfOneArg( FlashArgUInt( ItemToFlashUInt(item) ));		
	}
	
	private function AddEquippedPotionsToList(out itemsList  : array < SItemUniqueId > ) : void
	{
		var itemOnSlot : SItemUniqueId;
		
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_Potion1, itemOnSlot);
		if ( _inv.IsIdValid(itemOnSlot) )
		{
			itemsList.PushBack(itemOnSlot);
		}
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_Potion2,itemOnSlot);
		if ( _inv.IsIdValid(itemOnSlot) )
		{
			itemsList.PushBack(itemOnSlot);
		}
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_Potion3,itemOnSlot);
		if ( _inv.IsIdValid(itemOnSlot) )
		{
			itemsList.PushBack(itemOnSlot);
		}
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_Potion4,itemOnSlot);
		if ( _inv.IsIdValid(itemOnSlot) )
		{
			itemsList.PushBack(itemOnSlot);
		}
	}
	
	function PaperdollUpdateItemsList( itemsList : array<SItemUniqueId> )
	{
		var i					: int;
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		var itemsDataList		: CScriptedFlashArray;
		
		itemsDataList = m_flashValueStorage.CreateTempFlashArray();
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		for ( i = 0; i < itemsList.Size(); i += 1 )
		{
			itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");			
			_paperdollInv.SetInventoryFlashObjectForItem(itemsList[i], itemDataObject);
			itemsDataList.PushBackFlashObject(itemDataObject);
		}
		m_flashValueStorage.SetFlashArray( "inventory.grid.paperdoll.items.update", itemsDataList );		
	}
	
	function PaperdollUpdateItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
		_paperdollInv.SetInventoryFlashObjectForItem(item, itemDataObject);
		m_flashValueStorage.SetFlashObject( "inventory.grid.paperdoll.item.update", itemDataObject );
	}
	
	function PaperdollUpdateHorseItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
		_horsePaperdollInv.SetInventoryFlashObjectForItem(item, itemDataObject);
		m_flashValueStorage.SetFlashObject( "inventory.grid.paperdoll.item.update", itemDataObject );
	}
	
	function UpdateItemData( item : SItemUniqueId )
	{
		var l_flashObject		: CScriptedFlashObject;
		
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		_playerInv.SetInventoryFlashObjectForItem(item,l_flashObject);
		m_flashValueStorage.SetFlashObject( "inventory.grid.player.item", l_flashObject );
	}
	
	function PaperdollUpdateAll()
	{
		UpdateItemsList("inventory.grid.paperdoll", _paperdollInv, _horsePaperdollInv);
	}
	
	function UpdateHorsePaperdoll()
	{
		UpdateItemsList("inventory.grid.paperdoll.horse", _horsePaperdollInv);
	}
	
	function UpdateHorseInventory()
	{
		UpdateItemsList("inventory.grid.container", _horseInv);
	}
	
	function UpdateContainer()
	{
		UpdateItemsList("inventory.grid.container", _containerInv);
	}	
	
	function UpdateShop()
	{
		UpdateItemsList("inventory.grid.container", _shopInv);
	}
	
	private function UpdateItemsList( flashBinding:string, targetInventory : W3GuiBaseInventoryComponent, optional secondaryInventory : W3GuiBaseInventoryComponent ):void
	{
		var l_flashObject  : CScriptedFlashObject;
		var l_flashArray   : CScriptedFlashArray;
		
		l_flashArray = m_flashValueStorage.CreateTempFlashArray();
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		
		if (targetInventory)
		{
			targetInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);
		}
		
		if (secondaryInventory)
		{
			secondaryInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);
		}
		
		
		
			m_flashValueStorage.SetFlashArray( flashBinding, l_flashArray );
		
	}
	
	private function UpdateItemsCounter()
	{
		var itemsNr : int;
		var commonMenu 				: CR4CommonMenu;

		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if( commonMenu )
		{
			itemsNr = commonMenu.UpdateItemsCounter();
		}

		if( itemsNr >= MAX_ITEM_NR && currentItemsNr != itemsNr )
		{
			currentItemsNr = itemsNr;
			
		}
	} 
	
	
	
	event OnGetItemData(item : SItemUniqueId, compareItemType : int) 
	{
		ShowItemTooltip(item, compareItemType);
	}
	
	event OnGetItemDataForMouse(item : SItemUniqueId, compareItemType : int) 
	{
		ShowItemMouseTooltip(item, compareItemType);
	}
	
	event OnShowStatTooltip(statName : name) 
	{
		ShowStatTooltip(statName);
	}
	
	event OnGetEmptyPaperdollTooltip(equipID:int, isLocked:bool)
	{
		ShowEmptySlotTooltip(equipID);
	}
	
	
	public function ShowStatTooltip(statName : name) 
	{
		var resultData : CScriptedFlashObject;
		var statsList  : CScriptedFlashArray;
		
		resultData = m_flashValueStorage.CreateTempFlashObject();
		statsList = m_flashValueStorage.CreateTempFlashArray();
		switch (statName)
		{
			case 'vitality':
				GetHealthTooltipData(statsList);
				break;
			case 'toxicity':
				GetToxicityTooltipData(statsList);
				break;
			case 'stamina':
				GetStaminaTooltipData(statsList);
				break;
			case 'focus':
				GetAdrenalineTooltipData(statsList);
				break;
			case 'stat_offense':
				GetOffenseTooltipData(statsList);
				break;
			case 'stat_defense':
				GetDefenseTooltipData(statsList);
				break;
			case 'stat_signs':
				GetSignsTooltipData(statsList);
				break;
		}
		resultData.SetMemberFlashString("title", GetLocStringByKeyExt(statName));
		resultData.SetMemberFlashString("description", GetLocStringByKeyExt(statName+"_desc"));
		resultData.SetMemberFlashArray("statsList", statsList);
		
		m_flashValueStorage.SetFlashObject("statistic.tooltip.data", resultData);
	}
	
	var hackHideStatTooltip:bool; 
	public function HideStatTooltip()
	{
		m_flashValueStorage.SetFlashBool("statistic.tooltip.hide", hackHideStatTooltip);
		hackHideStatTooltip = !hackHideStatTooltip;
	}
	
	public function GetItemExpTooltipData(item : SItemUniqueId) : CScriptedFlashObject
	{
		_tooltipDataProvider.setCurrentInventory(GetCurrentInventory(item));
		return  _tooltipDataProvider.GetExItemData(item, _currentInv == _shopInv);
	}
	
	public function ShowEmptySlotTooltip(slotId : int):void
	{
		var tooltipData : CScriptedFlashObject;
		_tooltipDataProvider.setCurrentInventory(GetCurrentInventory(GetInvalidUniqueId()));
		tooltipData = _tooltipDataProvider.GetEmptySlotData(slotId);
		m_flashValueStorage.SetFlashObject("context.tooltip.data", tooltipData);
	}
	
	event  OnClearSlotNewFlag(item : SItemUniqueId)
	{
		var curInventory : CInventoryComponent;
		var uiData : SInventoryItemUIData;
		
		curInventory = GetCurrentInventory(item);
		
		if ( curInventory.IsIdValid( m_bookPopupItem ) && m_bookPopupItem == item )
		{
			
			m_bookPopupItem = GetInvalidUniqueId();
			return false;
		}
		
		
		if (curInventory.IsIdValid(item))
		{
			uiData = curInventory.GetInventoryItemUIData( item );
			uiData.isNew = false;
			curInventory.SetInventoryItemUIData( item, uiData );
		}
	}
	
	public function ShowItemTooltip(item : SItemUniqueId, compareItemType : int) : void
	{
		var tooltipData : CScriptedFlashObject;
		
		_tooltipDataProvider.setCurrentInventory(GetCurrentInventory(item));
		tooltipData = _tooltipDataProvider.GetTooltipData(item, _currentInv == _shopInv, true);
		m_flashValueStorage.SetFlashObject("context.tooltip.data", tooltipData);
	}
	
	public function ShowItemMouseTooltip(item : SItemUniqueId, compareItemType : int) : void
	{
		var tooltipData : CScriptedFlashObject;
		
		_tooltipDataProvider.setCurrentInventory(GetInventoryComponent(_currentMouseInv));
		tooltipData = _tooltipDataProvider.GetTooltipData(item, _currentMouseInv == _shopInv, true);
		m_flashValueStorage.SetFlashObject("context.tooltip.data", tooltipData);
	}
	
	var hackHideItemTooltip:bool; 
	public function HideItemTooltip()
	{
		m_flashValueStorage.SetFlashBool("context.tooltip.hide", hackHideItemTooltip);
		hackHideItemTooltip = !hackHideItemTooltip;
	}
	
	public function GetCurrentInventoryComponent():W3GuiBaseInventoryComponent
	{
		return _currentInv;
	}
	
	public function GetCurrentInventory(optional item : SItemUniqueId):CInventoryComponent
	{
		return GetInventoryComponent(_currentInv);
	}
	
	public function GetInventoryComponent(_targetInv : W3GuiBaseInventoryComponent):CInventoryComponent
	{		
		if( _targetInv == _shopInv )
		{
			return _shopNpc.GetInventory();
		}
		else if( _targetInv == _containerInv)
		{
			return _container.GetInventory();
		}
		else if (_targetInv == _horsePaperdollInv)
		{
			return _horsePaperdollInv.GetInventoryComponent();
		}
		else if (_targetInv == _horseInv)
		{
			return _horseInv.GetInventoryComponent();
		}
		else
		{
			return _inv;
		}
	}
	
	public function getShopInventory():CInventoryComponent
	{
		if (_shopNpc)
		{
			return _shopNpc.GetInventory();
		}
		return NULL;
	}
	
	function GetFilterType( item : SItemUniqueId ) : EInventoryFilterType
	{
		return _paperdollInv.GetFilterTypeByItem( item ); 
	}
	
	function GetItemDefaultActionName( item : SItemUniqueId ) : string
	{
		var itemAction : EInventoryActionType;
		itemAction = GetItemDefaultAction(item);
		
		return GetItemActionFriendlyName(itemAction,GetWitcherPlayer().IsItemEquipped(item));
	}
	
	function GetItemDefaultAction( item : SItemUniqueId ) : EInventoryActionType
	{
		var itemAction : EInventoryActionType;
		itemAction = _playerInv.GetItemActionType( item, true );
		return itemAction;
	}
	
	
		
	private function GetHealthTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var maxHealth:float;
		var curHealth:float;
		var inCombatRegen:float;
		var outOfCombatRegen:float;
		var inCombatRegenStr : string;
		var outOfCombatRegenStr : string;
		
		maxHealth = thePlayer.GetStatMax(BCS_Vitality);
		curHealth = thePlayer.GetStatPercents(BCS_Vitality);
		inCombatRegen = CalculateAttributeValue(thePlayer.GetAttributeValue('vitalityCombatRegen'));
		outOfCombatRegen = CalculateAttributeValue(thePlayer.GetAttributeValue('vitalityRegen')); 
		inCombatRegenStr    = NoTrailZeros( RoundTo( inCombatRegen, 1 ) );
		outOfCombatRegenStr = NoTrailZeros( RoundTo( outOfCombatRegen, 1 ) );
		PushStatItem(GFxData, "panel_common_statistics_tooltip_current_health",   (string)RoundMath(maxHealth * curHealth));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_maximum_health",   (string)RoundMath(maxHealth));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_incombat_regen",    inCombatRegenStr );
		PushStatItem(GFxData, "panel_common_statistics_tooltip_outofcombat_regen", outOfCombatRegenStr );
	}
	
	private function GetToxicityTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var maxToxicity:float;
		var curToxicity:float;
		var lockedToxicity:float;
		var toxicityThreshold:float;
		
		maxToxicity = thePlayer.GetStatMax(BCS_Toxicity);
		curToxicity = thePlayer.GetStat(BCS_Toxicity, true);
		lockedToxicity = thePlayer.GetStat(BCS_Toxicity) - curToxicity;
		toxicityThreshold = GetWitcherPlayer().GetToxicityDamageThreshold();
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_current_toxicity", (string)RoundMath(curToxicity));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_current_maximum", (string)RoundMath(maxToxicity));
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_locked", (string)RoundMath(lockedToxicity));		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_threshold", (string)RoundMath(toxicityThreshold));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_degeneration", (string)RoundMath(0));
	}
	
	private function GetStaminaTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var maxStamina:float;		
		var regenStamia:float;
		var value : SAbilityAttributeValue;
		
		value = thePlayer.GetAttributeValue('staminaRegen');
		regenStamia = value.valueMultiplicative / 0.34;
		maxStamina = thePlayer.GetStatMax(BCS_Stamina);
		PushStatItem(GFxData, "panel_common_statistics_tooltip_maximum_stamina ", (string)RoundMath(maxStamina));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_regeneration_rate", (string)NoTrailZeros( RoundTo(regenStamia, 2) ) );
		
	}
	
	private function GetAdrenalineTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var maxAdrenaline:float;
		var curAdrenaline:float;

		maxAdrenaline = thePlayer.GetStatMax(BCS_Focus);
		curAdrenaline = thePlayer.GetStat(BCS_Focus);
		PushStatItem(GFxData, "panel_common_statistics_tooltip_adrenaline_current", (string)FloorF(curAdrenaline));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_adrenaline_max", (string)RoundMath(maxAdrenaline));
		
	}
	
	private function GetOffenseTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var curStats:SPlayerOffenseStats;
		curStats = GetWitcherPlayer().GetOffenseStatsList();
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_fast_dps", StatToStr(curStats.steelFastDPS));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_fast_crit_chance", StatToStr(curStats.steelFastCritChance) + "%");
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_fast_crit_dmg", StatToStr(curStats.steelFastCritDmg) + "%");
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_strong_dps", StatToStr(curStats.steelStrongDPS));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_strong_crit_chance", StatToStr(curStats.steelStrongCritChance) + "%");
		PushStatItem(GFxData, "panel_common_statistics_tooltip_steel_strong_crit_dmg", StatToStr(curStats.steelStrongCritDmg) + "%");
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_fast_dps", StatToStr(curStats.silverFastDPS));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_fast_crit_chance", StatToStr(curStats.silverFastCritChance) + "%");
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_fast_crit_dmg", StatToStr(curStats.silverFastCritDmg) + "%");
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_strong_dps", StatToStr(curStats.silverStrongDPS));
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_strong_crit_chance", StatToStr(curStats.silverStrongCritChance) + "%");
		PushStatItem(GFxData, "panel_common_statistics_tooltip_silver_strong_crit_dmg", StatToStr(curStats.silverStrongCritDmg) + "%");
		
		PushStatItem(GFxData, "panel_common_statistics_tooltip_crossbow_dps", StatToStr(curStats.crossbowCritChance) + "%");
		PushStatItem(GFxData, "panel_common_statistics_tooltip_crossbow_crit_chance", StatToStr(curStats.crossbowSteelDmg));
	}
	
	private function GetDefenseTooltipData(out GFxData: CScriptedFlashArray):void
	{
		PushStatItem(GFxData, "panel_common_statistics_tooltip_armor", "");
		PushStatItem(GFxData, "slashing_resistance", GetStatValue('slashing_resistance_perc') + "%");
		PushStatItem(GFxData, "piercing_resistance", GetStatValue('piercing_resistance_perc') + "%");
		PushStatItem(GFxData, "bludgeoning_resistance", GetStatValue('bludgeoning_resistance_perc') + "%");
		PushStatItem(GFxData, "rending_resistance", GetStatValue('rending_resistance_perc') + "%");
		PushStatItem(GFxData, "elemental_resistance", GetStatValue('elemental_resistance_perc') + "%");
		PushStatItem(GFxData, "poison_resistance", GetStatValue('poison_resistance_perc') + "%");
		PushStatItem(GFxData, "fire_resistance", GetStatValue('fire_resistance_perc') + "%");
		PushStatItem(GFxData, "bleeding_resistance", GetStatValue('bleeding_resistance_perc') + "%");
		PushStatItem(GFxData, "knockdown_resistance", GetStatValue('knockdown_resistance_perc') + "%");
	}
	
	private function GetSignsTooltipData(out GFxData: CScriptedFlashArray):void
	{
		var sp : SAbilityAttributeValue;
		var witcher : W3PlayerWitcher;
		
		witcher = GetWitcherPlayer();
		
		sp = witcher.GetTotalSignSpellPower(S_Magic_1);
		PushStatItem(GFxData, 'aard_intensity', (string)RoundMath(sp.valueMultiplicative*100) + "%");
		
		sp = witcher.GetTotalSignSpellPower(S_Magic_2);
		PushStatItem(GFxData, 'igni_intensity', (string)RoundMath(sp.valueMultiplicative*100) + "%");
		
		sp = witcher.GetTotalSignSpellPower(S_Magic_3);
		PushStatItem(GFxData, 'yrden_intensity', (string)RoundMath(sp.valueMultiplicative*100) + "%");
		
		sp = witcher.GetTotalSignSpellPower(S_Magic_4);
		PushStatItem(GFxData, 'quen_intensity', (string)RoundMath(sp.valueMultiplicative*100) + "%");
		
		sp = witcher.GetTotalSignSpellPower(S_Magic_5);
		PushStatItem(GFxData, 'axii_intensity', (string)RoundMath(sp.valueMultiplicative*100) + "%");
	}
	
	private function PushStatItem(out statsList: CScriptedFlashArray, label:string, value:string):void
	{
		var statItemData : CScriptedFlashObject;
		statItemData = m_flashValueStorage.CreateTempFlashObject();
		statItemData.SetMemberFlashString("name", GetLocStringByKeyExt(label));
		statItemData.SetMemberFlashString("value", value);
		statsList.PushBackFlashObject(statItemData);
	}
	
	private function StatToStr(value:float):string
	{
		return (string)NoTrailZeros(RoundTo(value, 1));
	}

	public function UpdatePlayerStatisticsData()
	{
		UpdateVitality();
		UpdateToxicity();
	}
	
	private function updateSentStatValue(statName:name, statValue:string):void
	{
		var sentStat : SentStatsData;
		var i : int;
		
		for (i = 0; i < _sentStats.Size(); i += 1)
		{
			if (_sentStats[i].statName == statName)
			{
				_sentStats[i].statValue = statValue;
				return;
			}
		}
		
		sentStat.statName = statName;
		sentStat.statValue = statValue;
		_sentStats.PushBack(sentStat);
	}
	
	private function getLastSentStatValue(statName:name) : string
	{
		var i : int;
		
		for (i = 0; i < _sentStats.Size(); i += 1)
		{
			if (_sentStats[i].statName == statName)
			{
				return _sentStats[i].statValue;
			}
		}
		
		return "";
	}
	
	private function GetSignStat(targetSkill:ESkill):string
	{
		var powerStatValue	: SAbilityAttributeValue;
		var damageTypeName 	: name;
		var points 			: float;
		
		GetWitcherPlayer().GetSignStats(targetSkill, damageTypeName, points, powerStatValue);
		return NoTrailZeros(RoundMath(powerStatValue.valueMultiplicative * 100)) + " %";
	}
	
	function GetCurrentEquippedQuickSlot() : EEquipmentSlots
	{
		var currentSelectedQuickItem : SItemUniqueId;
		var itemOnSlot : SItemUniqueId;
		var i : int;
		var slot : EEquipmentSlots;
		slot = 	EES_InvalidSlot;
		
		currentSelectedQuickItem = GetWitcherPlayer().GetSelectedItemId();
		for( i = EES_Petard1; i < EES_Quickslot2 + 1; i += 1 )
		{
			if(GetWitcherPlayer().GetItemEquippedOnSlot(i,itemOnSlot))
			{
				if( currentSelectedQuickItem == itemOnSlot )
				{
					return i;
				}
			}
		}
		return EES_InvalidSlot;
	}
	
	event OnTick( timeDelta : float )
	{
		LogChannel('INVTICK'," timeDelta "+timeDelta);
	}
	
	event  OnGlobalUpdate()
	{
		UpdateData();
	}
	
	event  OnSetInventoryGridFilter( item : SItemUniqueId )
	{
		var filterType : EInventoryFilterType;
		filterType = _playerInv.GetFilterTypeByItem(item);
		_playerInv.SetFilterType( filterType );
		m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( getTabFromFilter(filterType) ));
	}
	
	event  OnSaveItemGridPosition( item : SItemUniqueId, gridPos : int )
	{
		SetGridPosition(item, gridPos);
	}
	
	private function SetGridPosition( item : SItemUniqueId, gridPos : int ) : void
	{
		var UIData : SInventoryItemUIData;
		UIData = _inv.GetInventoryItemUIData( item );
		UIData.gridPosition = gridPos;
		_inv.SetInventoryItemUIData( item , UIData );
	}
	private function GetGridPosition( item : SItemUniqueId ) : int
	{
		var UIData : SInventoryItemUIData;
		UIData = _inv.GetInventoryItemUIData( item );
		return UIData.gridPosition;
	}
	
	event  OnTooltipLoaded()
	{
		
	}	

	event  OnHighlightPaperDollSlot( slotType : int )
	{
		m_flashValueStorage.SetFlashInt("inventory.grid.paperdoll.highlight",slotType);
	}
	
	event  OnClosingMenu()
	{
		SaveStateData();
		super.OnClosingMenu();
		theGame.GetGuiManager().SetLastOpenedCommonMenuName( GetMenuName() );
		
		thePlayer.ForceSoundAppearanceUpdate();
		
		if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())		
		{
			theGame.GetTutorialSystem().uiHandler.OnClosingMenu('ShopMenu');
		}
		theGame.GetGuiManager().SendCustomUIEvent( 'ClosingShopMenu' );
		
		if (_playerInv)
		{
			delete _playerInv;
		}
		
		if (_paperdollInv)
		{
			delete _paperdollInv;
		}
		
		if (_horseInv)
		{
			delete _horseInv;
		}
		
		if (_horsePaperdollInv)
		{
			delete _horsePaperdollInv;
		}
		
		if (_tooltipDataProvider)
		{
			delete _tooltipDataProvider;
		}
		
		if (_containerInv)
		{
			delete _containerInv;
		}
		
		if (_shopInv)
		{
			delete _shopInv;
		}
		
		if (_quantityPopupData)
		{
			delete _quantityPopupData;
		}
		
		if (_statsContext)
		{
			delete _statsContext;
		}
		
		if (_paperdollContext)
		{
			delete _paperdollContext;
		}
		
		if (_invContext)
		{
			delete _invContext;
		}
		
		if (_externGridContext)
		{
			delete _externGridContext;
		}
		
		if (_bookPopupData)
		{
			delete _bookPopupData;
		}
		
		if (_charStatsPopupData)
		{
			_charStatsPopupData.ClosePopupOverlay();
			delete _charStatsPopupData;
		}
		
		if (_itemInfoPopupData)
		{
			delete _itemInfoPopupData;
		}
		
		if (_destroyConfPopData)
		{
			delete _destroyConfPopData;
		}
		
		if (_paintingPopupData)
		{
			delete _paintingPopupData;
		}
		
		theGame.GetGuiManager().RequestClearScene();
	}

	event  OnCloseMenu()
	{
		CloseMenu();
		
		if( m_parentMenu )
		{
			m_parentMenu.ChildRequestCloseMenu();
		}
		
		if( _currentEqippedQuickSlot != EES_InvalidSlot )
		{
			GetWitcherPlayer().ClearSelectedItemId();
			GetWitcherPlayer().SelectQuickslotItem(_currentEqippedQuickSlot);
		}
		
		if( _container ) 
		{
			_container.OnContainerClosed();
		}
	}
	
	
	event  OnSetActiveItem()
	{
		
		LogChannel('ITEMDRAG'," OnSetActiveItem ");
		
	}
	
	event  OnSwapItems( playerItem : SItemUniqueId, paperdollItem : SItemUniqueId, paperdollSlot : int )
	{
		OnEquipItem(playerItem, paperdollSlot, 1);
	}
	
	event  OnUseDye( item : SItemUniqueId, optional isPreview : bool )
	{
		var targetList : array<int>;
		var itemOnSlot : SItemUniqueId;
		var wplayer    : W3PlayerWitcher;
		
		
		var isNetflixSet : bool;
		
		wplayer = GetWitcherPlayer();
		
		m_dyePreviewMode = true;
		
		if( wplayer.GetItemEquippedOnSlot( EES_Armor, itemOnSlot ) && _inv.CanItemBeColored( itemOnSlot ) )
		{
			targetList.PushBack( EES_Armor );
		}
		
		if( wplayer.GetItemEquippedOnSlot( EES_Gloves, itemOnSlot ) && _inv.CanItemBeColored( itemOnSlot ) )
		{
			targetList.PushBack( EES_Gloves );
		}
		
		if( wplayer.GetItemEquippedOnSlot( EES_Pants, itemOnSlot ) && _inv.CanItemBeColored( itemOnSlot ) )
		{
			targetList.PushBack( EES_Pants );
		}
		
		if( wplayer.GetItemEquippedOnSlot( EES_Boots, itemOnSlot ) && _inv.CanItemBeColored( itemOnSlot ) )
		{
			targetList.PushBack( EES_Boots );
		}	
		
		if( targetList.Size() > 0 )
		{
			ShowSelectionMode( item, targetList );
		}
		else
		{
			
			if( wplayer.GetItemEquippedOnSlot( EES_Armor, itemOnSlot ) && _inv.ItemHasTag( itemOnSlot, 'NetflixSet' ) )
				isNetflixSet = true;
			if( wplayer.GetItemEquippedOnSlot( EES_Gloves, itemOnSlot ) && _inv.ItemHasTag( itemOnSlot, 'NetflixSet' ) )
				isNetflixSet = true;
			if( wplayer.GetItemEquippedOnSlot( EES_Pants, itemOnSlot ) && _inv.ItemHasTag( itemOnSlot, 'NetflixSet' ) )
				isNetflixSet = true;
			if( wplayer.GetItemEquippedOnSlot( EES_Boots, itemOnSlot ) && _inv.ItemHasTag( itemOnSlot, 'NetflixSet' ) )
				isNetflixSet = true;
				
			if(isNetflixSet)
				showNotification( GetLocStringByKeyExt( "inventory_cant_apply_dye_netflix" ) );
			else
				showNotification( GetLocStringByKeyExt( "inventory_cant_apply_dye" ) );
			
			OnPlaySoundEvent( "gui_global_denied" );
		}
	}
	
	event  OnPutInSocket( item : SItemUniqueId )
	{
		var targetList : array<int>;
		var itemOnSlot : SItemUniqueId;
		var uiStateRunes : W3TutorialManagerUIHandlerStateRunes;
		var uiStateArmorUpgrades : W3TutorialManagerUIHandlerStateArmorUpgrades;
		
		if (thePlayer.IsInCombat())
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
		} 
		else		
		{
			if(ShouldProcessTutorial('TutorialRunesSelectSword') && thePlayer.inv.ItemHasTag(item, 'WeaponUpgrade'))
			{
				uiStateRunes = (W3TutorialManagerUIHandlerStateRunes)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				if(uiStateRunes)
				{
					uiStateRunes.OnSelectingSword();
				}
			}
			else if(ShouldProcessTutorial('TutorialArmorSocketsSelectTab') && thePlayer.inv.ItemHasTag(item, 'ArmorUpgrade'))
			{
				uiStateArmorUpgrades = (W3TutorialManagerUIHandlerStateArmorUpgrades)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				if(uiStateArmorUpgrades)
				{
					uiStateArmorUpgrades.OnSelectingArmor();
				}
			}
			
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_SilverSword);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_SteelSword);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_Armor, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_Armor);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_Boots, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_Boots);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_Pants, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_Pants);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_Gloves, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_Gloves);
			}
		
			if (GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, itemOnSlot) && _playerInv.CanBeUpgradedBy(itemOnSlot, item))
			{
				targetList.PushBack(EES_RangedWeapon);
			}
		
		
		if (targetList.Size() > 0)
		{	
			ShowSelectionMode(item, targetList);
		}
		else
		{
			showNotification(GetLocStringByKeyExt("panel_inventory_notification_no_upgradable_items"));
			OnPlaySoundEvent("gui_global_denied");
		}
		
		
		}
	}
	
	public function ShowApplyOilMode( item : SItemUniqueId )
	{
		var targetList : array<int>;
		var itemOnSlot : SItemUniqueId; 
		
		
		
		if (_inv.ItemHasTag(item, 'SteelOil') && GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, itemOnSlot) && thePlayer.inv.IsItemSteelSwordUsableByPlayer(itemOnSlot))
		{
			targetList.PushBack(EES_SteelSword);
		}
		
		if (_inv.ItemHasTag(item, 'SilverOil') && GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, itemOnSlot) && thePlayer.inv.IsItemSilverSwordUsableByPlayer(itemOnSlot))
		{
			targetList.PushBack(EES_SilverSword);
		}
		
		if (targetList.Size() > 0)
		{
			ShowSelectionMode(item, targetList);
		}
		else
		{
			
			
		}
	}
	
	event  OnRepairItem( item : SItemUniqueId )
	{
		var targetList : array<int>;
		var itemOnSlot : SItemUniqueId;

					
		
		if (_inv.ItemHasTag(item, 'WeaponReapairKit') )
		{
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_SteelSword);
				}
			}
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_SilverSword);
				}
			}
		}
		
		if (_inv.ItemHasTag(item, 'ArmorReapairKit') )
		{
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_Armor, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_Armor);
				}
			}
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_Boots, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_Boots);
				}
			}
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_Pants, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_Pants);
				}
			}
			if ( GetWitcherPlayer().GetItemEquippedOnSlot(EES_Gloves, itemOnSlot) )
			{
				if ( GetWitcherPlayer().IsItemRepairAble ( itemOnSlot ) )
				{
					targetList.PushBack(EES_Gloves);
				}
			}
		}
		
		if (targetList.Size() > 0)
		{	
			ShowSelectionMode(item, targetList);
		}
		else
		{
			
			showNotification(GetLocStringByKeyExt("panel_inventory_nothing_to_repair"));
			OnPlaySoundEvent("gui_global_denied");
		}
	}
	
	public function TryEquipToPockets(item : SItemUniqueId, slot : int ) : bool
	{
		var targetList : array<int>;
		
		
		var bomb, mask, usable : bool;	
		
		mask = _inv.IsItemMask(item);	
		usable = _inv.IsItemUsable(item);
		
		
		if( slot == EES_Quickslot1 || slot == EES_Quickslot2 )
		{
			if(mask)
				targetList.PushBack(EES_Quickslot2);
			else
				targetList.PushBack(EES_Quickslot1);
			
		}	
		else if( slot == EES_Petard1 || slot == EES_Petard2 )
		{
			targetList.PushBack(EES_Petard1);
			
			bomb = true;
			
		}	
		else if( IsSlotPotionSlot(slot) )
		{
			targetList.PushBack(EES_Potion1);
			targetList.PushBack(EES_Potion2);
			targetList.PushBack(EES_Potion3);
			targetList.PushBack(EES_Potion4);
		}
		
		if (targetList.Size() > 0)
		{
			if (theInput.LastUsedPCInput() || mask || usable || bomb)	
			{
				EquipToFirstEmptySocket	(item, targetList);
			}
			else
			{						
				ShowSelectionMode(item, targetList);		
			}
			return true;
		}
		
		return false;
	}
	
	private function EquipToFirstEmptySocket(itemId : SItemUniqueId, targetSlotList : array< int >):void
	{
		var i, len       : int;
		var currentSlot  : int;
		var equippedItem : SItemUniqueId;
		
		len = targetSlotList.Size();
		if (len > 0)
		{
			for (i = 0; i < len; i += 1)
			{
				currentSlot = targetSlotList[i];
				GetWitcherPlayer().GetItemEquippedOnSlot(currentSlot, equippedItem);
				if (!_inv.IsIdValid(equippedItem))
				{
					OnEquipItem(itemId, currentSlot, 1);
					return;
				}
			}
			
			
			OnEquipItem(itemId, targetSlotList[len - 1], 1);
		}
	}
	
	event  OnDropOnPaperdoll(item : SItemUniqueId, slot : int, quantity : int)
	{
		OnEquipItem(item, slot, quantity);
	}
	
	event  OnApplyOil(item : SItemUniqueId, slot : int)
	{
		ApplyOil(item, slot);
	}
	
	event  OnApplyUpgrade(item : SItemUniqueId, slot : int)
	{
		ApplyUpgrade(item, slot);
	}
	
	event  OnApplyRepairKit(item : SItemUniqueId, slot : int)
	{
		ApplyRepairKit(item, slot);
	}
	
	event  OnApplyDye( item : SItemUniqueId, slot : int )
	{
		ApplyDye( item, slot );
	}
	
	event  OnEquipItem( item : SItemUniqueId, slot : int, quantity : int )
	{
		var	paperdollItemsToUpdate : array< SItemUniqueId >;
		var	gridItemsToUpdate	   : array< SItemUniqueId >;
		var itemAlreadyEuipped     : bool;
		var keepSelection          : bool;
		
		var OnSlot      : bool;
		var itemOnSlot  : SItemUniqueId;
		var boltsItem   : SItemUniqueId;		
		var hItem 	   	: SItemUniqueId;
		var uiData     	: SInventoryItemUIData;				
		var abls	    : array< name >;
		var i		    : int;
		var filterType  : EInventoryFilterType;
		
		OnSlot = false;
		itemAlreadyEuipped = false;
		
		if( _currentInv == _containerInv )
		{
			if( _shopNpc )
			{
				BuyItem(item, quantity);
				UpdateShop();
				UpdatePlayerStatisticsData();
			}
			else
			{
				TakeItem(item, quantity);
				UpdateContainer();
				UpdatePlayerStatisticsData();
			}
		}
		else
		{
			if( _shopNpc )
			{
				SellItem(item,quantity);
				UpdateShop();
				UpdatePlayerStatisticsData();
			}
			else if( _containerInv )
			{
				GiveItem(item, quantity);
				UpdateContainer();
				UpdatePlayerStatisticsData();
			}
			else
			{
				if ( !thePlayer.HasRequiredLevelToEquipItem(item) ) 
				{
					showNotification(GetLocStringByKeyExt("panel_inventory_cannot_equip_low_level"));
					OnPlaySoundEvent("gui_global_denied");
					return false;
				}
				
				LogChannel('INVENTORY'," item;  slot "+slot );
				
				GetWitcherPlayer().GetItemEquippedOnSlot( slot, itemOnSlot ); 
				if ( IsItemInPreview( item ) )
				{
					m_fxSetPaperdollPreviewIcon.InvokeSelfTwoArgs( FlashArgInt( slot ), FlashArgBool( false ) );
				}
				ResetDisplayPreviewCache( item, slot, gridItemsToUpdate );
				
				if( slot == EES_Bolt )
				{
					if (!GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_RangedWeapon))
					{
						showNotification(GetLocStringByKeyExt("panel_inventory_cannot_equip_bolts"));
						OnPlaySoundEvent("gui_global_denied");
						return false;
					}
					else if (_inv.ItemHasTag(itemOnSlot,theGame.params.TAG_INFINITE_AMMO))
					{
						
						if(_inv.GetItemName(itemOnSlot) == 'Harpoon Bolt')
						{
							showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_now"));
							OnPlaySoundEvent("gui_global_denied");
							return false;
						}
					
						OnSlot = true;
					}					
				}
				
				if ( slot == EES_HorseBlinders || slot == EES_HorseSaddle || slot == EES_HorseBag || slot == EES_HorseTrophy )
				{
					if (!GetWitcherPlayer().GetHorseManager())
					{
						return true; 
					}
					
					
					
					
					hItem = GetWitcherPlayer().GetHorseManager().MoveItemToHorse(item, 1);
					itemOnSlot = GetWitcherPlayer().GetHorseManager().EquipItem(hItem);
					
					if (_inv.IsIdValid(itemOnSlot))
					{
						InventoryRemoveItem(item, true);
						InventoryUpdateItem(itemOnSlot);
						
						itemAlreadyEuipped = true;
					}
					else
					{
						InventoryRemoveItem(item, false);
					}
					
					
					
						
					PaperdollUpdateHorseItem(hItem);
					
					UpdateEncumbranceInfo();
					
					PlayItemEquipSound( _horsePaperdollInv.GetInventoryComponent().GetItemCategory(item) );
					
					return true; 
				}
				else
				{
					PlayItemEquipSound( _inv.GetItemCategory(item) );
					
					itemAlreadyEuipped = GetWitcherPlayer().IsItemEquipped(item);
					_playerInv.EquipItem( item, slot );	
				}
				
				UpdatePlayerStatisticsData();
				
				PlayPaperdollAnimation(_inv.GetItemCategory( item ));
			}
		}
		
		if (!OnSlot && _inv.IsIdValid(itemOnSlot) && !_inv.ItemHasTag(itemOnSlot, 'NoShow'))
		{
			SetGridPosition(itemOnSlot, GetGridPosition(item));
			
			keepSelection = !_inv.ItemHasTag(itemOnSlot, 'NoShow');
			InventoryRemoveItem(item, keepSelection );
			
			if (!itemAlreadyEuipped)
			{
				gridItemsToUpdate.PushBack(itemOnSlot);
				
				filterType = _playerInv.GetFilterTypeByItem(itemOnSlot);
				_playerInv.SetFilterType( filterType );
				UpdateInventoryFilter( filterType );
			}
			else
			{
				paperdollItemsToUpdate.PushBack(itemOnSlot);
			}
			
			
			
		}
		else
		{
			InventoryRemoveItem(item);
		}
		
		
		UpdateEncumbranceInfo();
		if (slot == EES_RangedWeapon)
		{
			PaperdollUpdateAll();
		}
		else
		{
			paperdollItemsToUpdate.PushBack(item);
			
			if (_inv.GetEnchantment(item) == 'Runeword 6')
			{
				AddEquippedPotionsToList(paperdollItemsToUpdate);
			}
			
			if (_inv.IsItemSetItem(item))
			{
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Petard1);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Petard2);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Quickslot1);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Quickslot2);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Potion1);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Potion2);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Potion3);
				PushIfItemEquipped(paperdollItemsToUpdate, EES_Potion4);
				
				PopulateTabData(InventoryMenuTab_Potions);
			}
			
			PaperdollUpdateItemsList(paperdollItemsToUpdate);
		}
		
		if( gridItemsToUpdate.Size() > 0 )
		{
			InventoryUpdateItems( gridItemsToUpdate );
		}
		
		OnSaveItemGridPosition(item, -1);		
		UpdateGuiSceneEntityItems();
	}
	
	
	private function PlayPaperdollAnimation( category : name ):void
	{
		if (m_player)
		{
			((CActor)m_player).SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)PGMM_Inventory );
			
			switch (category)
			{
				case 'armor':
					m_player.RaiseEvent('ShowArmor_Inv');
					break;
				case 'gloves':
					m_player.RaiseEvent('ShowGlove_Inv');
					break;
				case 'pants':
					m_player.RaiseEvent('ShowPants_Inv');
					break;
				case 'boots':
					m_player.RaiseEvent('ShowBoots_Inv');
					break; 
				case 'steelsword':
					m_player.RaiseEvent('DrawSteelSword_Inv');
					break;
				case 'silversword':
					m_player.RaiseEvent('DrawSilverSword_Inv');
					break;
				case 'crossbow':
					m_player.RaiseEvent('DrawCrossbow_Inv');
					break;
				default:
					break;
			}
		}
	}
	
	function FindEmptySlot( first : EEquipmentSlots, last : EEquipmentSlots, out outSlot : int ) : bool
	{
		var i :	int;
		var itemOnSlot : SItemUniqueId;
		
		for(i = first; i < last + 1; i += 1 )
		{
			GetWitcherPlayer().GetItemEquippedOnSlot(i, itemOnSlot);
			
			if( !_inv.IsIdValid(itemOnSlot) )
			{
				outSlot = i;
				return true;
			}
		}
		return false;
	}
	
	function FindMaskSlot( first : EEquipmentSlots, last : EEquipmentSlots, out outSlot : int ) : bool
	{
		var i :	int;
		var itemOnSlot : SItemUniqueId;
		
		for(i = first; i < last + 1; i += 1 )
		{
			GetWitcherPlayer().GetItemEquippedOnSlot(i, itemOnSlot);
			
			if ( _inv.IsItemMask( itemOnSlot ) )
			{
				outSlot = i;
				return true;
			}
		}
		return false;
	}
	
	event  OnUnequipItem( item : SItemUniqueId, moveToIndex : int )
	{
		if (thePlayer.IsInCombat())
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
			return false;
		}

		return UnequipItem(item, moveToIndex);
	}
	
	public function UnequipItem( item : SItemUniqueId, moveToIndex : int ) : bool
	{
		var forceInvAllUpdate : bool;
		var isSetBonusActive  : bool;
		
		var filterType 	   : EInventoryFilterType;
		var itemOnSlot 	   : SItemUniqueId;
		var crossbowOnSlot : SItemUniqueId;
		var horseItem 	   : SItemUniqueId;
		var slot 		   : EEquipmentSlots;
		var itemsList      : array<SItemUniqueId>;
		var gridUpdateList : array<SItemUniqueId>;
		var abls	       : array<name>;
		var i, targetSlot  : int;
		
		forceInvAllUpdate = false;
		
		if (thePlayer.IsInCombat())
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
			return false;
		}
		
		if ( _horsePaperdollInv.GetInventoryComponent().IsIdValid(item) && _horsePaperdollInv.isHorseItem(item))
		{
			slot = _horsePaperdollInv.GetInventoryComponent().GetSlotForItemId(item);
			horseItem = GetWitcherPlayer().GetHorseManager().UnequipItem(slot);
			
			PlayItemUnequipSound( _inv.GetItemCategory(horseItem) );
			
			m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( GetTabIndexForSlot(slot) ));
			
			InventoryUpdateItem(horseItem);
			
			PaperdollUpdateAll(); 
			
			UpdateEncumbranceInfo();
			
			
			
			
			PlayItemUnequipSound( _horsePaperdollInv.GetInventoryComponent().GetItemCategory(item) );
			
			return true; 
		}
		
		if( _containerInv )
		{
			GiveItem(item, 1);
			UpdateContainer();
			
			InventoryUpdateItem(item);
			PaperdollRemoveItem(item);
			UpdatePlayerStatisticsData();
		}
		else if (_inv.IsIdValid(item))
		{
			if (_inv.IsItemBolt(item) && _inv.ItemHasTag(item,theGame.params.TAG_INFINITE_AMMO))
			{
				return false;
			}
			
			LogChannel('ITEMDRAG'," OnUnequipItem "+_playerInv.GetItemName(item)+" moveToIndex "+moveToIndex);
			if( moveToIndex > -1 )
			{
				_playerInv.MoveItem( item , moveToIndex );
			}
			
			PlayItemUnequipSound( _inv.GetItemCategory(item) );
			
			if (_inv.IsItemCrossbow(item) && GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt,itemOnSlot))
			{
				_playerInv.UnequipItem( itemOnSlot );
				PaperdollRemoveItem(itemOnSlot);
				
				if (!_inv.ItemHasTag(itemOnSlot,theGame.params.TAG_INFINITE_AMMO))
				{
					forceInvAllUpdate = true;
				}
			}
			
			isSetBonusActive = GetWitcherPlayer().IsSetBonusActive( EISB_RedWolf_2 );
			
			targetSlot = _inv.GetSlotForItemId( item );
			ResetDisplayPreviewCache( item, slot, gridUpdateList );
			
			_playerInv.UnequipItem( item );
			filterType = _playerInv.GetFilterTypeByItem(item);
			_playerInv.SetFilterType( filterType );
			UpdateInventoryFilter(filterType);
			
			if (_inv.IsItemSetItem(item) && isSetBonusActive)
			{
				PushIfItemEquipped(itemsList, EES_Petard1);
				PushIfItemEquipped(itemsList, EES_Petard2);
				PushIfItemEquipped(itemsList, EES_Quickslot1);
				PushIfItemEquipped(itemsList, EES_Quickslot2);
				PushIfItemEquipped(itemsList, EES_Potion1);
				PushIfItemEquipped(itemsList, EES_Potion2);
				PushIfItemEquipped(itemsList, EES_Potion3);
				PushIfItemEquipped(itemsList, EES_Potion4);
				
				PopulateTabData(InventoryMenuTab_Potions);
			}
			
			if (forceInvAllUpdate)
			{
				PopulateTabData(getTabFromItem(item));
			}
			else
			{
				gridUpdateList.PushBack( item );
			}
			
			if (_inv.GetEnchantment(item) == 'Runeword 6')
			{
				AddEquippedPotionsToList(itemsList);
			}
			
			PaperdollRemoveItem(item);
			
			if(_inv.IsItemBolt(item) && GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt, itemOnSlot))
			{
				itemsList.PushBack(itemOnSlot);
			}
			
			PaperdollUpdateItemsList(itemsList);
			
			UpdatePlayerStatisticsData();
		}
		
		if( gridUpdateList.Size() > 0 )
		{
			InventoryUpdateItems( gridUpdateList );
		}
		
		UpdateEncumbranceInfo();
		UpdateGuiSceneEntityItems();
		
			
		switch (_inv.GetItemCategory( item ))
			{
			case 'steelsword':
				m_player.RaiseEvent('RemoveSteelSword_Inv');
				break;
			case 'silversword':
				m_player.RaiseEvent('RemoveSilverSword_Inv');
				break;
			case 'crossbow':
				m_player.RaiseEvent('RemoveCrossbow_Inv');
				break;
			default:
				break;
			}
		
		return true;
	}
	
	private function PushIfItemEquipped(out itemsList : array<SItemUniqueId>, slotId:EEquipmentSlots):void
	{
		var itemOnSlot : SItemUniqueId;
		
		if(GetWitcherPlayer().GetItemEquippedOnSlot(slotId, itemOnSlot) && _inv.IsIdValid(itemOnSlot))
		{
			itemsList.PushBack(itemOnSlot);
		}
	}
	
	public function UpdateInventoryFilter( filterType : EInventoryFilterType ):void
	{
		m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( getTabFromFilter(filterType) ));
	}
	
	event  OnDragItemStarted( itemId : SItemUniqueId )
	{
		var filterType : EInventoryFilterType;
		var slot : EEquipmentSlots;
		
		if ( _horsePaperdollInv.GetInventoryComponent().IsIdValid(itemId) && _horsePaperdollInv.isHorseItem(itemId))
		{
			slot = _horsePaperdollInv.GetInventoryComponent().GetSlotForItemId(itemId);
			m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( GetTabIndexForSlot(slot) ));
		}
		else
		{
			filterType = _playerInv.GetFilterTypeByItem(itemId);			
			UpdateInventoryFilter(filterType);
		}
	}
	
	event  OnEmptySlotActivate( equipID : int )
	{
		var targetTabIndex : InventoryMenuTabIndexes;
		
		targetTabIndex = GetTabIndexForSlot(equipID);
		
		m_flashValueStorage.SetFlashInt("OnTabSelectRequested", -1); 
		m_flashValueStorage.SetFlashInt("OnTabSelectRequested", targetTabIndex);
	}
	
	protected function GetTabIndexForSlot(equipID : int) : int
	{
		switch (equipID)
		{
			case EES_SilverSword:
			case EES_SteelSword:
			case EES_Armor:
			case EES_Boots: 
			case EES_Pants: 
			case EES_Gloves:
			case EES_RangedWeapon:
			case EES_Bolt:
			default:
				return InventoryMenuTab_Weapons;
			case EES_Petard1: 
			
				return InventoryMenuTab_Potions;
			case EES_Quickslot1:
			
				if (_currentState == IMS_Stash)
				{
					return StashMenuTab_Default;
				}
				else
				{
					return InventoryMenuTab_Default;
				}
			case EES_Potion1:
			case EES_Potion2:
			case EES_Potion3:
			case EES_Potion4:
				return InventoryMenuTab_Potions;
			
			case EES_HorseTrophy:
			case EES_HorseBlinders:
			case EES_HorseSaddle:
			case EES_HorseBag:
				return InventoryMenuTab_Default;
		}
		
		return InventoryMenuTab_Weapons;
	}
	
	event  OnDropItem( item : SItemUniqueId, quantity : int ) 
	{
		if (( _inv.ItemHasTag(item, 'SilverOil') || _inv.ItemHasTag(item, 'SteelOil') || _inv.ItemHasTag(item, 'Petard') || ( _inv.ItemHasTag(item, 'Potion') && _inv.GetItemCategory(item)!='edibles' ) ) && _playerInv.CanDrop(item))
		{
			if (_destroyConfPopData)
			{
				delete _destroyConfPopData;
			}
			
			_destroyConfPopData = new W3DestroyItemConfPopup in this;
			_destroyConfPopData.SetMessageTitle(GetLocStringByKeyExt("panel_button_common_drop"));
			_destroyConfPopData.SetMessageText(GetLocStringByKeyExt("panel_inventory_message_destroy_item"));
			_destroyConfPopData.menuRef = this;
			_destroyConfPopData.item = item;
			_destroyConfPopData.quantity = quantity;
			_destroyConfPopData.BlurBackground = true;
			
			RequestSubMenu('PopupMenu', _destroyConfPopData);
		}
		else
		{
			DropItem(item, quantity);
		}
	}

	event  OnReadBook( item : SItemUniqueId ) 
	{
		var itemCategory : name;
		var tutStateBooks : W3TutorialManagerUIHandlerStateBooks;
		var tutStateRecipeReading : W3TutorialManagerUIHandlerStateRecipeReading;
		var isSthLearned : bool;
		var updateBook : bool;
		
		updateBook = !thePlayer.inv.IsBookRead(item);
		
		
		ReadBook(item);
		
		itemCategory = thePlayer.inv.GetItemCategory( item );
		isSthLearned = false;
		if ( itemCategory == 'alchemy_recipe' || itemCategory == 'crafting_schematic' )
		{
			if ( !thePlayer.inv.ItemHasTag( item, 'BookReaded') ) 
			{	
				thePlayer.inv.AddItemTag(item,'BookReaded');
				
				isSthLearned = true;
				
				UpdateData();
				updateCurrentTab();
			}
		}
		else if (updateBook)
		{
			InventoryUpdateItem(item);
		}
		
		
		if(ShouldProcessTutorial('TutorialBooksSelectTab'))
		{
			tutStateBooks = (W3TutorialManagerUIHandlerStateBooks)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(tutStateBooks)
			{
				tutStateBooks.OnBookRead();
			}
			else if(isSthLearned)
			{
				tutStateRecipeReading = (W3TutorialManagerUIHandlerStateRecipeReading)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				if(tutStateRecipeReading)
				{
					tutStateRecipeReading.OnBookRead();
				}
			}
		}
	}	
		
	event  OnUpgradeItem( item : SItemUniqueId, slot : int, quantity : int )
	{
		var swordItem : SItemUniqueId;
		if (thePlayer.IsInCombat())
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
		} else
		{
			if(_inv.ItemHasTag(item,'SilverOil'))
			{
				GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, swordItem);
			}
			else if(_inv.ItemHasTag(item,'SteelOil'))
			{
				GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, swordItem);
			}
		
			if( _inv.IsIdValid(swordItem) )
			{
				_playerInv.UpgradeItem( swordItem, item );
				UpdateData(); 
			}
		}
	}
	
	event  OnTransferItem( item : SItemUniqueId, quantity : int, moveToIdx : int )
	{
		var filterType : EInventoryFilterType;
		var newItemID  : SItemUniqueId;
		
		if( _currentInv == _containerInv )
		{
			_containerInv.GiveItem( item, _playerInv, quantity, newItemID );
			
			UpdateContainer();
			
			filterType = _playerInv.GetFilterTypeByItem( newItemID );
			_playerInv.SetFilterType( filterType );
			m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( getTabFromFilter( filterType ) ));
			InventoryUpdateItem( newItemID );
		}
		else
		{
			InventoryRemoveItem(item, false);
		
			_playerInv.GiveItem( item, _containerInv, quantity, newItemID );	
			_playerInv.clearGridPosition(item);
			
			UpdateContainer();
		}
		
		UpdateEncumbranceInfo();
	}
	
	event  OnSellItem( itemId : SItemUniqueId, quantity : int )
	{
		var invItem : SInventoryItem;
		var itemPrice : int;
        var newShopItem : SItemUniqueId;
		
		if (!_playerInv.GetInventoryComponent().IsIdValid(itemId))
		{
			return false;
		}
		 
		invItem = _playerInv.GetInventoryComponent().GetItem( itemId ); 
		itemPrice = _shopInv.GetInventoryComponent().GetInventoryItemPriceModified( invItem, true );
		
		if ( itemPrice <= 0 || !_playerInv.CanDrop( itemId ))
		{
			showNotification(GetLocStringByKeyExt("panel_shop_not_for_sale"));
			OnPlaySoundEvent("gui_global_denied");
			return false;
		}
		
		LogChannel('QP', "OnSellItem, quantity: " + quantity);
		if ( quantity <= 1 )
		{
			
			newShopItem = SellItem( itemId, quantity );
			if ( GetInvalidUniqueId() != newShopItem )
			{
				InventoryRemoveItem(itemId);
				UpdateItemsCounter();
				UpdatePlayerStatisticsData();
				ShopUpdateItem(newShopItem);
				UpdateEncumbranceInfo();
			}
		}
		else
		{
			
			if(_shopInv.GetInventoryComponent().GetMoney() < itemPrice)
			{	
				this.showNotification(GetLocStringByKeyExt("panel_shop_notification_shopkeeper_not_enough_money"));
				OnPlaySoundEvent("gui_global_denied");
			}
			else
			{
				OpenQuantityPopup( itemId, QTF_Sell, quantity );
			}
		}
	}
	
	event  OnBuyItem( item : SItemUniqueId, quantity : int, moveToIdx : int )
	{
		var itemName : name;
		var tutorialState : W3TutorialManagerUIHandlerStateShop;
		var result : bool;
		
		
		LogChannel('QP', "OnBuyItem, quantity: " + quantity);
		itemName = _shopInv.GetItemName(item);
		if (quantity <= 1)
		{
			result = BuyItem(item , quantity );
			
			
			if(result && ShouldProcessTutorial('TutorialShopBuy') && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'Shop' && itemName == 'Local pepper vodka')
			{
				tutorialState = (W3TutorialManagerUIHandlerStateShop)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
				tutorialState.OnBoughtItem();
			}
		}
		else
		{
			
			if(_shopInv.GetInventoryComponent().GetInventoryItemPriceModified( _shopInv.GetInventoryComponent().GetItem(item), false ) > thePlayer.GetMoney())
			{			
				showNotification( GetLocStringByKeyExt("panel_shop_notification_not_enough_money") );
				OnPlaySoundEvent("gui_global_denied");
			}
			else
			{
				OpenQuantityPopup(item, QTF_Buy, quantity);
			}
		}
	}
	
	private function OpenQuantityPopup( itemId : SItemUniqueId, action : EQuantityTransferFunction, maxValue : int )
	{
		var invItem : SInventoryItem;
		var maxAffordable, money : int;

		if ( _quantityPopupData )
		{
			delete _quantityPopupData;
		}
		
		_quantityPopupData = new QuantityPopupData in this;

		switch( action )
		{
			case QTF_Sell:
				invItem = _playerInv.GetInventoryComponent().GetItem( itemId );
				_quantityPopupData.itemCost = _shopInv.GetInventoryComponent().GetInventoryItemPriceModified( invItem, true );
				_quantityPopupData.showPrice = true;
				money = _shopInv.GetInventoryComponent().GetMoney();
				maxAffordable = FloorF(money / _quantityPopupData.itemCost);
				maxAffordable = Min(maxAffordable, maxValue);
				_quantityPopupData.minValue = Min(1, maxAffordable);
				break;
			case QTF_Buy:
				_quantityPopupData.itemCost = _shopInv.GetInventoryComponent().GetItemPriceModified( itemId, false );
				_quantityPopupData.showPrice = true;
				money = thePlayer.GetMoney();
				maxAffordable = FloorF(money / _quantityPopupData.itemCost);
				maxAffordable = Min(maxAffordable, maxValue);
				_quantityPopupData.minValue = Min(1, maxAffordable);
				break;
			case QTF_Give:
			case QTF_Take:
			case QTF_Drop:
			case QTF_MoveToStash:
				_quantityPopupData.showPrice = false;
				maxAffordable = maxValue;
				_quantityPopupData.minValue = 1;
				break;
		}

		_quantityPopupData.itemId = itemId;		
		_quantityPopupData.currentValue = maxAffordable;
		_quantityPopupData.maxValue = maxValue;
		_quantityPopupData.actionType = action;
		_quantityPopupData.inventoryRef = this;
		RequestSubMenu( 'PopupMenu', _quantityPopupData );
	}

	function TakeItem( item : SItemUniqueId, quantity : int  )
	{
		_containerInv.GiveItem( item, _playerInv, quantity );
	}
	
	function GiveItem( item : SItemUniqueId, quantity : int )
	{
		if( _container && _container.OnTryToGiveItem( item ) ) 
		{
			_playerInv.GiveItem( item, _containerInv, quantity );				
		}
		else if( _containerInv )
		{
			_playerInv.GiveItem( item, _containerInv, quantity );	
		}
	}
	
	
	function BuyItem( item : SItemUniqueId, quantity : int ) : bool
	{
		var m_defMgr	     : CDefinitionsManagerAccessor;
		var filterType       : EInventoryFilterType;
		var newItemID 		 : SItemUniqueId;
		var schematic		 : SCraftingSchematic;
		var resultValue      : bool;
		var isSchematic 	 : bool;
		var startingQuantity : int;
		var itemCategory 	 : name;
		var schematicName	 : name;
		var notifyString	 : string;
		
		theTelemetry.LogWithLabelAndValue(TE_INV_ITEM_BOUGHT, _shopInv.GetItemName(item), quantity);
		filterType = _shopInv.GetFilterTypeByItem(item);
		resultValue = _shopInv.GiveItem( item, _playerInv, quantity, newItemID);
		
		if (resultValue)
		{
			itemCategory = thePlayer.GetInventory().GetItemCategory( newItemID );
			isSchematic = itemCategory == 'alchemy_recipe' || itemCategory == 'crafting_schematic';			
			
			
			if (itemCategory != 'gwint' && !isSchematic ) 
			{
				
				_playerInv.SetFilterType( filterType );
				UpdateInventoryFilter(filterType);
				m_hideSelection = true;
				
				_playerInv.clearGridPosition(newItemID);
				InventoryUpdateItem(newItemID);
			}
			
			theSound.SoundEvent( 'gui_inventory_buy' );
			
			UpdateEncumbranceInfo();
			UpdatePlayerMoney();
			UpdatePlayerStatisticsData();
			UpdateItemsCounter();
			UpdateMerchantData();
			
			if( isSchematic )
			{
				m_defMgr = theGame.GetDefinitionsManager();
				thePlayer.inv.ReadSchematicsAndRecipes( newItemID );
				
				schematicName = thePlayer.inv.GetItemName( newItemID );
				schematic = getCraftingSchematicFromName( schematicName );
				
				notifyString = GetLocStringByKeyExt( "panel_hud_craftingschematic_update_new_entry" ) + "<br>";
				notifyString += GetLocStringByKeyExt( m_defMgr.GetItemLocalisationKeyName( schematic.craftedItemName ) );
				showNotification( notifyString );
			}
			
			if (_shopInv.GetItemQuantity(item) == 0)
			{
				ShopRemoveItem(item);
			}
			else
			{
				ShopUpdateItem(item);
			}
			
			UpdatePinnedCraftingItemInfo();
		}
		else
		{
			showNotification( GetLocStringByKeyExt("panel_shop_notification_not_enough_money") );
			OnPlaySoundEvent("gui_global_denied");
		}
		
		return resultValue;
	}
	
	function SellItem( item : SItemUniqueId, quantity : int ) : SItemUniqueId
	{
		var shopInvComponent : CInventoryComponent;
		var newItemID 		 : SItemUniqueId;
		var itemCost  		 : int;
		var shopMoney        : int;
		var invItem 		 : SInventoryItem;
		var preSellQty       : int;
		var uiDataGrid 		 : SInventoryItemUIData;
		
		newItemID = GetInvalidUniqueId();
		
		if( _shopNpc )
		{
			theTelemetry.LogWithLabelAndValue(TE_INV_ITEM_SOLD, _playerInv.GetItemName(item), quantity);
			
			invItem = _playerInv.GetInventoryComponent().GetItem( item );
			shopInvComponent = _shopInv.GetInventoryComponent();
			itemCost = shopInvComponent.GetInventoryItemPriceModified( invItem, true ) * quantity;
			shopMoney = shopInvComponent.GetMoney();
			
			preSellQty = _playerInv.GetInventoryComponent().GetItemQuantity( item );
			
			if ( shopMoney < itemCost )
			{
				this.showNotification(GetLocStringByKeyExt("panel_shop_notification_shopkeeper_not_enough_money"));
				OnPlaySoundEvent("gui_global_denied");
			}
			else if ( _shopInv.ReceiveItem( item, _playerInv, quantity, newItemID) )
			{
				theSound.SoundEvent( 'gui_inventory_sell' );
				
				UpdatePlayerMoney();
				UpdateMerchantData();
				UpdateItemsCounter();
				
				UpdatePinnedCraftingItemInfo();
				
				if (preSellQty == 1 || preSellQty == quantity)
				{
					
					uiDataGrid = _playerInv.GetInventoryComponent().GetInventoryItemUIData( item );
					uiDataGrid.gridPosition = -1;
					_playerInv.GetInventoryComponent().SetInventoryItemUIData( item, uiDataGrid );
				}
			}
			else
			{
				this.showNotification(GetLocStringByKeyExt("panel_shop_not_for_sale"));
				OnPlaySoundEvent("gui_global_denied");
			}
			
		}
		return newItemID;
	}
	
	function DropItem( item : SItemUniqueId, quantity : int ) : bool
	{
		var itemOnSlot :SItemUniqueId;
		var boltSlot : SItemUniqueId;
		var updateBoltsInInv : bool;		
		
		updateBoltsInInv = false;		
		
		if ( thePlayer.IsInCombat() && ( _inv.IsItemMounted( item ) || _inv.IsItemHeld( item ) ) )
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
			return false;
		}
		
		if (_playerInv.CanDrop(item))
		{
			if (quantity <= 1)
			{
				if ( _inv.ItemHasTag(item, 'Potion') && _inv.GetItemCategory(item) != 'edibles' )
				{
					OnPlaySoundEvent( "gui_inv_potion" );
				}
				else
				{
					OnPlaySoundEvent( "gui_inventory_drop" );
				}
				
				if (_inv.IsItemCrossbow(item) && GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon,itemOnSlot))
				{
					
					
					if (itemOnSlot == item && GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt,itemOnSlot))
					{
						updateBoltsInInv = !_inv.ItemHasTag(itemOnSlot,theGame.params.TAG_INFINITE_AMMO);
						
						PaperdollRemoveItem(itemOnSlot);
						_playerInv.UnequipItem( itemOnSlot );
						
						if (updateBoltsInInv)
						{
							InventoryUpdateItem(itemOnSlot);
						}
					}
				}
				
				FinalDropItem(item, quantity); 
				
				PaperdollRemoveItem(item);
				InventoryRemoveItem(item);
				UpdateItemsCounter();
				UpdatePlayerStatisticsData();
				UpdateGuiSceneEntityItems();
			}
			else
			{
				OpenQuantityPopup(item, QTF_Drop, quantity);
			}
		}
		else
		{
			OnPlaySoundEvent( "gui_global_denied" );
		}
		
		return true;
	}
	
	public function FinalDropItem(item : SItemUniqueId, quantity : int)
	{
		var uiDataGrid : SInventoryItemUIData;
		
		
		uiDataGrid = _inv.GetInventoryItemUIData( item );
		uiDataGrid.gridPosition = -1;
		_inv.SetInventoryItemUIData( item, uiDataGrid );
		
		if ( _inv.ItemHasTag(item, 'SilverOil') || _inv.ItemHasTag(item, 'SteelOil') || _inv.ItemHasTag(item, 'Petard') || ( _inv.ItemHasTag(item, 'Potion') && _inv.GetItemCategory(item) != 'edibles' ))
		{
			_inv.RemoveItem( item );
			_inv.DespawnItem( item );
		}
		else
		{
			_playerInv.DropItem( item, quantity );
		}
		
		OnSaveItemGridPosition(item, -1);
	}
	
	public function UpdatePlayerMoney()
	{
		var commonMenu 				: CR4CommonMenu;
		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if( commonMenu )
		{
			commonMenu.UpdatePlayerOrens();
		}
	}
	
	public function UpdateMerchantData() : void
	{
		var l_merchantData	: CScriptedFlashObject;
		
		if (_shopNpc)
		{
			l_merchantData = m_flashValueStorage.CreateTempFlashObject();
			GetNpcInfo((CGameplayEntity)_shopNpc, l_merchantData);
			m_flashValueStorage.SetFlashObject("inventory.merchant.info", l_merchantData);
		}
	}	
	
	public function IsItemInPreview( itemId : SItemUniqueId ) : bool
	{
		return m_previewItems.Contains( itemId );
	}
	
	public function IsSlotInPreview( targetSlot : int  ) : bool
	{
		return m_previewSlots[targetSlot] || _inv.IsIdValid( m_dyePreviewSlots[targetSlot] );
	}
	
	public function RemovePreviewFromSlot( targetSlot : int ) : void
	{
		var i, itemsCount : int;
		var curItemId     : SItemUniqueId;
		var itemsToUpdate : array< SItemUniqueId >;
		var itemOnSlot	  : SItemUniqueId;
		
		if( !m_previewSlots[ targetSlot ] )
		{
			return;
		}
		
		itemsCount = m_previewItems.Size();
		for(i = 0; i < itemsCount; i += 1)
		{
			curItemId = m_previewItems[i];
			
			if( targetSlot == _inv.GetSlotForItemId( curItemId ) && m_previewItems.Contains( curItemId ) )
			{
				m_previewItems.Remove( curItemId );
				itemsToUpdate.PushBack( curItemId );
				continue;
			}
		}
		
		m_previewSlots[ targetSlot ] = false;
		
		_playerInv.previewItems = m_previewItems;
		_paperdollInv.previewSlots = m_previewSlots;		
		
		GetWitcherPlayer().GetItemEquippedOnSlot( targetSlot, itemOnSlot );
		if( _inv.IsIdValid( itemOnSlot ) )
		{
			PaperdollUpdateItem( itemOnSlot );
		}
		
		InventoryUpdateItems( itemsToUpdate );
		UpdateGuiSceneEntityItems();
		
		m_fxSetPaperdollPreviewIcon.InvokeSelfTwoArgs( FlashArgInt( targetSlot ), FlashArgBool( false ) );
		
		if (m_currentContext)
		{
			m_currentContext.UpdateContext();
		}
	}
	
	public function UnPreviewItem( itemId : SItemUniqueId ) : void
	{	
		var idx			 : int;
		var targetSlot   : int;
		var itemOnSlot	 : SItemUniqueId;
		
		if( !_inv.IsIdValid( itemId ) || !m_previewItems.Contains( itemId ) )
		{
			return;
		}
		
		targetSlot = _inv.GetSlotForItemId( itemId );
		
		m_previewItems.Remove( itemId );
		m_previewSlots[ targetSlot ] = false;		
		
		_playerInv.previewItems = m_previewItems;		
		_paperdollInv.previewItems = m_previewItems;
		_paperdollInv.previewSlots = m_previewSlots;
		
		GetWitcherPlayer().GetItemEquippedOnSlot( targetSlot, itemOnSlot );
		if( _inv.IsIdValid( itemOnSlot ) )
		{
			PaperdollUpdateItem( itemOnSlot );
		}
		
		InventoryUpdateItem( itemId );
		UpdateGuiSceneEntityItems();
		
		m_fxSetPaperdollPreviewIcon.InvokeSelfTwoArgs( FlashArgInt( targetSlot ), FlashArgBool( false ) );
		
		if (m_currentContext)
		{
			m_currentContext.UpdateContext();
		}
	}
	
	public function PreviewItem( itemId : SItemUniqueId ):void
	{
		var i, itemsCount : int;
		var curItemId     : SItemUniqueId;
		var previewSlot   : EEquipmentSlots;
		var itemsToUpdate : array< SItemUniqueId >;
		var itemOnSlot	  : SItemUniqueId;
		
		previewSlot = _inv.GetSlotForItemId( itemId );
		m_previewSlots[ previewSlot ] = true;
		itemsCount = m_previewItems.Size();
		
		for(i = 0; i < itemsCount; i += 1)
		{
			curItemId = m_previewItems[i];
			
			if( previewSlot == _inv.GetSlotForItemId( curItemId ) )
			{
				m_previewItems.Remove( curItemId );
				itemsToUpdate.PushBack( curItemId );
				continue;
			}
		}				
		
		m_previewItems.PushBack( itemId );
		GetWitcherPlayer().GetItemEquippedOnSlot( previewSlot, itemOnSlot );
		m_previewSlots[ previewSlot ] = true;
		
		_playerInv.previewItems = m_previewItems;
		_paperdollInv.previewSlots = m_previewSlots;
		itemsToUpdate.PushBack( itemId );
		
		if( _inv.IsIdValid( itemOnSlot ) )
		{			
			PaperdollUpdateItem( itemOnSlot );
		}
		
		InventoryUpdateItems( itemsToUpdate );
		UpdateGuiSceneEntityItems();
		PlayPaperdollAnimation( _inv.GetItemCategory( itemId ) );
		
		m_fxSetPaperdollPreviewIcon.InvokeSelfTwoArgs( FlashArgInt( previewSlot ), FlashArgBool( true ) );
	}
	
	public function PreviewDye( itemId : SItemUniqueId, targetSlot : int ) : void
	{		
		m_dyePreviewSlots.Clear();
		m_dyePreviewSlots.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );
		m_dyePreviewSlots[ targetSlot ] = itemId;
		
		UpdateGuiSceneEntityItems();
	}
	
	public function UnpreviewDye() : void
	{
		m_dyePreviewSlots.Clear();
		m_dyePreviewSlots.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );		
		
		UpdateGuiSceneEntityItems();
	}
	
	private function ResetDisplayPreviewCache( itemId : SItemUniqueId, slot : EEquipmentSlots, optional out itemsToUpdate : array < SItemUniqueId > ) : void
	{
		var curItemId : SItemUniqueId;
		var i, len    : int;
		
		m_dyePreviewSlots[ slot ] = GetInvalidUniqueId();
		m_previewItems.Remove( itemId );
		m_previewSlots[ slot ] = false;
		
		_playerInv.previewItems = m_previewItems;
		_paperdollInv.previewItems = m_previewItems;		
		_paperdollInv.previewSlots = m_previewSlots;
		
		len = m_previewItems.Size();
		
		if( slot != EES_InvalidSlot )
		{
			for( i = 0; i < len; i = i + 1)
			{
				curItemId = m_previewItems[ i ];	
				
				if( _inv.GetSlotForItemId( curItemId ) == slot )
				{
					itemsToUpdate.PushBack( curItemId );
				}
			}
		}
	}
	
	event  OnSetCurrentPlayerGrid( value : string )
	{
		if( value == "inventory.grid.container" )
		{
			if( _shopInv )
			{
				_currentInv = _shopInv;
			}
			else if (_currentState == IMS_Stash)
			{
				_currentInv = _horseInv;
			}
			else
			{
				_currentInv = _containerInv;
			}
		}
		else
		if( value == "inventory.paperdoll.horse" )
		{
			_currentInv = _horsePaperdollInv;
		}
		else
		{
			_currentInv = _playerInv;
		}
	}
	
	event  OnConsumeItem( item : SItemUniqueId ) 
	{
		if (thePlayer.IsInCombat() && !thePlayer.inv.ItemHasTag(item, 'Edibles'))
		{
			showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_combat"));
			OnPlaySoundEvent("gui_global_denied");
		} 
		else
		{
			_playerInv.ConsumeItem( item );
			FactsAdd("item_use_" + _playerInv.GetItemName(item), 1, 3);
			
			if (_currentInv.GetItemQuantity( item ) > 0)
			{
				InventoryUpdateItem(item);
			}
			else 
			{
				InventoryRemoveItem(item);
			}
			UpdateItemsCounter();
			UpdatePlayerStatisticsData();
		}
	}
	
	event  OnMoveItem( item : SItemUniqueId, moveToIndex : int )
	{
		
		_playerInv.MoveItem( item , moveToIndex );
		
		
		
		InventoryUpdateItem(item);
		m_flashValueStorage.SetFlashInt("inventory.grid.player.offset",0);
	}

	event  OnMoveItems( item : SItemUniqueId, moveToIndex : int, itemSecond : SItemUniqueId, moveToSecondIndex : int )
	{
		var itemsList : array<SItemUniqueId>;
		
		_playerInv.MoveItems( item, moveToIndex, itemSecond, moveToSecondIndex);
		
		itemsList.PushBack(item);
		itemsList.PushBack(itemSecond);
		InventoryUpdateItems(itemsList);
		
		
		
		
		
	}
	
	
	
	event  OnContainerFilterSelected( filterType : EInventoryFilterType )
	{
		
		
		UpdateContainer();
	}
	
	function SaveStateData()
	{
		UISavedData.openedCategories.Clear();
		UISavedData.openedCategories.PushBack(GetFilterTypeName(_playerInv.GetFilterType()));
		m_guiManager.UpdateUISavedData( GetMenuName(), UISavedData.openedCategories, '',UISavedData.selectedModule , UISavedData.gridItem, UISavedData.slotID );
	}	
	
	

	event  OnModuleSelected(  moduleID : int, moduleBindingName : string )
	{
		LogChannel('CONTEXT'," OnModuleSelected " + moduleBindingName);
		super.OnModuleSelected( moduleID, moduleBindingName );
		
		m_lastSelectedModuleID = moduleID;
		m_lastSelectedModuleBindingName = moduleBindingName;
		
		if (m_selectionModeActive)
		{
			return false;
		}
		
		switch (moduleBindingName)
		{
			case "inventory.grid.player" :
				ResetContext();
				createInventoryContext();
				break;
			case "inventory.grid.paperdoll.horse":
			case "inventory.paperdoll" :
				ResetContext();
				createPaperdollContext();
				break;
			case "inventory.stats" :
				ResetContext();
				createStatContext();
				break;
			case "inventory.grid.container" :
				ResetContext();
				createExternalContext();
				break;
			default:
				break;
		}
	}
	
	protected function createStatContext():void
	{
		if (_statsContext)
		{
			delete _statsContext;
		}
		
		_statsContext = new W3PlayerStatsContext in this;
		_statsContext.SetInventoryRef(this);
		m_currentContext = _statsContext;
		ActivateContext(m_currentContext);
	}
	
	protected function createPaperdollContext():void
	{
		if (_paperdollContext)
		{
			delete _paperdollContext;
		}
		
		_paperdollContext = new W3InventoryPaperdollContext in this;
		_paperdollContext.SetInventoryRef(this);
		_paperdollContext.SetSecondInventoryComponentRef(GetWitcherPlayer().GetHorseManager().GetInventoryComponent());
		m_currentContext = _paperdollContext;
		ActivateContext(m_currentContext);
	}
	
	protected function createInventoryContext():void
	{
		if (_invContext)
		{
			delete _invContext;
		}
		
		_invContext = new W3InventoryGridContext in this;
		_invContext.SetInventoryRef(this);
		m_currentContext = _invContext;
		ActivateContext(m_currentContext);
	}
	
	protected function createExternalContext():void
	{
		if (_externGridContext)
		{
			delete _externGridContext;
		}
		
		_externGridContext = new W3ExternalGridContext in this;
		_externGridContext.SetInventoryRef(this);
		m_currentContext = _externGridContext;
		ActivateContext(m_currentContext);
	}
	
	
	event  OnSelectInventoryItem(itemId:SItemUniqueId, slot:int, positionX:float, positionY:float)
	{
		var inventoryGridContext : W3InventoryItemContext;
		var tutorialState : W3TutorialManagerUIHandlerStateRunes;
		var tutorialStateBooks : W3TutorialManagerUIHandlerStateBooks;
		var tutorialStateFood : W3TutorialManagerUIHandlerStateFood;
		var tutorialStateRecipeReading : W3TutorialManagerUIHandlerStateRecipeReading;
		var tutorialStateDye : W3TutorialManagerUIHandlerStateDye;
		var tutorialStateSets : W3TutorialManagerUIHandlerStateSetItemsInfo;
		
		inventoryGridContext = (W3InventoryItemContext) m_currentContext;
		SaveSelectedItem(itemId);
		if (inventoryGridContext)
		{
			inventoryGridContext.SetContextMenuData(positionX, positionY);
			inventoryGridContext.SetCurrentSlot(slot);
			inventoryGridContext.SetCurrentItem(itemId);
		}
		
		
		if(ShouldProcessTutorial('TutorialRunesSelectRune') && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'Runes')
		{
			tutorialState = (W3TutorialManagerUIHandlerStateRunes)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialState.OnSelectedItem(itemId);
		}
		
		if(ShouldProcessTutorial('TutorialBooksSelectTab') && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'Books')
		{
			tutorialStateBooks = (W3TutorialManagerUIHandlerStateBooks)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateBooks.OnSelectedItem(itemId);
		}	
		
		if(ShouldProcessTutorial('TutorialFoodSelectTab') && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'Food')
		{
			tutorialStateFood = (W3TutorialManagerUIHandlerStateFood)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateFood.OnSelectedItem(itemId);
		}
		
		if(ShouldProcessTutorial('TutorialBooksSelectTab') && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'RecipeReading')
		{
			tutorialStateRecipeReading = (W3TutorialManagerUIHandlerStateRecipeReading)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateRecipeReading.OnSelectedItem(itemId);
		}
		
		if( ShouldProcessTutorial( 'TutorialDye' ) && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'Dye' && thePlayer.inv.IsItemDye( itemId ) )
		{
			tutorialStateDye = ( W3TutorialManagerUIHandlerStateDye )theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateDye.OnDyeSelected();
		}
		
		if( ShouldProcessTutorial( 'TutorialSetBonusesInfo' ) && theGame.GetTutorialSystem().uiHandler && theGame.GetTutorialSystem().uiHandler.GetCurrentStateName() == 'SetItemsInfo' && thePlayer.inv.ItemHasTag(itemId, theGame.params.ITEM_SET_TAG_BONUS ) )
		{
			tutorialStateSets = ( W3TutorialManagerUIHandlerStateSetItemsInfo )theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			tutorialStateSets.OnSetItemSelected();
		}
	}
	
	event  OnSelectPaperdollItem(itemId:SItemUniqueId, slot:int, positionX:float, positionY:float)
	{
		var paperdollContext : W3InventoryPaperdollContext;
		
		
		if ( slot == EES_HorseBlinders || slot == EES_HorseSaddle || slot == EES_HorseBag || slot == EES_HorseTrophy )
		{
			OnSetCurrentPlayerGrid("inventory.paperdoll.horse");
		}
		else
		{
			OnSetCurrentPlayerGrid("inventory.paperdoll");
		}
		
		paperdollContext = (W3InventoryPaperdollContext) m_currentContext;
		UISavedData.slotID = slot;
		
		if (paperdollContext)
		{
			paperdollContext.SetContextMenuData(positionX, positionY);
			paperdollContext.SetCurrentSlot(slot);
			paperdollContext.SetCurrentItem(itemId);
		}
		
		if (m_dyePreviewMode)
		{
			PreviewDye(m_selectionModeItem, slot);
		}
	}
	
	event  OnSelectPlayerStat(statId : name)
	{
		var statContext : W3PlayerStatsContext;
		statContext = (W3PlayerStatsContext) m_currentContext;
		if (statContext)
		{
			statContext.SetStatName(statId);
		}
	}
	
	function SaveSelectedItem( itemId : SItemUniqueId )
	{
		UISavedData.gridItem = itemId;
	}
	
	function ReadBook( item : SItemUniqueId )
	{
		theSound.SoundEvent( 'gui_inventory_read' );
		
		ShowBookPopup( GetLocStringByKeyExt( _inv.GetItemLocalizedNameByUniqueID( item ) ), _playerInv.GetBookText( item ), item);
	}

	function ShowBookPopup(BookTitle:string, BookText:string, item : SItemUniqueId, optional singleBookMode : bool )
	{
		if (_bookPopupData)
		{
			delete _bookPopupData;
		}
		
		m_bookPopupItem = item;
		
		_bookPopupData = new BookPopupFeedback in this;
		_bookPopupData.SetMessageTitle( BookTitle );
		_bookPopupData.SetMessageText( BookText );
		_bookPopupData.bookItemId = item;
		_bookPopupData.singleBookMode = singleBookMode;
		_bookPopupData.inventoryRef = this;
		_bookPopupData.curInventory = GetCurrentInventory();
		
		RequestSubMenu('PopupMenu', _bookPopupData);
	}
	
	function ShowPainting(item : SItemUniqueId)
	{
		var itemName:name;
		
		if (_paintingPopupData)
		{
			delete _paintingPopupData;
		}
		
		itemName = _inv.GetItemName(item);
		
		if( !_inv.IsBookRead( item ) )
		{
			_inv.ReadBook( item );
		}
		
		_paintingPopupData = new PaintingPopup in this;
		_paintingPopupData.SetMessageTitle( GetLocStringByKeyExt(_inv.GetItemLocalizedNameByUniqueID(item)) );
		_paintingPopupData.SetImagePath("img://icons/inventory/paintings/" + itemName + ".png");
		
		RequestSubMenu('PopupMenu', _paintingPopupData);
	}
	
	event  OnShowFullStats()
	{
		if (_charStatsPopupData)
		{
			delete _charStatsPopupData;
		}
		
		_charStatsPopupData = new CharacterStatsPopupData in this;
		_charStatsPopupData.HideTutorial = true;
		
		RequestSubMenu('PopupMenu', _charStatsPopupData);
	}
	
	event  OnPlaySound( soundKey : string )
	{
		theSound.SoundEvent( soundKey );
	}
	
	
	event  OnInputHandled(NavCode:string, KeyCode:int, ActionId:int)
	{
		LogChannel('GFX', "OnInputHandled, NavCode: "+NavCode+"; actionId: "+ActionId);
		if (m_currentContext)
		{
			m_currentContext.HandleUserFeedback(NavCode);
		}
	}
	
	event  OnMouseInputHandled(NavCodeAnalog : string, itemId : SItemUniqueId, slotId:int, moduleBinding : string)
	{
		var curInvContext : W3InventoryItemContext;
		
		
		OnModuleSelected(0, moduleBinding);
		
		curInvContext = (W3InventoryItemContext) m_currentContext;
		if (curInvContext)
		{
			curInvContext.SetCurrentItem(itemId);
			curInvContext.SetCurrentSlot(slotId);
			curInvContext.HandleUserFeedback(NavCodeAnalog);
		}
	}
	
	event  OnSetMouseInventoryComponent(moduleBinding : string, slotId:int)
	{
		if( moduleBinding == "inventory.grid.container" )
		{
			if (_currentState == IMS_Stash)
			{
				_currentMouseInv = _horseInv;
			}
			else if( _shopInv )
			{
				_currentMouseInv = _shopInv;
			}
			else
			{
				_currentMouseInv = _containerInv;
			}
		}
		else
		if( moduleBinding == "inventory.paperdoll" )
		{
			if ( slotId == EES_HorseBlinders || slotId == EES_HorseSaddle || slotId == EES_HorseBag || slotId == EES_HorseTrophy )
			{
				_currentMouseInv = _horsePaperdollInv;
			}
			else
			{
				_currentMouseInv = _playerInv;
			}
		}
		else
		{
			_currentMouseInv = _playerInv;
		}
	}
	
	event  OnShowItemPopup( item : SItemUniqueId )
	{
		
	}
	
	public function ShowItemInfoPopup( item : SItemUniqueId ) : void
	{
		if (_itemInfoPopupData)
		{
			delete _itemInfoPopupData;
		}
		
		_itemInfoPopupData= new ItemInfoPopupData in this;
		_itemInfoPopupData.inventoryRef = this;
		_itemInfoPopupData.invRef = GetCurrentInventory(item);
		_itemInfoPopupData.itemId = item;
		RequestSubMenu('PopupMenu', _itemInfoPopupData);
	}
	
	public function OnItemPopupClosed():void
	{
		
		m_flashValueStorage.SetFlashBool( "render.to.texture.texture.visible", true);
	}
	
	private function UpdateGuiSceneEntityItems()
	{
		var guiSceneController : CR4GuiSceneController;
		
		if (_currentState != IMS_Player)
		{
			return;
		}
		
		guiSceneController = theGame.GetGuiManager().GetSceneController();
		if ( !guiSceneController )
		{
			return;
		}
		guiSceneController.SetEntityItems( true, m_previewItems, m_dyePreviewSlots );
	}
	
	event  OnInventoryItemSelected(itemId:SItemUniqueId) : void
	{
		
	}
	
	public function ShowSelectionMode( sourceItem : SItemUniqueId, targetSlotList : array< int > )
	{
		var l_flashArray : CScriptedFlashArray;
		var l_flashObject : CScriptedFlashObject;
		var i : int;
		
		if (m_selectionModeActive)
		{
			return;
		}
		
		if (targetSlotList.Size() == 0)
		{
			
			return;
		}
		
		if (!_inv.IsIdValid(sourceItem))
		{
			
			return;
		}
		
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		l_flashArray = m_flashValueStorage.CreateTempFlashArray();
		
		l_flashObject.SetMemberFlashInt("sourceItem", ItemToFlashUInt(sourceItem));
		l_flashObject.SetMemberFlashBool("isDyeApplyingMode", _inv.IsItemDye( sourceItem ) );
		
		for (i = 0; i < targetSlotList.Size(); i += 1)
		{
			l_flashArray.PushBackFlashInt(targetSlotList[i]);
		}
		
		OnPlaySoundEvent("gui_global_panel_open");
		
		l_flashObject.SetMemberFlashArray("validSlots", l_flashArray);
		
		m_selectionModeItem = sourceItem;
		ResetContext();
		
		m_flashValueStorage.SetFlashObject("inventory.selection.mode.show", l_flashObject);
		m_selectionModeActive = true;
	}
	
	public function HideSelectionMode()
	{
		if (!m_selectionModeActive)
		{
			return;
		}
		
		m_fxHideSelectionMode.InvokeSelf();
		m_selectionModeActive = false;		
		
		OnModuleSelected(m_lastSelectedModuleID, m_lastSelectedModuleBindingName);
		m_dyePreviewMode = false;
		UnpreviewDye();
	}
	
	event  OnSelectionModeCancelRequested()
	{
		var uiStateRunes : W3TutorialManagerUIHandlerStateRunes;
		var uiStateArmorUpgrades : W3TutorialManagerUIHandlerStateArmorUpgrades;
		
		if(ShouldProcessTutorial('TutorialRunesSelectSword'))
		{
			uiStateRunes = (W3TutorialManagerUIHandlerStateRunes)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(uiStateRunes)
			{
				uiStateRunes.OnSelectingSwordAborted();
			}			
		}
		else if(ShouldProcessTutorial('TutorialArmorSocketsSelectTab'))
		{
			uiStateArmorUpgrades = (W3TutorialManagerUIHandlerStateArmorUpgrades)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(uiStateArmorUpgrades)
			{
				uiStateArmorUpgrades.OnSelectingArmorAborted();
			}
		}
		
		OnPlaySoundEvent("gui_global_panel_close");
		
		HideSelectionMode();
		m_dyePreviewMode = false;
	}
	
	event  OnSelectionModeTargetChosen( targetSlot : int )
	{
		var alreadyEquippedItem : bool;
		var isEquippedItemValid : bool;
		var curItemInSlot, otherMask : SItemUniqueId;
		var filterType : EInventoryFilterType;
		
		alreadyEquippedItem = false;
		
		if( _inv.ItemHasTag( m_selectionModeItem, 'mod_dye' ) )
		{
			ApplyDye( m_selectionModeItem, targetSlot );
			m_dyePreviewMode = false;
		}
		
		
		else
		if (_playerInv.isPotionItem(m_selectionModeItem) || _playerInv.isPetardItem(m_selectionModeItem) || _playerInv.isQuickslotItem(m_selectionModeItem) || _playerInv.isFoodItem(m_selectionModeItem) )
		{
			
			if(_inv.IsItemMask(m_selectionModeItem))
			{
				if(targetSlot == EES_Quickslot1)
					GetWitcherPlayer().GetItemEquippedOnSlot(EES_Quickslot2, otherMask);
				else if(targetSlot == EES_Quickslot2)
					GetWitcherPlayer().GetItemEquippedOnSlot(EES_Quickslot1, otherMask);
			}
			
			alreadyEquippedItem = GetWitcherPlayer().GetItemEquippedOnSlot(targetSlot, curItemInSlot);
			
			PlayItemEquipSound( _inv.GetItemCategory(m_selectionModeItem) );
			_playerInv.EquipItem( m_selectionModeItem, targetSlot );
			UpdatePlayerStatisticsData();
			
			if (alreadyEquippedItem && _inv.IsIdValid(curItemInSlot))
			{
				InventoryRemoveItem(m_selectionModeItem, true);
				InventoryUpdateItem(curItemInSlot);
				
				filterType = _playerInv.GetFilterTypeByItem(curItemInSlot);
				_playerInv.SetFilterType( filterType );
				UpdateInventoryFilter(filterType);
			}
			else
			{
				InventoryRemoveItem(m_selectionModeItem);
			}
			
			
			if(_inv.IsItemMask(m_selectionModeItem) && _inv.IsItemMask(otherMask))
			{
				PaperdollRemoveItem(otherMask);
				InventoryUpdateItem(otherMask);
			}
			
			PaperdollUpdateItem(m_selectionModeItem);
		}
		else if (_inv.ItemHasTag(m_selectionModeItem, 'Upgrade'))
		{
			ApplyUpgrade(m_selectionModeItem, targetSlot);
		}
		else if (_inv.ItemHasTag(m_selectionModeItem, 'SteelOil') || _inv.ItemHasTag(m_selectionModeItem, 'SilverOil'))
		{
			ApplyOil(m_selectionModeItem, targetSlot);
		}
		else if (_inv.ItemHasTag(m_selectionModeItem, 'WeaponReapairKit') || _inv.ItemHasTag(m_selectionModeItem, 'ArmorReapairKit'))
		{
			ApplyRepairKit(m_selectionModeItem, targetSlot);
		}
		
		HideSelectionMode();
		UpdateGuiSceneEntityItems();
	}
	
	private function ApplyDye( itemId : SItemUniqueId,  targetSlot : int ) : void
	{
		var curItemInSlot       : SItemUniqueId;
		var isEquippedItemValid : bool;
		
		isEquippedItemValid = GetWitcherPlayer().GetItemEquippedOnSlot( targetSlot, curItemInSlot );
		
		if ( isEquippedItemValid && _inv.IsIdValid( curItemInSlot ) )
		{
			_inv.ColorItem( curItemInSlot, itemId );
			_inv.RemoveItem ( itemId, 1 );

			if ( _inv.GetItemQuantity( itemId ) > 0 )
			{
				InventoryUpdateItem( itemId );
			}
			else
			{
				InventoryRemoveItem( itemId );
			}
			
			PaperdollUpdateItem( curItemInSlot );
			UpdateGuiSceneEntityItems();
			
			theSound.SoundEvent("gui_ep2_apply_dye");
		}
	}
	
	private function ApplyUpgrade(itemId : SItemUniqueId,  targetSlot : int) : void
	{
		var curItemInSlot : SItemUniqueId;
		var uiStateRunes : W3TutorialManagerUIHandlerStateRunes;
		var uiStateArmorUpgrades : W3TutorialManagerUIHandlerStateArmorUpgrades;
		
		if (GetWitcherPlayer().GetItemEquippedOnSlot(targetSlot, curItemInSlot))
		{
			if (targetSlot == EES_SilverSword || targetSlot == EES_SteelSword)
			{
				OnPlaySoundEvent("gui_inventory_rune_attach");
			}
			else
			{
				OnPlaySoundEvent("gui_inventory_armorupgrade_attach");
			}
			
			if (_inv.EnhanceItemScript(curItemInSlot, itemId))
			{
				if (_inv.IsIdValid(itemId) && _inv.GetItemQuantity( itemId ) > 0)
				{
					InventoryUpdateItem(itemId);
				}
				else
				{
					InventoryRemoveItem(itemId);
				}
				PaperdollUpdateItem(curItemInSlot);
				
				if(ShouldProcessTutorial('TutorialRunesSelectSword'))
				{
					uiStateRunes = (W3TutorialManagerUIHandlerStateRunes)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
					if(uiStateRunes)
					{
						uiStateRunes.OnUpgradedItem();
					}
				}
				if(ShouldProcessTutorial('TutorialArmorSocketsSelectTab'))
				{
					uiStateArmorUpgrades = (W3TutorialManagerUIHandlerStateArmorUpgrades)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
					if(uiStateArmorUpgrades)
					{
						uiStateArmorUpgrades.OnUpgradedItem();
					}
				}
			}
		}
	}
	
	private function ApplyOil(itemId : SItemUniqueId,  targetSlot : int) : void
	{
		var curItemInSlot : SItemUniqueId;
		
		OnPlaySoundEvent("gui_preparation_potion");
		
		if (_inv.GetItemEquippedOnSlot(targetSlot, curItemInSlot))
		{
			GetWitcherPlayer().ApplyOil(itemId, curItemInSlot);
			InventoryUpdateItem(m_selectionModeItem);
			PaperdollUpdateItem(curItemInSlot);
		}
		else
		{
			return;
		}
	}
	
	private function ApplyRepairKit(itemId : SItemUniqueId,  targetSlot : int) : void
	{
		var curItemInSlot : SItemUniqueId;
		
		OnPlaySoundEvent("gui_inventory_repair");
		
		if (_inv.GetItemEquippedOnSlot(targetSlot, curItemInSlot))
		{
			GetWitcherPlayer().RepairItem (itemId, curItemInSlot);
			if (_inv.IsIdValid(itemId) && _inv.GetItemQuantity( itemId ) > 0)
			{
				InventoryUpdateItem(itemId);
			}
			else
			{
				InventoryRemoveItem(itemId);
			}
			PaperdollUpdateItem(curItemInSlot);
		}
		else
		{
			return;
		}
	}
	
	public function UpdateAllItemData() : void
	{
		UpdateItemsCounter();
		UpdatePlayerStatisticsData();
		UpdateGuiSceneEntityItems();
		UpdateEncumbranceInfo();
	}
	
	public final function GetCurrentlySelectedTab() : int
	{
		return currentlySelectedTab;
	}
	
	event  OnMoveToStash( item : SItemUniqueId )
	{
		MoveToStash( item );
	}
	
	
	function StashUpdateItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
		_horseInv.SetInventoryFlashObjectForItem(item, itemDataObject);
		itemDataObject.SetMemberFlashInt("tabIndex", GetTabIndexForSlot(getTabFromFilter(_horseInv.GetInventoryComponent().GetFilterTypeByItem(item))));
		m_flashValueStorage.SetFlashObject( "inventory.grid.container.itemUpdate", itemDataObject );
	}
	
	
	public function MoveToStash(item : SItemUniqueId) : void
	{
		var itemQuant:int;
		var stashItemID:SItemUniqueId; 
		
		if( _inv.IsItemQuest( item ) || _inv.IsItemAlchemyItem( item ) )
		{
			showNotification( GetLocStringByKeyExt( "inventory_cant_transfer_item" ) );
			OnPlaySoundEvent( "gui_global_denied" );
			return;
		}
		
		itemQuant = _inv.GetItemQuantity( item );
		
		if (itemQuant > 1)
		{
			OpenQuantityPopup( item, QTF_MoveToStash, _inv.GetItemQuantity( item ) );
		}
		else
		{
			InventoryRemoveItem(item, false);
			_playerInv.clearGridPosition(item);
			stashItemID = GetWitcherPlayer().GetHorseManager().MoveItemToHorse(item, 1);	
			StashUpdateItem(stashItemID);													
			UpdateEncumbranceInfo();
		}
	}
	
	public function handleMoveToStashQuantity(item : SItemUniqueId, quantity : int) : void
	{
		var itemQuant:int;
		var stashItemID:SItemUniqueId; 
		
		itemQuant = _inv.GetItemQuantity( item );
		stashItemID = GetWitcherPlayer().GetHorseManager().MoveItemToHorse(item, quantity);  

		if (quantity >= itemQuant)
		{
			InventoryRemoveItem(item, false);
			_playerInv.clearGridPosition(item);
		}
		else
		{
			InventoryUpdateItem(item);
		}

		StashUpdateItem(stashItemID); 
		UpdateEncumbranceInfo();
	}
	
	event  OnTakeFromStash(item : SItemUniqueId)
	{
		TakeItemFromStash(item);
	}
	
	public function TakeItemFromStash(item : SItemUniqueId) : void
	{
		var newItemId : SItemUniqueId;
		var filterType : EInventoryFilterType;
		
		if (GetWitcherPlayer().GetHorseManager().GetInventoryComponent().IsIdValid(item))
		{
			newItemId = GetWitcherPlayer().GetHorseManager().MoveItemFromHorse(item, GetWitcherPlayer().GetHorseManager().GetInventoryComponent().GetItemQuantity(item));
			ShopRemoveItem(item);	
			
			filterType = _playerInv.GetFilterTypeByItem(newItemId);
			_playerInv.SetFilterType( filterType );
			m_fxInventoryUpdateFilter.InvokeSelfOneArg( FlashArgUInt( getTabFromFilter(filterType) ));
			InventoryUpdateItem( newItemId );
			UpdateEncumbranceInfo();
		}
	}
	
	public function UpdatePinnedCraftingItemInfo() : array<name>
	{
		var craftedItemArray 	 : CScriptedFlashArray;
		var schematic 		 	 : SCraftingSchematic;		
		var recipe 			 	 : SAlchemyRecipe;
		var enchantment			 : SEnchantmentSchematic;
		var enchantmentIcon  	 : string;
		var enchantmentData  	 : CScriptedFlashObject;
		var ingredientsList   	 : array<name>;
		var i 				 	 : int;
		var pinnedRecipe         : name;
		
		pinnedRecipe = theGame.GetGuiManager().PinnedCraftingRecipe;
		craftedItemArray = m_flashValueStorage.CreateTempFlashArray();
		
		if (pinnedRecipe != '')
		{			
			if (StrStartsWith(NameToString(pinnedRecipe), "Runeword") || StrStartsWith(NameToString(pinnedRecipe), "Glyphword"))
			{
				enchantment = getEnchantmentSchematicFromName(pinnedRecipe);
				enchantmentData = m_flashValueStorage.CreateTempFlashObject();
				
				enchantmentData.SetMemberFlashString("txtName", GetLocStringByKeyExt(enchantment.localizedName) );
				
				switch (enchantment.level)
				{
					case 3:
						enchantmentIcon = "icons/inventory/enchantments/enchantment_level3.png";
						break;
					case 2:
						enchantmentIcon = "icons/inventory/enchantments/enchantment_level2.png";
						break;
					case 1:
					default:
						enchantmentIcon = "icons/inventory/enchantments/enchantment_level1.png";
						break;
				}
				enchantmentData.SetMemberFlashInt("gridSize", 1);
				enchantmentData.SetMemberFlashInt("quantity", -1);
				enchantmentData.SetMemberFlashString("imgLoc", enchantmentIcon);
				craftedItemArray.PushBackFlashObject(enchantmentData);
				
				for( i = 0; i < enchantment.ingredients.Size(); i += 1 )
				{
					ingredientsList.PushBack(enchantment.ingredients[i].itemName);
					craftedItemArray.PushBackFlashObject(CreateRecipeFlashItem(enchantment.ingredients[i].itemName, enchantment.ingredients[i].quantity));
				}
			}
			else
			{
				schematic = getCraftingSchematicFromName(pinnedRecipe);
				
				if (schematic.schemName != '')
				{
					craftedItemArray.PushBackFlashObject(CreateRecipeFlashItem(schematic.craftedItemName, -1));
					
					for( i = 0; i < schematic.ingredients.Size(); i += 1 )
					{
						ingredientsList.PushBack(schematic.ingredients[i].itemName);
						craftedItemArray.PushBackFlashObject(CreateRecipeFlashItem(schematic.ingredients[i].itemName, schematic.ingredients[i].quantity));
					}
				}
				else
				{
					recipe = getAlchemyRecipeFromName(pinnedRecipe);
					
					if (recipe.recipeName != '')
					{
						craftedItemArray.PushBackFlashObject(CreateRecipeFlashItem(recipe.cookedItemName, -1));
						
						for( i = 0; i < recipe.requiredIngredients.Size(); i += 1 )
						{
							ingredientsList.PushBack(recipe.requiredIngredients[i].itemName);
							craftedItemArray.PushBackFlashObject(CreateRecipeFlashItem(recipe.requiredIngredients[i].itemName, recipe.requiredIngredients[i].quantity));
						}
					}
				}
			}
		}
		
		if (craftedItemArray.GetLength() > 0)
		{
			m_flashValueStorage.SetFlashArray( "inventory.pinned.crafting.info", craftedItemArray );
		}
		
		return ingredientsList;
	}
	
	public function CreateRecipeFlashItem(item : name, reqQuantity : int) : CScriptedFlashObject
	{
		var returnObject 	: CScriptedFlashObject;
		var dm 				: CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
		var itemType		: EInventoryFilterType;
		var minQuality		: int;
		var maxQuality		: int;
		var itemInShop		: bool;
		
		returnObject = m_flashValueStorage.CreateTempFlashObject();
		
		itemType = dm.GetFilterTypeByItem(item);
		
		
		itemInShop = false;
		if (_shopNpc)
		{
			if ( _shopNpc.GetInventory().HasItem(item) )
			{
				itemInShop = true;
			}
		}
		
		returnObject.SetMemberFlashBool("highlight", itemInShop);
		
		if (reqQuantity == -1)
		{
			returnObject.SetMemberFlashInt("quantity", -1);
		}
		else
		{
			returnObject.SetMemberFlashInt("quantity", _inv.GetItemQuantityByName(item));
		}
		
		returnObject.SetMemberFlashInt("reqQuantity", reqQuantity);
		
		returnObject.SetMemberFlashString("imgLoc", dm.GetItemIconPath(item));
		
		if (itemType == IFT_Weapons || itemType == IFT_Armors)
		{
			returnObject.SetMemberFlashInt("gridSize", 2);
		}
		else
		{
			returnObject.SetMemberFlashInt("gridSize", 1);
		}
		returnObject.SetMemberFlashString("txtName", GetLocStringByKeyExt(dm.GetItemLocalisationKeyName(item)));
		
		_inv.GetItemQualityFromName(item, minQuality, maxQuality);
		
		returnObject.SetMemberFlashInt("quality", minQuality);
		
		return returnObject;
	}
	
	function PlayOpenSoundEvent()
	{
		
		
	}
	
	private function UpdateVitality():void
	{
		var value:int = RoundMath(thePlayer.GetStat(BCS_Vitality, true));
		var valueMax:int = RoundMath(thePlayer.GetStatMax(BCS_Vitality));
		
		m_fxSetVitality.InvokeSelfThreeArgs( FlashArgNumber(value), FlashArgNumber(0), FlashArgNumber(valueMax));
	}
	
	private function UpdateToxicity():void
	{
		var value:int = RoundMath(thePlayer.GetStat(BCS_Toxicity, false));
		var valueMax:int = RoundMath(thePlayer.GetStatMax(BCS_Toxicity));
		
		m_fxSetToxicity.InvokeSelfThreeArgs( FlashArgNumber(value), FlashArgNumber(0), FlashArgNumber(valueMax));
	}
	
	
	
	
}
