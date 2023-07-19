/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/

enum EItemSelectionPopupMode
{
	EISPM_Default,
	EISPM_ArmorStand,
	EISPM_SwordStand,
	EISPM_Painting,	
	
	EISPM_RadialMenuSlot1,
	EISPM_RadialMenuSlot2,
	EISPM_RadialMenuSlot3,
	EISPM_RadialMenuSlot4,
	EISPM_RadialMenuSteelOil,
	EISPM_RadialMenuSilverOil,
	
}


class W3ItemSelectionPopupData extends CObject
{
	var targetInventory : CInventoryComponent;
	var filterTagsList : array<name>;
	var filterForbiddenTagsList : array<name>;	
	var categoryFilterList : array<name>;	
	var collectorTag : name;
	var targetItems : array<name>;
	var selectionMode : EItemSelectionPopupMode;
	var overrideQuestItemRestrictions : bool;
	var checkTagsOR : bool; 
}

class CR4ItemSelectionPopup extends CR4PopupBase
{
	var m_DataObject     : W3ItemSelectionPopupData;
	var m_playerInv      : W3GuiSelectItemComponent;
	var m_containerInv   : W3GuiContainerInventoryComponent;
	var m_containerOwner : CGameplayEntity;
	var m_selectedItemCategory : int;	
	default m_selectedItemCategory = 0;

	
	private var m_fxSetItemDescription 		: CScriptedFlashFunction;
	private var m_fxSetCategory 			: CScriptedFlashFunction;
	private var m_fxShowCategoryButtons 	: CScriptedFlashFunction;
	private var m_fxDeselectItem			: CScriptedFlashFunction;
	
