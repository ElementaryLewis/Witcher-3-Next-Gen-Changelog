/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




enum InGameMenuActionType
{
	IGMActionType_CommonMenu 		= 0,
	IGMActionType_Close		 		= 1,
	IGMActionType_MenuHolder 		= 2,
	IGMActionType_MenuLastHolder	= 3,
	IGMActionType_Load 				= 4,
	IGMActionType_Save 				= 5,
	IGMActionType_Quit			 	= 6,
	IGMActionType_Preset 			= 7,
	IGMActionType_Toggle 			= 8,
	IGMActionType_List 				= 9,
	IGMActionType_Slider 			= 10,
	IGMActionType_LoadLastSave 		= 11,
	IGMActionType_Tutorials 		= 12,
	IGMActionType_Credits 			= 13,
	IGMActionType_Help 				= 14,
	IGMActionType_Controls 			= 15,
	IGMActionType_ControllerHelp 	= 16,
	IGMActionType_NewGame 			= 17,
	IGMActionType_CloseGame 		= 18,
	IGMActionType_UIRescale 		= 19,
	IGMActionType_Gamma 			= 20,
	IGMActionType_DebugStartQuest 	= 21,
	IGMActionType_Gwint 			= 22,
	IGMActionType_ImportSave 		= 23,
	IGMActionType_KeyBinds 			= 24,
	IGMActionType_Back				= 25,
	IGMActionType_NewGamePlus		= 26,
	IGMActionType_InstalledDLC		= 27,
	IGMActionType_Button			= 28,
	IGMActionType_ToggleRender		= 29,
	IGMActionType_Gog				= 30,
	IGMActionType_TelemetryConsent  = 31,
	IGMActionType_ListWithCondition = 32,
	IGMActionType_Stepper			= 33,
	IGMActionType_ToggleStepper		= 34,
	IGMActionType_Separator			= 35,
	IGMActionType_SubtleSeparator	= 36,
	
	IGMActionType_PurchaseEP1		= 37,
	IGMActionType_PurchaseEP2		= 38,

	IGMActionType_Options 			= 100
};

enum GERR 
{
        GOGNoInternetConnection = 0,
        RewardsTemporaryFail = 1,
        RewardsRequestFailed = 2,
		QRCodeTemporaryFail=  3,
		QRCodeRequestFailed = 4 
};
           

enum EIngameMenuConstants
{
	IGMC_Difficulty_mask	= 	7,   
	IGMC_Tutorials_On		= 	1024,
	IGMC_Simulate_Import 	= 	2048,
	IGMC_Import_Save		= 	4096,
	IGMC_EP1_Save			=   8192,
	IGMC_New_game_plus		=   16384,
	IGMC_EP2_Save			=   32768,
}

struct newGameConfig
{
	var tutorialsOn : bool;
	var difficulty : int;
	var simulate_import : bool;
	var import_save_index : int;
}


function UpdateAO2CorrespondRT(RTEnabled: bool, justValidate: bool)
{
	var inGameConfigWrapper	: CInGameConfigWrapper;
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		
	if( RTEnabled )
	{
		if ((justValidate && StringToInt(inGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) == IGMOPT_AO_SSAO)
		 ||(!justValidate && StringToInt(inGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) != IGMOPT_AO_NRDRTAO)) 
		{
			inGameConfigWrapper.SetVarValue('PostProcess', 'Virtual_SSAOSolution', IntToString(IGMOPT_AO_NRDRTAO));
		}
	} else {
		if(StringToInt(inGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) >= IGMOPT_AO_RTAO)
		{
			inGameConfigWrapper.SetVarValue('PostProcess', 'Virtual_SSAOSolution', IntToString(IGMOPT_AO_SSAO));
		}
	}
}
	
class CR4IngameMenu extends CR4MenuBase
{
	protected var mInGameConfigWrapper	: CInGameConfigWrapper;
	protected var inGameConfigBufferedWrapper : CInGameConfigBufferedWrapper;
	
	protected var currentNewGameConfig 	: newGameConfig;
	
	private var m_fxNavigateBack		: CScriptedFlashFunction;
	private var m_fxSetIsMainMenu		: CScriptedFlashFunction;
	private var m_fxSetCurrentUsername  : CScriptedFlashFunction;
	private var m_fxSetVersion			: CScriptedFlashFunction;
	private var m_fxShowHelp			: CScriptedFlashFunction;
	private var m_fxSetVisible			: CScriptedFlashFunction;
	private var m_fxSetPanelMode		: CScriptedFlashFunction;
	private var m_fxRemoveOption		: CScriptedFlashFunction;
	private var m_fxSetGameLogoLanguage	: CScriptedFlashFunction;
	private var m_fxUpdateOptionValue	: CScriptedFlashFunction;
	private var m_fxUpdateOptionLabel	: CScriptedFlashFunction;
	private var m_fxUpdateInputFeedback	: CScriptedFlashFunction;
	private var m_fxOnSaveScreenshotRdy : CScriptedFlashFunction;
	private var m_fxSetIgnoreInput		: CScriptedFlashFunction;
	private var m_fxUpdateSaveSlot		: CScriptedFlashFunction;
	private var m_fxForceEnterCurEntry	: CScriptedFlashFunction;
	private var m_fxForceBackgroundVis	: CScriptedFlashFunction;
	private var m_fxSetHardwareCursorOn : CScriptedFlashFunction;
	private var m_fxSetExpansionText	: CScriptedFlashFunction;
	private	var m_fxUpdateAnchorsAspectRatio : CScriptedFlashFunction;
	private var m_fxQRCodeReadyToLoad	: CScriptedFlashFunction;
	private var m_fxShowCloudModal      : CScriptedFlashFunction;
	private var m_fxCloseGalaxySignInModalWindow: CScriptedFlashFunction;
	private var m_fxSetDLSSIsSupported	: CScriptedFlashFunction;
	private var m_fxSetXESSIsSupported	: CScriptedFlashFunction;
	private var m_fxSetRTEnabled		: CScriptedFlashFunction;
	private var m_fxHideErrorWindow		: CScriptedFlashFunction;
	
	protected var loadConfPopup			: W3ApplyLoadConfirmation;
	protected var saveConfPopup			: W3SaveGameConfirmation;
	protected var newGameConfPopup		: W3NewGameConfirmation;
	protected var actionConfPopup		: W3ActionConfirmation;
	protected var deleteConfPopup		: W3DeleteSaveConf;
	protected var diffChangeConfPopup	: W3DifficultyChangeConfirmation;
	protected var isShowingSaveList		: bool; default isShowingSaveList = false;
	protected var isShowingLoadList		: bool; default isShowingLoadList = false;
	
	protected var smartKeybindingEnabled : bool; default smartKeybindingEnabled = true;
	
	public var m_structureCreator		: IngameMenuStructureCreator;
	
	protected var isInLoadselector		: bool; default isInLoadselector = false;
	protected var swapAcceptCancelChanged : bool; default swapAcceptCancelChanged = false;
	protected var alternativeRadialInputChanged : bool; default alternativeRadialInputChanged = false;
	protected var EnableUberMovement : bool; default EnableUberMovement = false;
	
	protected var shouldRefreshKinect	: bool; default shouldRefreshKinect = false;
	public var isMainMenu 				: bool;
	
	protected var managingPause		: bool; default managingPause = false;
	
	protected var updateInputDeviceRequired : bool; default updateInputDeviceRequired = false;
	
	protected var hasChangedOption		: bool;
	default hasChangedOption = false;
	
	
	protected var curMenuDepth		: int; 
	default curMenuDepth = 0;
	protected var depthOptions		: int;
	default depthOptions = 10;
	
	private var ignoreInput				: bool;
	default ignoreInput = false;
	
	public var disableAccountPicker	: bool;
	default disableAccountPicker = false;
	
	protected var lastSetTag : int;
	
	protected var currentLangValue		: string;
	protected var lastUsedLangValue		: string;
	protected var currentSpeechLang		: string;
	protected var lastUsedSpeechLang	: string;
	private var languageName 			: string;
	
	private var panelMode 				: bool; default panelMode = false;
	private var postprocessRtGreyed 	: bool; default postprocessRtGreyed = false;
	private var postprocessEntered		: bool; default postprocessEntered = false;
	
	public var lastSetDifficulty		: int;
	
	private var lastTimeGetOption 		: int;	default lastTimeGetOption = 0;
	
	event  OnConfigUI()
	{
		var initDataObject 		: W3MenuInitData;
		var commonIngameMenu 	: CR4CommonIngameMenu;
		var commonMainMenuBase	: CR4CommonMainMenuBase;
		var deathScreenMenu 	: CR4DeathScreenMenu;
		var audioLanguageName 	: string;
		var tempLanguageName 	: string;
		var username 			: string;
		var lootPopup			: CR4LootPopup;
		var ep1StatusText		: string;
		var ep2StatusText		: string;
		var width				: int;
		var height				: int;
		
		super.OnConfigUI();
		
		m_fxNavigateBack = m_flashModule.GetMemberFlashFunction("handleNavigateBack");
		m_fxSetIsMainMenu = m_flashModule.GetMemberFlashFunction("setIsMainMenu");
		m_fxSetCurrentUsername = m_flashModule.GetMemberFlashFunction("setCurrentUsername");
		m_fxSetVersion = m_flashModule.GetMemberFlashFunction("setVersion");
		m_fxShowHelp = m_flashModule.GetMemberFlashFunction("showHelpPanel");		
		m_fxSetVisible = m_flashModule.GetMemberFlashFunction("setVisible");
		m_fxSetPanelMode = m_flashModule.GetMemberFlashFunction("setPanelMode");
		m_fxRemoveOption = m_flashModule.GetMemberFlashFunction("removeOption"); 
		m_fxSetGameLogoLanguage = m_flashModule.GetMemberFlashFunction( "setGameLogoLanguage" );
		m_fxUpdateOptionValue = m_flashModule.GetMemberFlashFunction( "updateOptionValue" );
		m_fxUpdateOptionLabel = m_flashModule.GetMemberFlashFunction( "updateOptionLabel" );
		m_fxUpdateInputFeedback = m_flashModule.GetMemberFlashFunction( "updateInputFeedback" );
		m_fxOnSaveScreenshotRdy = m_flashModule.GetMemberFlashFunction( "onSaveScreenshotLoaded" );
		m_fxSetIgnoreInput = m_flashModule.GetMemberFlashFunction( "setIgnoreInput" );
		m_fxUpdateSaveSlot = m_flashModule.GetMemberFlashFunction( "updateSaveSlot" );
		m_fxForceEnterCurEntry = m_flashModule.GetMemberFlashFunction( "forceEnterCurrentEntry" );
		m_fxForceBackgroundVis = m_flashModule.GetMemberFlashFunction( "setForceBackgroundVisible" );
		m_fxSetHardwareCursorOn = m_flashModule.GetMemberFlashFunction( "setHardwareCursorOn" );
		m_fxSetExpansionText = m_flashModule.GetMemberFlashFunction( "setExpansionText" );
		m_fxUpdateAnchorsAspectRatio = m_flashModule.GetMemberFlashFunction( "UpdateAnchorsAspectRatio" );
		m_fxQRCodeReadyToLoad = m_flashModule.GetMemberFlashFunction("QRCodeReadyToLoad");
		m_fxShowCloudModal = m_flashModule.GetMemberFlashFunction("ShowCloudModal");
		m_fxCloseGalaxySignInModalWindow = m_flashModule.GetMemberFlashFunction("closeGalaxySignInDialog");
		m_fxSetDLSSIsSupported = m_flashModule.GetMemberFlashFunction("DLSSIsSupported");
		m_fxSetXESSIsSupported = m_flashModule.GetMemberFlashFunction("XESSIsSupported");
		m_fxSetRTEnabled = m_flashModule.GetMemberFlashFunction("RTEnabled");
		m_fxHideErrorWindow = m_flashModule.GetMemberFlashFunction("hideErrorHandlingWindow");

		m_structureCreator = new IngameMenuStructureCreator in this;
		m_structureCreator.parentMenu = this;
		m_structureCreator.m_flashValueStorage = m_flashValueStorage;
		m_structureCreator.m_flashConstructor = m_flashValueStorage.CreateTempFlashObject();
		
		m_hideTutorial = false;
		m_forceHideTutorial = false;
		disableAccountPicker = false;
		
		theGame.LoadHudSettings();
		
		mInGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		inGameConfigBufferedWrapper = theGame.GetGuiManager().GetInGameConfigBufferedWrapper();
		
		lootPopup = (CR4LootPopup)theGame.GetGuiManager().GetPopup('LootPopup');
			
		if (lootPopup)
		{
			lootPopup.ClosePopup();
		}
		
		commonIngameMenu = (CR4CommonIngameMenu)(GetParent());
		commonMainMenuBase = (CR4CommonMainMenuBase)(GetParent());
		deathScreenMenu = (CR4DeathScreenMenu)(GetParent());
		
		if (commonIngameMenu)
		{
			isMainMenu = false;
			panelMode = false;
			mInGameConfigWrapper.ActivateScriptTag('inGame');
			mInGameConfigWrapper.DeactivateScriptTag('mainMenu');
			if ((!thePlayer.IsAlive() && !thePlayer.OnCheckUnconscious()) || theGame.HasBlackscreenRequested() || FactsQuerySum("nge_pause_menu_disabled") > 0  ) 
			{
				CloseMenu();
				return true;
			}
			
			
			if(theGame.IsDialogOrCutscenePlaying())
				theSound.SoundEvent("music_pause");
			
		}
		else if (commonMainMenuBase)
		{
			isMainMenu = true;
			panelMode = false;
			mInGameConfigWrapper.ActivateScriptTag('mainMenu');
			mInGameConfigWrapper.DeactivateScriptTag('inGame');
			
			StartShowingCustomDialogs();
			
			
			
			if (theGame.GetDLCManager().IsEP1Available())
			{
				ep1StatusText = GetLocStringByKeyExt("expansion_status_installed");
			}
			else
			{
				ep1StatusText = GetLocStringByKeyExt("expansion_status_available");
			}
			
			if (theGame.GetDLCManager().IsEP2Available())
			{
				ep2StatusText = GetLocStringByKeyExt("expansion_status_installed");
			}
			else
			{
				
				ep2StatusText = GetLocStringByKeyExt("expansion_status_available");
			}			
			
			m_fxSetExpansionText.InvokeSelfTwoArgs(FlashArgString(ep1StatusText), FlashArgString(ep2StatusText));
			
			if (theGame.AreConfigResetInThisSession() && !theGame.HasShownConfigChangedMessage())
			{
				showNotification(GetLocStringByKeyExt("update_warning_message"));
				OnPlaySoundEvent("gui_global_denied");
				theGame.SetHasShownConfigChangedMessage(true);
			}
		}
		else if (deathScreenMenu)
		{
			isMainMenu = false;
			panelMode = true;
			mInGameConfigWrapper.DeactivateScriptTag('mainMenu');
			mInGameConfigWrapper.DeactivateScriptTag('inGame');
			
			deathScreenMenu.HideInputFeedback();
			
			if (hasSaveDataToLoad())
			{
				isInLoadselector = true;
				SendLoadData();
				m_fxSetPanelMode.InvokeSelfOneArg(FlashArgBool(true));
			}
			else
			{
				CloseMenu();
			}
		}
		else
		{
			initDataObject = (W3MenuInitData)GetMenuInitData();
			
			if (initDataObject && initDataObject.getDefaultState() == 'SaveGame')
			{
				isMainMenu = false;
				panelMode = true;
				
				managingPause = true;
				theInput.StoreContext( 'EMPTY_CONTEXT' );
				theGame.Pause('IngameMenu');
				
				mInGameConfigWrapper.DeactivateScriptTag('mainMenu');
				mInGameConfigWrapper.DeactivateScriptTag('inGame');
				
				SendSaveData();
				m_fxSetPanelMode.InvokeSelfOneArg(FlashArgBool(true));
			}
		}
		
		IngameMenu_UpdateDLCScriptTags();
		
		if (!panelMode)
		{
			m_fxSetIsMainMenu.InvokeSelfOneArg(FlashArgBool(isMainMenu)); 
			
			if (isMainMenu)
			{
				username = FixStringForFont(theGame.GetActiveUserDisplayName());
				m_fxSetCurrentUsername.InvokeSelfOneArg(FlashArgString(username));
				
				m_fxSetVersion.InvokeSelfOneArg(FlashArgString(theGame.GetApplicationVersion()));
				
				if( !theGame.IsContentAvailable( 'content12' ) )
				{
					theGame.GetGuiManager().RefreshMainMenuAfterContentLoaded();
				}
			}
			
			theGame.GetSecondScreenManager().SendGameMenuOpen();
			
			lastSetDifficulty = theGame.GetDifficultyLevel();
			
			currentLangValue = mInGameConfigWrapper.GetVarValue('Localization', 'Virtual_Localization_text');
			lastUsedLangValue = currentLangValue;
			
			currentSpeechLang = mInGameConfigWrapper.GetVarValue('Localization', 'Virtual_Localization_speech');
			lastUsedSpeechLang = currentSpeechLang;
			
			theGame.GetGameLanguageName(audioLanguageName,tempLanguageName);
			if( tempLanguageName != languageName )
			{
				languageName = tempLanguageName;
				m_fxSetGameLogoLanguage.InvokeSelfOneArg( FlashArgString(languageName) );
			}
			
			PopulateMenuData();
			if(!theTelemetry.WasConsentWindowShown())
			{
				ShowTelemetryWindow();
			}
		}
		
		theGame.GetCurrentViewportResolution( width, height );
		m_fxUpdateAnchorsAspectRatio.InvokeSelfTwoArgs( FlashArgInt( width ), FlashArgInt( height ) );
		
		theInput.RegisterListener( this, 'OnShowDeveloperMode', 'ShowDeveloperMode' );
	}
	
