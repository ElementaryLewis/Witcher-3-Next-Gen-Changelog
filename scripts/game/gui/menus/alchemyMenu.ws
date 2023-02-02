/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




struct SItemAttribute
{
	var attributeName	: name;
	var min, max		: float;
};

class CR4AlchemyMenu extends CR4ListBaseMenu
{	
	private var m_alchemyManager	: W3AlchemyManager;
	private var m_recipeList		: array< SAlchemyRecipe >;
	private var m_definitionsManager: CDefinitionsManagerAccessor;
	private var bCouldCraft			: bool;
	protected var _inv       		: CInventoryComponent;
	private var _playerInv			: W3GuiPlayerInventoryComponent;
	
	private var m_fxSetCraftingEnabled	: CScriptedFlashFunction;
	private var m_fxSetCraftedItem 		: CScriptedFlashFunction;
	private var m_fxHideContent	 		: CScriptedFlashFunction;
	private var m_fxSetFilters			: CScriptedFlashFunction;
	private var m_fxSetPinnedRecipe		: CScriptedFlashFunction;
	
	default DATA_BINDING_NAME_SUBLIST	= "crafting.sublist.items";
	default DATA_BINDING_NAME_DESCRIPTION	= "alchemy.item.description";
	
	var itemsQuantity 						: array< int >;
	
