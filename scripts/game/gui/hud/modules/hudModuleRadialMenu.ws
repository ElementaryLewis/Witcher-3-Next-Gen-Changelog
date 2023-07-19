/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CR4HudModuleRadialMenu extends CR4HudModuleBase
{
	private var m_flashValueStorage 			  : CScriptedFlashValueStorage;	
	private var m_fxBlockRadialMenuSFF			  : CScriptedFlashFunction;
	private var m_fxShowRadialMenuSFF			  : CScriptedFlashFunction;
	private var m_fxUpdateItemIconSFF			  : CScriptedFlashFunction;
	private var m_fxUpdateFieldEquippedStateSFF	  : CScriptedFlashFunction;
	private var m_fxSetDesaturatedSFF			  : CScriptedFlashFunction;
	private var m_fxSetCiriRadialSFF			  : CScriptedFlashFunction;
	private var m_fxSetCiriItemSFF				  : CScriptedFlashFunction;
	private var m_fxSetMeditationButtonEnabledSFF : CScriptedFlashFunction;
	private var m_fxSetSelectedItem				  : CScriptedFlashFunction;
	private var m_fxSetArabicAligmentMode 		  : CScriptedFlashFunction;
	private var m_fxUpdateInputMode				  : CScriptedFlashFunction;
	
	
	private var m_fxSetDescription				  : CScriptedFlashFunction;
	private var m_fxResetPetardData				  : CScriptedFlashFunction;
	private var m_fxDisableRadialInput 			  : CScriptedFlashFunction;
	private var selectedSign : ESignType;
	private var lastItemDescription : string;
	
	
	private var m_shown							: bool;	
	private var m_IsPlayerCiri					: bool;
	private var m_isDesaturated					: bool;
	private	var m_HasBlink 						: bool;
	private var m_HasCharge						: bool;
	private	var m_allowAutoRotationReturnValue	: bool;
	private var m_swappedAcceptCancel			: bool;
	private var m_tutorialsHidden				: bool;
	private var _currentSelection				: string; 
	
	
	default m_shown = false;
	default m_IsPlayerCiri = false;
	default m_isDesaturated = false;
	default m_allowAutoRotationReturnValue = true;

	event  OnConfigUI()
	{
		var flashModule : CScriptedFlashSprite;
		
		m_tutorialsHidden = false;
		
		m_anchorName = "ScaleOnly";
		super.OnConfigUI();
		
		flashModule = GetModuleFlash();	
		m_flashValueStorage = GetModuleFlashValueStorage();
		
		m_fxUpdateInputMode 			= flashModule.GetMemberFlashFunction( "setAlternativeInputMode" );
		m_fxSetArabicAligmentMode       = flashModule.GetMemberFlashFunction( "setArabicAligmentMode" );
		m_fxBlockRadialMenuSFF			= flashModule.GetMemberFlashFunction( "BlockRadialMenu" );
		m_fxShowRadialMenuSFF			= flashModule.GetMemberFlashFunction( "ShowRadialMenu" );
		m_fxUpdateItemIconSFF			= flashModule.GetMemberFlashFunction( "UpdateItemIcon" );
		m_fxUpdateFieldEquippedStateSFF	= flashModule.GetMemberFlashFunction( "UpdateFieldEquippedState" );
		m_fxSetDesaturatedSFF 		= flashModule.GetMemberFlashFunction( "SetDesaturated" ); 
		m_fxSetCiriRadialSFF 		= flashModule.GetMemberFlashFunction( "setCiriRadial" ); 
		m_fxSetCiriItemSFF 			= flashModule.GetMemberFlashFunction( "setCiriItem" ); 
		m_fxSetMeditationButtonEnabledSFF 		= flashModule.GetMemberFlashFunction( "SetMeditationButtonEnabled" ); 
		m_fxSetSelectedItem 		= flashModule.GetMemberFlashFunction( "setSelectedItem" );
		
		
		m_fxSetDescription 			= flashModule.GetMemberFlashFunction( "SetChoosenDescription" );
		m_fxResetPetardData			= flashModule.GetMemberFlashFunction( "ResetPetardData" );
		m_fxDisableRadialInput		= flashModule.GetMemberFlashFunction( "DisableRadialInput" );
		
		
		theInput.RegisterListener( this, 'OnRadialMenu', 'RadialMenu' );
		theInput.RegisterListener( this, 'OnRadialMenuClose', 'CloseRadialMenu' );
		theInput.RegisterListener( this, 'OnRadialMenuConfirmSelection', 'ConfirmRadialMenuSelection' );
		theInput.RegisterListener( this, 'OnOpenMeditation', 'OpenMeditation' );
		
		UpdateSwapAcceptCancel();
		UpdateInputMode();
		setArabicAligmentMode();
		
		SelectCurrentSign();
	}
	
	
	public function DisableRadialMenuInput(disable : bool)
	{
		m_fxDisableRadialInput.InvokeSelfOneArg(FlashArgBool(disable));
	}
	
	private function ToggleRadialMenuInItemsModule(on : bool)
	{	
		var itemInfoModule : CR4HudModuleItemInfo;
		itemInfoModule = (CR4HudModuleItemInfo)theGame.GetHud().GetHudModule("ItemInfoModule");
		itemInfoModule.RadialMenuOn(on);
	}
	
	
	public function setArabicAligmentMode() : void
	{
		var language : string;
		var audioLanguage : string;
		theGame.GetGameLanguageName(audioLanguage,language);
		if (m_fxSetArabicAligmentMode)
		{
			m_fxSetArabicAligmentMode.InvokeSelfOneArg( FlashArgBool( (language == "AR") ) );
		}
	}
	
	public function UpdateSwapAcceptCancel():void
	{
		var inGameConfigWrapper : CInGameConfigWrapper;
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		m_swappedAcceptCancel = inGameConfigWrapper.GetVarValue('Controls', 'SwapAcceptCancel');
	}
	
	public function UpdateInputMode():void
	{
		var inGameConfigWrapper    : CInGameConfigWrapper;
		var isAlternativeInputMode : bool;
		
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		isAlternativeInputMode = inGameConfigWrapper.GetVarValue('Controls', 'AlternativeRadialMenuInputMode');
		m_fxUpdateInputMode.InvokeSelfOneArg( FlashArgBool( isAlternativeInputMode ) );
	}
	
	event OnTick( timeDelta : float )
	{
	}

	function IsRadialMenuOpened() : bool
	{
		return m_shown;
	}

	event OnRadialMenuItemSelected(choosenSymbol : string, isDesaturated : bool )
	{
		m_isDesaturated = isDesaturated;
		if( !m_isDesaturated )
		{
			_currentSelection = choosenSymbol;	
		}
		else
		{
			_currentSelection = "";
		}
		if ( !theGame.IsBlackscreen() )
		{
			theSound.SoundEvent( "gui_ingame_wheel_highlight" );
		}
		else
		{
			LogChannel( 'IgnoredSounds', "HUD: gui_ingame_wheel_highlight" );
		}
	}

	event OnRadialMenuItemChoose( choosenSymbol : string )
	{
		
	}	

	event OnRadialMenuConfirmSelection(  action : SInputAction  )
	{
		if( IsPressed(action) )
		{
			
			if (m_swappedAcceptCancel)
			{
				UserClose();
			}
			else
			{
				UserConfirmSelection();
			}
		}
	}
	
	event OnRadialMenuClose( action : SInputAction )
	{
		if( IsPressed(action) )
		{
			
			if (m_swappedAcceptCancel)
			{
				UserConfirmSelection();
			}
			else
			{
				UserClose();
			}
		}
	}
	
	private function UserConfirmSelection():void
	{
		if( m_shown && !m_IsPlayerCiri)
		{
			if( _currentSelection != "" )
			{
				HideRadialMenu();
				thePlayer.OnRadialMenuItemChoose(_currentSelection);
				
				EquipLastSelectedItem(); 
			}
			else
			{
				theSound.SoundEvent( "gui_global_denied" );	
			}
		}
	}
	
	event  OnActivateSlot(slotName:string, isTabOrBumper:bool, swappingItems:bool) 
	{
		var outKeys : array< EInputKey >;
		var player : W3PlayerWitcher;
		player = GetWitcherPlayer();
		
		
		if(isTabOrBumper)
		{
			if(!swappingItems)
				EquipLastSelectedItem(true);
		}
		else
			thePlayer.OnRadialMenuItemChoose(slotName);
		
		
	}
	
	event  OnRequestCloseRadial(PCConfirmControls:bool) 
	{
		
		if(PCConfirmControls)
			EquipLastSelectedItem();
		
		UserClose();
	}
	
	private function UserClose():void
	{
		if( m_shown )
		{
			HideRadialMenu();
		}
	}
	
	event OnOpenMeditation(  action : SInputAction  )
	{
		var witcher : W3PlayerWitcher;
		
		if( !m_IsPlayerCiri && IsPressed(action) )
		{
			if( m_shown )
			{
				witcher = GetWitcherPlayer();
				
				if(witcher.IsActionAllowed(EIAB_OpenMeditation))
				{
					HideRadialMenu();
					ResetMeditationSavedData();
					thePlayer.OnRadialMenuItemChoose("Meditation"); 
					
					
					
					if(thePlayer.GetCurrentStateName() != 'Meditation')
					{
						thePlayer.DisplayActionDisallowedHudMessage(EIAB_OpenMeditation, , witcher.IsThreatened(), !witcher.CanMeditateHere(), witcher.IsThreatened());
					}
					else
					{
						
						return true;
					}
				}
				else
				{
					thePlayer.DisplayActionDisallowedHudMessage(EIAB_OpenMeditation, , witcher.IsThreatened(), !witcher.CanMeditateHere(), witcher.IsThreatened());
				}
			}	
		}
	}
	
	function ResetMeditationSavedData()
	{
		var guiManager 			: CR4GuiManager;
		
		guiManager = theGame.GetGuiManager();
		guiManager.RemoveUISavedData('MeditationClockMenu');
	}
	
	event OnRadialMenu( action : SInputAction )
	{
		if( IsPressed(action) )
		{
			if( m_shown )
			{
				
				
				return true;
			}
			if(!thePlayer.IsActionAllowed(EIAB_RadialMenu))
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_RadialMenu);
				return false;
			}
		
			if ( theGame.IsDialogOrCutscenePlaying() || theGame.IsBlackscreenOrFading() || (!thePlayer.GetBIsInputAllowed() && !GetWitcherPlayer().IsUITakeInput()) )
				return false;
				
			ShowRadialMenu();
			
		}
	}
	event  OnRadialPauseGame()
	{
		
	}
	function ShowRadialMenu()
	{
		var camera : CCustomCamera;
		var hud : CR4ScriptedHud;
		
		if( !m_shown && !theGame.IsDialogOrCutscenePlaying())
		{
			
			if(!thePlayer.IsActionAllowed(EIAB_OpenInventory) && !thePlayer.IsCiri())
			{
				m_fxResetPetardData.InvokeSelf();
			}
			
		
			
			thePlayer.RestoreBlockedSlots();
			
			
			theGame.CenterMouse();
			
			theGame.ForceUIAnalog(true);
			theInput.StoreContext( 'RadialMenu' );
			theSound.SoundEvent( "gui_ingame_wheel_open" );
			if( thePlayer.IsCiri() != m_IsPlayerCiri || m_HasBlink != thePlayer.HasAbility('CiriBlink') || m_HasCharge != thePlayer.HasAbility('CiriCharge') )
			{
				m_IsPlayerCiri = thePlayer.IsCiri();
				m_HasBlink = thePlayer.HasAbility('CiriBlink');
				m_HasCharge = thePlayer.HasAbility('CiriCharge');
				m_fxSetCiriRadialSFF.InvokeSelfThreeArgs( FlashArgBool(m_IsPlayerCiri), FlashArgBool(m_HasBlink), FlashArgBool(m_HasCharge) );
			}
			thePlayer.BlockAction(EIAB_Jump,'RadialMenu');
			
			UpdateItemsIcons();
			
			theGame.SetTimeScale( 0.1, theGame.GetTimescaleSource(ETS_RadialMenu), theGame.GetTimescalePriority(ETS_RadialMenu), false, true);
			GetWitcherPlayer().SetUITakeInput(true);

			
			camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
			m_allowAutoRotationReturnValue = camera.allowAutoRotation;
			camera.allowAutoRotation = false;
			
			
			m_shown = true;
			ResetItemsModule();
			theGame.GetGuiManager().SendCustomUIEvent( 'OpenedRadialMenu' );
			if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())		
			{
				theGame.GetTutorialSystem().uiHandler.OnOpenedMenu('RadialMenu');
			}
			m_fxSetMeditationButtonEnabledSFF.InvokeSelfOneArg(FlashArgBool(GetWitcherPlayer().IsActionAllowed(EIAB_OpenMeditation)));
			
			
			
			LogChannel( 'GWINT_AI', "SHOW RADIAL");
			if (!m_tutorialsHidden)
			{
				theGame.GetGuiManager().HideTutorial( true, false );
				m_tutorialsHidden = true;
			}

			UpdateBuffsModule( true );
			
			hud = (CR4ScriptedHud)theGame.GetHud();
			if ( hud )
			{
				hud.OnRadialOpened();
			}
			
			theGame.GetTutorialSystem().uiHandler.OnOpeningMenu( 'RadialMenu' );
			
			
			ToggleRadialMenuInItemsModule(true);
			if(!thePlayer.IsCiri())
				selectedSign = GetWitcherPlayer().GetEquippedSign();
		}
	}
	
	private function SelectCurrentSign()
	{
		if (thePlayer.IsCiri() == m_IsPlayerCiri)
		{
			m_fxSetSelectedItem.InvokeSelfOneArg(FlashArgString(SignEnumToString(thePlayer.GetEquippedSign())));
		}
	}
	

	event OnHideRadialMenu()
	{
		LogChannel( 'GWINT_AI', "HIDE RADIAL");
		if (m_tutorialsHidden)
		{
			theGame.GetGuiManager().HideTutorial( false, false );
			m_tutorialsHidden = false;
		}
	}
	
	function HideRadialMenu()
	{
		var camera : CCustomCamera;
		var hud : CR4ScriptedHud;
		
		if( m_shown )
		{	
			
			theGame.ForceUIAnalog(false);
			theSound.SoundEvent( "gui_ingame_wheel_close" );
			
			theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_RadialMenu) );
			theGame.Unpause( "FastMenu" );
			GetWitcherPlayer().SetUITakeInput(false);

			
			camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
			camera.allowAutoRotation = m_allowAutoRotationReturnValue;
			
			m_shown = false;
			theInput.RestoreContext( 'RadialMenu', true );
			
			theGame.GetGuiManager().SendCustomUIEvent( 'ClosedRadialMenu' );
			ResetItemsModule();
			if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())		
			{
				theGame.GetTutorialSystem().uiHandler.OnClosedMenu('RadialMenu');
			}
			thePlayer.UnblockAction( EIAB_Jump, 'RadialMenu' );

			UpdateBuffsModule( false );

			hud = (CR4ScriptedHud)theGame.GetHud();
			if ( hud )
			{
				hud.OnRadialClosed();
			}
			
			theGame.GetTutorialSystem().uiHandler.OnClosingMenu( 'RadialMenu' );
			
			
			ToggleRadialMenuInItemsModule(false);
			if(GetWitcherPlayer().GetEquippedSign() == ST_None)
			{
				GetWitcherPlayer().SetEquippedSign(selectedSign);
				m_fxUpdateFieldEquippedStateSFF.InvokeSelfFourArgs( FlashArgString( SignEnumToString(GetWitcherPlayer().GetEquippedSign())), FlashArgString(""), FlashArgString(true), FlashArgInt(0));
			}
			
		}
	}

	private function UpdateBuffsModule( onRadialMenuOpened : bool )
	{
		var module : CR4HudModuleBase;
		var hud : CR4ScriptedHud;

		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
		{
			if ( onRadialMenuOpened )
			{
				module = (CR4HudModuleBase)hud.GetHudModule( "BuffsModule" );
				if (module)
				{
					module.SetEnabled( true );
				}
			}
			else
			{
				hud.UpdateHudConfig( 'BuffsModule', true );
			}
		}
	}
	
	private function ResetItemsModule()
	{	
		var itemInfoModule : CR4HudModuleItemInfo;
		itemInfoModule = (CR4HudModuleItemInfo)theGame.GetHud().GetHudModule("ItemInfoModule");
		itemInfoModule.ResetItems();
	}
	
	function UpdateItemsIcons(optional onlyCrossbow : bool)
	{
		var i   	: int;
		var inv 	: CInventoryComponent;
		var player  : W3PlayerWitcher;
		var outKeys : array< EInputKey >;
		
		var itemName 		: string;
		var itemDescription : string;
		var itemPath 		: string;
		var itemCategory 	: name;
		var itemQuality		: int;
		
		var equippedItem   : SItemUniqueId;
		var selectedItemId : SItemUniqueId;
		
		var pocket1Slots  : array <EEquipmentSlots>;
		var pocket2Slots  : array <EEquipmentSlots>;
		var itemsDataList : CScriptedFlashArray;
		
		player = GetWitcherPlayer();
		inv = thePlayer.GetInventory();
		
		selectedItemId = GetWitcherPlayer().GetSelectedItemId();
		
		if( m_IsPlayerCiri )
		{
			equippedItem = GetCiriItem();
			
			if( inv.IsIdValid( equippedItem ) )
			{
				itemName = inv.GetItemName( equippedItem );
				itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( equippedItem ) );
				itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( equippedItem ) );
				itemPath = inv.GetItemIconPathByUniqueID( equippedItem );
			}
			
			m_fxSetCiriItemSFF.InvokeSelfThreeArgs( FlashArgString( itemPath ), FlashArgString( itemName ), FlashArgString( itemDescription ) );
		}
		else
		{
			
			
			
			
			itemsDataList = m_flashValueStorage.CreateTempFlashArray();
			
			
			if(onlyCrossbow)
				UpdateCrossbowItemData( 7, itemsDataList );
			else	
			{
				UpdateCrossbowItemData( 7, itemsDataList );
				UpdateNGEItemData( 6, itemsDataList, 'petard', "slot1" );
				UpdateNGEItemData( 8, itemsDataList, 'usable', "slot3" );
			}

			
			
			
			
			m_flashValueStorage.SetFlashArray( "hud.radial.items", itemsDataList );
			
			
			
			if(!onlyCrossbow)
			{
				outKeys.Clear();
				theInput.GetCurrentKeysForAction('CastSign',outKeys);
				m_fxUpdateFieldEquippedStateSFF.InvokeSelfFourArgs( FlashArgString( SignEnumToString(player.GetEquippedSign())), FlashArgString(""), FlashArgString(true), FlashArgInt(outKeys[0]));
			}
		}
	}

	
	private function UpdateNGEItemData( radialSlotId : int, out dataList : CScriptedFlashArray, itemCat : name, radialSlotName : string ) : void
	{
		var player 		    : W3PlayerWitcher;
		var inv    		    : CInventoryComponent;
		var items		    : array<SItemUniqueId>;
		var masks		    : array<SItemUniqueId>;
		var currentItem   	: SItemUniqueId;
		var equippedItem  	: SItemUniqueId;
		var selectedItem    : SItemUniqueId;
		var itemsList		: CScriptedFlashArray;
		var itemDataObject  : CScriptedFlashObject;
		var containerObject : CScriptedFlashObject;
		
		var slotName     	: string;
		var itemCategory   	: string;
		var itemName	 	: string; 
		var itemDescription : string;
		var itemIconPath 	: string;

		var itemQuality  : int;
		var itemQuantity : int;
		var chargesCount : int;
		var i, count 	 : int;
		
		var tempItems, tempBombs	: array<SItemUniqueId>;
		var tempItem,tempItem2 	: SItemUniqueId;
		var tempName 	: name;
		
		player = GetWitcherPlayer();
		inv = player.GetInventory();
		selectedItem = GetWitcherPlayer().GetSelectedItemId();
		
		items = inv.GetItemsByCategory(itemCat);
		count = items.Size();
		
		if(itemCat == 'petard' && !player.IsActionAllowed(EIAB_OpenInventory))
		{
			for(i=0;i<count;i+=1)
			{			
				tempName = inv.GetItemName(items[i]);
				
				switch(tempName)
				{
					case 'q703_paint_bomb_red':
					case 'q703_paint_bomb_green':
					case 'q703_paint_bomb_yellow':
					case 'q703_paint_bomb_blue':
					case 'q703_paint_bomb_purple':
					case 'Snow Ball':
					case 'Tutorial Bomb':
					{
						tempBombs.PushBack(items[i]);
						if(!player.GetItemEquippedOnSlot( EES_Petard1, tempItem))
							GetWitcherPlayer().EquipItem( items[i], EES_Petard1 );
					}
				}
			}
			
			items = tempBombs;
		}
		
		if(itemCat == 'usable')
		{
			for(i=0;i<count;i+=1)
			{			
				tempName = inv.GetItemName(items[i]);
				
				switch(tempName)
				{
					case 'FeromoneBomb':
					case 'ciris_phylactery':
					case 'q403_ciri_meteor':
					case 'mq1060_right_hand_potion':
					case 'Torch_work':
					case 'Torch_work_right':
					case 'mq7014_reagent':
					case 'q703_torch_work_right':
					case 'sq701_tutorial_shield':
					{
						continue;
					}
				}
				
				tempItems.PushBack(items[i]);
			}		
			items = tempItems;
		}
		
		count = items.Size();
		
		itemsList = m_flashValueStorage.CreateTempFlashArray();
		containerObject = m_flashValueStorage.CreateTempFlashObject();
		
		slotName = radialSlotName;
		containerObject.SetMemberFlashInt( "slotId", radialSlotId );
		containerObject.SetMemberFlashString( "slotName", slotName );
		containerObject.SetMemberFlashBool( "showChangeItemText", true );
		
		if( !player.GetItemEquippedOnSlot( EES_Quickslot1, tempItem) && player.IsActionAllowed(EIAB_OpenInventory) && (itemCat == 'usable') && count > 0 )
		{
			GetWitcherPlayer().EquipItem( items[0], EES_Quickslot1 );
			GetWitcherPlayer().SelectQuickslotItem( EES_Quickslot1 );
		}
		if( !player.GetItemEquippedOnSlot( EES_Petard1, tempItem) && player.IsActionAllowed(EIAB_OpenInventory) && itemCat == 'petard' && count > 0 )
		{
			GetWitcherPlayer().EquipItem( items[0], EES_Petard1 );
			GetWitcherPlayer().SelectQuickslotItem( EES_Petard1 );
		}	
		
		
		player.UnequipItemFromSlot(EES_Petard2,true);		
		player.GetItemEquippedOnSlot( EES_Quickslot2, tempItem );
		if(inv.IsIdValid(tempItem) && inv.GetItemCategory(tempItem) != 'mask')
		{
			player.UnequipItemFromSlot(EES_Quickslot2,true);	
		}		
		
		
		inv.GetItemEquippedOnSlot( EES_Quickslot1, tempItem );
		inv.GetItemEquippedOnSlot( EES_Quickslot2, tempItem2 );
		if(!inv.IsIdValid(tempItem2) && inv.IsIdValid(tempItem) && inv.GetItemCategory(tempItem) == 'mask')
		{
			player.EquipItemInGivenSlot(tempItem, EES_Quickslot2, true, false);
		}
		
		if(itemCat == 'usable')
			player.GetItemEquippedOnSlot( EES_Quickslot1, equippedItem  );
		else if(itemCat == 'petard')
			player.GetItemEquippedOnSlot( EES_Petard1, equippedItem  );
		
		if( inv.IsIdValid( equippedItem  ) || count > 0 )
		{
			itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( equippedItem  ) );
			itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( equippedItem  ) );
			itemCategory = inv.GetItemCategory( equippedItem  );
			itemQuality = inv.GetItemQuality( equippedItem  );
			itemIconPath = inv.GetItemIconPathByUniqueID( equippedItem  );
			
			containerObject.SetMemberFlashString( "name", itemName );
			containerObject.SetMemberFlashString( "description", itemDescription );
			containerObject.SetMemberFlashString( "category", itemCategory );
			containerObject.SetMemberFlashString( "itemIconPath", itemIconPath );
			containerObject.SetMemberFlashInt( "quality", itemQuality );
			containerObject.SetMemberFlashBool( "isEquipped", selectedItem == equippedItem  );
			
			lastItemDescription = itemDescription;
			
			
			for ( i = 0; i < count; i += 1 )
			{
				currentItem = items[ i ];

				itemDataObject = m_flashValueStorage.CreateTempFlashObject();
				itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( currentItem  ) );
				itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( currentItem  ) );
				itemCategory = inv.GetItemCategory( currentItem  );
				itemQuality = inv.GetItemQuality( currentItem  );
				itemIconPath = "img://" + inv.GetItemIconPathByUniqueID( currentItem  );
				
				lastItemDescription = itemDescription;
				
				if( inv.IsItemSingletonItem( currentItem  ) && inv.SingletonItemGetMaxAmmo( currentItem  ) > 0 )
				{
					
					if(itemCat == 'petard')
						chargesCount = thePlayer.inv.SingletonItemGetAmmo( equippedItem  );	
					else
					
						chargesCount = thePlayer.inv.SingletonItemGetAmmo( currentItem  );	
				}
				else
				{
					chargesCount = -1;
				}
				
				itemDataObject.SetMemberFlashString( "name", itemName );
				itemDataObject.SetMemberFlashString( "description", itemDescription );
				itemDataObject.SetMemberFlashString( "itemIconPath", itemIconPath );
				itemDataObject.SetMemberFlashBool( "isEquipped", currentItem  == equippedItem  );
				itemDataObject.SetMemberFlashInt( "charges", chargesCount );
				itemDataObject.SetMemberFlashInt( "id", ItemToFlashUInt( currentItem  ) );
				
				itemsList.PushBackFlashObject( itemDataObject );
			}
			
			containerObject.SetMemberFlashArray( "itemsList", itemsList );
		}
		else
		{
			containerObject.SetMemberFlashBool( "isEmpty", true );
		}
		
		dataList.PushBackFlashObject( containerObject );	
	}
	
	
	
	private var lastSelectedItem : SItemUniqueId; 
	private var lastItemCategory : name;
	private function EquipLastSelectedItem(optional force : bool)
	{
		if(force || GetWitcherPlayer().GetEquippedSign() == ST_None)
		{
			if(lastItemCategory == 'bomb' && _currentSelection == "slot1")
			{
				GetWitcherPlayer().EquipItem( lastSelectedItem, EES_Petard1);
				GetWitcherPlayer().SelectQuickslotItem( EES_Petard1 );
				GetWitcherPlayer().SetEquippedSign(selectedSign);
			}
			else if(lastItemCategory == 'usable' && _currentSelection == "slot3")
			{
				if( thePlayer.IsHoldingItemInLHand() && lastSelectedItem != thePlayer.currentlyEquipedItemL )
				{
					thePlayer.SetPlayerActionToRestore ( PATR_None );
					thePlayer.OnUseSelectedItem();
					thePlayer.SetLastSelectedRadialItem(lastSelectedItem);
				}
				else
				{
					GetWitcherPlayer().EquipItem( lastSelectedItem, EES_Quickslot1, false);
					GetWitcherPlayer().SelectQuickslotItem( EES_Quickslot1 );
				}
				GetWitcherPlayer().SetEquippedSign(selectedSign);
			}
			else if(lastItemCategory == ''  && _currentSelection == "Crossbow")
			{
				GetWitcherPlayer().SelectQuickslotItem( EES_RangedWeapon );
			}
		}
		
		if(force)
		{
			if(_currentSelection == "Aard")
				GetWitcherPlayer().SetEquippedSign(ST_Aard);
			else if(_currentSelection == "Igni")
				GetWitcherPlayer().SetEquippedSign(ST_Igni);
			else if(_currentSelection == "Yrden")
				GetWitcherPlayer().SetEquippedSign(ST_Yrden);
			else if(_currentSelection == "Axii")
				GetWitcherPlayer().SetEquippedSign(ST_Axii);
			else if(_currentSelection == "Quen")
				GetWitcherPlayer().SetEquippedSign(ST_Quen);
		}
	}
	
	
	event OnEquipBolt( boltItemId : SItemUniqueId )
	{
		var inv : CInventoryComponent;
		var equippedBolts : SItemUniqueId;
		
		
		var tempName : name;
		var itemDescription : string;

		inv = GetWitcherPlayer().GetInventory();
		lastItemCategory = '';

		if( inv.IsIdValid(boltItemId) && inv.GetItemCategory(boltItemId) == 'petard')
		{
			if(thePlayer.IsActionAllowed( EIAB_QuickSlots ))
			{			
				if(thePlayer.IsActionAllowed( EIAB_OpenInventory ))
				{
					lastSelectedItem = boltItemId;
					lastItemCategory = 'bomb';
					itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( boltItemId  ) );
					m_fxSetDescription.InvokeSelfOneArg(FlashArgString(itemDescription));
				}
				else
				{
					tempName = inv.GetItemName(boltItemId);
					switch(tempName)
					{
						case 'q703_paint_bomb_red':
						case 'q703_paint_bomb_green':
						case 'q703_paint_bomb_yellow':
						case 'q703_paint_bomb_blue':
						case 'q703_paint_bomb_purple':
						case 'Snow Ball':
						case 'Tutorial Bomb':
						{
							lastSelectedItem = boltItemId;
							lastItemCategory = 'bomb';
							itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( boltItemId  ) );
							m_fxSetDescription.InvokeSelfOneArg(FlashArgString(itemDescription));
						}
					}
				}
			}
		}
		else if(inv.IsIdValid(boltItemId) && inv.GetItemCategory(boltItemId) == 'usable')
		{
			if(thePlayer.IsActionAllowed( EIAB_QuickSlots ))
			{
				lastSelectedItem = boltItemId;
				lastItemCategory = 'usable';
				itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( boltItemId  ) );
				m_fxSetDescription.InvokeSelfOneArg(FlashArgString(itemDescription));
			}
		}
		else  if ( boltItemId == GetInvalidUniqueId() )
		{
			
			GetWitcherPlayer().GetItemEquippedOnSlot( EES_Bolt, equippedBolts );
			
			if ( inv.IsIdValid( equippedBolts ) && !inv.ItemHasTag( equippedBolts, theGame.params.TAG_INFINITE_AMMO ) )
			{
				GetWitcherPlayer().UnequipItemFromSlot( EES_Bolt, false );
			}	
			
			UpdateItemsIcons(true);
		}
		else if( thePlayer.inv.IsIdValid( boltItemId ) )
		{
			GetWitcherPlayer().EquipItem( boltItemId, EES_Bolt);
			thePlayer.SetUpdateQuickSlotItems(true);	
			
			UpdateItemsIcons(true);
		}
	}
	
	private function UpdateCrossbowItemData( radialSlotId : int, out dataList : CScriptedFlashArray ) : void
	{
		var player 		    : W3PlayerWitcher;
		var inv    		    : CInventoryComponent;
		var boltsList	    : array<SItemUniqueId>;
		var currentBolt     : SItemUniqueId;
		var equippedBolt    : SItemUniqueId;
		var equippedItem    : SItemUniqueId;
		var selectedItem    : SItemUniqueId;
		var itemsList		: CScriptedFlashArray;
		var itemDataObject  : CScriptedFlashObject;
		var containerObject : CScriptedFlashObject;
		
		var slotName     	: string;
		var itemCategory   	: string;
		var itemName	 	: string; 
		var itemDescription : string;
		var itemIconPath 	: string;
		
		var itemCat      : name;
		var itemQuality  : int;
		var itemQuantity : int;
		var chargesCount : int;
		var i, count 	 : int;
		var playerLevel  : int;
		
		var dm : CDefinitionsManagerAccessor;
		
		var infiniteBoltItemName : name;
		
		playerLevel = thePlayer.GetLevel();
		player = GetWitcherPlayer();
		inv = player.GetInventory();
		infiniteBoltItemName = player.GetCurrentInfiniteBoltName();
		
		selectedItem = GetWitcherPlayer().GetSelectedItemId();
		
		itemsList = m_flashValueStorage.CreateTempFlashArray();
		containerObject = m_flashValueStorage.CreateTempFlashObject();
		
		
		slotName = "Crossbow";
		containerObject.SetMemberFlashInt( "slotId", radialSlotId );
		containerObject.SetMemberFlashString( "slotName", slotName );
		
		player.GetItemEquippedOnSlot( EES_RangedWeapon, equippedItem );
		player.GetItemEquippedOnSlot( EES_Bolt, equippedBolt );
		
		if( inv.IsIdValid( equippedItem ) )
		{
			
			
			itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( equippedItem ) );
			itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( equippedItem ) );
			itemCategory = inv.GetItemCategory( equippedItem );
			itemQuality = inv.GetItemQuality( equippedItem );
			itemIconPath = inv.GetItemIconPathByUniqueID( equippedItem );
			
			containerObject.SetMemberFlashString( "name", itemName );
			containerObject.SetMemberFlashString( "description", itemDescription );
			containerObject.SetMemberFlashString( "category", itemCategory );
			containerObject.SetMemberFlashString( "itemIconPath", itemIconPath );
			containerObject.SetMemberFlashInt( "quality", itemQuality );
			containerObject.SetMemberFlashBool( "isEquipped", selectedItem == equippedItem );
			
			lastItemDescription = itemDescription;
			
			
			
			boltsList = inv.GetItemsByCategory('bolt');
			count = boltsList.Size();
			
			
			dm = theGame.GetDefinitionsManager();
			itemName = GetLocStringByKeyExt( dm.GetItemLocalisationKeyName( infiniteBoltItemName ) );
			itemDescription = GetLocStringByKeyExt( dm.GetItemLocalisationKeyDesc( infiniteBoltItemName ) );
			itemIconPath = "img://" + dm.GetItemIconPath( infiniteBoltItemName );
			inv.GetItemId( infiniteBoltItemName );

			if ( StrLen( itemName ) )
			{
				itemDataObject = m_flashValueStorage.CreateTempFlashObject();
				
				itemDataObject.SetMemberFlashString( "name", itemName );
				itemDataObject.SetMemberFlashString( "description", itemDescription );
				itemDataObject.SetMemberFlashString( "itemIconPath", itemIconPath );
				itemDataObject.SetMemberFlashBool( "isEquipped", true );
				itemDataObject.SetMemberFlashInt( "charges", -1 );
				itemDataObject.SetMemberFlashInt( "id", 0 );

				itemsList.PushBackFlashObject( itemDataObject );
			}

			if ( !GetWitcherPlayer().ShouldUseInfiniteWaterBolts() )
			{
			
			for ( i = 0; i < count; i += 1 )
			{
				currentBolt = boltsList[ i ];
				
				if ( inv.GetItemLevel( currentBolt ) <= playerLevel )
				{
					if ( inv.GetItemName( currentBolt ) == infiniteBoltItemName )
					{
						
						continue;
					}
					itemDataObject = m_flashValueStorage.CreateTempFlashObject();
					itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( currentBolt ) );
					itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( currentBolt ) );
					itemCategory = inv.GetItemCategory( currentBolt );
					itemQuality = inv.GetItemQuality( currentBolt );
					itemIconPath = "img://" + inv.GetItemIconPathByUniqueID( currentBolt );
					
					if( inv.ItemHasTag( currentBolt, theGame.params.TAG_INFINITE_AMMO ) )
					{
						chargesCount = -1;
					}
					else
					{
						chargesCount = inv.GetItemQuantity( currentBolt );
					}
					
					itemDataObject.SetMemberFlashString( "name", itemName );
					itemDataObject.SetMemberFlashString( "description", itemDescription );
					itemDataObject.SetMemberFlashString( "itemIconPath", itemIconPath );
					itemDataObject.SetMemberFlashBool( "isEquipped", currentBolt == equippedBolt );
					itemDataObject.SetMemberFlashInt( "charges", chargesCount );
					itemDataObject.SetMemberFlashInt( "id", ItemToFlashUInt( currentBolt ) );
					
					itemsList.PushBackFlashObject( itemDataObject );
				}
			}
			
			}
			
			containerObject.SetMemberFlashArray( "itemsList", itemsList );
		}
		else
		{
			containerObject.SetMemberFlashArray( "itemsList", itemsList );
			containerObject.SetMemberFlashBool( "isEmpty", true );
		}
		
		dataList.PushBackFlashObject( containerObject );	
	}
	
	private function UpdatePocketItemData( radialSlotId : int, slotsList : array <EEquipmentSlots>, out dataList : CScriptedFlashArray ) : void
	{
		var player 		    : W3PlayerWitcher;
		var inv    		    : CInventoryComponent;
		var equippedItem    : SItemUniqueId;
		var selectedItem    : SItemUniqueId;
		var itemsList		: CScriptedFlashArray;
		var itemDataObject  : CScriptedFlashObject;
		var containerObject : CScriptedFlashObject;
		
		var itemCategory   	: string;
		var slotName     	: string;
		var itemName		: string; 
		var itemDescription : string;
		var itemIconPath 	: string;
		
		var itemCat      : name;
		var itemQuality  : int;
		var itemQuantity : int;
		var chargesCount : int;
		var i, count 	 : int;
		
		player = GetWitcherPlayer();
		inv = player.GetInventory();
		count = slotsList.Size();
		selectedItem = GetWitcherPlayer().GetSelectedItemId();
		
		itemsList = m_flashValueStorage.CreateTempFlashArray();
		containerObject = m_flashValueStorage.CreateTempFlashObject();
		slotName = "Slot" + ( radialSlotId - 5 ); 
		containerObject.SetMemberFlashInt( "slotId", radialSlotId );
		containerObject.SetMemberFlashBool( "isPocketData", true );
		containerObject.SetMemberFlashString( "slotName", slotName );
		
		for ( i = 0; i < count; i += 1 )
		{
			itemDataObject = m_flashValueStorage.CreateTempFlashObject();
			slotName = "Slot" + ( radialSlotId - 5 + i ); 
			itemDataObject.SetMemberFlashString( "slotName", slotName );
			player.GetItemEquippedOnSlot( slotsList[i], equippedItem );
			
			if( inv.IsIdValid( equippedItem ) )
			{
				itemName = GetLocStringByKeyExt( inv.GetItemLocalizedNameByUniqueID( equippedItem ) );
				itemDescription = GetLocStringByKeyExt( inv.GetItemLocalizedDescriptionByUniqueID( equippedItem ) );
				itemCategory = inv.GetItemCategory( equippedItem );
				itemQuality = inv.GetItemQuality( equippedItem );
				itemIconPath = inv.GetItemIconPathByUniqueID( equippedItem );
				
				itemDataObject.SetMemberFlashString( "name", itemName );
				itemDataObject.SetMemberFlashString( "description", itemDescription );
				itemDataObject.SetMemberFlashString( "category", itemCategory );
				itemDataObject.SetMemberFlashString( "itemIconPath", itemIconPath );
				itemDataObject.SetMemberFlashInt( "quality", itemQuality );
				itemDataObject.SetMemberFlashBool( "isEquipped", selectedItem == equippedItem );
				
				if( inv.IsItemSingletonItem( equippedItem ) && inv.SingletonItemGetMaxAmmo( equippedItem ) > 0 )
				{
					chargesCount = thePlayer.inv.SingletonItemGetAmmo( equippedItem );					
				}
				else
				{
					chargesCount = -1;
				}
				
				itemDataObject.SetMemberFlashInt( "charges", chargesCount );
					
				
				itemsList.PushBackFlashObject( itemDataObject );
			}
		}
		
		containerObject.SetMemberFlashArray( "itemsList", itemsList );
		dataList.PushBackFlashObject( containerObject );
	}
	
	private function UpdateItemIconByIdx( i : int, slotId : EEquipmentSlots ) : void 
	{			
		var inv : CInventoryComponent;
		var item : SItemUniqueId;
		var player : W3PlayerWitcher;
		var itemName : string;
		var itemDescription : string;
		var itemPath : string;
		var itemCategory : name;
		var itemQuality: int;
		var _CurrentSelectedItem : SItemUniqueId; 
		
		player = GetWitcherPlayer();
		inv = player.GetInventory();
		
		player.GetItemEquippedOnSlot(slotId, item);
		_CurrentSelectedItem = GetWitcherPlayer().GetSelectedItemId();
		
		if( inv.IsIdValid(item) )
		{
			itemName = GetLocStringByKeyExt(inv.GetItemLocalizedNameByUniqueID(item));
			itemDescription = GetLocStringByKeyExt(inv.GetItemLocalizedDescriptionByUniqueID(item));
			itemCategory = inv.GetItemCategory (item);
			itemQuality = inv.GetItemQuality(item);
			itemPath = inv.GetItemIconPathByUniqueID(item);
			
			m_fxUpdateItemIconSFF.InvokeSelfSixArgs( FlashArgInt( i ), FlashArgString( itemPath ), FlashArgString( itemName ), FlashArgString( itemCategory ), FlashArgString( itemDescription ) , FlashArgInt( itemQuality ) );
			
			itemName = "Slot" + ( i - 5 );
			
			
			if( item == _CurrentSelectedItem )
			{
				if( inv.IsIdValid(_CurrentSelectedItem) )
				{
					m_fxUpdateFieldEquippedStateSFF.InvokeSelfFourArgs( FlashArgString(itemName), FlashArgString(itemDescription), FlashArgBool(true) ,FlashArgInt(0));
				}
			}
			else
			{
				m_fxUpdateFieldEquippedStateSFF.InvokeSelfFourArgs( FlashArgString(itemName), FlashArgString(itemDescription), FlashArgBool(false), FlashArgInt(0) );
			}
			
		}
		else
		{
			m_fxUpdateItemIconSFF.InvokeSelfSixArgs( FlashArgInt(i),FlashArgString(""),FlashArgString(""), FlashArgString(""), FlashArgString(""), FlashArgString("") );
		}
	}
	
	function GetCiriItem() : SItemUniqueId
	{
		var ret : array<SItemUniqueId>;
		
		ret = thePlayer.GetInventory().GetItemsByName('q403_ciri_meteor');
		
		return ret[0];
	}
	
	public function SetDesaturated( value : bool, fieldName : string )
	{
		
		
		
		
		
		
		m_fxSetDesaturatedSFF.InvokeSelfTwoArgs(FlashArgBool(value),FlashArgString(fieldName));
	}
		
	protected function UpdateScale( scale : float, flashModule : CScriptedFlashSprite ) : bool 
	{
		return false;
	}
}

exec function srfdes( value : bool, fieldName : string )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleRadialMenu;

	hud = (CR4ScriptedHud)theGame.GetHud();
	module = (CR4HudModuleRadialMenu)hud.GetHudModule("RadialMenuModule");
	module.SetDesaturated( value, fieldName );
}