	var m_potionInv, m_mutagenInv, m_edibleInv : W3GuiSelectItemComponent;
	var forbiddenTags, forbiddenTagsPotion, tagsP, tagsM, tagsE : array<name>;
	
	
	event  OnConfigUI()
	{
		super.OnConfigUI();
		
		theInput.StoreContext( 'EMPTY_CONTEXT' );
		m_DataObject = (W3ItemSelectionPopupData)GetPopupInitData();		
		
		if (!m_DataObject)
		{
			ClosePopup();
		}
		
		if (theInput.LastUsedPCInput())
		{
			theGame.MoveMouseTo(0.5, 0.5);
		}
		
		
		m_fxSetItemDescription = GetPopupFlash().GetMemberFlashFunction( "setItemDescription" );
		m_fxSetCategory = GetPopupFlash().GetMemberFlashFunction( "setCategory" );
		m_fxShowCategoryButtons = GetPopupFlash().GetMemberFlashFunction( "showCategoryButtons" );
		m_fxDeselectItem = GetPopupFlash().GetMemberFlashFunction( "deselectItem" );
		
		if( m_DataObject.selectionMode == EISPM_RadialMenuSlot1 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot2 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot3 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot4 )
		{	
			tagsP.PushBack('Potion');
			tagsM.PushBack('Mutagen');
			tagsE.PushBack('Edibles');
		
			forbiddenTags.PushBack('NoEquip');
			forbiddenTagsPotion.PushBack('NoEquip');
			forbiddenTagsPotion.PushBack('Mutagen');
			forbiddenTagsPotion.PushBack('Edibles');
			
			m_potionInv = new W3GuiSelectItemComponent in this;
			m_potionInv.Initialize( thePlayer.GetInventory() );
			m_potionInv.filterTagList = tagsP;
			m_potionInv.filterForbiddenTagList = forbiddenTagsPotion;
			m_potionInv.ignorePosition = true;
			m_potionInv.SetFilterType( IFT_None );
			
			m_potionInv.maxItemLimit = 80;
			
			m_mutagenInv = new W3GuiSelectItemComponent in this;
			m_mutagenInv.Initialize( thePlayer.GetInventory() );
			m_mutagenInv.filterTagList = tagsM;
			m_mutagenInv.filterForbiddenTagList = forbiddenTags;
			m_mutagenInv.ignorePosition = true;
			m_mutagenInv.checkTagsOR = true;
			m_mutagenInv.SetFilterType( IFT_None );
			
			m_mutagenInv.maxItemLimit = 80;
			
			m_edibleInv = new W3GuiSelectItemComponent in this;
			m_edibleInv.Initialize( thePlayer.GetInventory() );
			m_edibleInv.filterTagList = tagsE;
			m_edibleInv.filterForbiddenTagList = forbiddenTags;
			m_edibleInv.ignorePosition = true;
			m_edibleInv.checkTagsOR = true;
			m_edibleInv.SetFilterType( IFT_None );
			
			m_edibleInv.maxItemLimit = 80;
			
			m_playerInv = m_potionInv;
			m_fxSetCategory.InvokeSelfOneArg( FlashArgString( GetLocStringByKeyExt( "panel_alchemy_tab_potions" ) ) );
			m_fxShowCategoryButtons.InvokeSelfOneArg( FlashArgBool(true) );
		}
		else
		{
			m_fxShowCategoryButtons.InvokeSelfOneArg( FlashArgBool(false) );		
			
			m_playerInv = new W3GuiSelectItemComponent in this;
			m_playerInv.Initialize( thePlayer.GetInventory() );
			m_playerInv.filterTagList = m_DataObject.filterTagsList;
			m_playerInv.filterForbiddenTagList = m_DataObject.filterForbiddenTagsList;
			m_playerInv.ignorePosition = true; 
			m_playerInv.checkTagsOR = m_DataObject.checkTagsOR; 
		}
		
		switch( m_DataObject.selectionMode )
		{
			case EISPM_Default :
			{
				
				m_playerInv.SetFilterType( IFT_QuestItems );
			}
			break;
			
			case EISPM_ArmorStand :
			{
				
				m_playerInv.SetFilterType( IFT_Armors );
				
				if( m_DataObject.categoryFilterList.Size() > 0 )
				{
					m_playerInv.SetItemCategoryType( m_DataObject.categoryFilterList[m_selectedItemCategory] );	
				}
				else
				{
					m_playerInv.SetItemCategoryType( 'armor' );
				}
				
				
				m_playerInv.SetOverrideQuestItemFilters( m_DataObject.overrideQuestItemRestrictions );
			}
			break;
			
			case EISPM_SwordStand :
			{
				
				m_playerInv.SetFilterType( IFT_Weapons );
				m_playerInv.SetOverrideQuestItemFilters( m_DataObject.overrideQuestItemRestrictions );			
			}
			break;	
			
			case EISPM_Painting :
			{
				
				m_playerInv.SetFilterType( IFT_None );
				m_playerInv.SetOverrideQuestItemFilters( m_DataObject.overrideQuestItemRestrictions );			
			}
			break;
			
			
			case EISPM_RadialMenuSlot1 :
			case EISPM_RadialMenuSlot2 :
			case EISPM_RadialMenuSlot3 :
			case EISPM_RadialMenuSlot4 :
			case EISPM_RadialMenuSteelOil :
			case EISPM_RadialMenuSilverOil :
			{
				m_playerInv.SetFilterType( IFT_None );	
			}
			break;
			
		}
		
		
		m_containerOwner = (CGameplayEntity)theGame.GetEntityByTag( m_DataObject.collectorTag );
		
		
		
		UpdateData();
		
		
		m_guiManager.RequestMouseCursor(true);
		theGame.ForceUIAnalog(true);
		
		theGame.Pause("ItemSelectionPopup");
	}
	
	event  OnCloseSelectionPopup()
	{
		ClosePopup();
	}
	