	event  OnConfigUI()
	{	
		var commonMenu 			: CR4CommonMenu;
		var l_craftingFilters	: SCraftingFilters;
		var pinnedTag			: int;
		
		super.OnConfigUI();
		
		m_initialSelectionsToIgnore = 2;
		
		_inv = thePlayer.GetInventory();
		m_definitionsManager = theGame.GetDefinitionsManager();
		
		_playerInv = new W3GuiPlayerInventoryComponent in this;
		_playerInv.Initialize( _inv );
		
		m_alchemyManager = new W3AlchemyManager in this;
		m_alchemyManager.Init();		
		m_recipeList     = m_alchemyManager.GetRecipes(false);
		
		m_fxSetCraftedItem = m_flashModule.GetMemberFlashFunction("setCraftedItem");
		m_fxSetCraftingEnabled = m_flashModule.GetMemberFlashFunction("setCraftingEnabled");
		m_fxHideContent = m_flashModule.GetMemberFlashFunction("hideContent");
		m_fxSetFilters = m_flashModule.GetMemberFlashFunction("SetFiltersValue");
		m_fxSetPinnedRecipe = m_flashModule.GetMemberFlashFunction("setPinnedRecipe");
		
		l_craftingFilters = GetWitcherPlayer().GetAlchemyFilters();
		m_fxSetFilters.InvokeSelfSixArgs(FlashArgString(GetLocStringByKeyExt("gui_panel_filter_has_ingredients")), FlashArgBool(l_craftingFilters.showCraftable), 
										 FlashArgString(GetLocStringByKeyExt("gui_panel_filter_elements_missing")), FlashArgBool(l_craftingFilters.showMissingIngre), 
										 FlashArgString(GetLocStringByKeyExt("gui_panel_filter_already_crafted")), FlashArgBool(l_craftingFilters.showAlreadyCrafted));
		
		commonMenu = (CR4CommonMenu)m_parentMenu;
		bCouldCraft = true;
		m_fxSetCraftingEnabled.InvokeSelfOneArg(FlashArgBool(bCouldCraft));
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

	event OnEntryRead( tag : name )
	{
		
		
		
	}
	
	event  OnStartCrafting()
	{
		OnPlaySoundEvent("gui_alchemy_brew");
	}
	
	event OnCraftItem( tag : name )
	{
		CreateItem(FindRecipieID(tag));
		ShowSelectedItemInfo(tag);
	}
	
	event OnEntryPress( tag : name )
	{
		
	}
	
	event  OnCraftingFiltersChanged( showHasIngre : bool, showMissingIngre : bool, showAlreadyCrafted : bool )
	{
		GetWitcherPlayer().SetAlchemyFilters(showHasIngre, showMissingIngre, showAlreadyCrafted);
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

	event OnEntrySelected( tag : name ) 
	{
		
		var i : int;
		var uiState : W3TutorialManagerUIHandlerStateAlchemy;
		
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
		
		
		if(ShouldProcessTutorial('TutorialAlchemySelectRecipe'))
		{
			uiState = (W3TutorialManagerUIHandlerStateAlchemy)theGame.GetTutorialSystem().uiHandler.GetCurrentState();
			if(uiState)
				uiState.SelectedRecipe(tag, m_alchemyManager.CanCookRecipe(tag) == EAE_NoException);
		}
		
		
		
	}
	
	event  OnShowCraftedItemTooltip( tag : name )
	{
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
			player.AddExpandedAlchemyCategory( categoryName );
		}
		else
		{
			player.RemoveExpandedAlchemyCategory( categoryName );
		}

		
		super.OnCategoryOpened( categoryName, opened );
	}
	
	protected function ShowSelectedItemInfo( tag : name ):void
	{
		var recipe 				: SAlchemyRecipe;
		var l_DataFlashObject	: CScriptedFlashObject;
		var itemNameLoc			: string;
		var imgPath				: string;
		var canCraft			: bool;
		var itemType 			: EInventoryFilterType;
		var gridSize			: int;
		var itemName			: name;
		
		recipe = m_recipeList[FindRecipieID(tag)];
		itemName = recipe.cookedItemName;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		
		_playerInv.GetCraftedItemInfo(itemName, l_DataFlashObject);
		
		m_flashValueStorage.SetFlashObject("alchemy.menu.crafted.item.tooltip", l_DataFlashObject);
		
		itemNameLoc = GetLocStringByKeyExt(_inv.GetItemLocalizedNameByName(itemName));
		imgPath = m_definitionsManager.GetItemIconPath(itemName);
		canCraft = m_alchemyManager.CanCookRecipe(recipe.recipeName) == EAE_NoException;
		itemType = m_definitionsManager.GetFilterTypeByItem(itemName);
		
		if (itemType == IFT_Weapons || itemType == IFT_Armors)
		{
			gridSize = 2;
		}
		else
		{
			gridSize = 1;
		}
		
		m_fxSetCraftedItem.InvokeSelfSixArgs(FlashArgUInt(NameToFlashUInt(recipe.recipeName)), FlashArgString(itemNameLoc), FlashArgString(imgPath), FlashArgBool(canCraft), FlashArgInt(gridSize), FlashArgString(""));
	}
		
	function CreateItem( recipeIndex : int )
	{
		var recipe			: SAlchemyRecipe;		
		var exception		: EAlchemyExceptions;
		var cookedItemName	: string;
		recipe  = m_recipeList[ recipeIndex ];

		exception = EAE_CookNotAllowed;		
		
		LogChannel( 'Alchemy', "OnCreateItem - " + recipeIndex + " " + recipe.recipeName );
		if( bCouldCraft )
		{
			GetWitcherPlayer().StartInvUpdateTransaction();			
			
			exception = m_alchemyManager.CanCookRecipe( recipe.recipeName );
			if( exception == EAE_NoException )
			{
				m_alchemyManager.CookItem( recipe.recipeName );
				
				if (recipe.level > 1)
				{
					
					m_recipeList = m_alchemyManager.GetRecipes(false);
				}
				
				PopulateData();
				UpdateItemsById(recipeIndex);
				cookedItemName = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName( recipe.cookedItemName ));
				showNotification(GetLocStringByKeyExt("panel_crafting_successfully_crafted") + ": " + cookedItemName);
				OnPlaySoundEvent("gui_crafting_craft_item_complete");
			}
			
			GetWitcherPlayer().FinishInvUpdateTransaction();
		}
		
		if (exception != EAE_NoException)
		{
			showNotification(GetLocStringByKeyExt(AlchemyExceptionToString(exception)));
			OnPlaySoundEvent("gui_global_denied");
		}
	}

