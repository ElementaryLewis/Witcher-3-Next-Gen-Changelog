/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




class CR4BlacksmithMenu extends CR4MenuBase
{
	private var _disassembleInv 		: W3GuiDisassembleInventoryComponent;
	private var _repairInv 				: W3GuiRepairInventoryComponent;
	private var _socketInv 				: W3GuiSocketsInventoryComponent;
	private var _curInv	   				: W3GuiBaseInventoryComponent;
	private var _addSocketInv   		: W3GuiAddSocketsInventoryComponent;
	private var _standaloneDismantleInv : W3StandaloneDismantleComponent;
	private var _tooltipDataProvider	: W3TooltipComponent;
	
	protected var _inv 		      : CInventoryComponent;
	protected var _fixerNpc 	  : CNewNPC;
	protected var _fixerInventory : CInventoryComponent;
	
	private var m_standaloneMode : bool;
	private var m_menuInited : bool;
	private var m_lastConfirmedDisassembleQuantity : int;

	private var MAX_ITEM_NR : int;
	default MAX_ITEM_NR = 64;
	private var currentItemsNr : int;
	default	currentItemsNr = 0;
	
	private var InitDataConfirmation 	: PriceConfirmationPopupData;
	private var repairAllPopupData 		: RepairAllPopupData;
	private var quantityPopupData		: QuantityPopupData;
	
	private var m_fxRemoveItem   		: CScriptedFlashFunction;
	private var m_fxConfirmAction		: CScriptedFlashFunction;
	private var m_fxSetPlayerMoney		: CScriptedFlashFunction;
	private var m_fxSetXActionLabel 	: CScriptedFlashFunction;
	
	private var m_sectionsList			: CScriptedFlashArray;
	
	private var m_ingrForMissingDecoctions : array<name>;
	
	event  OnConfigUI()
	{	
		var l_flashPaperdoll		: CScriptedFlashSprite;
		var l_flashInventory		: CScriptedFlashSprite;
		var l_flashObject			: CScriptedFlashObject;
		var l_flashArray			: CScriptedFlashArray;
		var l_obj		 			: IScriptable;
		var l_fixerEntity			: CGameplayEntity;		
		var l_initData				: W3InventoryInitData;
		var l_dismantleInitData	    : W3StandaloneDismantleInitData;
		var hasUpgrades				: bool;
		var items 					: array<SItemUniqueId>;
		var i 						: int;
		
		m_menuInited = false;
		m_standaloneMode = false;
		
		super.OnConfigUI();
		
		m_initialSelectionsToIgnore = 0;
		
		l_obj = GetMenuInitData();
		l_initData = (W3InventoryInitData)l_obj;
		l_dismantleInitData = (W3StandaloneDismantleInitData)l_obj;		
		
		if( l_dismantleInitData )
		{
			m_ingrForMissingDecoctions = l_dismantleInitData.m_ingredientsForMissingDecoctions;
			m_standaloneMode = true;
		}
		else if( l_initData )
		{
			l_fixerEntity = l_initData.containerNPC;
		}
		else
		{
			l_fixerEntity = (CGameplayEntity)l_obj;
		}
		
		if( l_fixerEntity )
		{
			_fixerNpc = (CNewNPC)l_fixerEntity;
			_fixerInventory = l_fixerEntity.GetInventory();
		}
		
		_inv = thePlayer.GetInventory();
		m_flashModule = GetMenuFlash();
		m_fxConfirmAction = m_flashModule.GetMemberFlashFunction( "confirmAction" );
		m_fxSetPlayerMoney = m_flashModule.GetMemberFlashFunction( "setPlayerMoney" );
		m_fxRemoveItem = m_flashModule.GetMemberFlashFunction( "removeItem" );
		m_fxSetXActionLabel = m_flashModule.GetMemberFlashFunction( "setXActionLabel" );
		
		_tooltipDataProvider = new W3TooltipComponent in this;
		_tooltipDataProvider.initialize(_inv, m_flashValueStorage);
		_tooltipDataProvider.setCurrentInventory(_inv);
		
		if( _fixerInventory )
		{
			
			_repairInv = new W3GuiRepairInventoryComponent in this;
			_repairInv.Initialize( _inv );
			_repairInv.merchantInv = _fixerInventory;
			
			
			_repairInv.repairArmors = true;
			_repairInv.repairSwords = true;
			_repairInv.masteryLevel = 5;
			
			
			_socketInv = new W3GuiSocketsInventoryComponent in this;
			_socketInv.Initialize( _inv );
			_socketInv.SetSocketsFilter(true);
			_socketInv.merchantInv = _fixerInventory;
			
			
			_addSocketInv = new W3GuiAddSocketsInventoryComponent in this;
			_addSocketInv.Initialize( _inv );
			_addSocketInv.merchantInv = _fixerInventory;
			_addSocketInv.ignorePosition = true;
			
			
			_disassembleInv = new W3GuiDisassembleInventoryComponent in this;
			_disassembleInv.Initialize( _inv );
			_disassembleInv.merchantInv = _fixerInventory;
		}
		else
		{
			
			
			
			_standaloneDismantleInv = new W3StandaloneDismantleComponent in this;
			_standaloneDismantleInv.Initialize( _inv );
		}
		
		m_menuInited = true;
		ApplyMenuState(m_menuState);
		
		
		m_flashValueStorage.SetFlashString("repair.grid.player.name", GetLocStringByKeyExt("panel_inventory_grid_name"));
		
		
		if( !m_standaloneMode && m_menuState == 'Disassemble' && ShouldProcessTutorial( 'TutorialDismantleDescription' ) )
		{
			items = _disassembleInv.GetAllItems();
			for(i=0; i<items.Size(); i+=1)
			{
				if(_disassembleInv.ShouldShowItem(items[i]))
				{
					
					GameplayFactsSet("tut_dismantle_cond", 1);				
					theGame.GetTutorialSystem().uiHandler.OnOpeningMenu(GetMenuName());
				
					break;
				}
			}
		}
		else if( m_standaloneMode && ShouldProcessTutorial( 'TutorialMutagenTableDescription' ) )
		{
			theGame.GetTutorialSystem().uiHandler.OnOpeningMenu( 'MutagenDismantleMenu' );
		}
		
		m_fxSetTooltipState.InvokeSelfTwoArgs( FlashArgBool( thePlayer.upscaledTooltipState ), FlashArgBool( true ) );
	}
	