	event OnRefreshActiveUserDisplayName()
	{
		var username 			: string;

		if (isMainMenu)
		{
			username = FixStringForFont(theGame.GetActiveUserDisplayName());
			m_fxSetCurrentUsername.InvokeSelfOneArg(FlashArgString(username));
		}
	}
	
	event OnRefreshHDR()
	{
		PopulateMenuData();
	}
	
	event OnRefresh()
	{
		var audioLanguageName 	: string;
		var tempLanguageName 	: string;
		var overlayPopupRef  	: CR4OverlayPopup;
		var username 			: string;
		var hud 				: CR4ScriptedHud;
		var ep1StatusText		: string;
		var ep2StatusText		: string;
		
		
		currentLangValue = mInGameConfigWrapper.GetVarValue('Localization', 'Virtual_Localization_text');
		lastUsedLangValue = currentLangValue;
			
		currentSpeechLang = mInGameConfigWrapper.GetVarValue('Localization', 'Virtual_Localization_speech');
		lastUsedSpeechLang = currentSpeechLang;
		
		if (isMainMenu)
		{
			username = FixStringForFont(theGame.GetActiveUserDisplayName());
			m_fxSetCurrentUsername.InvokeSelfOneArg(FlashArgString(username));
			
			PopulateMenuData();
			
			
			
			
			
			
			
		}
		
		UpdateAcceptCancelSwaping();
		SetPlatformType(theGame.GetPlatform());
		hud = (CR4ScriptedHud)(theGame.GetHud());
		if (hud)
		{
			hud.UpdateAcceptCancelSwaping();
		}
		
		overlayPopupRef = (CR4OverlayPopup) theGame.GetGuiManager().GetPopup('OverlayPopup');
		if (overlayPopupRef)
		{
			overlayPopupRef.UpdateAcceptCancelSwaping();
		}
		
		theGame.GetGameLanguageName(audioLanguageName,tempLanguageName);
		if( tempLanguageName != languageName )
		{
			languageName = tempLanguageName;
			m_fxSetGameLogoLanguage.InvokeSelfOneArg( FlashArgString(languageName) );
			m_fxUpdateInputFeedback.InvokeSelf();
			if (overlayPopupRef)
			{
				overlayPopupRef.UpdateButtons();
			}
		}
		
		
		{
			
			
			if (theGame.GetDLCManager().IsEP1Available())
			{
				ep1StatusText = GetLocStringByKeyExt("expansion_status_installed");
			}
			else
			{
				ep1StatusText = GetLocStringByKeyExt("expansion_status_available");
			}
			
			if (theGame.GetDLCManager().IsEP2Available())
			{
				ep2StatusText = GetLocStringByKeyExt("expansion_status_installed");
			}
			else
			{
				
				ep2StatusText = GetLocStringByKeyExt("expansion_status_available");
			}
			
			m_fxSetExpansionText.InvokeSelfTwoArgs(FlashArgString(ep1StatusText), FlashArgString(ep2StatusText));
		}
		setArabicAligmentMode();
	}

	event OnVisitWeibo()
	{
		theGame.VisitWeibo();
	}
	
	function OnRequestSubMenu( menuName: name, optional initData : IScriptable )
	{
		RequestSubMenu(menuName, initData);
		m_fxSetVisible.InvokeSelfOneArg(FlashArgBool(false));
	}
	
	function ChildRequestCloseMenu()
	{
		m_fxSetVisible.InvokeSelfOneArg(FlashArgBool(true));
	}
	
	event OnCloseMenu() 
	{
		
		if(theGame.IsDialogOrCutscenePlaying())
			theSound.SoundEvent("music_resume");
		
		CloseMenu();
	}
	
	public function ReopenMenu()
	{
		var commonInGameMenu : CR4CommonIngameMenu;
		var commonMainMenuBase : CR4CommonMainMenuBase;
		
		commonInGameMenu = (CR4CommonIngameMenu)m_parentMenu;
		if(commonInGameMenu)
		{
			commonInGameMenu.reopenRequested = true;
		}
		
		commonMainMenuBase = (CR4CommonMainMenuBase)m_parentMenu;
		if ( commonMainMenuBase )
		{
			commonMainMenuBase.reopenRequested = true;
		}
		
		CloseMenu();
	}
		
	event  OnClosingMenu()
	{
		var commonInGameMenu : CR4CommonIngameMenu;
		var commonMainMenuBase : CR4CommonMainMenuBase;
		var deathScreenMenu : CR4DeathScreenMenu;
		var controlsFeedbackModule : CR4HudModuleControlsFeedback;
		var interactionModule : CR4HudModuleInteractions;
		var hud : CR4ScriptedHud;
		
		theGame.SetHDRMenuActive(false);
		
		SaveChangedSettings();
		
		theGame.GetSecondScreenManager().SendGameMenuClose();
		super.OnClosingMenu();
		
		
		hud = (CR4ScriptedHud)(theGame.GetHud());
		if (hud)
		{
			controlsFeedbackModule = (CR4HudModuleControlsFeedback)(hud.GetHudModule(NameToString('ControlsFeedbackModule')));
			if (controlsFeedbackModule)
			{
				controlsFeedbackModule.ForceModuleUpdate();
			}
			
			interactionModule = (CR4HudModuleInteractions)(hud.GetHudModule(NameToString('InteractionsModule')));
			if (interactionModule)
			{
				interactionModule.ForceUpdateModule();
			}
		}
		
		if (managingPause)
		{
			managingPause = false;
			theInput.RestoreContext( 'EMPTY_CONTEXT', true );
			theGame.Unpause('IngameMenu');
		}
		
		if (theGame.GetGuiManager().potalConfirmationPending)
		{
			theGame.GetGuiManager().ResumePortalConfirmationPendingMessage();
		}
		
		if (m_structureCreator)
		{
			delete m_structureCreator;
		}
		
		if (loadConfPopup)
		{
			delete loadConfPopup;
		}
		
		if (saveConfPopup)
		{
			delete saveConfPopup;
		}
		
		if (actionConfPopup)
		{
			delete actionConfPopup;
		}
		
		if (newGameConfPopup)
		{
			delete newGameConfPopup;
		}
		
		if (deleteConfPopup)
		{
			delete deleteConfPopup;
		}
		
		if (diffChangeConfPopup)
		{
			delete diffChangeConfPopup;
		}
		
		commonInGameMenu = (CR4CommonIngameMenu)m_parentMenu;
		if(commonInGameMenu)
		{
			commonInGameMenu.ChildRequestCloseMenu();
			return true;
		}
		
		commonMainMenuBase = (CR4CommonMainMenuBase)m_parentMenu;
		if ( commonMainMenuBase )
		{
			commonMainMenuBase.ChildRequestCloseMenu();
			return true;
		}
		
		deathScreenMenu = (CR4DeathScreenMenu)m_parentMenu;
		if (deathScreenMenu)
		{
			deathScreenMenu.ChildRequestCloseMenu();
			return true;
		}
	}
	
	
	protected function CloseCurrentPopup():void
	{
		if (loadConfPopup)
		{
			loadConfPopup.ClosePopupOverlay();
		}
		else if (saveConfPopup)
		{
			saveConfPopup.ClosePopupOverlay();
		}		
		else if (actionConfPopup)
		{
			actionConfPopup.ClosePopupOverlay();
		}		
		else if (newGameConfPopup)
		{
			newGameConfPopup.ClosePopupOverlay();
		}		
		else if (deleteConfPopup)
		{
			deleteConfPopup.ClosePopupOverlay();
		}		
		else if (diffChangeConfPopup)
		{
			diffChangeConfPopup.ClosePopupOverlay();
		}
	}
	
	public function SetIgnoreInput(value : bool) : void
	{
		if (value != ignoreInput)
		{
			ignoreInput = value;
			m_fxSetIgnoreInput.InvokeSelfOneArg( FlashArgBool(value) );
		}
	}
	
	public function UpdateSaveSlot() : void
	{
		m_fxUpdateSaveSlot.InvokeSelf();
	}
	
	public function OnUserSignIn() : void
	{
		SetIgnoreInput(false);
		CloseCurrentPopup();
	}
	
	public function OnUserSignInCancelled() : void
	{
		SetIgnoreInput(false);
		CloseCurrentPopup();
	}
	
	public function OnSaveLoadingFailed() : void
	{
		SetIgnoreInput(false);
		CloseCurrentPopup();
	}
	