	event  OnCallSelectItem(itemId : SItemUniqueId)
	{
		var len, i : int;
		
		switch( m_DataObject.selectionMode )
		{
			
			case EISPM_Default :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					len = m_DataObject.targetItems.Size();
					for (i = 0; i < len; i=i+1 )
					{
						
						if (m_DataObject.targetItems[i] == m_playerInv.GetItemName(itemId))
						{
							thePlayer.GetInventory().GiveItemTo( m_containerOwner.GetInventory(), itemId, 1 );
							break;
						}
					}
					ClosePopup();
				}
			}
			break;
			
			
			case EISPM_ArmorStand :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.GetInventory().GiveItemTo( m_containerOwner.GetInventory(), itemId, 1 );
					
					while( m_selectedItemCategory <= m_DataObject.categoryFilterList.Size() )
					{
						if(TryToOpenNextCategory())
						{
							return true;
						}
					}
					
					ClosePopup();
				}
			}
			break;
			
			
			case EISPM_SwordStand :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.GetInventory().GiveItemTo( m_containerOwner.GetInventory(), itemId, 1 );
					ClosePopup();
				}
			}
			break;
			
			
			case EISPM_Painting :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.GetInventory().GiveItemTo( m_containerOwner.GetInventory(), itemId, 1 );
					ClosePopup();
				}
			}
			break;		
			
			
			case EISPM_RadialMenuSlot1 :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.EquipItem(itemId, EES_Potion1);
					GetWitcherPlayer().EnableRadialInput();
					ClosePopup();		
				}
			}
			break;
			
			case EISPM_RadialMenuSlot2 :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.EquipItem(itemId, EES_Potion2);
					GetWitcherPlayer().EnableRadialInput();
					ClosePopup();		
				}
			}
			break;
			
			case EISPM_RadialMenuSlot3 :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.EquipItem(itemId, EES_Potion3);
					GetWitcherPlayer().EnableRadialInput();
					ClosePopup();		
				}
			}
			break;
			
			case EISPM_RadialMenuSlot4 :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.EquipItem(itemId, EES_Potion4);
					GetWitcherPlayer().EnableRadialInput();
					ClosePopup();		
				}
			}
			break;
			
			case EISPM_RadialMenuSteelOil :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.ApplyOil(itemId, GetWitcherPlayer().GetEquippedSword( true ));
					GetWitcherPlayer().EnableRadialInput();
					theSound.SoundEvent( "gui_preparation_potion" );
					ClosePopup();		
				}
			}
			break;
			
			case EISPM_RadialMenuSilverOil :
			{
				if (thePlayer.GetInventory().IsIdValid(itemId))
				{
					thePlayer.ApplyOil(itemId, GetWitcherPlayer().GetEquippedSword( false ));
					GetWitcherPlayer().EnableRadialInput();
					theSound.SoundEvent( "gui_preparation_potion" );
					ClosePopup();		
				}
			}
			break;
			
		}
	}
	
	event  OnInventoryItemSelected(itemId : SItemUniqueId)
	{
		
	}
	
	event  OnClosingPopup()
	{
		theGame.Unpause("ItemSelectionPopup");
		
		if (m_containerInv)
		{
			delete m_containerInv;
		}
		
		if (m_playerInv)
		{
			delete m_playerInv;
		}
		
		theInput.RestoreContext( 'EMPTY_CONTEXT', true );
		theGame.ForceUIAnalog(false);
		m_guiManager.RequestMouseCursor(false);
		
		
		if (m_potionInv)
			delete m_potionInv;
			
		if (m_mutagenInv)
			delete m_mutagenInv;
			
		if (m_edibleInv)
			delete m_edibleInv;
		
		if( m_DataObject.selectionMode == EISPM_RadialMenuSteelOil 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSilverOil 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot1 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot2 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot3 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot4 )
			GetWitcherPlayer().EnableRadialInput();
		
		
		super.OnClosingPopup();
	}
	
	
	private function ClearPopupSelection()
	{
		m_playerInv.SetItemCategoryType( 'none' );
		UpdateData();
	}
	
	
	private function TryToOpenNextCategory() : bool
	{
		var stand : W3HouseDecorationBase;
		
		m_selectedItemCategory += 1;
		ClearPopupSelection();
		
		stand = (W3HouseDecorationBase) m_containerOwner;
		
		
		if( !stand )
		{
			return false;
		}
		
		
		if( stand.GetHasSleevlessArmor() && m_DataObject.categoryFilterList[m_selectedItemCategory] == 'gloves' )
		{
			return false;
		}
		
		
		if( !thePlayer.GetInventory().GetHasValidDecorationItems( thePlayer.inv.GetItemsByCategory( m_DataObject.categoryFilterList[m_selectedItemCategory] ), stand ) )
		{
			return false;
		}
		
		m_playerInv.SetItemCategoryType( m_DataObject.categoryFilterList[m_selectedItemCategory] );
		UpdateData();		
		
		return true;
	}
	
	
	private function UpdateData():void
	{
		var l_flashObject			: CScriptedFlashObject;
		var l_flashArray			: CScriptedFlashArray;
		
		l_flashObject = m_flashValueStorage.CreateTempFlashObject();
		l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
		m_playerInv.GetInventoryFlashArray(l_flashArray, l_flashObject);		
		m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
	}
	
	
	event OnChangeCategory( id : int )
	{
		var locString : string;
	
		if( m_DataObject.selectionMode == EISPM_RadialMenuSlot1 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot2 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot3 
			|| m_DataObject.selectionMode == EISPM_RadialMenuSlot4 )
		{	
			m_selectedItemCategory += id;
			if (m_selectedItemCategory < 0)
				m_selectedItemCategory = 2;
			else if (m_selectedItemCategory > 2)
				m_selectedItemCategory = 0;
			
			switch(m_selectedItemCategory)
			{
				case 0:
					locString = GetLocStringByKeyExt( "panel_alchemy_tab_potions" );	
					m_playerInv = m_potionInv;
					break;
				case 1:
					locString = GetLocStringByKeyExt( "panel_inventory_filter_type_decoctions" );	
					m_playerInv = m_mutagenInv;
					break;
				case 2:
					locString = GetLocStringByKeyExt( "item_category_edibles" );	
					m_playerInv = m_edibleInv;
					break;
			}
			
			m_fxDeselectItem.InvokeSelf();
			m_fxSetCategory.InvokeSelfOneArg( FlashArgString( locString ) );
			UpdateData();
			
			return true;
		}
		
		return false;
	}
	
	event OnItemSelected( itemId : SItemUniqueId )
	{
		var uniqueDescription, valueString : string;
		var currentStat	: SAttributeTooltip;
		var itemStats : array<SAttributeTooltip>;
		var i : int;
		
		if( m_DataObject.selectionMode == EISPM_RadialMenuSlot1 ||
			m_DataObject.selectionMode == EISPM_RadialMenuSlot2 ||
			m_DataObject.selectionMode == EISPM_RadialMenuSlot3 ||
			m_DataObject.selectionMode == EISPM_RadialMenuSlot4 )
		{
			uniqueDescription = GetLocStringByKeyExt( thePlayer.GetInventory().GetItemLocalizedDescriptionByUniqueID(itemId) );		
			m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( uniqueDescription ) );
		}
		else if( m_DataObject.selectionMode ==  EISPM_RadialMenuSteelOil || m_DataObject.selectionMode ==  EISPM_RadialMenuSilverOil )
		{		
			thePlayer.GetInventory().GetItemBaseStats(itemId, itemStats);		

			for( i = 0; i < itemStats.Size(); i += 1) 
			{
				currentStat = itemStats[i];	
				valueString = NoTrailZeros( RoundMath( currentStat.value * 100 ) ) + "% ";				
				uniqueDescription = valueString + currentStat.attributeName;
			}
			
			m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( uniqueDescription ) );
		}
	}
	
}