	public  function SetMenuState(newState : name) : void
	{
		var i : int;
		var hasUpgrades : bool;
		var items : array<SItemUniqueId>;
		var numEnhancements : int;
		var hasEnchantment : bool;
		
		if (newState == 'Sockets')
		{
			m_initialSelectionsToIgnore = 1;
		}
		
		super.SetMenuState(newState);
		if (m_menuInited)
		{
			ApplyMenuState(newState);
		}
		
		if(m_menuState == 'Sockets' && ShouldProcessTutorial('TutorialUpgRemovalDescription'))
		{
			thePlayer.inv.GetAllItems(items);
			hasUpgrades = false;
			
			
			for(i=0; i<items.Size(); i+=1)
			{
				hasEnchantment = thePlayer.inv.GetEnchantment( items[ i ] ) != '';
				numEnhancements = thePlayer.inv.GetItemEnhancementCount( items[ i ] ); 
				if( numEnhancements > 0 && !hasEnchantment )
				{
					hasUpgrades = true;
					break;
				}
			}
			
			GameplayFactsSet("tutorial_upg_removal_cond", (int)hasUpgrades);
			theGame.GetTutorialSystem().uiHandler.OnOpeningMenu(GetMenuName());
		}
	}
	
	protected function ApplyMenuState( newState : name ) : void
	{
		if (m_standaloneMode)
		{
			
			
			switch( newState )
			{
				case 'Disassemble':
					_curInv = _standaloneDismantleInv;
					break;
				case 'Repair':
				case 'Sockets':
				case 'AddSockets':
					
					break;
				default:
					break;
			}
			
			m_sectionsList = NULL;
		}
		else
		{
			
			
			switch( newState )
			{
				case 'Repair':
					_curInv = _repairInv;
					break;
				case 'Sockets':
					_curInv = _socketInv;
					break;
				case 'Disassemble':
					_curInv = _disassembleInv;
					break;
				case 'AddSockets':
					_curInv = _addSocketInv;
					break;
				default:
					break;
			}
			
			SetSectionsDataList( newState );
		}
		
		UpdateRepairAllInputFeedback( newState );
		UpdateData();
	}
	