	event  OnItemActivated( actionType:int, menuTag:int ) : void
	{
		var l_DataFlashArray : CScriptedFlashArray;
		var manager : CR4GuiManager;
		
		if (ignoreInput)
		{
			m_fxNavigateBack.InvokeSelf();
		}
		else
		{
			postprocessEntered = false;
			
			switch (actionType)
			{
			case IGMActionType_CommonMenu:
				theGame.RequestMenu( 'CommonMenu' );
				break;
			case IGMActionType_MenuHolder:
				
				
				m_initialSelectionsToIgnore = 1;
				OnPlaySoundEvent( "gui_global_panel_open" );
				curMenuDepth += 1;
				break;
			case IGMActionType_MenuLastHolder:
				m_initialSelectionsToIgnore = 1;
				OnPlaySoundEvent( "gui_global_panel_open" );
				curMenuDepth += 1;
				break;
			case IGMActionType_Load:
				if (hasSaveDataToLoad())
				{
					SendLoadData();
				}
				else
				{
					
					m_fxNavigateBack.InvokeSelf();
				}
				isInLoadselector = true;
				break;
			case IGMActionType_Save:
				if ( !theGame.AreSavesLocked() )
				{
					SendSaveData();
				}
				else
				{
					m_fxNavigateBack.InvokeSelf();
					theGame.GetGuiManager().DisplayLockedSavePopup();
				}
				isInLoadselector = false;
				break;
			case IGMActionType_Quit:
				ShowActionConfPopup( IGMActionType_Quit, "", GetPlatformLocString( "error_message_exit_game" ) );
				break;
			case IGMActionType_Toggle:
				break;
			case IGMActionType_ListWithCondition:
				break;
			case IGMActionType_List:
				break;
			case IGMActionType_Slider:
				break;
			case IGMActionType_LoadLastSave:
				LoadLastSave();
				break;
			case IGMActionType_Close:
				
				break;
			case IGMActionType_Tutorials:
				theGame.RequestMenuWithBackground( 'GlossaryTutorialsMenu', 'CommonMenu' );
				break;
			case IGMActionType_Credits:
				theGame.GetGuiManager().RequestCreditsMenu(menuTag);
				break;
			case IGMActionType_Help:
				showHelpPanel();
				break;
			case IGMActionType_Options:
				DLSSSupported();
				XESSSupported();
				RTEnabled();
				
				developerOptions = m_flashValueStorage.CreateTempFlashArray();
				
				showOptionsPanel();
				
				isDeveloperModeEnabled = false;
				ShowDeveloperMode( isDeveloperModeEnabled );
				break;
			case IGMActionType_ControllerHelp:
				curMenuDepth += 1;
				SendControllerData();
				break;
			case IGMActionType_NewGame:
				TryStartNewGame(menuTag);
				break;
			case IGMActionType_NewGamePlus:
				fetchNewGameConfigFromTag(menuTag);
				SendNewGamePlusSaves();
				break;
			case IGMActionType_InstalledDLC:
				SendInstalledDLCList();
				break;
			case IGMActionType_UIRescale:
				curMenuDepth += 1;
				SendRescaleData();
				break;
			case IGMActionType_DebugStartQuest:
				RequestSubMenu( 'MainDbgStartQuestMenu', GetMenuInitData() );
				break;
			case IGMActionType_Gwint:
				GetRootMenu().CloseMenu();
				theGame.RequestMenu( 'DeckBuilder' );
				break;
			case IGMActionType_ImportSave:
				lastSetTag = menuTag;
				fetchNewGameConfigFromTag( menuTag );
				SendImportSaveData( );
				break;
			case IGMActionType_CloseGame:
				if (!isMainMenu)
				{
					ShowActionConfPopup(IGMActionType_CloseGame, "", GetLocStringByKeyExt("error_message_exit_game"));
				}
				else
				{
					theGame.RequestExit();
				}
				break;
			case IGMActionType_KeyBinds:
				curMenuDepth += 1;
				SendKeybindData();
				break;
				
			case IGMActionType_ToggleRender:
				ToggleRTEnabled();
			    break;
			case IGMActionType_Gog:
				m_initialSelectionsToIgnore = 1;
				manager = (CR4GuiManager)theGame.GetGuiManager();
				if (manager) {
					manager.GalaxyQRSignInInitiate();
				}
				break;
			case IGMActionType_TelemetryConsent:	
				ShowTelemetryWindow();
				break;
			case IGMActionType_PurchaseEP1:
				theGame.DisplayStoreExpansionPack('ep1');
				break;
			case IGMActionType_PurchaseEP2:
				theGame.DisplayStoreExpansionPack('bob_000_000');
				break;
			}
		}
	}

	event  OnShowSaveGameMenu() : void
	{
		LogChannel('UI', "OnShowSaveGameMenu");
	}

	event  OnShowLoadGameMenu() : void
	{
		theGame.RefreshCrossProgressionSavesList();
	}

	event  OnShowOptionSubmenu( actionType:int, menuTag:int, id:string ) : void
	{		
		updateDLSSGOptionChanged();
		if (id == "settings_hdr")
		{
			theGame.SetHDRMenuActive(true);
		}
		else
		{
			theGame.SetHDRMenuActive(false);
		}
	}
	
	public function HandleLoadGameFailed():void
	{
		disableAccountPicker = false;
		SetIgnoreInput(false);
	}
	
