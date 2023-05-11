/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




class CR4CommonIngameMenu extends CR4MenuBase
{
	private var m_menuData 	  		: array< SMenuTab >;
	protected var currentMenuName 	: name;
	public var reopenRequested	: bool; default reopenRequested = false;
	
	event  OnConfigUI()
	{
		var menuName : name;
		var selectionPopupRef : CR4ItemSelectionPopup; 
		
		
		if ((!thePlayer.IsAlive() && !thePlayer.OnCheckUnconscious()) || theGame.HasBlackscreenRequested() || FactsQuerySum("nge_pause_menu_disabled") > 0 ) 
		{
			CloseMenu();
		}
		else
		{
			
			if(theGame.IsDialogOrCutscenePlaying())
				theSound.SoundEvent("music_pause");
			
			
			
			selectionPopupRef = (CR4ItemSelectionPopup)theGame.GetGuiManager().GetPopup('ItemSelectionPopup');
			if (selectionPopupRef)
			{
				theGame.ClosePopup('ItemSelectionPopup');
			}
			
			
			m_hideTutorial = true;
			m_forceHideTutorial = true;
			super.OnConfigUI();
			menuName = theGame.GetMenuToOpen();
			
			theGame.GetGuiManager().RequestMouseCursor(true);
			
			if (theInput.LastUsedPCInput())
			{
				theGame.MoveMouseTo(0.17, 0.36);
			}
			
			
			{
				menuName = 'IngameMenu';
			}
			
			
			
			theSound.SoundEvent("system_pause");
			
			SetupMenu();
			OnRequestSubMenu( menuName, GetMenuInitData() );
			
			theInput.StoreContext( 'EMPTY_CONTEXT' );
		}
	}
	
	event  OnClosingMenu()
	{
		
		if(theGame.IsDialogOrCutscenePlaying())
			theSound.SoundEvent("music_resume");
		
		
		super.OnClosingMenu();
		
		if (m_configUICalled)
		{
			theGame.GetGuiManager().RequestMouseCursor(false);
			
			theSound.SoundEvent("system_resume");
			
			theInput.RestoreContext( 'EMPTY_CONTEXT', false );
			
			OnPlaySoundEvent( "gui_global_panel_close" );
		}
	}

	function OnRequestSubMenu( menuName: name, optional initData : IScriptable )
	{
		RequestSubMenu( menuName, initData );
		currentMenuName = menuName;
	}

	event  OnInputHandled(NavCode:string, KeyCode:int, ActionId:int)
	{
	}

	

	event  OnSwipe( swipe : int )
	{
	}

	private function DefineMenuItem(itemName:name, itemLabel:string, optional parentMenuItem:name) : void
	{
		var newMenuItem 	: SMenuTab;

		newMenuItem.MenuName = itemName;
		newMenuItem.MenuLabel = itemLabel;
		newMenuItem.Enabled = true;
		newMenuItem.Visible = true;
		
		newMenuItem.ParentMenu = parentMenuItem;
		m_menuData.PushBack(newMenuItem);
	}
	
	private function SetupMenu() : void
	{
	}

	event  OnCloseMenu()
	{
		var menu			: CR4MenuBase;
		
		
		
		
		
		
		
	}
	
	function CloseMenuRequest():void
	{
		var menu			: CR4MenuBase;
		
		menu = (CR4MenuBase)GetSubMenu();
		if( !menu )
		{
			CloseMenu();
		}
	}

	function ChildRequestCloseMenu()
	{
		var menu			: CR4MenuBase;
		var menuToOpen		: name;
		var initData : W3MainMenuInitData;
		initData = new W3MainMenuInitData in this;
		
		
		if (reopenRequested)
		{
			reopenRequested = false;
			OnRequestSubMenu( 'IngameMenu', GetMenuInitData() );
		}
		else
		{
			menu = (CR4MenuBase)GetSubMenu();
		
			if( menu )
			{
				
				menuToOpen = GetParentMenuName(currentMenuName);
				if( menuToOpen )
				{
					OnRequestSubMenu( menuToOpen, initData );
				}
				else
				{
					CloseMenu();
				}
			}
		}
	}
	
	function GetParentMenuName( menu : name ) : name
	{
		var i : int;
		var parentName : name;
		var CurDataItem : SMenuTab;
		
		for ( i = 0; i < m_menuData.Size(); i += 1 )
		{
			CurDataItem = m_menuData[i];
			
			if ( CurDataItem.MenuName == menu )
			{
				parentName = CurDataItem.ParentMenu;
			}
		}
		return parentName;
	}	

	function PlayOpenSoundEvent()
	{
		OnPlaySoundEvent("gui_global_panel_open");	
	}
}

exec function ingamemenu()
{
	
	theGame.SetMenuToOpen( '' );
	theGame.RequestMenu('CommonIngameMenu' );
}