	protected function SetSectionsDataList( newState : name ) : void
	{
		var curDataObject : CScriptedFlashObject;
		
		switch( newState )
		{
			case 'Sockets':
			case 'Repair':
			case 'AddSockets':
				
				m_sectionsList = m_flashValueStorage.CreateTempFlashArray();
				curDataObject = CreateSectionsData( 0, 0, 3, GetLocStringByKeyExt( "panel_blacksmith_equipped" ) );
				m_sectionsList.PushBackFlashObject( curDataObject );
				curDataObject = CreateSectionsData( 1, 4, 8, GetLocStringByKeyExt( "item_category_misc" ) );
				m_sectionsList.PushBackFlashObject( curDataObject );
				break;
				
			case 'Disassemble':
				
				m_sectionsList = m_flashValueStorage.CreateTempFlashArray();
				curDataObject = CreateSectionsData( 0, 0, 3, GetLocStringByKeyExt( "item_category_equipement" ) );
				m_sectionsList.PushBackFlashObject( curDataObject );
				curDataObject = CreateSectionsData( 1, 4, 8, GetLocStringByKeyExt( "item_category_misc" ) );
				m_sectionsList.PushBackFlashObject( curDataObject );
				
				break;
				
			default:
				
				m_sectionsList = NULL;
				break;
		}
	}
	
	protected function CreateSectionsData( id : int, start : int, end : int, label : string ) : CScriptedFlashObject
	{
		var resData : CScriptedFlashObject;
		
		resData = m_flashValueStorage.CreateTempFlashObject( "red.game.witcher3.menus.inventory_menu.ItemSectionData" );
		resData.SetMemberFlashInt( "id", id );
		resData.SetMemberFlashInt( "start", start );
		resData.SetMemberFlashInt( "end", end );
		resData.SetMemberFlashString( "label", label );
		
		return resData;
	}
	
	protected function UpdateRepairAllInputFeedback(newState : name) : void
	{
		var repairString 		: string;
		var totalRepairCost 	: int;
		var language 	   		: string;
		var audioLanguage  		: string;
		var locStringRepair  	: string;
		var locStringPriceRepair 		: string;
		theGame.GetGameLanguageName( audioLanguage, language);
		
		repairString = "";
		
		if (newState == 'Repair')
		{
			totalRepairCost = _repairInv.GetTotalRepairCost();
			
			if (totalRepairCost > 0)
			{
				locStringRepair = GetLocStringByKeyExt( "repair_equipped_items" );
				if( language != "AR")
				{
					repairString = locStringRepair + " (" + totalRepairCost + ")";
				}
				else
				{
					locStringPriceRepair =" *" + totalRepairCost + "*";
					repairString =   locStringRepair + locStringPriceRepair;
				}
			}
		}
		
		m_fxSetXActionLabel.InvokeSelfOneArg(FlashArgString(repairString));
	}
	
	event  OnClearSlotNewFlag(item : SItemUniqueId)
	{
		RemoveNewItemMark(item);
	}
	
	event  OnPlayDeniedSound()
	{
		OnPlaySoundEvent( "gui_global_denied" );
	}
	
	function RemoveNewItemMark(item : SItemUniqueId)
	{
		if (_inv.IsIdValid(item))
		{
			_curInv.ClearItemIsNewFlag(item);
		}
	}
	
	public function HandleActionConfirmation(value:bool):void
	{
		m_fxConfirmAction.InvokeSelfOneArg(FlashArgBool(value));
	}
	
	event  OnRequestConfirmation( itemId : SItemUniqueId, price : int )
	{
		var itemName		: name;
		
		if( m_menuState == 'Disassemble' && m_standaloneMode && _inv.GetItemQuantity(itemId) == 1 )
		{
			itemName = _inv.GetItemName( itemId );
			
			if( m_ingrForMissingDecoctions.Contains( itemName ) )
			{
				ShowConfirmationPopup( itemId, price, 1 );
			}
			else
			{
				ProcessRequestConfirmation(itemId, price);
			}
		}
		else
		{
			ProcessRequestConfirmation(itemId, price);
		}
	}
	
	public function ProcessRequestConfirmation( itemId : SItemUniqueId, price : int )
	{
		var additionalDesc	: string = "";
		
		if( m_menuState == 'Disassemble' && _inv.GetItemQuantity(itemId) > 1 )
		{
			if( m_standaloneMode )
			{
				
				price = 0;
			}
			
			if( _inv.GetMoney() < price ) 
			{
				showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
				HandleActionConfirmation( false );
				OnPlaySoundEvent( "gui_global_denied" );
			}
			else
			{
				ShowDisassembleQuantityPopup( itemId, price );
			}
		}
		else
		{
			if (!m_standaloneMode)
			{
				ShowConfirmationPopup( itemId, price, 1 );
			}
			else
			{
				m_lastConfirmedDisassembleQuantity = 1;
				HandleActionConfirmation( true );
			}
		}
	}
	