	private function StartShowingCustomDialogs()
	{
		
		
		
		if (theGame.GetInGameConfigWrapper().GetVarValue('Hidden', 'HasSeenGotyWelcomeMessage') == "false")
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Hidden', 'HasSeenGotyWelcomeMessage', "true");
			theGame.SaveUserSettings();

			prepareBigMessageGOTY( "menu_goty_starting_message_alt" );
		}
	}
	
	protected function prepareBigMessage( epIndex : int ):void
	{
		var l_DataFlashObject 		: CScriptedFlashObject;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();

		l_DataFlashObject.SetMemberFlashInt( "index", epIndex );
		l_DataFlashObject.SetMemberFlashString( "tfTitle1", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_1") );
		l_DataFlashObject.SetMemberFlashString( "tfTitle2", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_2") );
		
		l_DataFlashObject.SetMemberFlashString( "tfTitlePath1", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_1") );
		l_DataFlashObject.SetMemberFlashString( "tfTitlePath2", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_2") );
		l_DataFlashObject.SetMemberFlashString( "tfTitlePath3", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_3") );
		
		l_DataFlashObject.SetMemberFlashString( "tfDescPath1", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_1_description") );
		l_DataFlashObject.SetMemberFlashString( "tfDescPath2", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_2_description") );
		l_DataFlashObject.SetMemberFlashString( "tfDescPath3", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_title_path_3_description") );
		
		l_DataFlashObject.SetMemberFlashString( "tfWarning", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_warning_level") );
		l_DataFlashObject.SetMemberFlashString( "tfGoodLuck", GetLocStringByKeyExt("ep" + epIndex + "_installed_information_good_luck") );
		
		m_flashValueStorage.SetFlashObject( "ingamemenu.bigMessage" + epIndex, l_DataFlashObject );
	}
	
	private function prepareBigMessageGOTY( text : string )
	{
		var l_DataFlashObject 		: CScriptedFlashObject;
		var title1 : string;
		var content : string;
		var titleEnd : string;

		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();

		title1   = GetLocStringByKey( text );
		content  = GetLocStringByKey( "menu_goty_starting_message_content" );
		titleEnd = GetLocStringByKey( "ep1_installed_information_good_luck" );

		l_DataFlashObject.SetMemberFlashInt( "index", 3 );
		l_DataFlashObject.SetMemberFlashString( "tfTitle1",   title1 );
		l_DataFlashObject.SetMemberFlashString( "tfContent",  content );
		l_DataFlashObject.SetMemberFlashString( "tfTitleEnd", titleEnd );
		
		m_flashValueStorage.SetFlashObject( "ingamemenu.bigMessage3", l_DataFlashObject );

	}
	
	public function StartShowCustomDialogGalaxySignIn()
	{
		var l_DataFlashObject 		: CScriptedFlashObject;
		var isPlatformPC		: bool;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		isPlatformPC = (theGame.GetGalaxyPf() == Platform_PC);
		
		l_DataFlashObject.SetMemberFlashInt( "index", 4 );
		l_DataFlashObject.SetMemberFlashBool("isPlatformPC", isPlatformPC);
		l_DataFlashObject.SetMemberFlashString( "tfTitleSignIn", "[[ui_gog_qr_title]]" );
		l_DataFlashObject.SetMemberFlashString( "tfContentSignInTopA", "[[ui_gog_qr_explain_1]]" );
		l_DataFlashObject.SetMemberFlashString( "tfContentSignInTopB", "[[ui_gog_qr_explain_2]]" );
		if (isPlatformPC) {
			l_DataFlashObject.SetMemberFlashString( "tfContentSignIn2", "[[ui_gog_red_launcher_signin_instructions]]");
		}
		else
		{
			l_DataFlashObject.SetMemberFlashString( "tfLink1" , "[[ui_gog_qr_pls_wait]]");
			l_DataFlashObject.SetMemberFlashString( "tfContentSignIn2", "[[ui_gog_qr_use_url]]");
			l_DataFlashObject.SetMemberFlashString( "tfContentSignIn3", "[[ui_gog_qr_scan_hint]]" );
		}
		
		m_flashValueStorage.SetFlashObject( "ingamemenu.bigMessage4", l_DataFlashObject );
	}

	public function HideErrorWindow()
	{
		m_fxHideErrorWindow.InvokeSelf();
	}

	public function ShowErrorWindow(error : int)
	{
		var l_DataFlashObject : CScriptedFlashObject;
		var tfDescription : string ;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		switch(error)
		{
			case RewardsRequestFailed:
			case QRCodeRequestFailed:
			case GOGNoInternetConnection:
				tfDescription = "[[ui_gog_error_no_connection]]";
				break;
			case RewardsTemporaryFail:
				tfDescription = "[[ui_gog_error_fault_retry]]";
				break;
			default:
				tfDescription = "[[ui_gog_error_smt_wrong]]";
				break;
		}		
		l_DataFlashObject.SetMemberFlashString("tfTitleError","[[ui_gog_error_popup_title]]");
		l_DataFlashObject.SetMemberFlashString("tfDescription",tfDescription);
		
		m_flashValueStorage.SetFlashObject("ingamemenu.ErrorHandleWindow", l_DataFlashObject);
	}

	private function SetRewardsCellParams( out dataFObj : CScriptedFlashObject, out rewarr : array< int >, cellName: string, rewID : int )
	{
		var rewTitle : string ;
		var rewDesc : string ;
		var isPresent : bool ;
		
		
		isPresent = rewarr.Contains(rewID);
		dataFObj.SetMemberFlashBool("b"+cellName+"on", isPresent);
		if ( !isPresent ) {
			return;
		}	
		
		
		theGame.GetGuiManager().GetGalaxyRewardDesc( rewID, rewTitle, rewDesc );
		dataFObj.SetMemberFlashString("tf"+cellName+"title", rewTitle);
		dataFObj.SetMemberFlashString("tf"+cellName+"desc", rewDesc);
	}

	public function ShowRewardsWindow( out rewarr : array< int > )
	{		
		var dataFObj : CScriptedFlashObject;
		var tfTableTitle : string ;
		var tfTableDescription : string ;
		var tfRoachDescription : string ;
		var isRoachPresent : bool ;

		
		dataFObj = m_flashValueStorage.CreateTempFlashObject();
		tfTableTitle = GetLocStringByKeyExt("ui_gog_rewards_table_title");
		dataFObj.SetMemberFlashString("tfTitleRewards",tfTableTitle);
		if(theGame.GetPlatform() == Platform_PC)
			dataFObj.SetMemberFlashString("tfTitleLink","[[ui_gog_link_rewards]]");
		else
			dataFObj.SetMemberFlashString("tfTitleLink","");
		tfTableDescription = GetLocStringByKeyExt("ui_gog_rewards_table_description");
		dataFObj.SetMemberFlashString("tfTopDescription",tfTableDescription);
		
		
    	
		
		
		
		
		
		SetRewardsCellParams( dataFObj, rewarr, "Cell_1_1", 6);  
		SetRewardsCellParams( dataFObj, rewarr, "Cell_1_2", 7);  
		SetRewardsCellParams( dataFObj, rewarr, "Cell_2_1", 8);  
		SetRewardsCellParams( dataFObj, rewarr, "Cell_2_2", 9);  
		SetRewardsCellParams( dataFObj, rewarr, "Cell_3_1", 10); 
		SetRewardsCellParams( dataFObj, rewarr, "Cell_3_2", 11); 
		SetRewardsCellParams( dataFObj, rewarr, "Cell_4_1", 12); 
		SetRewardsCellParams( dataFObj, rewarr, "Cell_4_2", 13); 
		SetRewardsCellParams( dataFObj, rewarr, "Cell_5_1", 14); 
		SetRewardsCellParams( dataFObj, rewarr, "Cell_5_2", 15); 
		
		
		isRoachPresent = rewarr.Contains(12);
		if	(isRoachPresent) {
			tfRoachDescription = GetLocStringByKeyExt("ui_gog_reward_roach_table_desc");
		} else {
			tfRoachDescription = "";
		}
		dataFObj.SetMemberFlashString("tfRoachDescription",tfRoachDescription);

		
		m_flashValueStorage.SetFlashObject("ingamemenu.RewardsTableWindow", dataFObj);
	}
	
	private function ShowTelemetryWindow()
	{
		var l_DataFlashObject 	: CScriptedFlashObject;
		var isPlatformPC		: bool = (theGame.GetGalaxyPf() == Platform_PC);
		
		if( theGame.isUserSignedIn() )
		{
			l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();

			l_DataFlashObject.SetMemberFlashBool("isPlatformPC", isPlatformPC);
			l_DataFlashObject.SetMemberFlashString("tfTelemetryTitle","[[ui_gog_tel_consent_title]]");
			l_DataFlashObject.SetMemberFlashString("tfTelemetryContent","[[ui_gog_tel_consent_big_text]]");
			l_DataFlashObject.SetMemberFlashString("tfTelemetryContent2","[[ui_gog_tel_consent_question]]");
			l_DataFlashObject.SetMemberFlashString("tfTelemetryFooter","[[ui_gog_tel_consent_thanks]]");
			l_DataFlashObject.SetMemberFlashString("tfTelemetryFooter2","CD PROJEKT RED");
			
			m_flashValueStorage.SetFlashObject("ingamemenu.TelemetryModalWindow",l_DataFlashObject);
			
			theTelemetry.MarkShownConsentWindow();
		}
	}
		
	protected function LoadLastSave():void
	{
		if (theGame.GetGuiManager().GetPopup('MessagePopup') && theGame.GetGuiManager().lastMessageData.messageId == UMID_ControllerDisconnected)
		{
			return;
		}
		
		SetIgnoreInput(true);
		
		if (isMainMenu)
		{
			disableAccountPicker = true;
		}
		
		theGame.LoadLastGameInit();
	}
	
	protected function ShowActionConfPopup(action : int, title : string, description : string) : void
	{
		if (actionConfPopup)
		{
			delete actionConfPopup;
		}
		
		actionConfPopup = new W3ActionConfirmation in this;
		actionConfPopup.SetMessageTitle(title);
		actionConfPopup.SetMessageText(description);
		actionConfPopup.actionID = action;
		actionConfPopup.menuRef = this;
		actionConfPopup.BlurBackground = true;
			
		RequestSubMenu('PopupMenu', actionConfPopup);
	}
	
	public function OnActionConfirmed(action:int) : void
	{
		var parentMenu : CR4MenuBase;
		
		parentMenu = (CR4MenuBase)GetParent();
		
		switch (action)
		{
		case IGMActionType_Quit:
			{
				parentMenu.OnCloseMenu();
				theGame.RequestEndGame();
				break;
			}
		case IGMActionType_CloseGame:
			{
				theGame.RequestExit();
				break;
			}
		}
	}
	
	event  OnPresetApplied(groupId:name, targetPresetIndex:int)
	{
		hasChangedOption = true;
		IngameMenu_ChangePresetValue(groupId, targetPresetIndex, this);
		
		if (groupId == 'Rendering' && !isMainMenu)
		{
			m_fxForceBackgroundVis.InvokeSelfOneArg(FlashArgBool(true));
		}
		
		
		if(groupId == 'PostProcess')
		{
			UpdateAO2CorrespondRT(theGame.GetRTEnabled(), true);
			UpdateOptions('PostProcess', false);
		}

		updateOptionsDisableState();
	}
	
	event  OnTelemetryConsentChanged(telemetryConsent:bool)
	{
		theTelemetry.TelemetryConsentChanged( telemetryConsent );
		
	}
	
	event  OnConsentPopupWasShown(consentPopupWasShown: bool)
	{
		theTelemetry.MarkShownConsentWindow();
	}
	
	public function UpdateOptions(groupId:name, applyLocks:bool)
	{
		var optionChangeContainer : CScriptedFlashObject;
		
		optionChangeContainer = m_flashValueStorage.CreateTempFlashObject();
		IngameMenu_GatherOptionUpdatedValues(groupId, optionChangeContainer, m_flashValueStorage, applyLocks);
		
		m_flashValueStorage.SetFlashObject( "ingamemenu.optionValueChanges", optionChangeContainer );
		IngameMenu_GatherOptionUpdatedValueList(groupId, m_flashValueStorage);
	}
	
	public function DLSSSupported()
	{
		var DLSSIsSupported : bool;
		DLSSIsSupported = theGame.GetIsDLSSSupported();
		m_fxSetDLSSIsSupported.InvokeSelfTwoArgs( FlashArgBool(DLSSIsSupported), FlashArgUInt(NameToFlashUInt('AAMode') ));				
	}

	public function XESSSupported()
	{
		var XESSIsSupported : bool;
		XESSIsSupported = theGame.GetIsXESSSupported();
		m_fxSetXESSIsSupported.InvokeSelfTwoArgs( FlashArgBool(XESSIsSupported), FlashArgUInt(NameToFlashUInt('AAMode') ));				
	}
	
	public function RTEnabled()
	{ 
		var RTEnabled : bool;
		RTEnabled = theGame.GetRTEnabled();
		m_fxSetRTEnabled.InvokeSelfTwoArgs( FlashArgBool(RTEnabled), FlashArgUInt(NameToFlashUInt('Virtual_SSAOSolution') ));
		if(RTEnabled == false)
		{
			if( StringToInt(mInGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) >= 2 )
			{
				mInGameConfigWrapper.SetVarValue( 'PostProcess', 'Virtual_SSAOSolution','1' );
				m_fxUpdateOptionValue.InvokeSelfTwoArgs( FlashArgUInt(NameToFlashUInt('Virtual_SSAOSolution')), FlashArgString('1') );
			}
		}
	}
	
	event  OnCancelOptionValueChange(groupId:int, optionName:name)
	{
		var groupName:name;
		var curTimeGetOption:int;
				
		groupName = mInGameConfigWrapper.GetGroupName(groupId);

		if (groupName == 'Graphics' && optionName == 'AAMode' && theGame.GetIsXESSSupported() == false)
		{
			showNotification(GetPlatformLocString("option_warning_xess_support"));
		}

		if (groupName == 'Graphics' && optionName == 'AAMode' && theGame.GetIsDLSSSupported() == false)
		{
			showNotification(GetPlatformLocString("option_warning_dlss_support"));
		}

		
		
		
		
		
		
		
		
		
		curTimeGetOption = theGame.GetLocalTimeAsMilliseconds();
		if(((curTimeGetOption - lastTimeGetOption) > 300))
		{
			lastTimeGetOption = curTimeGetOption;
			theSound.SoundEvent("gui_global_denied");
		}
	}
	
	event  OnOptionValueChanged(groupId:int, optionName:name, optionValue:string)
	{
		var groupName			: name;
		var hud 				: CR4ScriptedHud;
		var isValid 			: bool;
		var isBuffered 			: bool;
				
		
		var dialogModule : CR4HudModuleDialog;
		var subtitleModule : CR4HudModuleSubtitles;
		var onelinerModule : CR4HudModuleOneliners;
		
		
		
		var minimapModule : CR4HudModuleMinimap2;
		
		
		
		var objectiveModule : CR4HudModuleQuests;
		

		hasChangedOption = true;
		
		OnPlaySoundEvent( "gui_global_switch" );
		
		
		if (groupId == NameToFlashUInt('SpecialSettingsGroupId'))
		{
			HandleSpecialValueChanged(optionName, optionValue);
			return true;
		}		
		
		
		if (optionName == 'InvertLockOption')
		{
			if ( optionValue == "true" )
				thePlayer.SetInvertedLockOption(true);
			else
				thePlayer.SetInvertedLockOption(false);
		}
		
		if (optionName == 'InvertCameraX')
		{
			if ( optionValue == "true" )
				thePlayer.SetInvertedCameraX(true);
			else
				thePlayer.SetInvertedCameraX(false);
		}
		
		if (optionName == 'InvertCameraY')
		{
			if ( optionValue == "true" )
				thePlayer.SetInvertedCameraY(true);
			else
				thePlayer.SetInvertedCameraY(false);
		}
		
		if (optionName == 'InvertCameraXOnMouse')
		{
			if ( optionValue == "true" )
				thePlayer.SetInvertedMouseCameraX(true);
			else
				thePlayer.SetInvertedMouseCameraX(false);
		}
		
		if (optionName == 'InvertCameraYOnMouse')
		{
			if ( optionValue == "true" )
				thePlayer.SetInvertedMouseCameraY(true);
			else
				thePlayer.SetInvertedMouseCameraY(false);
		}
		
		
		
		if (optionName == 'EnableAlternateSignCasting')
		{
			if ( optionValue == "1" )
			{
				thePlayer.GetInputHandler().SetIsAltSignCasting(true);
				FactsSet( "nge_alt_sign_casting_chosen", 1 );
			}
			else
			{
				thePlayer.GetInputHandler().SetIsAltSignCasting(false);
				FactsSet( "nge_alt_sign_casting_chosen", 0 );
			}
			thePlayer.ApplyCastSettings();
		}
		
		
		
		if (optionName == 'EnableAlternateExplorationCamera')
		{
			if ( optionValue == "1" )
				thePlayer.SetExplCamera(true);
			else
				thePlayer.SetExplCamera(false);
		}
		
		if (optionName == 'EnableAlternateCombatCamera')
		{
			if ( optionValue == "1" )
				thePlayer.SetCmbtCamera(true);
			else
				thePlayer.SetCmbtCamera(false);
		}
		
		if (optionName == 'EnableAlternateHorseCamera')
		{
			if ( optionValue == "1" )
				thePlayer.SetHorseCamera(true);
			else
				thePlayer.SetHorseCamera(false);
		}
		
		if (optionName == 'SoftLockCameraAssist')
		{
			if ( optionValue == "true" )
				thePlayer.SetSoftLockCameraAssist(true);
			else
				thePlayer.SetSoftLockCameraAssist(false);
		}
		
		
		
		if (optionName == 'SubtitleScale')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if(hud)
			{
				dialogModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
				if(dialogModule)
					dialogModule.SetSubtitleScale( StringToInt(optionValue) );
				
				subtitleModule = (CR4HudModuleSubtitles)hud.GetHudModule("SubtitlesModule");
				if(subtitleModule)
					subtitleModule.SetSubtitleScale( StringToInt(optionValue) );
			}
		}
		
		if (optionName == 'DialogChoiceScale')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if(hud)
			{
				dialogModule = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");
				if(dialogModule)
					dialogModule.SetDialogChoiceScale( StringToInt(optionValue) );
			}
		}
		
		if (optionName == 'OnelinerScale')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if(hud)
			{
				onelinerModule = (CR4HudModuleOneliners)hud.GetHudModule("OnelinersModule");
				if(onelinerModule)
					onelinerModule.SetOnelinerScale( StringToInt(optionValue) );
			}
		}
		
		
		if (optionName == 'WidescreenCutscene' && optionValue == "true")
		{
			theGame.GetGuiManager().ShowUserDialog(0, "", "message_widescreen_cutscene_use_cachets_disclaimer", UDB_Ok);
		}
		
		
		if (optionName == 'MinimapDuringFocusCombat')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if(hud)
			{
				minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");
				if(minimapModule)
				{
					if ( optionValue == "true" )
					{
						minimapModule.SetMinimapDuringFocusCombat( true );
					}
					else
					{
						minimapModule.SetMinimapDuringFocusCombat( false );
					}
				}					
			}
		}
		
		
		
		if (optionName == 'ObjectiveDuringFocusCombat')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if(hud)
			{
				objectiveModule = (CR4HudModuleQuests)hud.GetHudModule("QuestsModule");
				if(objectiveModule)
				{
					if ( optionValue == "true" )
					{
						objectiveModule.SetObjectiveDuringFocusCombat( true );
					}
					else
					{
						objectiveModule.SetObjectiveDuringFocusCombat( false );
					}
				}					
			}
		}
		
		
		
		if (optionName == 'LeftStickSprint')
		{
			if ( optionValue == "true" )
				thePlayer.SetLeftStickSprint(true);
			else
				thePlayer.SetLeftStickSprint(false);
		}
		
		
		
		if (optionName == 'AutoApplyBladeOils')
		{
			if ( optionValue == "true" )
				thePlayer.SetAutoApplyOils(true);
			else
				thePlayer.SetAutoApplyOils(false);
		}
		
		
		if (optionName == 'HardwareCursor')
		{
			isValid = optionValue;
			m_fxSetHardwareCursorOn.InvokeSelfOneArg(FlashArgBool(isValid));
		}
		
		if( optionName == 'ConsentTelemetry' )
		{
			if ( optionValue =="true" )
			{
				OnTelemetryConsentChanged(true);
			}
			else
			{
				OnTelemetryConsentChanged(false);
			}
		}
		
		if (optionName == 'SwapAcceptCancel')
		{
			swapAcceptCancelChanged = true;
		}
		
		if (optionName == 'AlternativeRadialMenuInputMode')
		{
			alternativeRadialInputChanged = true;
		}
		
		if (optionName == 'EnableUberMovement')
		{
			if ( optionValue == "1" )
				theGame.EnableUberMovement( true );
			else
				theGame.EnableUberMovement( false );
		}
		
		if (optionName == 'GwentDifficulty')
		{
			if ( optionValue == "0" )
				FactsSet( 'gwent_difficulty' , 1 );
			else if ( optionValue == "1" )
				FactsSet( 'gwent_difficulty' , 2 );
			else if ( optionValue == "2" )
				FactsSet( 'gwent_difficulty' , 3 );
			
			return true;
		}
		
		if (optionName == 'HardwareCursor')
		{
			updateInputDeviceRequired = true;
		}
		
		groupName = mInGameConfigWrapper.GetGroupName( groupId );
		
		
		isBuffered = 
			( mInGameConfigWrapper.DoGroupHasTag( groupName, 'buffered' ) || mInGameConfigWrapper.DoVarHasTag( groupName, optionName, 'buffered' ) )
			&& !mInGameConfigWrapper.DoVarHasTag( groupName, optionName, 'dropDown' )
			&& !mInGameConfigWrapper.DoVarHasTag( groupName, optionName, 'nonbuffered' );
		
		if ( groupName == 'Localization' &&
			 optionName == 'Virtual_Localization_speech' && 
			 theGame.GetVoiceLangDownloadStatus( mInGameConfigWrapper.GetVarOption( groupName, optionName, StringToInt( optionValue ) ) ) != STREAMABLE_LOADED 
			)
		{
			return true;
		}
		
		if( isBuffered == true )
		{
			inGameConfigBufferedWrapper.SetVarValue(groupName, optionName, optionValue);
		}
		else
		{
			mInGameConfigWrapper.SetVarValue(groupName, optionName, optionValue);
		}
			
		theGame.OnConfigValueChanged(optionName, optionValue);
		
		if (groupName == 'Hud' || optionName == 'Subtitles')
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			
			if (hud)
			{
				hud.UpdateHudConfig(optionName, true);
			}
		}
		
		if (groupName == 'Localization')
		{
			if (optionName == 'Virtual_Localization_text')
			{
				currentLangValue = optionValue;
			}
			else if (optionName == 'Virtual_Localization_speech')
			{
				currentSpeechLang = optionValue;
			}
		}
		
		if (groupName == 'Rendering' && !isMainMenu)
		{
			m_fxForceBackgroundVis.InvokeSelfOneArg(FlashArgBool(true));
		}
		
		if (groupName == 'Rendering' && optionName == 'PreserveSystemGamma')
		{
			theGame.GetGuiManager().DisplayRestartGameToApplyAllChanges();
		}
		
		if(optionName == 'EnableRT')
		{
			
			if( optionValue == "true" )
			{
				if(StringToInt(mInGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) != IGMOPT_AO_NRDRTAO)
				{
					mInGameConfigWrapper.SetVarValue('PostProcess', 'Virtual_SSAOSolution', IntToString(IGMOPT_AO_NRDRTAO));
				}
			}
			if( optionValue == "false" )
			{
				if(StringToInt(mInGameConfigWrapper.GetVarValue('PostProcess', 'Virtual_SSAOSolution')) >= IGMOPT_AO_RTAO)
				{
					mInGameConfigWrapper.SetVarValue('PostProcess', 'Virtual_SSAOSolution', IntToString(IGMOPT_AO_SSAO));
				}
			}
			UpdateAO2CorrespondRT(optionValue == "true", false);
			UpdateOptions('PostProcess', false);

			
			updateRTOptionEnabled(optionValue == "true");
			updateRTAOOptionChanged();
			updateRTROptionChanged();
		}
		
		if (optionName == 'AllowMotionBlur')
		{
			updateMotionBlurOptionChanged(optionValue == "true");
		}

		
		
		
		
		
		

		
		
		
		
		
		

		if ( optionName == 'Virtual_HairWorksLevel' )
		{
			updateHairWorksOptionChanged();
		}
		
		if( optionName == 'AAMode' )
		{
			UpdateOptions('PostProcess', true);
			updateAAOptionChanged();
		}

		if (optionName == 'RTAOEnabled')
		{
			updateRTAOOptionChanged();
		}

		if (optionName == 'EnableRtRadiance')
		{
			updateRTROptionChanged();
		}
		
		if( optionName == 'DeveloperMode' )
		{
			ShowDeveloperOptions( optionValue == "true" );
		}

		if (optionName == 'GraphicsPreset')
		{
			setLocksOnPresetChanged();
		}

		if (optionName == 'Virtual_DLSSG')
		{
			updateDLSSGOptionChanged();
		}

		if (optionName == 'Virtual_Reflex')
		{
			updateReflexOptionChanged();
		}

		IngameMenu_AdditionalOptionValueChangeHandling( groupName, optionName, optionValue, m_flashValueStorage );

		
		
		
		
		
		
		if ( optionName == 'CrossProgression' )
		{
			theGame.UpdateCrossProgressionValue( optionValue );
		}
	}
	
	private function updateMotionBlurOptionChanged(enabled:bool):void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('MotionBlurIntensity') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);
		
		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	private function setLocksOnPresetChanged():void
	{
		setLocksOnRTChange(theGame.GetRTEnabled());
		updateHairWorksOptionChanged();
		updateAAOptionChanged();
	}

	private function setLocksOnRTChange(enabled:bool):void
	{
		UpdateAO2CorrespondRT(enabled, false);
		UpdateOptions('PostProcess', true);
		updateRTOptionEnabled(enabled);
		updateRTAOOptionChanged();
		updateRTROptionChanged();
	}

	private function updateOptionsDisableState():void
	{
		updateRTOptionEnabled(theGame.GetRTEnabled());
		updateAAOptionChanged();
		updateHairWorksOptionChanged();
		updateRTAOOptionChanged();
		updateRTROptionChanged();
	}

	protected function updateRTOptionEnabled(enabled:bool):void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		if ( !theGame.GetRTSupported() ) return; 

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('RTGIPreset') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('EnableRtRadiance') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Shadows') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('RTAOEnabled') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_GlobalIllumination') );
		dataObject.SetMemberFlashBool( "disabled", !enabled);
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateAAOptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('FSRQuality') );
		dataObject.SetMemberFlashBool( "disabled", !theGame.GetFSREnabled());
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('DLSSQuality') );
		dataObject.SetMemberFlashBool( "disabled", !theGame.GetDLSSEnabled());
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('XESSQuality') );
		dataObject.SetMemberFlashBool( "disabled", !theGame.GetXESSEnabled());
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('DynamicResolutionScaling') );
		dataObject.SetMemberFlashBool( "disabled", theGame.GetDLSSEnabled() || theGame.GetDLSSGEnabled()  || theGame.GetXESSEnabled());
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_SharpenAmount') );
		dataObject.SetMemberFlashBool( "disabled", false );
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateHairWorksOptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_HairWorksAALevel') );
		dataObject.SetMemberFlashBool( "disabled", !theGame.GetHairWorksEnabled());
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_HairWorksQualityPreset') );
		dataObject.SetMemberFlashBool( "disabled", !theGame.GetHairWorksEnabled());
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateRTAOOptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('SSAOEnabled') );
		dataObject.SetMemberFlashBool( "disabled", theGame.GetRTAOEnabled());
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateDLSSGOptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;
		var dlssEnabled : bool;
		var dlssgEnabled : bool;

		dlssEnabled = theGame.GetDLSSEnabled();
		dlssgEnabled = theGame.GetDLSSGEnabled();

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_Reflex') );
		dataObject.SetMemberFlashBool( "disabled", dlssgEnabled || !theGame.GetReflexSupported());
		if (dlssgEnabled)
		{
			dataObject.SetMemberFlashString( "current", "1");
		}
		else
		{
			dataObject.SetMemberFlashBool( "resetToStartingValue", true);
		}
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('VSync') );
		dataObject.SetMemberFlashBool( "disabled", dlssgEnabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('FPSLimit') );
		dataObject.SetMemberFlashBool( "disabled", dlssgEnabled);
		dataArray.PushBackFlashObject(dataObject);

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('DynamicResolutionScaling') );
		dataObject.SetMemberFlashBool( "disabled", dlssEnabled || dlssgEnabled);
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateReflexOptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_Reflex') );
		dataObject.SetMemberFlashBool( "disabled", theGame.GetDLSSGEnabled() || !theGame.GetReflexSupported());
		if (!theGame.GetDLSSGEnabled())
		{
			dataObject.SetMemberFlashBool( "resetStartingValue", true);
		}
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}

	protected function updateRTROptionChanged():void
	{
		var dataObject : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;

		dataArray = m_flashValueStorage.CreateTempFlashArray();

		dataObject = m_flashValueStorage.CreateTempFlashObject();
		dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt('Virtual_SSREnabled') );
		dataObject.SetMemberFlashBool( "disabled", theGame.GetRTREnabled());
		dataArray.PushBackFlashObject(dataObject);

		m_flashValueStorage.SetFlashArray( "options.update_disabled", dataArray );
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
	}
	
	event  OnButtonClicked( optionName : name )
	{
		if ( optionName == 'MoreSpeechLanguages' )
		{
			theGame.DisplayStore();
		}
	}
	
	event  OnOptionSelectionChanged( optionName : name, value : bool)
	{
		if (!postprocessEntered && optionName == 'AAMode')
		{
			UpdateOptions('PostProcess', true);
			postprocessEntered = true;
			updateAAOptionChanged();
		}
		
		if ( optionName == 'EnableRT')
		{
			
			if (value && postprocessRtGreyed == true)
			{
				postprocessRtGreyed = false;
				UpdateOptions('PostProcess', false);
			}
		}
		else if (value)
		{
			if (postprocessRtGreyed == false)
			{
				postprocessRtGreyed = true;
				UpdateOptions('PostProcess', true);
			}
		}
	}
	
	protected function HandleSpecialValueChanged(optionName:name, optionValue:string):void
	{
		var intValue : int;
		
		if (optionName == 'GameDifficulty')
		{
			intValue = StringToInt(optionValue, 1);
			
			lastSetDifficulty = intValue + 1;
		}
	}
	
	public function OnGraphicsUpdated(keepChanges:bool):void
	{
		
		
		
		
		
	}
	
	event  OnOptionPanelNavigateBack()
	{
		var graphicChangesPending:bool;
		var hud : CR4ScriptedHud;
		
		theGame.SetHDRMenuActive(false);
		
		if (inGameConfigBufferedWrapper.AnyBufferedVarHasTag('refreshViewport'))
		{
			inGameConfigBufferedWrapper.ApplyNewValues();
			theGame.GetGuiManager().ShowProgressDialog(UMID_GraphicsRefreshing, "", "message_text_confirm_option_changes", true, UDB_OkCancel, 100, UMPT_GraphicsRefresh, '');
			ReopenMenu();
			return true;
		}
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		if (hud)
		{
			hud.RefreshHudConfiguration();
		}
		
		thePlayer.SetAutoCameraCenter( inGameConfigBufferedWrapper.GetVarValue( 'Gameplay', 'AutoCameraCenter' ) );
		thePlayer.SetEnemyUpscaling( inGameConfigBufferedWrapper.GetVarValue( 'Gameplay', 'EnemyUpscaling' ) );
	}
	
	event  OnNavigatedBack()
	{
		var lowestDifficultyUsed : EDifficultyMode;
		var hud : CR4ScriptedHud;
		var overlayPopupRef : CR4OverlayPopup;
		var radialMenuModule : CR4HudModuleRadialMenu;
		var confirmResult : int;
		var flashObject : CScriptedFlashObject;
		
		theGame.SetHDRMenuActive(false);
		
		hud = (CR4ScriptedHud)(theGame.GetHud());
		overlayPopupRef = (CR4OverlayPopup) theGame.GetGuiManager().GetPopup('OverlayPopup');
		
		if( inGameConfigBufferedWrapper.IsEmpty() == false )
		{
			if (!inGameConfigBufferedWrapper.AnyBufferedVarHasTag('refreshViewport'))
			{
				inGameConfigBufferedWrapper.FlushBuffer();
			}
			
			hasChangedOption = true;
		}
		
		if ( theGame.GetVoiceLangDownloadStatus( mInGameConfigWrapper.GetVarOption( 'Localization', 'Virtual_Localization_speech', StringToInt( currentSpeechLang ) ) ) != STREAMABLE_LOADED )
		{
			
			currentSpeechLang = lastUsedSpeechLang;
			mInGameConfigWrapper.SetVarValue( 'Localization', 'Virtual_Localization_speech', currentSpeechLang );
			
			theGame.UpdateSpeechLanguageSlider( currentSpeechLang );
		}
		
		if (currentLangValue != lastUsedLangValue || lastUsedSpeechLang != currentSpeechLang)
		{
			lastUsedLangValue = currentLangValue;
			lastUsedSpeechLang = currentSpeechLang;
			theGame.ReloadLanguage();
			
			flashObject = m_flashValueStorage.CreateTempFlashObject();
			flashObject.SetMemberFlashUInt( "optionTag", NameToFlashUInt( 'Virtual_Localization_speech' ) );
			flashObject.SetMemberFlashString( "optionSelectedId", currentSpeechLang );	
			m_flashValueStorage.SetFlashObject( "option.changedId", flashObject );
		}
		
		if (swapAcceptCancelChanged)
		{
			swapAcceptCancelChanged = false;
			UpdateAcceptCancelSwaping();
			
			if (hud)
			{
				hud.UpdateAcceptCancelSwaping();
			}
			
			if (overlayPopupRef)
			{
				overlayPopupRef.UpdateAcceptCancelSwaping();
			}
		}
		
		if (alternativeRadialInputChanged)
		{
			alternativeRadialInputChanged = false;
			
			if (hud)
			{
				radialMenuModule =  (CR4HudModuleRadialMenu)hud.GetHudModule( "RadialMenuModule" );
				if (radialMenuModule)
				{
					radialMenuModule.UpdateInputMode();
				}
			}
		}
		
		isShowingSaveList = false;
		isShowingLoadList = false;
		
		OnPlaySoundEvent( "gui_global_panel_close" );
		
		lowestDifficultyUsed = theGame.GetLowestDifficultyUsed();
		
		
		
		if (!isMainMenu && theGame.GetDifficultyLevel() != lastSetDifficulty && lowestDifficultyUsed > lastSetDifficulty && lowestDifficultyUsed > EDM_Medium)
		{
			diffChangeConfPopup = new W3DifficultyChangeConfirmation in this;
			
			diffChangeConfPopup.SetMessageTitle("");
			diffChangeConfPopup.SetMessageText( GetPlatformLocString( "difficulty_change_warning_message", "difficulty_change_warning_message_X1" ) );
			diffChangeConfPopup.menuRef = this;
			diffChangeConfPopup.targetDifficulty = lastSetDifficulty;
			diffChangeConfPopup.BlurBackground = true;
			
			RequestSubMenu('PopupMenu', diffChangeConfPopup);
		}
		else if (lastSetDifficulty != theGame.GetDifficultyLevel())
		{
			theGame.SetDifficultyLevel(lastSetDifficulty);
			theGame.OnDifficultyChanged(lastSetDifficulty);
		}
		
		SaveChangedSettings();

		if (overlayPopupRef && updateInputDeviceRequired)
		{
			updateInputDeviceRequired = false;
			overlayPopupRef.UpdateInputDevice();
		}

		
		curMenuDepth -= 1;
		if (curMenuDepth < depthOptions) {
			curMenuDepth = 1;
		}
		theTelemetry.NoticeMenuDepth(curMenuDepth);
	}
	
	public function CancelDifficultyChange() : void
	{
		var difficultyIndex:int;
		var difficultyIndexAsString:string;
		
		lastSetDifficulty = theGame.GetDifficultyLevel();
		
		difficultyIndex = lastSetDifficulty - 1;
		difficultyIndexAsString = "" + difficultyIndex;
		m_fxUpdateOptionValue.InvokeSelfTwoArgs(FlashArgUInt(NameToFlashUInt('GameDifficulty')), FlashArgString(difficultyIndexAsString));
	}
	
	protected function SaveChangedSettings()
	{
		if (hasChangedOption)
		{
			hasChangedOption = false;
			theGame.SaveUserSettings();
		}
	}
	
	event  OnProfileChange()
	{
		if( !disableAccountPicker )
		{
			SetIgnoreInput(true);
			theGame.ChangeActiveUser();
		}
	}
	
	event  OnSaveGameCalled(type : ESaveGameType, saveArrayIndex : int)
	{
		var saves : array< SSavegameInfo >;
		var currentSave : SSavegameInfo;
		
		ignoreInput = true; 
		
		if ( theGame.AreSavesLocked() )
		{
			theGame.GetGuiManager().DisplayLockedSavePopup();
			SetIgnoreInput(false);
			return false;
		}
	
		if (saveArrayIndex >= 0)
		{
			if (saveConfPopup)
			{
				delete saveConfPopup;
			}
			
			theGame.GetRecentListSG( saves );
			currentSave = saves[ saveArrayIndex ];
			
			saveConfPopup = new W3SaveGameConfirmation in this;
			saveConfPopup.SetMessageTitle("");
			saveConfPopup.SetMessageText( GetPlatformLocString( "error_message_overwrite_save" ) );
			saveConfPopup.menuRef = this;
			saveConfPopup.type = currentSave.slotType;
			saveConfPopup.slot = currentSave.slotIndex;
			saveConfPopup.BlurBackground = true;
				
			RequestSubMenu('PopupMenu', saveConfPopup);
		}
		else
		{
			executeSave(type, -1);
			SetIgnoreInput(false);
		}
	}
	
	public function executeSave(type : ESaveGameType, slot : int)
	{
		theGame.SaveGame(type, slot);
		m_fxNavigateBack.InvokeSelf();
	}
	
	event  OnLoadGameCalled(type : ESaveGameType, saveListIndex : int)
	{
		var saveGameRef : SSavegameInfo;
		var saveGames	: array< SSavegameInfo >;
		
		if (ignoreInput)
		{
			return false;
		}
		
		disableAccountPicker = true;
		
		if (loadConfPopup)
		{
			delete loadConfPopup;
		}
		
		theGame.ListSavedGames( saveGames );
		saveGameRef = saveGames[saveListIndex];
		
		if (panelMode || (isMainMenu && !hasValidAutosaveData()))
		{
			LoadSaveRequested(saveGameRef);
		}
		else
		{
			loadConfPopup = new W3ApplyLoadConfirmation in this;
			loadConfPopup.SetMessageTitle( GetPlatformLocString( "panel_mainmenu_popup_load_title" ) );
			
			if (isMainMenu)
			{
				loadConfPopup.SetMessageText( GetPlatformLocString("error_message_load_game_main_menu") );
			}
			else
			{
				loadConfPopup.SetMessageText( GetPlatformLocString( "error_message_load_game" ) );
			}
			
			loadConfPopup.menuRef = this;
			loadConfPopup.saveSlotRef = saveGameRef;
			loadConfPopup.BlurBackground = true;
			
			SetIgnoreInput(true);
					
			RequestSubMenu('PopupMenu', loadConfPopup);
		}
	}
	
	public function LoadSaveRequested(saveSlotRef : SSavegameInfo) : void
	{	
		var fromDeathScreen : bool;
		
		if (theGame.GetGuiManager().GetPopup('MessagePopup') && theGame.GetGuiManager().lastMessageData.messageId == UMID_ControllerDisconnected)
		{
			SetIgnoreInput(false);
			disableAccountPicker = false;
			return;
		}
		
		SetIgnoreInput(true);
		
		if (isMainMenu)
		{
			disableAccountPicker = true;
		}

		
		fromDeathScreen = (CR4DeathScreenMenu)m_parentMenu;
		theGame.LoadGameInit( saveSlotRef , fromDeathScreen );
	}
	
	event  OnImportGameCalled(menuTag:int):void
	{
		var savesToImport : array< SSavegameInfo >;
		var difficulty:int;
		var tutorialsEnabled:bool;
		var simulateImport:bool;
		var maskResult:int;
		var progress : float;
		
		if (!theGame.IsContentAvailable('launch0'))
		{
			progress = theGame.ProgressToContentAvailable('launch0');
			theSound.SoundEvent("gui_global_denied");
			theGame.GetGuiManager().ShowProgressDialog(0, "", "error_message_new_game_not_ready", true, UDB_Ok, progress, UMPT_Content, 'launch0');
			
		}
		else
		{
			theGame.ListW2SavedGames( savesToImport );
			
			if ( menuTag < savesToImport.Size() )
			{
				disableAccountPicker = true;
				
				theGame.ClearInitialFacts();
				
				if (theGame.ImportSave( savesToImport[ menuTag ] ))
				{
					currentNewGameConfig.import_save_index = menuTag;
					
					if ((lastSetTag & IGMC_New_game_plus) == IGMC_New_game_plus)
					{
						m_fxForceEnterCurEntry.InvokeSelf();
					}
					else
					{
						
						theGame.SetDifficultyLevel(currentNewGameConfig.difficulty);
						TutorialMessagesEnable(currentNewGameConfig.tutorialsOn);
						
						if ( theGame.RequestNewGame( theGame.GetNewGameDefinitionFilename() ) )
						{
							OnPlaySoundEvent("gui_global_game_start");
							OnPlaySoundEvent("mus_intro_usm");
							GetRootMenu().CloseMenu();
						}
					}
				}
				else
				{
					showNotification(GetLocStringByKeyExt("import_witcher_two_failed"));
					OnPlaySoundEvent("gui_global_denied");
				}
			}
		}
	}
	
	event  OnNewGamePlusCalled(saveListIndex:int):void
	{
		var startGameStatus : ENewGamePlusStatus;
		var saveGameRef 	: SSavegameInfo;
		var saveGames		: array< SSavegameInfo >;
		var errorMessage 	: string;
		var progress : float;
		
		var requiredContent : name = 'content12';
		
		ignoreInput = true; 
		
		if (!theGame.IsContentAvailable(requiredContent))
		{
			progress = theGame.ProgressToContentAvailable(requiredContent);
			theSound.SoundEvent("gui_global_denied");
			SetIgnoreInput(false);
			theGame.GetGuiManager().ShowProgressDialog(0, "", "error_message_new_game_not_ready", true, UDB_Ok, progress, UMPT_Content, requiredContent);
		}
		else
		{
			disableAccountPicker = true;
			
			theGame.ListSavedGames( saveGames );
			saveGameRef = saveGames[saveListIndex];
			
			if (currentNewGameConfig.import_save_index == -1 && currentNewGameConfig.simulate_import)
			{
				theGame.AddInitialFact("simulate_import_ingame");
			}
			
			theGame.SetDifficultyLevel(currentNewGameConfig.difficulty);
			
			TutorialMessagesEnable(currentNewGameConfig.tutorialsOn);
			
			startGameStatus = theGame.StartNewGamePlus(saveGameRef);
			
			if (startGameStatus == NGP_Success)
			{
				theGame.GetGuiManager().RequestMouseCursor(false);
				OnPlaySoundEvent("gui_global_game_start");
				OnPlaySoundEvent("mus_intro_usm");
				GetRootMenu().CloseMenu();
			}
			else
			{
				errorMessage = "";
				SetIgnoreInput(false);
				disableAccountPicker = false;
				
				switch (startGameStatus)
				{
				case NGP_Invalid:
					errorMessage = GetPlatformLocString("newgame_plus_error_invalid");
					break;
				case NGP_CantLoad:
					errorMessage = GetLocStringByKeyExt("newgame_plus_error_cantload");
					break;
				case NGP_TooOld:
					errorMessage = GetLocStringByKeyExt("newgame_plus_error_too_old");
					break;
				case NGP_RequirementsNotMet:
					errorMessage = GetLocStringByKeyExt("newgame_plus_error_requirementnotmet");
					break;
				case NGP_InternalError:
					errorMessage = GetPlatformLocString("newgame_plus_error_internalerror");
					break;
				case NGP_ContentRequired:
					errorMessage = GetLocStringByKeyExt("newgame_plus_error_contentrequired");
					break;
				}
				
				showNotification(errorMessage);
				OnPlaySoundEvent("gui_global_denied");
			}
		}
	}
	
	event  OnDeleteSaveCalled(type : ESaveGameType, saveListIndex : int, isSaveMode:bool)
	{
		if (ignoreInput)
		{
			return false;
		}
		
		SetIgnoreInput(true);
		
		disableAccountPicker = true;
		
		if (deleteConfPopup)
		{
			delete deleteConfPopup;
		}
		
		deleteConfPopup = new W3DeleteSaveConf in this;
		deleteConfPopup.SetMessageTitle("");
		
		if (theGame.GetPlatform() == Platform_PS5)
		{
			deleteConfPopup.SetMessageText( GetPlatformLocString( "error_message_delete_save_ps5" ) );
		}
		else
		{
			deleteConfPopup.SetMessageText( GetPlatformLocString( "panel_mainmenu_confirm_delete_text" ) );
		}
		deleteConfPopup.menuRef = this;
		deleteConfPopup.type = type;
		deleteConfPopup.slot = saveListIndex;
		deleteConfPopup.saveMode = isSaveMode;
		deleteConfPopup.BlurBackground = true;
			
		RequestSubMenu('PopupMenu', deleteConfPopup);
	}
	
	event  OnSyncSaveCalled(type : ESaveGameType, saveListIndex : int, isSaveMode:bool)
	{
		
		var manager : CR4GuiManager;
		manager = (CR4GuiManager)theGame.GetGuiManager();
		if (manager) {
			manager.SyncGalaxySlot(saveListIndex);
		}
	}
	
	event  OnLoginCloudCalled()
	{
		var manager : CR4GuiManager;
		
		
		if (!theGame.IsGalaxyUserSignedIn()) {
			manager = (CR4GuiManager)theGame.GetGuiManager();
			if (manager) {
				manager.GalaxyQRSignInInitiate();
			}
		}
	}
	
	event  OnShowCloudModalCalled()
	{
		var manager : CR4GuiManager;

		if (!theGame.HasInternetConnection()) {
			ShowErrorWindow( GOGNoInternetConnection );
		} else if (theGame.IsGalaxyUserSignedIn()) {
			
			manager = (CR4GuiManager)theGame.GetGuiManager();
			if (manager) {
				manager.ShowCloudModal();
				
			}
		}
	}
	
	public function DeleteSave(type : ESaveGameType, saveListIndex : int, isSaveMode:bool)
	{
		var saves : array< SSavegameInfo >;
		var currentSave : SSavegameInfo;
		var numSavesBeforeDelete : int;
		
		theGame.GetRecentListSG( saves );
		
		numSavesBeforeDelete = saves.Size();
		
		if (saveListIndex < saves.Size())
		{
			currentSave = saves[ saveListIndex ];
			theGame.DeleteSavedGame(currentSave);
		}
		
		if (numSavesBeforeDelete <= 1)
		{
			m_fxRemoveOption.InvokeSelfOneArg(FlashArgInt(NameToFlashUInt('Continue')));
			m_fxRemoveOption.InvokeSelfOneArg(FlashArgInt(NameToFlashUInt('LoadGame')));
			
			if (isInLoadselector)
			{
				m_fxNavigateBack.InvokeSelf();
			}
			else
			{
				SendSaveData();
			}
		}
		else
		{
			if (isSaveMode)
			{
				SendSaveData();
			}
			else if (hasSaveDataToLoad())
			{
				SendLoadData();
			}
		}
	}
	
	protected function showOptionsPanel() : void
	{
		var l_DataFlashArray : CScriptedFlashArray;
	
		if (theGame.GetPlatform() == Platform_PC)
		{
			m_fxSetHardwareCursorOn.InvokeSelfOneArg(FlashArgBool(mInGameConfigWrapper.GetVarValue('Rendering', 'HardwareCursor')));
		}
		
		l_DataFlashArray = IngameMenu_FillOptionsSubMenuData(m_flashValueStorage, isMainMenu);
		
		m_initialSelectionsToIgnore = 1;
		OnPlaySoundEvent( "gui_global_panel_open" );
		
		m_flashValueStorage.SetFlashArray( "ingamemenu.options.entries", l_DataFlashArray );
		
		
		curMenuDepth = depthOptions;
		theTelemetry.NoticeMenuDepth(curMenuDepth);
	}
	
	public function ToggleRTEnabled() : void
	{
		theGame.ToggleRTEnabled();
		RTEnabled();
		m_fxUpdateOptionLabel.InvokeSelfTwoArgs(FlashArgUInt(NameToFlashUInt('toggle_render')), FlashArgString(theGame.GetToggleButtonCaption()));
		theGame.SaveUserSettings();
	}
	
	protected function showHelpPanel() : void
	{
		m_fxNavigateBack.InvokeSelf();
		
		theGame.DisplaySystemHelp();
	}
	
	public function TryStartNewGame(optionsArray : int):void
	{
		var progress : float;
		
		if (!theGame.IsContentAvailable('launch0'))
		{
			progress = theGame.ProgressToContentAvailable('launch0');
			theSound.SoundEvent("gui_global_denied");
			theGame.GetGuiManager().ShowProgressDialog(0, "", "error_message_new_game_not_ready", true, UDB_Ok, progress, UMPT_Content, 'launch0');
		}
		else
		{
			fetchNewGameConfigFromTag(optionsArray);
			
			if ((optionsArray & IGMC_EP2_Save) == IGMC_EP2_Save)
			{
				
				theGame.InitStandaloneDLCLoading('bob_000_000', currentNewGameConfig.difficulty);
				theGame.EnableUberMovement( true );
				((CInGameConfigWrapper)theGame.GetInGameConfigWrapper()).SetVarValue( 'Gameplay', 'EnableUberMovement', 1 );
			}
			else if ((optionsArray & IGMC_EP1_Save) == IGMC_EP1_Save)
			{
				
				theGame.InitStandaloneDLCLoading('ep1', currentNewGameConfig.difficulty);
				theGame.EnableUberMovement( true );
				((CInGameConfigWrapper)theGame.GetInGameConfigWrapper()).SetVarValue( 'Gameplay', 'EnableUberMovement', 1 );
			}
			else
			{
				if (hasValidAutosaveData())
				{
					if (newGameConfPopup)
					{
						delete newGameConfPopup;
					}
					
					newGameConfPopup = new W3NewGameConfirmation in this;
					newGameConfPopup.SetMessageTitle("");
					newGameConfPopup.SetMessageText( GetPlatformLocString( "error_message_start_game" ) );
					newGameConfPopup.menuRef = this;
					newGameConfPopup.BlurBackground = true;
						
					RequestSubMenu('PopupMenu', newGameConfPopup);
				}
				else
				{
					NewGameRequested();
				}
			}
		}
	}
	
	protected function fetchNewGameConfigFromTag(optionsTag : int):void
	{
		var maskResult:int;
		
		currentNewGameConfig.difficulty = optionsTag & IGMC_Difficulty_mask;
		
		maskResult = optionsTag & IGMC_Tutorials_On;
		currentNewGameConfig.tutorialsOn = (maskResult == IGMC_Tutorials_On);
		
		maskResult = optionsTag & IGMC_Import_Save;
		if (maskResult != IGMC_Import_Save)
		{
			currentNewGameConfig.import_save_index = -1;
		}
		
		maskResult = optionsTag & IGMC_Simulate_Import;
		currentNewGameConfig.simulate_import = (maskResult == IGMC_Simulate_Import);
	}
	
	public function NewGameRequested():void
	{
		disableAccountPicker = true;
		
		if (currentNewGameConfig.import_save_index == -1)
		{
			theGame.ClearInitialFacts();
		}
		
		if (currentNewGameConfig.import_save_index == -1 && currentNewGameConfig.simulate_import)
		{
			theGame.AddInitialFact("simulate_import_ingame");
		}
		
		theGame.SetDifficultyLevel(currentNewGameConfig.difficulty);
		
		TutorialMessagesEnable(currentNewGameConfig.tutorialsOn);
		
		StartNewGame();
	}
	
	event  OnUpdateRescale(hScale : float, vScale : float)
	{
		var hud : CR4ScriptedHud;
		var needRescale : bool;
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		needRescale = false;
		
		if( theGame.GetUIHorizontalFrameScale() != hScale )
		{
			theGame.SetUIHorizontalFrameScale(hScale);
			mInGameConfigWrapper.SetVarValue('Hidden', 'uiHorizontalFrameScale', FloatToString(hScale));
			needRescale = true;
			hasChangedOption = true;
		}	
		if( theGame.GetUIVerticalFrameScale() != vScale )
		{
			theGame.SetUIVerticalFrameScale(vScale);
			mInGameConfigWrapper.SetVarValue('Hidden', 'uiVerticalFrameScale', FloatToString(vScale));
			needRescale = true;
			hasChangedOption = true;
		}	
		
		if( needRescale && hud ) 
		{
			hud.RescaleModules();
		}
	}
	
	public function ShowTutorialChosen(enabled:bool):void
	{
		TutorialMessagesEnable(enabled);
		
		StartNewGame();
	}
	
	public function StartNewGame():void
	{
		if (theGame.GetGuiManager().GetPopup('MessagePopup') && theGame.GetGuiManager().lastMessageData.messageId == UMID_ControllerDisconnected)
		{
			return;
		}
		
		if ( theGame.RequestNewGame( theGame.GetNewGameDefinitionFilename() ) )
		{
			theGame.GetGuiManager().RequestMouseCursor(false);
			OnPlaySoundEvent("gui_global_game_start");
			OnPlaySoundEvent("mus_intro_usm");
			GetRootMenu().CloseMenu();
		}
	}
	
	function PopulateMenuData()
	{
		var l_DataFlashArray		: CScriptedFlashArray;
		var l_ChildMenuFlashArray	: CScriptedFlashArray;
		var l_DataFlashObject 		: CScriptedFlashObject;
		var l_subDataFlashObject	: CScriptedFlashObject;
		
		l_DataFlashArray = m_structureCreator.PopulateMenuData();
		
		m_flashValueStorage.SetFlashArray( "ingamemenu.entries", l_DataFlashArray );
	}
	
	protected function addInLoadOption():void
	{
		var l_DataFlashObject 		: CScriptedFlashObject;
		var l_ChildMenuFlashArray	: CScriptedFlashArray;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashString( "id", "mainmenu_loadgame");
		l_DataFlashObject.SetMemberFlashUInt(  "tag", NameToFlashUInt('LoadGame') );
		l_DataFlashObject.SetMemberFlashString(  "label", GetLocStringByKeyExt("panel_mainmenu_loadgame") );	
		
		l_DataFlashObject.SetMemberFlashUInt( "type", IGMActionType_Load );	
		
		l_ChildMenuFlashArray = m_flashValueStorage.CreateTempFlashArray();
		l_DataFlashObject.SetMemberFlashArray( "subElements", l_ChildMenuFlashArray );
		
		m_flashValueStorage.SetFlashObject( "ingamemenu.addloading", l_DataFlashObject );
	}
	
	event  OnBack()
	{
		CloseMenu();
	}
	
	public function HasSavesToImport() : bool
	{
		var savesToImport : array< SSavegameInfo >;
		
		theGame.ListW2SavedGames( savesToImport );
		return savesToImport.Size() != 0;
	}

	protected function SendImportSaveData()
	{
		var dataFlashArray 	: CScriptedFlashArray;
		
		dataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		IngameMenu_PopulateImportSaveData(m_flashValueStorage, dataFlashArray);
		
		m_initialSelectionsToIgnore = 1;
		OnPlaySoundEvent( "gui_global_panel_open" );
		
		isShowingSaveList = true;
		m_flashValueStorage.SetFlashArray( "ingamemenu.importSlots", dataFlashArray );
	}
	
	protected function hasValidAutosaveData() : bool
	{
		var currentSave	: SSavegameInfo;
		var num : int;
		var i : int;
		
		num = theGame.GetNumSaveSlots( SGT_AutoSave );
		for ( i = 0; i < num; i = i + 1 )
		{
			if ( theGame.GetSaveInSlot( SGT_AutoSave, i, currentSave ) )
			{
				return true;
			}
		}
		
		num = theGame.GetNumSaveSlots( SGT_CheckPoint );
		for ( i = 0; i < num; i = i + 1 )
		{
			if ( theGame.GetSaveInSlot( SGT_CheckPoint, i, currentSave ) )
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function HandleSaveListUpdate():void
	{
		if (isShowingSaveList)
		{
			SendSaveData();
		}
		else if (isShowingLoadList)
		{
			SendLoadData();
		}
		
		if (hasSaveDataToLoad())
		{
			addInLoadOption();
		}
	}
	
	public function QRCodeReady(UrlAdres : String):void
	{
		m_fxQRCodeReadyToLoad.InvokeSelfOneArg(FlashArgString(UrlAdres));	
	}

	public function CloudPersonaReady(namePersona : String):void
	{
		m_fxShowCloudModal.InvokeSelfOneArg(FlashArgString(namePersona));	
	}
	
	public function CloseGalaxySignInModalWindow():void
	{
		m_fxCloseGalaxySignInModalWindow.InvokeSelf();
		
		showNotification( GetLocStringByKeyExt("ui_cloud_gog_sign_in_success"),, true );
	}
	
	event OnVisitSignInPage()
	{
		var manager : CR4GuiManager;
		manager = (CR4GuiManager)theGame.GetGuiManager();
		if ( manager )
		{
			manager.VisitSignInPage();
		}

	}
	
	event OnGalaxyQRSignInCancel()
	{
		var manager : CR4GuiManager;
		manager = (CR4GuiManager)theGame.GetGuiManager();
		if ( manager )
		{
			manager.GalaxyQRSignInCancel();
		}
	}
	
	event OnGalaxyUnlinkAccounts()
	{
		var manager : CR4GuiManager;
		manager = (CR4GuiManager)theGame.GetGuiManager();
		if ( manager )
		{
			manager.GalaxyUnlinkAccounts();
		}
	}

	public function CheckSaveAvailability(): void
	{
		if(!hasSaveDataToLoad())
		{
			m_fxRemoveOption.InvokeSelfOneArg(FlashArgInt(NameToFlashUInt('LoadGame')));
			m_fxRemoveOption.InvokeSelfOneArg(FlashArgInt(NameToFlashUInt('Continue')));
		}
		else
		{
			PopulateMenuData();
		}
	}
	
	protected function SendLoadData():void
	{
		var l_DataFlashObject : CScriptedFlashObject;
		var dataFlashArray 	: CScriptedFlashArray;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashBool( "isUserSignedIn", theGame.IsGalaxyUserSignedIn() && theGame.GetInGameConfigWrapper().GetVarValue( 'Gameplay', 'CrossProgression' ) == "true" );
		m_flashValueStorage.SetFlashObject( "ingamemenu.gogCloudState", l_DataFlashObject );
		
		dataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		PopulateSaveDataForSlotType(-1, dataFlashArray, false);
		
		m_initialSelectionsToIgnore = 1;
		OnPlaySoundEvent( "gui_global_panel_open" );
		
		if (dataFlashArray.GetLength() == 0)
		{
			m_fxNavigateBack.InvokeSelf();
		}
		else
		{
			isShowingLoadList = true;
			m_flashValueStorage.SetFlashArray( "ingamemenu.loadSlots", dataFlashArray );
		}
	}
	
	
	protected function SendSaveData():void
	{
		var l_DataFlashObject : CScriptedFlashObject;
		var dataFlashArray 	: CScriptedFlashArray;
		
		l_DataFlashObject = m_flashValueStorage.CreateTempFlashObject();
		l_DataFlashObject.SetMemberFlashBool( "isUserSignedIn", theGame.IsGalaxyUserSignedIn() && theGame.GetInGameConfigWrapper().GetVarValue( 'Gameplay', 'CrossProgression' ) == "true" );
		m_flashValueStorage.SetFlashObject( "ingamemenu.gogCloudState", l_DataFlashObject );
		
		dataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		
		
		PopulateSaveDataForSlotType(SGT_Manual, dataFlashArray, true);
		
		m_initialSelectionsToIgnore = 1;
		OnPlaySoundEvent( "gui_global_panel_open" );
		
		isShowingSaveList = true;
		m_flashValueStorage.SetFlashArray( "ingamemenu.saveSlots", dataFlashArray );
		
		if ( theGame.ShouldShowSaveCompatibilityWarning() )
		{
			theGame.GetGuiManager().ShowUserDialog( UMID_SaveCompatWarning, "", "error_save_not_compatible", UDB_Ok );
		}
	}
	
	protected function SendNewGamePlusSaves():void
	{
		var dataFlashArray 	: CScriptedFlashArray;
		
		dataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		PopulateSaveDataForSlotType(-1, dataFlashArray, false);
		
		theGame.GetGuiManager().ShowUserDialog(0, "", "message_new_game_plus_reminder", UDB_Ok);
		
		if (dataFlashArray.GetLength() == 0)
		{
			OnPlaySoundEvent("gui_global_denied");
			showNotification(GetLocStringByKeyExt("mainmenu_newgame_plus_no_saves"));
			m_fxNavigateBack.InvokeSelf();
		}
		else
		{
			m_initialSelectionsToIgnore = 1;
			OnPlaySoundEvent( "gui_global_panel_open" );
			m_flashValueStorage.SetFlashArray( "ingamemenu.newGamePlusSlots", dataFlashArray );
		}
	}
	
	protected function PopulateSaveDataForSlotType(saveType:int, parentObject:CScriptedFlashArray, allowEmptySlot:bool):void
	{
		IngameMenu_PopulateSaveDataForSlotType(m_flashValueStorage, saveType, parentObject, allowEmptySlot);
	}
	
	event  OnLoadSaveImageCancelled():void
	{
		theGame.FreeScreenshotData();
	}
	
	event  OnScreenshotDataRequested(saveIndex:int):void
	{
		var targetSaveInfo 	: SSavegameInfo;
		var saveGames		: array< SSavegameInfo >;
		
		theGame.GetRecentListSG( saveGames );
		UpdateSaveSlot();
		
		if (saveIndex >= 0 && saveIndex < saveGames.Size())
		{
			targetSaveInfo = saveGames[saveIndex];
			
			theGame.RequestScreenshotData(targetSaveInfo);
		}
	}
	
	event  OnCheckScreenshotDataReady():void
	{
		if (theGame.IsScreenshotDataReady())
		{
			m_fxOnSaveScreenshotRdy.InvokeSelf();
		}
	}
	
	protected function SendInstalledDLCList():void
	{
		var currentData : CScriptedFlashObject;
		var dataArray : CScriptedFlashArray;
		var dlcManager : CDLCManager;
		var i : int;
		var dlcList : array<name>;
		
		var currentName : string;
		var currentDesc : string;
		
		
		
		dataArray = m_flashValueStorage.CreateTempFlashArray();
		
		dlcManager = theGame.GetDLCManager();
		dlcManager.GetDLCs(dlcList);
		
		for (i = 0; i < dlcList.Size(); i += 1)
		{
			
			
				currentData = m_flashValueStorage.CreateTempFlashObject();
				
				currentName = GetLocStringByKeyExt( "content_name_" + NameToString(dlcList[i]) );
				currentDesc = "";
				
				if (currentName != "")
				{
					currentData.SetMemberFlashString("label", currentName);
					currentData.SetMemberFlashString("desc", currentDesc);
					
					dataArray.PushBackFlashObject(currentData);
				}
			
		}
		
		
		
		m_flashValueStorage.SetFlashArray("ingamemenu.installedDLCs", dataArray);
	}
	
	protected function SendRescaleData():void
	{
		var currentData : CScriptedFlashObject;
		
		currentData = m_flashValueStorage.CreateTempFlashObject();
		
		currentData.SetMemberFlashNumber("initialHScale", theGame.GetUIHorizontalFrameScale() );
		currentData.SetMemberFlashNumber("initialVScale", theGame.GetUIVerticalFrameScale() );
		
		m_flashValueStorage.SetFlashObject("ingamemenu.uirescale", currentData);
	}
	
	protected function SendControllerData():void
	{
		var dataFlashArray : CScriptedFlashArray;
		
		if ( (W3ReplacerCiri)thePlayer )
		{
			dataFlashArray = InGameMenu_CreateControllerDataCiri(m_flashValueStorage);
		}
		else
		{
			dataFlashArray = InGameMenu_CreateControllerData(m_flashValueStorage);
		}
		
		m_flashValueStorage.SetFlashArray( "ingamemenu.gamepad.mappings", dataFlashArray );
	}
	
	protected function SendKeybindData():void
	{
		var dataFlashArray : CScriptedFlashArray;
		
		dataFlashArray = m_flashValueStorage.CreateTempFlashArray();
		
		IngameMenu_GatherKeybindData(dataFlashArray, m_flashValueStorage);
		
		m_flashValueStorage.SetFlashArray( "ingamemenu.keybindValues", dataFlashArray );
	}
	
	event  OnClearKeybind(keybindTag:name):void
	{
		hasChangedOption = true;
		mInGameConfigWrapper.SetVarValue('PCInput', keybindTag, "IK_None;IK_None"); 
		SendKeybindData();
	}
	
	
	
	protected function GetKeybindGroupTag(keybindName : name) : name
	{
		if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap1'))
		{
			return 'input_overlap1';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap2'))
		{
			return 'input_overlap2';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap3'))
		{
			return 'input_overlap3';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap4'))
		{
			return 'input_overlap4';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap5'))
		{
			return 'input_overlap5';
		}
		
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap_potion1'))
		{
			return 'input_overlap_potion1';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap_potion2'))
		{
			return 'input_overlap_potion2';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap_potion3'))
		{
			return 'input_overlap_potion3';
		}
		else if (mInGameConfigWrapper.DoVarHasTag('PCInput', keybindName, 'input_overlap_potion4'))
		{
			return 'input_overlap_potion4';
		}
		
		
		return '';
	}
	
	event  OnChangeKeybind(keybindTag:name, newKeybindValue:EInputKey):void
	{
		var newSettingString : string;
		var exisitingKeybind : name;
		var groupIndex : int;
		var keybindChangedMessage : string;
		var numKeybinds : int;
		var i : int;
		var currentBindingTag : name;
		
		var iterator_KeybindName : name;
		var iterator_KeybindKey : string;
		
		hasChangedOption = true;
		
		newSettingString = newKeybindValue;
		
		
		
		{
			groupIndex = IngameMenu_GetPCInputGroupIndex();
		
			if (groupIndex != -1)
			{
				numKeybinds = mInGameConfigWrapper.GetVarsNumByGroupName('PCInput');
				currentBindingTag = GetKeybindGroupTag(keybindTag);
				
				for (i = 0; i < numKeybinds; i += 1)
				{
					iterator_KeybindName = mInGameConfigWrapper.GetVarName(groupIndex, i);
					iterator_KeybindKey = mInGameConfigWrapper.GetVarValue('PCInput', iterator_KeybindName);
					
					iterator_KeybindKey = StrReplace(iterator_KeybindKey, ";IK_None", ""); 
					iterator_KeybindKey = StrReplace(iterator_KeybindKey, "IK_None;", "");
					
					if (iterator_KeybindKey == newSettingString && iterator_KeybindName != keybindTag && 
						(currentBindingTag == '' || currentBindingTag != GetKeybindGroupTag(iterator_KeybindName)))
					{
						if (keybindChangedMessage != "")
						{
							keybindChangedMessage += ", ";
						}
						keybindChangedMessage += IngameMenu_GetLocalizedKeybindName(iterator_KeybindName);
						OnClearKeybind(iterator_KeybindName);
					}
				}
			}
			
			if (keybindChangedMessage != "")
			{
				keybindChangedMessage += " </br>" + GetLocStringByKeyExt("key_unbound_message");
				showNotification(keybindChangedMessage);
			}
		}
		
		newSettingString = newKeybindValue + ";IK_None"; 
		mInGameConfigWrapper.SetVarValue('PCInput', keybindTag, newSettingString);
		SendKeybindData();
		
		
		if(keybindTag == 'DrinkPotion1')
			OnChangeKeybind('DrinkPotion1Hold', newKeybindValue);
		else if(keybindTag == 'DrinkPotion2')
			OnChangeKeybind('DrinkPotion2Hold', newKeybindValue);
		else if(keybindTag == 'DrinkPotion3')
			OnChangeKeybind('DrinkPotion3Hold', newKeybindValue);
		else if(keybindTag == 'DrinkPotion4')
			OnChangeKeybind('DrinkPotion4Hold', newKeybindValue);
		
	}
	
	event  OnSmartKeybindEnabledChanged(value:bool):void
	{
		smartKeybindingEnabled = value;
	}
	
	event  OnInvalidKeybindTried(keyCode:EInputKey):void
	{
		showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_now"));
		OnPlaySoundEvent("gui_global_denied");
	}
	
	event  OnLockedKeybindTried():void
	{
		showNotification(GetLocStringByKeyExt("menu_cannot_perform_action_now"));
		OnPlaySoundEvent("gui_global_denied");
	}
	
	event  OnResetKeybinds():void
	{
		mInGameConfigWrapper.ResetGroupToDefaults('PCInput');
		SendKeybindData();
		showNotification(inGameMenu_TryLocalize("menu_option_reset_successful"));
		
		hasChangedOption = true;
	}
	
	event OnDownloadContentRequested( groupId:int, optionName:name, optionValue:string )
	{
		var groupName : name;
		var locale : string;
	
		groupName = mInGameConfigWrapper.GetGroupName(groupId);
	
		if (groupName == 'Localization' && optionName == 'Virtual_Localization_speech')
		{
			locale = mInGameConfigWrapper.GetVarOption( groupName, optionName, StringToInt( optionValue ) );
			theGame.RequestVoiceLangDownload( locale );
		}
	}
	
	function PlayOpenSoundEvent()
	{
	}
	
	private var isDeveloperModeEnabled : bool; default isDeveloperModeEnabled = false;
	private var developerOptions : CScriptedFlashArray;
	
	public function GetDeveloperOptionsContainer() : CScriptedFlashArray
	{
		return developerOptions;
	}
	
	private function ShowDeveloperMode( show : bool )
	{
		var optionObject		: CScriptedFlashObject;
		var optionFlashArray 	: CScriptedFlashArray;
		var entriesArray		: CScriptedFlashArray;
		var entriesObject		: CScriptedFlashObject;
		var i					: int;
		
		if( show )
		{
			optionObject = m_flashValueStorage.CreateTempFlashObject();
			optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt( 'DeveloperMode' ) );
			optionObject.SetMemberFlashInt( "groupID", theGame.GetInGameConfigWrapper().GetGroupIdx( 'Rendering' ) );
			optionObject.SetMemberFlashUInt( "type", IGMActionType_ToggleStepper );
			optionObject.SetMemberFlashString( "label", inGameMenu_TryLocalize( "DeveloperMode" ) );
			optionObject.SetMemberFlashString( "current", theGame.GetInGameConfigWrapper().GetVarValue( 'Rendering', 'DeveloperMode' ) );
			optionObject.SetMemberFlashString( "startingValue", "false" );
			optionObject.SetMemberFlashBool( "checkHardwareCursor", false );
			optionObject.SetMemberFlashBool( "streamable", false );	
			optionObject.SetMemberFlashBool( "isDropdownContent", false );
			optionObject.SetMemberFlashBool( "isDeveloper", true );
		
			entriesArray = m_flashValueStorage.CreateTempFlashArray();
			entriesArray.PushBackFlashObject( optionObject );
		
			entriesObject = m_flashValueStorage.CreateTempFlashObject();
			entriesObject.SetMemberFlashArray( "list", entriesArray );
			entriesObject.SetMemberFlashUInt( "masterTag", 0 );
			m_flashValueStorage.SetFlashObject( "options.insert_entry", entriesObject );
		}
		else
		{
			optionObject = m_flashValueStorage.CreateTempFlashObject();
			optionObject.SetMemberFlashUInt( "tag", NameToFlashUInt( 'DeveloperMode' ) );
		
			entriesArray = m_flashValueStorage.CreateTempFlashArray();
			entriesArray.PushBackFlashObject( optionObject );
		
			entriesObject = m_flashValueStorage.CreateTempFlashObject();
			entriesObject.SetMemberFlashArray( "list", entriesArray );
			m_flashValueStorage.SetFlashObject( "options.remove_entry", entriesObject );
		}
		
		theGame.GetGuiManager().ForceProcessFlashStorage();
		ShowDeveloperOptions( theGame.GetInGameConfigWrapper().GetVarValue( 'Rendering', 'DeveloperMode' ) == "true" );
	}
	
	public function ShowDeveloperOptions( show : bool )
	{
		var optionObject		: CScriptedFlashObject;
		var optionFlashArray 	: CScriptedFlashArray;
		var entriesArray		: CScriptedFlashArray;
		var entriesObject		: CScriptedFlashObject;
		var i					: int;
		var masterTag			: int;
	
		if( show && isDeveloperModeEnabled )
		{
			for( i = 0; i < developerOptions.GetLength(); i = i + 1 )
			{
				entriesArray = m_flashValueStorage.CreateTempFlashArray();
				entriesArray.PushBackFlashObject( developerOptions.GetElementFlashObject( i ) );
				
				entriesObject = m_flashValueStorage.CreateTempFlashObject();
				entriesObject.SetMemberFlashArray( "list", entriesArray );
				masterTag = developerOptions.GetElementFlashObject( i ).GetMemberFlashUInt( "masterTag");
				entriesObject.SetMemberFlashUInt( "masterTag", masterTag );
				
				m_flashValueStorage.SetFlashObject( "options.insert_entry", entriesObject );
				theGame.GetGuiManager().ForceProcessFlashStorage();
			}
		}
		else
		{
			for( i = 0; i < developerOptions.GetLength(); i = i + 1 )
			{
				entriesArray = m_flashValueStorage.CreateTempFlashArray();
				entriesArray.PushBackFlashObject( developerOptions.GetElementFlashObject( i ) );
				
				entriesObject = m_flashValueStorage.CreateTempFlashObject();
				entriesObject.SetMemberFlashArray( "list", entriesArray );
				
				m_flashValueStorage.SetFlashObject( "options.remove_entry", entriesObject );
				theGame.GetGuiManager().ForceProcessFlashStorage();
			}
		}
	}
	
	event OnShowDeveloperMode( action : SInputAction )
	{
		if( !IsPressed(action) || !theInput.IsActionPressed( 'ShowDeveloperModeAlt' ) )
			return false;
			
		isDeveloperModeEnabled = !isDeveloperModeEnabled;
		ShowDeveloperMode( isDeveloperModeEnabled );
	}
}

exec function ddd()
{
	LogChannel('asd', "[" + GetLocStringByKey( "menu_goty_starting_message_content" ) + "]" );
	LogChannel('asd', "[" + GetLocStringById( 1217650 ) + "]" );
}