	private function PopulateData()
	{
		var l_DataFlashArray		: CScriptedFlashArray;
		var l_DataFlashObject 		: CScriptedFlashObject;
		
		var recipe					: SAlchemyRecipe;
		
		var i, length				: int;
		
		var l_Title					: string;
		var l_Tag					: name;
		var l_IconPath				: string;
		var l_GroupTitle			: string;
		var l_GroupTag				: name;
		var l_IsNew					: bool;
		var canCraftResult			: EAlchemyExceptions;
		var canCraftResultFilters	: EAlchemyExceptions;
		
		
		var cookableType			: EAlchemyCookedItemType;
		var cookable				: SCookable;
		var cookables				: array<SCookable>;
		var exists					: bool;
		var j, cookableCount		: int;
		var minQuality, maxQuality  : int;
		
		var expandedAlchemyCategories : array< name >;
		
		expandedAlchemyCategories = GetWitcherPlayer().GetExpandedAlchemyCategories();

		l_DataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		length = m_recipeList.Size();
		
		
		for(i=0; i<length; i+=1)
		{
			if(m_alchemyManager.CanCookRecipe(m_recipeList[i].recipeName) == EAE_NoException)
			{
				exists = false;
				cookableType = m_recipeList[i].cookedItemType;
				
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
			recipe = m_recipeList[ i ];
			l_GroupTag = AlchemyCookedItemTypeEnumToName( recipe.cookedItemType );
			
			l_GroupTitle = GetLocStringByKeyExt( AlchemyCookedItemTypeToLocKey(recipe.cookedItemType) );
			
			l_Title = GetLocStringByKeyExt( m_definitionsManager.GetItemLocalisationKeyName( recipe.cookedItemName ) ) ;	
			l_IconPath = m_definitionsManager.GetItemIconPath(recipe.cookedItemName);
			l_IsNew	= false;
			l_Tag = recipe.recipeName;
			
			canCraftResult = m_alchemyManager.CanCookRecipe(recipe.recipeName);
			canCraftResultFilters = m_alchemyManager.CanCookRecipe(recipe.recipeName, true);
			
			
			cookableCount = 0;
			for(j=0; j<cookables.Size(); j+=1)
			{
				if(cookables[j].type == recipe.cookedItemType)
				{
					cookableCount = cookables[j].cnt;
					break;
				}
			}
			
			
			l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
			
			if(cookableCount > 0)
			{
				l_DataFlashObject.SetMemberFlashString(  "categoryPostfix", " | " + cookableCount + " |");
			}
			else
			{
				l_DataFlashObject.SetMemberFlashString(  "categoryPostfix", "" );
			}
			
			thePlayer.inv.GetItemQualityFromName( recipe.cookedItemName, minQuality, maxQuality );
			
			l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt(l_Tag) );
			l_DataFlashObject.SetMemberFlashString(  "dropDownLabel", l_GroupTitle );
			l_DataFlashObject.SetMemberFlashUInt(  "dropDownTag",  NameToFlashUInt(l_GroupTag) );
			l_DataFlashObject.SetMemberFlashBool(  "dropDownOpened", expandedAlchemyCategories.Contains( l_GroupTag ) );
			l_DataFlashObject.SetMemberFlashString(  "dropDownIcon", "icons/monsters/ICO_MonsterDefault.png" );
			
			l_DataFlashObject.SetMemberFlashBool( "isNew", l_IsNew );
			
			if ( m_guiManager.GetShowItemNames() )
			{
				l_Title = l_Title + "<br><font color=\"#FFDB00\">'" + recipe.recipeName + "'</font>";
			}
			
			l_DataFlashObject.SetMemberFlashString(  "label", l_Title );
			l_DataFlashObject.SetMemberFlashString(  "iconPath", l_IconPath );
			l_DataFlashObject.SetMemberFlashInt( "rarity", minQuality );
			
			if (canCraftResult != EAE_NoException)
			{
				l_DataFlashObject.SetMemberFlashString( "cantCookReason", GetLocStringByKeyExt(AlchemyExceptionToString(canCraftResult)));
			}
			else
			{
				l_DataFlashObject.SetMemberFlashString( "cantCookReason", "" );
			}
			
			l_DataFlashObject.SetMemberFlashBool( "isSchematic", false );
			l_DataFlashObject.SetMemberFlashInt( "canCookStatus", canCraftResult);
			l_DataFlashObject.SetMemberFlashInt( "canCookStatusForFilter", canCraftResultFilters);
			
			l_DataFlashArray.PushBackFlashObject(l_DataFlashObject);
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

	function UpdateDescription( tag : name )
	{
		var description : string;
		var title : string;
		var id : int;
		
		id = FindRecipieID(tag);
		
		title = GetLocStringByKeyExt(m_definitionsManager.GetItemLocalisationKeyName(m_recipeList[id].cookedItemName));	
		description = m_definitionsManager.GetItemLocalisationKeyDesc(m_recipeList[id].cookedItemName);	
		if(description == "" || description == "<br>" )
		{
			description = "panel_journal_quest_empty_description";
		}
		description = GetLocStringByKeyExt(description);	
		
		m_flashValueStorage.SetFlashString(DATA_BINDING_NAME_DESCRIPTION+".title",title);
		m_flashValueStorage.SetFlashString(DATA_BINDING_NAME_DESCRIPTION+".text",description);	
	}	

	function GetDescription( currentCharacter : CJournalCharacter ) : string
	{
		var i : int;
		var str : string;
		var locStrId : int;
		
		var description : CJournalCharacterDescription;
		
		str = "";
		for( i = 0; i < currentCharacter.GetNumChildren(); i += 1 )
		{
			description = (CJournalCharacterDescription)(currentCharacter.GetChild(i));
			if( m_journalManager.GetEntryStatus(description) == JS_Active )
			{
				locStrId = description.GetDescriptionStringId();
				str += GetLocStringById(locStrId)+"<br>";
			}
		}

		if( str == "" || str == "<br>" )
		{
			str = GetLocStringByKeyExt("panel_journal_quest_empty_description");
		}
		
		return str;
	}
	

	function FindRecipieID(tag : name ) : int
	{
		var i : int;
		for( i = 0; i < m_recipeList.Size(); i += 1 )
		{
			if( m_recipeList[i].recipeName == tag )
			{
				return i;
			}
		}
		return -1;
	}
	
	function UpdateItems( tag : name )
	{
		UpdateItemsById(FindRecipieID(tag));
		ShowSelectedItemInfo(tag);
	}
	
	private function UpdateItemsById( id : int ) : void
	{
		var itemsFlashArray	: CScriptedFlashArray;
		var i : int;
		
		itemsNames.Clear();
		itemsQuantity.Clear();
		for( i = 0; i < m_recipeList[id].requiredIngredients.Size(); i += 1 )
		{
			itemsNames.PushBack(m_recipeList[id].requiredIngredients[i].itemName); 
			itemsQuantity.PushBack(m_recipeList[id].requiredIngredients[i].quantity);
		}
		itemsFlashArray = CreateItems(itemsNames);
		
		if( itemsFlashArray )
		{
			m_flashValueStorage.SetFlashArray( DATA_BINDING_NAME_SUBLIST, itemsFlashArray );
		}
	}
	
	public function FillItemInformation(flashObject : CScriptedFlashObject, index:int) : void
	{	
		super.FillItemInformation(flashObject, index);
		
		flashObject.SetMemberFlashInt("reqQuantity", itemsQuantity[index]);
	}
	
	function GetItemRarityDescription( itemName : name ) : string
	{
		var itemQuality : int;
		
		itemQuality = 1; 
		return GetItemRarityDescriptionFromInt(itemQuality);
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
	
	private function addGFxItemStat(out targetArray:CScriptedFlashArray, type:string, value:string):void
	{
		var resultData : CScriptedFlashObject;
		resultData = m_flashValueStorage.CreateTempFlashObject();
		resultData.SetMemberFlashString("type", type);
		resultData.SetMemberFlashString("value", value);
		targetArray.PushBackFlashObject(resultData);
	}
	
	function PlayOpenSoundEvent()
	{
		
		
	}
	
	public final function IsInShop() : bool
	{
		var l_obj		 			: IScriptable;		
		var l_initData				: W3InventoryInitData;
		var m_npc					: CNewNPC;
		
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
		
		return m_npc;
	}
}