	public function ShowConfirmationPopup( itemId : SItemUniqueId, price : int, quantity : int )
	{
		var confirmationTitle 	: string;
		var confirmationText  	: string;
		var costRepairPoint   	: int;
		var invItem 			: SInventoryItem;
		var playerMoney	 		: int;
		
		playerMoney = _inv.GetMoney();
		
		invItem = _inv.GetItem( itemId );
		
		switch (m_menuState)
		{
			case 'Repair':
				confirmationText = "panel_repair_popup_repair_item_text";
				confirmationTitle = "panel_button_common_repair";
				break;
			case 'Sockets':
				confirmationText = "panel_blacksmith_remove_improvement_confirmation";
				confirmationTitle = "panel_title_blacksmith_sockets";
				break;
			case 'Disassemble':
				if (m_standaloneMode)
				{
					confirmationText = "mutagen_dismantling_table_confirmation_popup";
				}
				else
				{
					confirmationText = "panel_repair_popup_disassemble_item_text";
				}
				confirmationTitle = "panel_title_blacksmith_disassamble";
				m_lastConfirmedDisassembleQuantity = quantity;
				break;				
			case 'AddSockets':
				confirmationText = "panel_blacksmith_add_socket_confirmation";
				confirmationTitle = "panel_title_blacksmith_add_sockets";
				break;
			default:
				confirmationText = "";
				confirmationTitle = "";
				break;
		}
		
		if ( playerMoney >= price )
		{
			if (m_lastConfirmedDisassembleQuantity > 1)
			{
				HandleActionConfirmation(true);
			}
			else
			{
				InitDataConfirmation = new PriceConfirmationPopupData in this;
				InitDataConfirmation.menuRef = this;
				InitDataConfirmation.BlurBackground = true;
				InitDataConfirmation.isStandaloneDismantle = m_standaloneMode;
				InitDataConfirmation.itemId = itemId;
				
				if ( confirmationText != "" )
				{
					InitDataConfirmation.SetMessageText( GetLocStringByKeyExt( confirmationText ) );
				}
				
				if ( confirmationTitle != "" )
				{
					InitDataConfirmation.SetMessageTitle( GetLocStringByKeyExt( confirmationTitle ) );
				}
				
				InitDataConfirmation.SetPrice( price );
				
				RequestSubMenu( 'PopupMenu', InitDataConfirmation );
			}
		}
		else
		{
			showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
			HandleActionConfirmation(false);
			OnPlaySoundEvent( "gui_global_denied" );
		}
	}
	
	public function OnDisassembleStack( itemId : SItemUniqueId, price : int, quantity : int )
	{
		var playerMoney	 		: int;
		
		playerMoney = _inv.GetMoney();
		
		if ( playerMoney >= price )
		{
			m_lastConfirmedDisassembleQuantity = quantity;
			HandleActionConfirmation(true);
		}
		else
		{
			showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
			HandleActionConfirmation(false);
			OnPlaySoundEvent( "gui_global_denied" );
		}
	}
	
	private function ShowDisassembleQuantityPopup( itemId : SItemUniqueId, price : int )
	{
		var maxValue : int;
		
		maxValue = _inv.GetItemQuantity(itemId);
		
		if ( quantityPopupData )
		{
			delete quantityPopupData;
		}
		
		quantityPopupData = new QuantityPopupData in this;
		
		quantityPopupData.showPrice = !m_standaloneMode;
		quantityPopupData.itemCost = price;
		quantityPopupData.itemId = itemId;
		quantityPopupData.minValue = 1;
		quantityPopupData.currentValue = _inv.GetItemQuantity(itemId);
		quantityPopupData.maxValue = _inv.GetItemQuantity(itemId);
		quantityPopupData.actionType = QTF_Dismantle;
		quantityPopupData.blacksmithRef = this;
		RequestSubMenu( 'PopupMenu', quantityPopupData );
	}
	
	event  OnRemoveImprovements(item : SItemUniqueId, price : int)
	{
		var socketItems	  : array<name>;
		var itemsListText : string;
		var idx, len	  : int;
		
		_inv.GetItemEnhancementItems(item, socketItems);
		itemsListText = GetLocStringByKeyExt("panel_blacksmith_items_added");
		len = socketItems.Size();
		for (idx = 0; idx < len; idx+=1)
		{
			itemsListText += ("<br/> +" + GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(socketItems[idx])));
		}
		
		_fixerInventory.AddMoney(price);
		_inv.RemoveMoney(price);
		_inv.RemoveAllItemEnhancements(item);
		
		if (_inv.GetItemQuantity(item) > 1)
		{
			UpdateItem(item);
		}
		else
		{
			RemoveItem(item);
		}
		
		UpdatePlayerMoney();
		UpdateMerchantData();
		theSound.SoundEvent( 'gui_inventory_buy' );		
	}
	
	event  OnDisassembleItem( item : SItemUniqueId, price : int)
	{
		var partList	  		: array <SItemParts>;
		var currentPartList 	: array <SItemParts>;
		var runesList	  		: array <name>;
		var itemsListText 		: string;
		var idx, len			: int;
		var i, x				: int;		
		var itemsCount	  		: int;
		var entryFound			: bool;
		var updateAfter			: bool;
		var craftComp			: W3CraftsmanComponent;
		
		var itemsAdded			: array <SItemUniqueId>;
		var itemsToUpdate		: array <SItemUniqueId>;
		var curPart				: SItemUniqueId;
		
		if( m_lastConfirmedDisassembleQuantity < 1 )
		{
			OnPlaySoundEvent( "gui_global_denied" );
			return 0;
		}
		
		itemsListText = "<font color =\"#404040\">" + GetLocStringByKeyExt( "panel_blacksmith_items_removed" ) + ": </font>";
		itemsListText += "<br/>" + ( GetLocStringByKeyExt( _inv.GetItemLocalizedNameByUniqueID( item ) ) + " x" + m_lastConfirmedDisassembleQuantity );
		
		if ( m_standaloneMode )
		{
			
			
			
			if( _inv.GetItemQuantity( item ) == m_lastConfirmedDisassembleQuantity)
			{
				RemoveItem( item );
				updateAfter = false;
			}
			else
			{
				updateAfter = true;
			}
			
			_standaloneDismantleInv.DoDismantling( item, m_lastConfirmedDisassembleQuantity, itemsAdded );
			
			if( updateAfter )
			{
				UpdateItem( item );
			}
			
			if( itemsAdded.Size() )
			{
				itemsListText += "<br/>" + "<font color =\"#404040\">" + GetLocStringByKeyExt( "panel_blacksmith_items_added" ) + ": </font>";
				itemsListText += "<br/>" + GetLocStringByKeyExt( _inv.GetItemLocalizedNameByName( _inv.GetItemName( itemsAdded[0] ) ) ) + " x" + m_lastConfirmedDisassembleQuantity;
				showNotification( itemsListText );
			}
		}
		else
		{
			
			
			partList = _inv.GetItemRecyclingParts(item);
			
			len = partList.Size();
			for (idx = 0; idx < len; idx+=1)
			{
				partList[idx].quantity = _inv.GetItemQuantityByName(partList[idx].itemName);
			}
			
			itemsListText += "<br/>" + "<font color =\"#404040\">" + GetLocStringByKeyExt("panel_blacksmith_items_added") + ": </font>";
			
			GetWitcherPlayer().StartInvUpdateTransaction();
			
			_fixerInventory.AddMoney(price * m_lastConfirmedDisassembleQuantity);
			_inv.RemoveMoney(price * m_lastConfirmedDisassembleQuantity);
			if ( _inv.GetItemEnhancementCount(item) > 0 )
			{
				_inv.GetItemEnhancementItems(item, runesList);
				for (idx = 0; idx <  runesList.Size(); idx+=1)
				{
					_inv.AddAnItem( runesList[idx] );
					itemsListText += "<br/>" + (GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(runesList[idx])) + " x1");
				}		
			}
			
			craftComp = (W3CraftsmanComponent)_fixerNpc.GetComponentByClassName( 'W3CraftsmanComponent' );
			
			for (i = 0; i < m_lastConfirmedDisassembleQuantity; i += 1)
			{
				if ( craftComp )
				{
					if ( craftComp.IsCraftsmanType( ECT_Smith ) )
					{
						itemsAdded = _inv.RecycleItem(item, craftComp.GetCraftsmanLevel( ECT_Smith ) );
					}
					else if ( craftComp.IsCraftsmanType( ECT_Armorer ) )
					{
						itemsAdded = _inv.RecycleItem(item, craftComp.GetCraftsmanLevel( ECT_Armorer ) );
					}
					else
					{
						itemsAdded = _inv.RecycleItem( item, ECL_Journeyman );
					}
				}
				else
				{
					itemsAdded = _inv.RecycleItem( item, ECL_Journeyman );
				}
			}
			
			for (idx = 0; idx < len; idx+=1)
			{
				itemsCount = _inv.GetItemQuantityByName(partList[idx].itemName) - partList[idx].quantity;
				itemsListText += "<br/>" + GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(partList[idx].itemName)) + " x" + itemsCount;
			}
			
			
			showNotification(itemsListText);
			
			if (_inv.GetItemQuantity(item) > 0)
			{
				itemsToUpdate.PushBack(item);
			}
			else
			{
				RemoveItem(item);
			}
			
			len = itemsAdded.Size();
			for (idx = 0; idx < len; idx+=1)
			{
				curPart = itemsAdded[idx];
				partList.Clear();
				partList = _inv.GetItemRecyclingParts( curPart );
				if (partList.Size() > 0)
				{
					itemsToUpdate.PushBack(curPart);
				}
			}
		}
		
		
		
		if (itemsToUpdate.Size() > 0)
		{
			UpdateItemsList(itemsToUpdate);
		}
		
		GetWitcherPlayer().FinishInvUpdateTransaction();
		
		UpdatePlayerMoney();
		UpdateMerchantData();
		UpdateItemsCounter();
		
		theSound.SoundEvent( 'gui_inventory_buy' );
	}
	
	event  OnStartCrafting()
	{
		OnPlaySoundEvent("gui_crafting_craft_item");
	}
	
	event  OnRepairItem( item : SItemUniqueId, price : int )
	{
		_repairInv.RepairItem( item, 1 );
		_fixerInventory.AddMoney(price);
		_inv.RemoveMoney(price);
		
		if (_inv.GetItemQuantity(item) > 1)
		{
			UpdateItem(item);
		}
		else
		{
			RemoveItem(item);
		}
		
		UpdatePlayerMoney();
		UpdateMerchantData();
		
		theSound.SoundEvent( 'gui_inventory_buy' );
		theSound.SoundEvent( 'gui_inventory_repair' );
		
		UpdateRepairAllInputFeedback('Repair');
	}
	
	event  OnAddSocket( item : SItemUniqueId, price : int)
	{
		_addSocketInv.AddSocket( item );
		
		_fixerInventory.AddMoney(price);
		_inv.RemoveMoney(price);
		
		UpdateItem(item);
		
		UpdatePlayerMoney();
		UpdateMerchantData();
		
		theSound.SoundEvent( 'gui_enchanting_socket_add' );
	}
	
	event  OnRepairAllItems()
	{
		var totalRepairCost : int;
		
		totalRepairCost = _repairInv.GetTotalRepairCost();
		
		if (_inv.GetMoney() < totalRepairCost) 
		{
			showNotification( GetLocStringByKeyExt( "panel_shop_notification_not_enough_money" ) );
			HandleActionConfirmation(false);
			OnPlaySoundEvent( "gui_global_denied" );
		}
		else
		{
			repairAllPopupData = new RepairAllPopupData in this;
			repairAllPopupData.menuRef = this;
			repairAllPopupData.BlurBackground = true;
				
			repairAllPopupData.SetPrice( totalRepairCost );
			
			RequestSubMenu( 'PopupMenu', repairAllPopupData );
			
		}
	}
	
	public function RepairAll()
	{
		var emptyString : string;
		var totalRepairCost : int;
		
		emptyString = "";
		totalRepairCost = _repairInv.GetTotalRepairCost();
		
		_repairInv.RepairAllItems(1);
		
		_fixerInventory.AddMoney(totalRepairCost);
		_inv.RemoveMoney(totalRepairCost);
		UpdatePlayerMoney();
		UpdateMerchantData();
		
		theSound.SoundEvent( 'gui_inventory_buy' );
		theSound.SoundEvent( 'gui_inventory_repair' );
		
		InventoryUpdateAll();
		m_fxSetXActionLabel.InvokeSelfOneArg(FlashArgString(emptyString));
	}
	
	event  OnGetItemData(item : SItemUniqueId, compareItemType : int)
	{
		ShowItemTooltip(item, compareItemType);
	}
	
	event  OnGlobalUpdate()
	{
		UpdateData();
	}
		
	event  OnSaveItemGridPosition( item : SItemUniqueId, gridPos : int )
	{
		var UIData : SInventoryItemUIData;
		UIData = _inv.GetInventoryItemUIData( item );
		UIData.gridPosition = gridPos;
		
	}
	
	
	
	function UpdateData()
	{
		InventoryUpdateAll();
		UpdateItemsCounter();
		UpdateMerchantData();
		m_fxSetPlayerMoney.InvokeSelfOneArg( FlashArgInt( thePlayer.GetMoney() ) );
	}
	
	function InventoryUpdateAll()
	{
		var l_flashObject  : CScriptedFlashObject;
		var l_flashArray   : CScriptedFlashArray;
		
		if( _curInv )
		{
			l_flashObject = m_flashValueStorage.CreateTempFlashObject();
			l_flashArray = m_flashValueStorage.CreateTempFlashArray();
			
			_curInv.GetInventoryFlashArray( l_flashArray, l_flashObject );
			
			m_flashValueStorage.SetFlashArray( "blacksmith.grid.section", m_sectionsList );
			m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
		}
	}
	
	function UpdateMerchantData() : void
	{
		var l_merchantData			: CScriptedFlashObject;
		l_merchantData = m_flashValueStorage.CreateTempFlashObject();
		GetNpcInfo((CGameplayEntity)_fixerNpc, l_merchantData);
		m_flashValueStorage.SetFlashObject("blacksmith.merchant.info", l_merchantData);
	}
	
	function InventoryUpdateItems( itemsList : array<SItemUniqueId>  )
	{
		var i					: int;
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		var itemsDataList		: CScriptedFlashArray;
		
		if (_curInv)
		{
			itemsDataList = m_flashValueStorage.CreateTempFlashArray();
			tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
			for ( i = 0; i < itemsList.Size(); i += 1 )
			{
				itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
				_curInv.SetInventoryFlashObjectForItem(itemsList[i], itemDataObject);
				itemsDataList.PushBackFlashObject(itemDataObject);
			}
			m_flashValueStorage.SetFlashArray( "repair.grid.player.itemsUpdate", itemsDataList );
		}
	}
	
	function UpdatePlayerMoney()
	{
		var commonMenu 				: CR4CommonMenu;
		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if( commonMenu )
		{
			commonMenu.UpdatePlayerOrens();
		}
	}
	
	private function UpdateItemsList( itemsList : array<SItemUniqueId> ):void
	{
		var tempFlashObject : CScriptedFlashObject;
		var tempFlashArray  : CScriptedFlashArray;
		var itemDataObject	: CScriptedFlashObject;
		var idx, len:int;
		
		tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
		tempFlashArray = m_flashValueStorage.CreateTempFlashArray();
		len = itemsList.Size();
		for (idx = 0; idx < len; idx +=1)
		{
			itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
			_curInv.SetInventoryFlashObjectForItem(itemsList[idx], itemDataObject);
			tempFlashArray.PushBackFlashObject(itemDataObject);
		}
		
		m_flashValueStorage.SetFlashArray( "blacksmith.item.list.update", tempFlashArray );
	}
	
	private function UpdateItem( item : SItemUniqueId )
	{
		var tempFlashObject		: CScriptedFlashObject;
		var itemDataObject		: CScriptedFlashObject;
		
		if (_curInv)
		{
			tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
			itemDataObject = tempFlashObject.CreateFlashObject("red.game.witcher3.menus.common.ItemDataStub");
			_curInv.SetInventoryFlashObjectForItem(item, itemDataObject);
			m_flashValueStorage.SetFlashObject( "blacksmith.item.update", itemDataObject );
		}
	}
	
	private function RemoveItem( item : SItemUniqueId ):void
	{
		m_fxRemoveItem.InvokeSelfTwoArgs( FlashArgUInt(ItemToFlashUInt(item)), FlashArgBool( false ));
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
	
	function GetCurrentInventory():CInventoryComponent
	{
		return _inv;
	}
	
	function GetItemDefaultActionName( item : SItemUniqueId ) : string
	{
		var itemAction : EInventoryActionType;
		itemAction = GetItemDefaultAction(item);
		
		return GetItemActionFriendlyName(itemAction,GetWitcherPlayer().IsItemEquipped(item));
	}
	
	function GetItemDefaultAction( item : SItemUniqueId ) : EInventoryActionType
	{
		return IAT_Repair;
	}
	
	event  OnCloseMenu()
	{
		if( m_standaloneMode )
		{
			theGame.GetTutorialSystem().uiHandler.OnClosingMenu( 'MutagenDismantleMenu' );
		}
		
		CloseMenu();
		
		if( m_parentMenu )
		{
			m_parentMenu.ChildRequestCloseMenu();
		}
	}
	
	event  OnClosingMenu()
	{
		if (_repairInv)
		{
			delete _repairInv;
		}
		if (_socketInv)
		{
			delete _socketInv;
		}
		if (InitDataConfirmation)
		{
			delete InitDataConfirmation;
		}
		if (quantityPopupData)
		{
			delete quantityPopupData;
		}
		if (repairAllPopupData)
		{
			delete repairAllPopupData;
		}
		
		theGame.GetGuiManager().SetLastOpenedCommonMenuName( GetMenuName() );
		super.OnClosingMenu();		
	}

	
	event  OnMoveItem( item : SItemUniqueId, moveToIndex : int )
	{
	}

	
	event  OnMoveItems( item : SItemUniqueId, moveToIndex : int, itemSecond : SItemUniqueId, moveToSecondIndex : int )
	{
	}
	
	event  OnPlaySound( soundKey : string )
	{
		theSound.SoundEvent( soundKey );
	}
	
	
	event  OnSetCurrentPlayerGrid( value : string )
	{
		
	}
	
	
	event  OnEquipItem( item : SItemUniqueId, slot : int, quantity : int )
	{
		
	}
	
	
	

	public function ShowItemTooltip(item : SItemUniqueId, compareItemType : int)
	{
		var tooltipData : CScriptedFlashObject;
		tooltipData = _tooltipDataProvider.GetTooltipData(item, true, true);
		m_flashValueStorage.SetFlashObject("context.tooltip.data", tooltipData);
	}
	
	event  OnShowItemPopup( item : SItemUniqueId )
	{
		var initData : ItemInfoPopupData;
		
		initData = new ItemInfoPopupData in this;
		initData.invRef = GetCurrentInventory();
		initData.itemId = item;
		RequestSubMenu('PopupMenu', initData);	
	}
	
	function PlayOpenSoundEvent()
	{
		
		
	}
	
	event  OnAppendGFxButton(actionId:int, gamepadNavCode:String, keyboardKeyCode:int, label:String, holdPrefix:bool)
	{
		var newButtonDef:SKeyBinding;
		
		RemoveGFxButtonById(actionId);
		newButtonDef.ActionID = actionId;
		newButtonDef.Gamepad_NavCode = gamepadNavCode;
		newButtonDef.Keyboard_KeyCode = keyboardKeyCode;
		
		if (holdPrefix)
		{
			newButtonDef.LocalizationKey = GetHoldLabel() + " " + GetLocStringByKeyExt(label);
			newButtonDef.IsLocalized = true;
		}
		else
		{
			newButtonDef.LocalizationKey = label;
		}
		
		if (actionId == 1002)
		{
			newButtonDef.IsLocalized = true;
		}
		
		m_GFxInputBindings.PushBack(newButtonDef);
	}
}




class PriceConfirmationPopupData extends ConfirmationPopupData
{
	private var m_Price : float;
	
	public var itemId : SItemUniqueId;
	public var isStandaloneDismantle : bool;
	public var menuRef : CR4BlacksmithMenu; 

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
		if (isStandaloneDismantle)
		{
			menuRef.ProcessRequestConfirmation(itemId, 0);
		}
		else
		{
			menuRef.HandleActionConfirmation(true);
		}
		
		ClosePopup();
	}
	
	protected function OnUserDecline() : void
	{
		menuRef.HandleActionConfirmation(false);
		ClosePopup();
	}
}

class RepairAllPopupData extends ConfirmationPopupData
{
	private var m_Price : float;
	public var menuRef : CR4BlacksmithMenu; 

	public  function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject
	{
		var l_flashObject : CScriptedFlashObject;
		
		l_flashObject = parentFlashValueStorage.CreateTempFlashObject();
		l_flashObject.SetMemberFlashString("ContentRef", GetContentRef());
		l_flashObject.SetMemberFlashString("TextContent", GetLocStringByKeyExt("repair_equipped_items_description"));
		l_flashObject.SetMemberFlashString("TextTitle", GetLocStringByKeyExt("repair_equipped_items"));
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
		menuRef.RepairAll();
		ClosePopup();
	}
	
	protected function OnUserDecline() : void
	{
		ClosePopup();
	}
}


exec function repairmenu()
{
	theGame.RequestMenuWithBackground( 'BlacksmithMenu', 'CommonMenu' );
}

exec function tdisass()
{
	var initDataObject:W3StandaloneDismantleInitData = new W3StandaloneDismantleInitData in theGame.GetGuiManager();
	
	initDataObject.setDefaultState( 'Disassemble' );
	initDataObject.unlockCraftingMenu = true;
	initDataObject.SetBlockOtherPanels( true );
	
	theGame.RequestMenuWithBackground( 'BlacksmithMenu', 'CommonMenu', initDataObject );
}
