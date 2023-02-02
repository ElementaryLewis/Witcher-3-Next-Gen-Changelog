/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
import class CR4Hud extends CHud
{
	
	import final function ShowOneliner( text : string, entity : CEntity );
	import final function HideOneliner( entity : CEntity );
}

enum EHudVisibilitySource
{
	HVS_System,
	HVS_User,
	HVS_Scene,
	HVS_RadialMenu,
};
	
class CR4ScriptedHud extends CR4Hud
{
	private var m_hudSize					: int;		default m_hudSize = 0;
	private var m_minimapRotationEnabled	: bool;		default m_minimapRotationEnabled 	= true;
	private var m_minimapZoom				: float;	default m_minimapZoom 				= 1;
	private var m_enabledEnemyFocus			: bool;		default m_enabledEnemyFocus			= true;
	private var m_enabledNPCNames			: bool;		default m_enabledNPCNames			= true;
	private var m_enemyHitEffects			: bool;		default m_enemyHitEffects			= true;
	
	private var m_dlcMessagePending			: bool; 	default m_dlcMessagePending = false;
	
	private var m_HudFlashSFS				: CScriptedFlashSprite;
	private var m_fxShowModulesSFF			: CScriptedFlashFunction;
	private var m_fxPrintInfoSFF			: CScriptedFlashFunction;
	private var m_fxSetInputContextSFF		: CScriptedFlashFunction;
	private var m_fxSetIsDynamicSFF			: CScriptedFlashFunction;
	private var m_fxSetControllerType 	 	: CScriptedFlashFunction;
	private var m_fxSwapAcceptCancel	    : CScriptedFlashFunction;
	protected var m_fxSetGamepadType       	: CScriptedFlashFunction;
	protected var m_fxLockControlScheme     : CScriptedFlashFunction;
	private var m_fxSetGameLanguage			: CScriptedFlashFunction;
	private var m_fxOnCutscene				: CScriptedFlashFunction;
	
	private var hudModules					: array<CR4HudModuleBase>;
	public	var hudModulesNames				: array<name>;
	public	var currentInputContext			: name;
	public	var previousInputContext		: name;
	private	var m_isDynamic					: bool;		default m_isDynamic						= true;
	private	var m_guiManager 	  			: CR4GuiManager;
	
	private var m_deathTimerActive			: bool;		default m_deathTimerActive = false;
	private var m_deathTimer				: float;
	
	private var m_scaleformWidth				: int;	default m_scaleformWidth   = 1920;
	private var m_scaleformHeight				: int;	default m_scaleformHeight  = 1080;
	private var m_scaleformOffsetX				: int;	default m_scaleformOffsetX = 0;
	private var m_scaleformOffsetY				: int;	default m_scaleformOffsetY = 0;
	
	private var m_visibleHudBySystem : bool;	default m_visibleHudBySystem = true;
	private var m_visibleHudByUser   : bool;	default m_visibleHudByUser = true;
	private var m_visibleHudByScene  : bool;	default m_visibleHudByScene = false;
	private var m_visibleHudByRadial : bool;	default m_visibleHudByRadial = false;
	private var languageName 					: string;

	private var m_lastUsedDeviceName : EInputDeviceType;

	event OnTick( timeDelta : float )
	{
		var curUsedDeviceName : EInputDeviceType;
		var overlayPopupRef	  : CR4OverlayPopup;
		var guiManager        : CR4GuiManager;
		




		ClearCachedPositionForEntity();




		UpdateLootPopupContext();
		
		if( currentInputContext != theInput.GetContext() )
		{
			previousInputContext = currentInputContext;
			currentInputContext = theInput.GetContext();
			
			if( IsRadialMenuOpened() && currentInputContext != 'RadialMenu' && !IsRadialMenuOverwritenByContext(currentInputContext) )
			{
				theInput.RestoreContext( 'RadialMenu', true );
				theInput.StoreContext( 'RadialMenu' );
				currentInputContext = 'RadialMenu';
				LogChannel('HUD_TICK',"INPUT CONTEXT CHANGED !!! if( IsRadialMenuOpened() !!! "+currentInputContext+" previousInputContext "+previousInputContext);
			}
			else
			{
				m_fxSetInputContextSFF.InvokeSelfOneArg(FlashArgString(currentInputContext));
			}
			
			
			
			
			
			
			{
				GetHudEventController().RunEvent_ControlsFeedbackModule_Update( currentInputContext );
			}

			OnInputContextChanged();
			
			
			LogChannel('HUD_TICK',"INPUT CONTEXT CHANGED "+currentInputContext+" previousInputContext "+previousInputContext);
			LogChannel('HUD_TICK',"");
		}
		
		UpdateDLCPendingMessage();
		
		UpdateDeathTimer(timeDelta);
		
		GetHudEventController().RunDelayedEvents();
		
		curUsedDeviceName = theInput.GetLastUsedGamepadType();
		if( curUsedDeviceName != m_lastUsedDeviceName )
		{
			m_lastUsedDeviceName = curUsedDeviceName;
			UpdateInputDeviceType();
			guiManager = theGame.GetGuiManager();
			overlayPopupRef = (CR4OverlayPopup) guiManager.GetPopup( 'OverlayPopup' );
			
			if( overlayPopupRef )
			{
				overlayPopupRef.UpdateGamepadType();
			}
			
			UpdateInputDevice();
		}
	}
	
	
	public function setGameLanguage() : void
	{
		var tempLanguageName 	: string;
		var audioLanguageName 	: string;
		theGame.GetGameLanguageName(audioLanguageName,tempLanguageName);
			if( tempLanguageName != languageName )
			{
				languageName = tempLanguageName;
				m_fxSetGameLanguage.InvokeSelfOneArg( FlashArgString(languageName) );
			}
	}
	
	protected function CheckDLCMessagePending():void
	{
		var dlcManager : CDLCManager;
		var hasSeen : bool;
		var dlcNames : array<name>;
		var i : int;
		
		hasSeen = theGame.GetInGameConfigWrapper().GetVarValue('Hidden', 'HasSeenDLCMessage');
		
		if (!hasSeen)
		{
			dlcManager = theGame.GetDLCManager();
			dlcManager.GetDLCs(dlcNames);
			
			for (i = 0; i < dlcNames.Size(); i += 1)
			{
				if (dlcManager.IsDLCAvailable(dlcNames[i]))
				{
					m_dlcMessagePending = true;
					break;
				}
			}
		}
	}
	
	protected function UpdateDLCPendingMessage():void
	{
		if (m_dlcMessagePending && !theGame.IsDialogOrCutscenePlaying() && !theGame.IsBlackscreenOrFading())
		{
			m_dlcMessagePending = false;
			theGame.GetInGameConfigWrapper().SetVarValue('Hidden', 'HasSeenDLCMessage', "true");
			theGame.SaveUserSettings();
			theGame.GetGuiManager().ShowUserDialog(0, "", "dlc_pop_up", UDB_Ok);
		}
	}
	
	protected function UpdateLootPopupContext():void
	{
		var lootPopup : CR4LootPopup;
		
		lootPopup = (CR4LootPopup)theGame.GetGuiManager().GetPopup('LootPopup');
			
		if (lootPopup)
		{
			lootPopup.UpdateInputContext();
		}
	}
	
	public function StartDeathTimer(duration : float)
	{
		m_deathTimer = duration;
		m_deathTimerActive = true;
	}
	
	private function UpdateDeathTimer(timeDelta : float)
	{
		var currentMenu : CR4Menu;
		
		
		
		
		if ( m_deathTimerActive )
		{
			m_deathTimer -= timeDelta;
			
			if (m_deathTimer <= 0.0)
			{
				m_deathTimerActive = false;
				
				currentMenu = theGame.GetGuiManager().GetRootMenu();
				
				
				if (currentMenu)
				{
					currentMenu.CloseMenu();
				}
				
				theGame.RequestMenu( 'DeathScreenMenu' );
				
				theInput.StoreContext('Death');
			}
		}
	}
	
	private function GetHudEventController() : CR4HudEventController
	{
		return theGame.GetGuiManager().GetHudEventController();
	}
	
	private function OnInputContextChanged()
	{
		var module : CR4HudModuleInteractions;
		
		module = (CR4HudModuleInteractions)GetHudModule( "InteractionsModule" );
		if ( module )
		{
			module.OnInputContextChanged();
		}
	}
	
	public function RefreshHudConfiguration() : void
	{
		UpdateScaleformStageSize();
		UpdateHudScale();
		UpdateHudConfigs();
	}

	public function UpdateScaleformStageSize()
	{
		var currentWidth, currentHeight : int;
		var ratio : float;
		
		theGame.GetCurrentViewportResolution( currentWidth, currentHeight );
		ratio = ( (float)currentWidth ) / currentHeight;
		
		
		if ( AbsF( ratio - 4.0 / 3.0 ) < 0.01 )
		{
			m_scaleformWidth   = 1920;
			m_scaleformHeight  = 1440;
			m_scaleformOffsetX = 0;
			m_scaleformOffsetY = -180;
		}
		else if ( AbsF( ratio - 21.0 / 9.0 ) < 0.01 )
		{
			m_scaleformWidth   = 2520;
			m_scaleformHeight  = 1080;
			m_scaleformOffsetX = -300;
			m_scaleformOffsetY = 0;
		}
		else if ( AbsF( ratio - 43.0 / 18.0 ) < 0.01 )
		{
			m_scaleformWidth   = 2580;
			m_scaleformHeight  = 1080;
			m_scaleformOffsetX = -330;
			m_scaleformOffsetY = 0;
		}
		else
		{
			m_scaleformWidth   = 1920;
			m_scaleformHeight  = 1080;
			m_scaleformOffsetX = 0;
			m_scaleformOffsetY = 0;
		}
	}

	public function GetScaleformPoint( x : float, y : float ) : Vector
	{
		var normalizedPoint : Vector;
		normalizedPoint.X = x * m_scaleformWidth  + m_scaleformOffsetX;
		normalizedPoint.Y = y * m_scaleformHeight + m_scaleformOffsetY;
		return normalizedPoint;
	}

	public function UpdateHudScale()
	{
		var l_hudModuleAnchors	: CR4HudModuleAnchors; 
		
		l_hudModuleAnchors	= (CR4HudModuleAnchors) GetHudModule( "AnchorsModule" );
		if (l_hudModuleAnchors)
		{
			l_hudModuleAnchors.UpdateAnchorsAspectRatio();
		}
		
		if( ( m_hudSize == 1 ) )
		{
			theGame.SetUIGamepadScaleGain(0.25);
		}
		else
		{
			theGame.SetUIGamepadScaleGain(0.0);
		}
		theGame.SetUIOpacity(1);

		RescaleModules();
	}
	
	
	

	event  OnConfigUI()
	{
		var i : int;
		m_HudFlashSFS = GetHudFlash();
		m_guiManager = theGame.GetGuiManager();
		
		UpdateScaleformStageSize();
		UpdateHudScale();
		m_fxShowModulesSFF 		= m_HudFlashSFS.GetMemberFlashFunction( "ShowModules");
		m_fxPrintInfoSFF   		= m_HudFlashSFS.GetMemberFlashFunction( "PrintInfo");
		m_fxSetInputContextSFF	= m_HudFlashSFS.GetMemberFlashFunction( "SetInputContext");
		m_fxSetIsDynamicSFF		= m_HudFlashSFS.GetMemberFlashFunction( "SetDynamic");
		m_fxSetControllerType   = m_HudFlashSFS.GetMemberFlashFunction( "setControllerType" );
		m_fxSwapAcceptCancel    = m_HudFlashSFS.GetMemberFlashFunction( "swapAcceptCancel" );
		
		m_fxSetGamepadType		= m_HudFlashSFS.GetMemberFlashFunction( "setGamepadType" );
		m_fxLockControlScheme	= m_HudFlashSFS.GetMemberFlashFunction( "lockControlScheme" );
		m_fxSetGameLanguage 	= m_HudFlashSFS.GetMemberFlashFunction( "setGameLanguage" );
		m_fxOnCutscene			= m_HudFlashSFS.GetMemberFlashFunction( "onCutsceneStartedOrEnded" );
		
		CreateHudModule("AnchorsModule");			
		hudModulesNames.PushBack('ControlsFeedbackModule');
		hudModulesNames.PushBack('HorseStaminaBarModule');		
		hudModulesNames.PushBack('HorsePanicBarModule');			
		hudModulesNames.PushBack('InteractionsModule');			
		hudModulesNames.PushBack('MessageModule');				
		hudModulesNames.PushBack('RadialMenuModule');			
		hudModulesNames.PushBack('QuestsModule');				
		
		hudModulesNames.PushBack('SubtitlesModule');				
		
		
		hudModulesNames.PushBack('BuffsModule');					
		hudModulesNames.PushBack('WolfHeadModule');				
		hudModulesNames.PushBack('ItemInfoModule');				
		hudModulesNames.PushBack('OxygenBarModule');				
		hudModulesNames.PushBack('EnemyFocusModule');
		hudModulesNames.PushBack('BossFocusModule');
		hudModulesNames.PushBack('DialogModule');
		
		hudModulesNames.PushBack('BoatHealthModule');
		
		hudModulesNames.PushBack('ConsoleModule');				
		hudModulesNames.PushBack('JournalUpdateModule');				
		hudModulesNames.PushBack('AreaInfoModule');				
		hudModulesNames.PushBack('CrosshairModule');				
		hudModulesNames.PushBack('OnelinersModule');				
		hudModulesNames.PushBack('Minimap2Module');
		hudModulesNames.PushBack('CompanionModule');
		hudModulesNames.PushBack('DamagedItemsModule');
		hudModulesNames.PushBack('TimeLapseModule');
		hudModulesNames.PushBack('TimeLeftModule');

		for( i = 0; i < hudModulesNames.Size(); i += 1 )
		{
			CreateHudModule(NameToString(hudModulesNames[i]));
		}
		
		m_fxSetIsDynamicSFF.InvokeSelfOneArg(FlashArgBool(m_isDynamic));
		
		UpdateHudConfigs();
		UpdateAcceptCancelSwaping();
		
		UpdateInputDeviceType();
		
		
		
		
		setGameLanguage();
		ToogleMinimalBuffView(true);
	}
	
	public function IsHudVisibilityAllowedByUser() : bool
	{
		return m_visibleHudByUser;
	}
	
	public function ForceShow( show : bool, source : EHudVisibilitySource )
	{
		var previouslyVisibleHud : bool;
		var currentlyVisibleHud : bool;

		LogChannel('hudv', "----------------------------------------- " + show + " " + source );
		
		previouslyVisibleHud = ( m_visibleHudBySystem && ( m_visibleHudByUser || m_visibleHudByScene || m_visibleHudByRadial ) );

		LogChannel('hudv', "P " + previouslyVisibleHud + "   " + m_visibleHudBySystem + " " + m_visibleHudByUser + " " + m_visibleHudByScene + " " + m_visibleHudByRadial );
		
		if ( source == HVS_System )
		{
			m_visibleHudBySystem = show;
		}
		else if ( source == HVS_User )
		{
			m_visibleHudByUser = show;
			if ( m_visibleHudByScene )
			{
				
				m_visibleHudByScene = false;
			}

		}
		else if ( source == HVS_Scene )
		{
			m_visibleHudByScene = show;
		}
		else if ( source == HVS_RadialMenu )
		{
			m_visibleHudByRadial = show;
		}
		
		currentlyVisibleHud = ( m_visibleHudBySystem && ( m_visibleHudByUser || m_visibleHudByScene || m_visibleHudByRadial ) );
		
		LogChannel('hudv', "C " + currentlyVisibleHud + "   " + m_visibleHudBySystem + " " + m_visibleHudByUser + " " + m_visibleHudByScene + " " + m_visibleHudByRadial );

		if ( previouslyVisibleHud != currentlyVisibleHud )
		{
			m_HudFlashSFS.SetVisible( currentlyVisibleHud );
		}
	}
	
	public function ToggleHudByUser()
	{
		var inGameConfigWrapper	: CInGameConfigWrapper;
		var newValue : bool;

		if ( IsRadialMenuOpened() )
		{
			
			return;
		}

		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		
		if ( m_visibleHudByScene )
		{
			newValue = false;
		}
		else
		{
			newValue = !inGameConfigWrapper.GetVarValue( 'Hud', 'HudVisibility' );
		}
		
		if ( newValue )
		{
			inGameConfigWrapper.SetVarValue( 'Hud', 'HudVisibility', "true" );
		}
		else
		{
			inGameConfigWrapper.SetVarValue( 'Hud', 'HudVisibility', "false" );
		}
		theGame.SaveUserSettings();
			
		ForceShow( newValue, HVS_User );

	}
	
	public function UpdateAcceptCancelSwaping():void
	{
		var inGameConfigWrapper : CInGameConfigWrapper;
		var configValue : bool;
		var radialMenuModule : CR4HudModuleRadialMenu;
		
		if (m_fxSwapAcceptCancel)
		{
			inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
			configValue = inGameConfigWrapper.GetVarValue('Controls', 'SwapAcceptCancel');
			m_fxSwapAcceptCancel.InvokeSelfOneArg( FlashArgBool(configValue) );
		}
		
		radialMenuModule =  (CR4HudModuleRadialMenu)GetHudModule( "RadialMenuModule" );
		if (radialMenuModule)
		{
			radialMenuModule.UpdateSwapAcceptCancel();
		}
	}
	
	protected function UpdateInputDeviceType():void
	{
		var deviceType : EInputDeviceType;
		
		if (m_fxSetGamepadType)
		{
			deviceType = theInput.GetLastUsedGamepadType();
			m_fxSetGamepadType.InvokeSelfOneArg( FlashArgUInt(deviceType) );
		}
	}

	protected function UpdateControlSchemeLock():void
	{
		if (m_fxLockControlScheme && m_guiManager)
		{
			m_fxLockControlScheme.InvokeSelfOneArg( FlashArgUInt(m_guiManager.GetLockedControlScheme()) );
		}
	}
	
	public function UpdateInputDevice():void
	{
		if (m_fxSetControllerType)	
		{
			m_fxSetControllerType.InvokeSelfOneArg( FlashArgBool(theInput.LastUsedGamepad()) );
		}
	}
	
	public function ShowBuffUpdate():void
	{
		var module : CR4HudModuleBuffs;
		
		module = (CR4HudModuleBuffs)(GetHudModule('BuffsModule'));
		if (module)
		{
			module.ShowBuffUpdate();
		}
	}
	
	
	public function UpdateHudConfigs():void
	{
		
		var minimapModule : CR4HudModuleMinimap2;
		var objectiveModule : CR4HudModuleQuests;
		

		UpdateHudConfig('Subtitles', false);
		
		
		
		UpdateHudConfig('HudVisibility', false);
		UpdateHudConfig('HudSize', false);
		UpdateHudConfig('TimeLapseModule', false);
		UpdateHudConfig('BoatHealthModule', false);
		UpdateHudConfig('BossFocusModule', false);
		UpdateHudConfig('BuffsModule', false);
		UpdateHudConfig('CompanionModule', false);
		UpdateHudConfig('ConsoleModule', false);
		UpdateHudConfig('DamagedItemsModule', false);
		UpdateHudConfig('EnemyFocusModule', false);
		UpdateHudConfig('NPCNames', false);
		UpdateHudConfig('EnemyHitEffects', false);		
		UpdateHudConfig('HorsePanicBarModule', false);
		UpdateHudConfig('HorseStaminaBarModule', false);
		UpdateHudConfig('ItemInfoModule', false);
		
		
		
		minimapModule = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");
		if(minimapModule)
		{
			if(!minimapModule.GetMinimapDuringFocusCombat())
			{
				UpdateHudConfig('Minimap2Module', false);
			}
		}	
		
		
		UpdateHudConfig('DayWeatherIndicator',false);
		UpdateHudConfig('TrackedMonster',false);
		UpdateHudConfig('OnelinersModule', false);
		UpdateHudConfig('OxygenBarModule', false);
		
		
		
		
		objectiveModule = (CR4HudModuleQuests)GetHudModule("QuestsModule");
		if(objectiveModule)
		{
			if(!objectiveModule.GetObjectiveDuringFocusCombat())
			{
				UpdateHudConfig('QuestsModule', false);
			}
		}	
		
		
		UpdateHudConfig('WolfMedalion',false);
		UpdateHudConfig('MessageModule', false);
		UpdateHudConfig('MinimapRotation', false);
		UpdateHudConfig('MinimapFocusClues', false);
		UpdateHudConfig('MinimapTracksWaypoints', false);
		UpdateHudConfig('MiminapPoiQuestionMarks', false);
		UpdateHudConfig('MinimapPoiCompletedIcons', false);
		UpdateHudConfig('ControlsFeedbackModule', false);		
		UpdateHudConfig('TimeLeftModule', false);

		UpdateHUD();
	}
	
	public function UpdateHudConfig(configName : name, updateHud : bool):void
	{
		var configValue : string;
		var inGameConfigWrapper : CInGameConfigWrapper;
		var module : CR4HudModuleBase;
		
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		
		switch (configName)
		{
		case 'HudVisibility':
			configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
			ForceShow( configValue == "true", HVS_User );
			break;
		case 'HudSize':
			configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
			SetHudSize( StringToInt( configValue ), true );
			break;
		case 'Subtitles':
			{
				configValue = inGameConfigWrapper.GetVarValue('Localization', configName);
				module = (CR4HudModuleBase)(GetHudModule(NameToString('SubtitlesModule')));
				if (module)
				{
					module.SetEnabled(configValue == "true");
				}
				
				theGame.setDialogDisplayDisabled(configValue == "false");
			}
			break;
		case 'WolfMedalion':		
		case 'TimeLapseModule':
		case 'BoatHealthModule':
		case 'BossFocusModule':
		case 'CompanionModule':
		case 'ConsoleModule':
		case 'DamagedItemsModule':
		case 'HorsePanicBarModule':
		case 'HorseStaminaBarModule':
		case 'ItemInfoModule':
		
		case 'Minimap2Module':
		case 'OnelinersModule':
		case 'OxygenBarModule':
		case 'QuestsModule':
		case 'MessageModule':
		case 'BuffsModule':
		case 'ControlsFeedbackModule':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				if( configName == 'WolfMedalion' )
				{
					configName = 'WolfHeadModule';
				}
				module = (CR4HudModuleBase)(GetHudModule(NameToString(configName)));
				if (module)
				{
					module.SetEnabled(configValue == "true");
				}
				
			}
			break;
		case 'TimeLeftModule':
			{
				module = (CR4HudModuleBase)(GetHudModule(NameToString(configName)));
				if (module)
				{
					module.SetEnabled( true );
				}
			}
			break;
		case 'EnemyFocusModule':
			{
				configValue = inGameConfigWrapper.GetVarValue( 'Hud', configName );
				
				m_enabledEnemyFocus = ( configValue == "true" );
				UpdateEnemyFocusVisiblity( m_enabledEnemyFocus, m_enabledNPCNames );
			}
			break;
		case 'NPCNames':
			{
				configValue = inGameConfigWrapper.GetVarValue( 'Hud', configName );
				
				m_enabledNPCNames = ( configValue == "true" );
				UpdateEnemyFocusVisiblity( m_enabledEnemyFocus, m_enabledNPCNames );
			}
			break;
		case 'EnemyHitEffects':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				
				m_enemyHitEffects = configValue == "true";
			}
			break;
		case 'DayWeatherIndicator':
			
			break;
		case 'TrackedMonster':
			
			break;
		case 'MinimapRotation':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				EnableMinimapRotation(configValue == "true");
			}
			break;
		case 'MinimapFocusClues':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				theGame.GetCommonMapManager().ShowFocusClues( configValue == "true" );
			}
			break;
		case 'MiminapPoiQuestionMarks':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				theGame.GetCommonMapManager().ShowKnownEntities( configValue == "true" );
			}
			break;
		case 'MinimapPoiCompletedIcons':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				theGame.GetCommonMapManager().ShowDisabledEntities( configValue == "true" );
			}
			break;
		case 'MinimapTracksWaypoints':
			{
				configValue = inGameConfigWrapper.GetVarValue('Hud', configName);
				theGame.GetCommonMapManager().ShowHintWaypoints( configValue == "true" );
			}
			break;
		}
		
		if (updateHud)
		{
			UpdateHUD();
		}
	}
	
	function EnableBuffedMonsterDisplay( value : bool )
	{
		var minimapModule : CR4HudModuleMinimap2;
		minimapModule = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");
		minimapModule.bDisplayBuffedMoster = value;
	}	
	
	function Toggle24HRFormat( value : bool )
	{
		var minimapModule : CR4HudModuleMinimap2;
		minimapModule = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");

		minimapModule.b24HRFormat = value;
		minimapModule.RefreshTimeDisplay();
	}
	
	public function AddHudModuleReference( hudModule : CR4HudModuleBase )
	{
		if( hudModules.FindFirst( hudModule ) < 0 )
		{
			hudModules.PushBack( hudModule );
		}
	}
	
	public function HandleDialogClosed( messageId : int )
	{
		var hudModuleDialog : CR4HudModuleDialog;
		
		if (messageId == UMID_MissingContentOnDialogError)
		{
			hudModuleDialog = GetDialogModule();
			
			if (hudModuleDialog)
			{
				hudModuleDialog.OnMissingContentDialogClosed();
			}
		}
	}

	function GetDialogModule() : CR4HudModuleDialog
	{
		return (CR4HudModuleDialog)GetHudModule( "DialogModule" );
	}
	
	function GetDamagedItemModule() : CR4HudModuleDamagedItems
	{
		return (CR4HudModuleDamagedItems)GetHudModule( "DamagedItemsModule" );
	}
	
	function RescaleModules()
	{
		var i : int;
		for( i = 0; i < hudModules.Size(); i += 1)
		{
			hudModules[i].SnapToAnchorPosition();
		}
	}
	
	function IsRadialMenuOpened() : bool
	{
		var radialMenuModule : CR4HudModuleRadialMenu;
		radialMenuModule =  (CR4HudModuleRadialMenu)GetHudModule( "RadialMenuModule" );
		
		if(radialMenuModule)
			return radialMenuModule.IsRadialMenuOpened();
			
		return false;
	}
			
	function IsRadialMenuOverwritenByContext( context : name ) : bool
	{
		switch(context)
		{
			case 'Scene':
			case 'FastMenu':
			case 'EMPTY_CONTEXT':
				return true;
			default:
				return false;
		}
		return false;
	}
		
	
	

	event  OnDialogHudShow()
	{
		theInput.StoreContext( 'Scene' ); 
	}

	event  OnDialogHudHide()
	{	
		theInput.RestoreContext( 'Scene', true ); 
	}

	event  OnDialogSentenceSet( text : string, alternativeUI : bool )
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogSentenceSet( text, alternativeUI );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogSentenceSet)" );
		}
	}
	
	event  OnDialogPreviousSentenceSet( text : string )
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogPreviousSentenceSet( text );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogPreviousSentenceSet)" );
		}
	}
	
	event  OnDialogPreviousSentenceHide()
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogPreviousSentenceHide();
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogPreviousSentenceHide)" );
		}
	}

	event  OnDialogSentenceHide()
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogSentenceHide();
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogSentenceHide)" );
		}
	}
	
	event  OnDialogChoicesSet( choices : array< SSceneChoice >, alternativeUI : bool )
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogChoicesSet( choices, alternativeUI );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogChoicesSet)" );
		}
	}
	
	event  OnDialogChoiceTimeoutSet( timeOutPercent : float )
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogChoiceTimeoutSet(timeOutPercent);
			FactsSet("nge_pause_menu_disabled",1,20); 
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogChoiceTimeoutSet)" );
		}
	}

	event  OnDialogChoiceTimeoutHide()
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogChoiceTimeoutHide();
			FactsRemove("nge_pause_menu_disabled"); 
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogChoiceTimeoutHide)" );
		}
	}

	event  OnDialogSkipConfirmShow()
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogSkipConfirmShow();
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogSkipConfirmShow)" );
		}
	}

	event  OnDialogSkipConfirmHide()
	{
		var dialogModule : CR4HudModuleDialog;
		
		dialogModule = GetDialogModule();
		if ( dialogModule )
		{
			dialogModule.OnDialogSkipConfirmHide();
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleDialog not found (OnDialogSkipConfirmHide)" );
		}
	}
	
	event  OnSubtitleAdded( id : int, speakerNameDisplayText : string, htmlString : string, alternativeUI : bool  )
	{
		var subtitlesModule : CR4HudModuleSubtitles;
		
		subtitlesModule = (CR4HudModuleSubtitles)GetHudModule( "SubtitlesModule" );
		if ( subtitlesModule )
		{
			subtitlesModule.OnSubtitleAdded( id, speakerNameDisplayText, htmlString, alternativeUI );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleSubtitles not found (OnSubtitleAdded)" );
		}
	}
	
	event  OnSubtitleRemoved( id : int )
	{
		var subtitlesModule : CR4HudModuleSubtitles;
		
		subtitlesModule = (CR4HudModuleSubtitles)GetHudModule( "SubtitlesModule" );
		if ( subtitlesModule )
		{
			subtitlesModule.OnSubtitleRemoved( id );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleSubtitles not found (OnSubtitleRemoved)" );
		}
	}

	
	
	
	event OnVideoSubtitles( subtitles : string )
	{
		LogChannel('Video', "[" + subtitles + "]");

		if ( subtitles != "" )
		{
			OnDialogSentenceSet( subtitles, false );
		}
		else
		{
			OnDialogSentenceHide();
		}
	}

	
	

	event  OnCreateOneliner( target : CEntity, value : string, ID : int )
	{
		var onelinersModule : CR4HudModuleOneliners;
		
		onelinersModule = (CR4HudModuleOneliners)GetHudModule( "OnelinersModule" );
		if ( onelinersModule )
		{
			onelinersModule.OnCreateOneliner( target, value, ID );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleOneliners not found (OnCreateOneliner)" );
		}
	}

	event  OnRemoveOneliner( ID : int )
	{
		var onelinersModule : CR4HudModuleOneliners;
		
		onelinersModule = (CR4HudModuleOneliners)GetHudModule( "OnelinersModule" );
		if ( onelinersModule )
		{
			onelinersModule.OnRemoveOneliner( ID );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleOneliners not found (OnRemoveOneliner)" );
		}
	}

	
	

	event  OnInteractionsUpdated( component : CInteractionComponent )
	{
		var interactionsModule : CR4HudModuleInteractions;
		
		interactionsModule = (CR4HudModuleInteractions)GetHudModule( "InteractionsModule" );
		if ( interactionsModule )
		{
			interactionsModule.OnInteractionsUpdated( component );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleInteractions not found (OnInteractionsUpdated)" );
		}
	}
	
	public function IsInteractionInCameraView( interaction : CInteractionComponent ) : bool
	{
		var interactionsModule : CR4HudModuleInteractions;		
		interactionsModule = (CR4HudModuleInteractions)GetHudModule( "InteractionsModule" );
		if ( interactionsModule )
		{
			return interactionsModule.IsInteractionInCameraView( interaction );
		}
		return false;
	}
	
	
	
	
	event  OnDebugTextShown( text : string )
	{
		
	}

	event  OnDebugTextHidden()
	{
		
	}
				
	
	

	event  OnCharacterEvent( journalCharacter : CJournalCharacter )
	{
		LogChannel( 'Journal', "OnCharacterEvent" );
		OnJournalUpdate(journalCharacter,false);
		m_guiManager.RegisterNewGlossaryEntry( journalCharacter, 'panel_title_glossary_dictionary' ); 
	}

	event  OnCharacterDescriptionEvent( journalCharacterDescription : CJournalCharacterDescription )
	{
		var journalCharacter : CJournalCharacter;
		LogChannel( 'Journal', "OnCharacterDescriptionEvent" );
		journalCharacter = (CJournalCharacter)journalCharacterDescription.GetParent();
		if( journalCharacter )
		{
			OnJournalUpdate(journalCharacter,true);
		}
	}

	event  OnCreatureEvent( journalCreature : CJournalCreature )
	{
		LogChannel( 'Journal', "OnCreatureEvent" );
		OnJournalUpdate(journalCreature,false);
		m_guiManager.RegisterNewGlossaryEntry( journalCreature, 'panel_title_glossary_bestiary' );
	}

	event  OnCreatureDescriptionEvent( journalCreatureDescription : CJournalCreatureDescriptionEntry )
	{
		var journalCreature : CJournalCreature;
		LogChannel( 'Journal', "OnCreatureDescriptionEvent" );
		
		
		
		
		
		journalCreature = (CJournalCreature)journalCreatureDescription.GetParent();
		if( journalCreature )
		{
			OnJournalUpdate(journalCreature,true);
		}
	}

	event  OnGlossaryEvent( journalGlossary : CJournalGlossary )
	{
	
	}

	event  OnGlossaryDescriptionEvent( journalGlossaryDescription : CJournalGlossaryDescription )
	{
	
	}

	event  OnStoryBookPageEvent( journalStoryBookPage : CJournalStoryBookPage )
	{
		LogChannel( 'Journal', "OnStoryBookPageEvent" );
	}

	event  OnTutorialEvent( journalTutorial : CJournalTutorial )
	{
		LogChannel( 'Journal', "OnTutorialEvent" );
	}

	event  OnPlaceEvent( journalPlace : CJournalPlace )
	{
		LogChannel( 'Journal', "OnPlaceEvent" );
	}

	event  OnPlaceDescriptionEvent( journalPlaceDescription : CJournalPlaceDescription )
	{
		LogChannel( 'Journal', "OnPlaceDescriptionEvent" );
	}

	event  OnQuestEvent( journalQuest : CJournalQuest )
	{
		LogChannel( 'Journal', "OnQuestEvent "+journalQuest.baseName );
		OnQuestUpdate( journalQuest, true );
	}

	event  OnQuestObjectiveEvent( journalQuest : CJournalQuest, journalObjective : CJournalQuestObjective )
	{
		LogChannel( 'Journal', "OnQuestObjectiveEvent " + journalQuest.baseName + " : " + journalObjective.baseName );
		OnQuestUpdate( journalQuest, false ); 
	}
	
	function OnQuestUpdate( journalQuest : CJournalQuest, isQuestUpdate : bool )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		var manager : CWitcherJournalManager;
		var status : int;
		var id : int;
		var itemIds : array<SItemUniqueId>;

		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddQuestUpdate( journalQuest, isQuestUpdate );
		}

		manager = theGame.GetJournalManager();

		status = manager.GetEntryStatus( journalQuest );
		
		if ( status == JS_Success )
		{
			thePlayer.inv.GetAllItems( itemIds );

			theTelemetry.LogWithLabel( TE_INV_QUEST_COMPLETED, "QUEST COMPLETED - ECONOMY REPORT" );
			theTelemetry.LogWithLabelAndValue( TE_INV_QUEST_COMPLETED, "Crowns", thePlayer.GetMoney() );

			for ( id = itemIds.Size() - 1; id >= 0; id -= 1 )
			{
				theTelemetry.LogWithLabelAndValue( TE_INV_QUEST_COMPLETED, thePlayer.inv.GetItemName(itemIds[ id ] ), thePlayer.inv.GetItemQuantity( itemIds[ id ] ) );
			}
		}
	}
	
	function OnLevelUpUpdate( level : int, show : bool)
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		var hudQuestsModule : CR4HudModuleQuests;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			if ( show ) hudJournalUpdateModule.AddLevelUpUpdate(level);
			if ( thePlayer.IsCiri() ) show = false;
			OnShowLevelUpIndicator( show );
		}
		
		hudQuestsModule = (CR4HudModuleQuests)GetHudModule( "QuestsModule" );
		if (hudQuestsModule)
		{
			hudQuestsModule.OnLevelUp();
		}
	}	

	function OnShowLevelUpIndicator( show : bool )
	{
		var hudWolfHeadModule : CR4HudModuleWolfHead;
		
		hudWolfHeadModule = (CR4HudModuleWolfHead)GetHudModule( "WolfHeadModule" );
		if ( hudWolfHeadModule )
		{
			hudWolfHeadModule.ShowLevelUpIndicator(show);
		}
	}	

	function OnExperienceUpdate( exp : int, show : bool )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule && show )
		{
			if ( show ) hudJournalUpdateModule.AddExperienceUpdate(exp);
		}
	}
	
	function OnMapPinUpdate( mapPinTag : name )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddMapPinUpdate(mapPinTag);
		}
	}
	
	function OnItemRecivedDuringScene( itemName : name, optional quantity : int )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddItemRecivedDuringSceneUpdate(itemName, quantity);
		}
	}
	
	function OnJournalUpdate( journalEntry : CJournalBase, isDescription : bool )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddJournalUpdate( journalEntry, isDescription );
		}
	}	
	
	function OnCraftingSchematicUpdate( schematicName : name )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddCraftingSchematicUpdate( schematicName );
		}
		m_guiManager.RegisterNewGlossaryEntry( NULL, 'panel_title_crafting', schematicName );
	}		

	function OnAlchemySchematicUpdate( schematicName : name )
	{
		var hudJournalUpdateModule : CR4HudModuleJournalUpdate;
		
		hudJournalUpdateModule = (CR4HudModuleJournalUpdate)GetHudModule( "JournalUpdateModule" );
		if ( hudJournalUpdateModule )
		{
			hudJournalUpdateModule.AddAlchemySchematicUpdate( schematicName );
		}
		m_guiManager.RegisterNewAlchemyEntry( schematicName );
	}	
		
	
	

	event  OnQuestTrackingStarted( journalQuest : CJournalQuest )
	{
		GetHudEventController().RunEvent_QuestsModule_OnQuestTrackingStarted( journalQuest );
		LogChannel( 'Journal', "OnQuestTrackingStarted " + journalQuest.baseName );
	}

	event  OnTrackedQuestUpdated( journalQuest : CJournalQuest )
	{
		var hudQuestTrackerModule : CR4HudModuleQuests;
		
		hudQuestTrackerModule = (CR4HudModuleQuests)GetHudModule( "QuestsModule" );
		if ( hudQuestTrackerModule )
		{
			hudQuestTrackerModule.OnTrackedQuestUpdated( journalQuest );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleQuests not found (OnTrackedQuestUpdated)" );
		}
		LogChannel( 'Journal', "OnTrackedQuestUpdated " + journalQuest.baseName );
	}
	
	event  OnTrackedQuestObjectivesUpdated( journalObjective : CJournalQuestObjective )
	{
		var hudQuestTrackerModule : CR4HudModuleQuests;
		
		hudQuestTrackerModule = (CR4HudModuleQuests)GetHudModule( "QuestsModule" );
		if ( hudQuestTrackerModule )
		{
			hudQuestTrackerModule.OnTrackedQuestObjectivesUpdated( journalObjective );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleQuests not found (OnTrackedQuestObjectivesUpdated)" );
		}
		LogChannel( 'Journal', "OnTrackedQuestObjectivesUpdated " + journalObjective.baseName );
	}

	event  OnTrackedQuestObjectiveCounterUpdated( journalObjective : CJournalQuestObjective )
	{
		var hudQuestTrackerModule : CR4HudModuleQuests;
		
		hudQuestTrackerModule = (CR4HudModuleQuests)GetHudModule( "QuestsModule" );
		if ( hudQuestTrackerModule )
		{
			hudQuestTrackerModule.OnTrackedQuestObjectiveCounterUpdated( journalObjective );
		}
		else
		{
			LogChannel( 'MissingHudModule', "CR4HudModuleQuests not found (OnTrackedQuestObjectiveCounterUpdated)" );
		}
		LogChannel( 'Journal', "OnTrackedQuestObjectiveCounterUpdated " + journalObjective.baseName );
	}

	event  OnTrackedQuestObjectiveHighlighted( journalObjective : CJournalQuestObjective, journalObjectiveIndex : int )
	{
		GetHudEventController().RunEvent_QuestsModule_OnTrackedQuestObjectiveHighlighted( journalObjective, journalObjectiveIndex );
		LogChannel( 'Journal', "OnTrackedQuestObjectiveHighlighted " + journalObjective.baseName );
	}

	function __PrintInfo()
	{
	    m_fxPrintInfoSFF.InvokeSelf();
	}
	
	private function SetHudSize( size : int, update : bool )
	{
		m_hudSize = size;
		if ( update )
		{
			UpdateHudScale();
		}
	}

	private function UpdateEnemyFocusVisiblity( enableEnemyFocus : bool, enabledNPCNames : bool )
	{
		var enemyFocusModule : CR4HudModuleEnemyFocus;		

		enemyFocusModule = (CR4HudModuleEnemyFocus)( GetHudModule( "EnemyFocusModule" ) );
		if ( enemyFocusModule )
		{
			enemyFocusModule.SetGeneralVisibility( enableEnemyFocus, enabledNPCNames );
		}
	}

	public function AreEnabledEnemyHitEffects(): bool
	{
		return m_enemyHitEffects;
	}

	public function IsEnabledMinimapRotation() : bool
	{
		return m_minimapRotationEnabled;
	}
	
	private function EnableMinimapRotation( enable : bool )
	{
		var module : CR4HudModuleMinimap2;

		m_minimapRotationEnabled = enable;

		module = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");
		if ( module )
		{
			module.EnableRotation( enable );
		}
	}
	
	public function SetMinimapZoom( zoom : float )
	{
		m_minimapZoom = zoom;
	}

	public function GetMinimapZoom() : float
	{
		return m_minimapZoom;
	}
	
	public function HudConsoleMsg( msgText : string )
	{
		var module : CR4HudModuleConsole;
		
		module = (CR4HudModuleConsole)GetHudModule("ConsoleModule");
		if ( module )
		{
			module.ConsoleMsg( msgText );
		}
	}

	public function HudConsoleTest()
	{
		var module : CR4HudModuleConsole;
		
		module = (CR4HudModuleConsole)GetHudModule("ConsoleModule");
		if ( module )
		{
			module.ConsoleTest();
		}
	}

	public function HudConsoleCleanup()
	{
		var module : CR4HudModuleConsole;
		
		module = (CR4HudModuleConsole)GetHudModule("ConsoleModule");
		if ( module )
		{
			module.ConsoleCleanup();
		}
	}	

	public function SetDynamic( value : bool )
	{
		m_isDynamic = value;
		m_fxSetIsDynamicSFF.InvokeSelfOneArg(FlashArgBool(m_isDynamic));
		UpdateHUD();
	}	

	public function GetDynamic( ) : bool
	{
		return m_isDynamic;
	}
	
	public function UpdateHUD()
	{
		m_fxSetInputContextSFF.InvokeSelfOneArg(FlashArgString(currentInputContext));
	}
	
	public function DisplayTutorialHighlight( tutorialName : name ,bShow : bool )
	{
		var hudModule : CR4HudModuleBase;
		
		LogChannel('TUTHUGH',"tutorialName "+tutorialName+" bShow "+bShow);
		switch(tutorialName)
		{
			case 'TutorialHorseStamina' :
				hudModule = (CR4HudModuleBase)GetHudModule("HorseStaminaBarModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;
			case 'TutorialOxygen' :
				hudModule = (CR4HudModuleBase)GetHudModule("OxygenBarModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;
			case 'TutorialMinimap' :
			case 'TutorialActiveGoalHighlight' :
			case 'TutorialMinimapAndQuestLog' :
				hudModule = (CR4HudModuleBase)GetHudModule("Minimap2Module");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				if( tutorialName != 'TutorialMinimapAndQuestLog' ) 
				{
					break;
				}
			case 'TutorialMinimapAndQuestLog' :
			case 'TutorialQuestTodo' :
				hudModule = (CR4HudModuleBase)GetHudModule("QuestsModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;
			
			case 'TutorialFallingDamage' :
			case 'TutorialStaminaSigns' :
			case 'TutorialStaminaExploration' :
			case 'TutorialAdrenaline' :
				hudModule = (CR4HudModuleBase)GetHudModule("WolfHeadModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;
				
			case 'TutorialBuffs' :
				hudModule = (CR4HudModuleBase)GetHudModule("BuffsModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;

			case 'TutorialSelectQuen' :
			case 'TutorialSelectIgni' :
			case 'TutorialSelectAard' :
			case 'TutorialSelectAxii' :
			case 'TutorialSelectYrden' :
			case 'TutorialSelectPetard' :
			case 'TutorialSelectCrossbow' :
				hudModule = (CR4HudModuleBase)GetHudModule("RadialMenuModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;		
			case 'TutorialLootWindow' :
				hudModule = (CR4HudModuleBase)GetHudModule("LootPopupModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;	
			case 'TutorialBoatDamage' :
				hudModule = (CR4HudModuleBase)GetHudModule("BoatHealthModule");
				hudModule.ShowTutorialHighlight(bShow,NameToString(tutorialName));
				break;
			default:
				break;
		}
	}
	
	public function OnRadialOpened()
	{
	
		ToogleMinimalBuffView(false);
		ForceShow( true, HVS_RadialMenu );

	}
	
	public function OnRadialClosed()
	{
		ToogleMinimalBuffView(true);
		ForceShow( false, HVS_RadialMenu );
	}
	
	public function OnCutsceneStarted()
	{
		
		var qst : CR4HudModuleQuests;		
		var mm : CR4HudModuleMinimap2;

		mm = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");
		qst = (CR4HudModuleQuests)GetHudModule("QuestsModule");
		
		if(mm)
			mm.SetIsInDlg(true);
			
		if(qst)
			qst.SetIsInDlg(true);				
		
	
	
		ForceShow( true, HVS_Scene );
		
		m_fxOnCutscene.InvokeSelfOneArg( FlashArgBool( true ) );
	}
	
	public function OnCutsceneEnded()
	{
		
		var qst : CR4HudModuleQuests;		
		var mm : CR4HudModuleMinimap2;

		mm = (CR4HudModuleMinimap2)GetHudModule("Minimap2Module");
		qst = (CR4HudModuleQuests)GetHudModule("QuestsModule");
		
		if(mm)
			mm.SetIsInDlg(false);
			
		if(qst)
			qst.SetIsInDlg(false);				
		
	
		ForceShow( false, HVS_Scene );
		
		m_fxOnCutscene.InvokeSelfOneArg( FlashArgBool( false ) );
	}
	
	public function ToogleMinimalBuffView( value : bool )
	{
		var buffModule : CR4HudModuleBuffs;
		
		buffModule = (CR4HudModuleBuffs)GetHudModule("BuffsModule");
		if( buffModule )
		{
			buffModule.SetMinimalViewMode(value);
		}	
	}
	
	





	private var _cachedEntity : CEntity;
	private var _cachedEntityPosition : Vector;
	
	function IsCachedPositionForEntity( entity : CEntity ) : bool
	{
		return _cachedEntity == entity;
	}

	function GetCachedPositionForEntity( entity : CEntity ) : Vector
	{
		return _cachedEntityPosition;
	}

	function SetCachedPositionForEntity( entity : CEntity, pos : Vector )
	{
		_cachedEntity = entity;
		_cachedEntityPosition = pos;
	}

	function ClearCachedPositionForEntity()
	{
		_cachedEntity = NULL;
	}





	function OnRelevantSkillChanged( skill : ESkill, equipped : bool )
	{
		var buffModule : CR4HudModuleBuffs;
		
		buffModule = (CR4HudModuleBuffs)GetHudModule("BuffsModule");
		if( buffModule )
		{
			buffModule.ForceUpdate();
		}		
	}
}

exec function showCrossbowTut()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.DisplayTutorialHighlight('TutorialSelectCrossbow', true);
}

function GetBaseScreenPosition( out screenPos : Vector, entity : CEntity, optional comp : CInteractionComponent, optional extraZ : float, optional noOppositeCamera : bool, optional normalized : bool ) : bool
{
	var hud : CR4ScriptedHud;
	var targetActor				: CActor;
	var targetEntity			: CGameplayEntity;
	var headBoneIdx				: int;
	var targetPos				: Vector;
	var box						: Box;
	var drawableComponent		: CDrawableComponent;
	var drawableComponentCount	: int;
	var useDrawableComponent	: bool;
	var compMat					: Matrix;

	var actorExtraZ : float = 0.5;

	if ( !entity )
	{
		return false;
	}

	hud = (CR4ScriptedHud)theGame.GetHud();
	
	
	
	
	targetActor = (CActor)entity;
	if ( targetActor )
	{
	




		if ( hud.IsCachedPositionForEntity( targetActor ) )
		{
			targetPos = hud.GetCachedPositionForEntity( targetActor );
		}
		else
		{



			headBoneIdx = targetActor.GetHeadBoneIndex();
			if ( headBoneIdx >= 0 )
			{
				targetPos = MatrixGetTranslation( targetActor.GetBoneWorldMatrixByIndex( headBoneIdx ) );
			}
			else
			{
				targetPos = targetActor.GetWorldPosition();
			}



			hud.SetCachedPositionForEntity( targetActor, targetPos );




		}
		targetPos += targetActor.iconOffset;
		targetPos.Z += actorExtraZ;
	}
	else
	{
		targetEntity = (CGameplayEntity)entity;
		if ( targetEntity )
		{
			if ( comp )
			{
				targetPos = comp.GetWorldPosition();
				if ( comp.iconOffset.X != 0.f || comp.iconOffset.Y != 0.f || comp.iconOffset.Z != 0.f )
				{
					compMat = comp.GetLocalToWorld();				
					targetPos = VecTransform( compMat, comp.iconOffset );				
				}
				else
				{
					useDrawableComponent = true;
				}
			}
			else
			{
				targetPos = targetEntity.GetWorldPosition();
				if ( targetEntity.iconOffset.X != 0.f || targetEntity.iconOffset.Y != 0.f || targetEntity.iconOffset.Z != 0.f )
				{
					compMat = targetEntity.GetLocalToWorld();				
					targetPos = VecTransform( compMat, targetEntity.iconOffset );	
				}
				else
				{
					useDrawableComponent = true;				
				}
			}
			
			if ( useDrawableComponent )
			{
				drawableComponentCount = targetEntity.GetComponentsCountByClassName( 'CDrawableComponent' );
				if ( drawableComponentCount == 1 )
				{
					
					drawableComponent = (CDrawableComponent)( targetEntity.GetComponentByClassName( 'CDrawableComponent' ) );
					if( drawableComponent  )
					{
						drawableComponent.GetObjectBoundingVolume( box );
						if ( box.Max.Z > 0 )
						{
							targetPos.Z = box.Max.Z;
						}
						else
						{
							targetPos.Z += 0.25f;
						}
					}
				}
			}
			
		}
		else
		{
			targetPos = entity.GetWorldPosition();
		}
	}
	
	targetPos.Z += extraZ;

	if ( !theCamera.WorldVectorToViewRatio( targetPos, screenPos.X, screenPos.Y ) )
	{
		if ( noOppositeCamera )
		{
			return false;
		}
		GetOppositeCameraScreenPos( targetPos, screenPos.X, screenPos.Y );
	}

	screenPos.X = ( screenPos.X + 1 ) / 2;
	screenPos.Y = ( screenPos.Y + 1 ) / 2;

	if ( !normalized )
	{
		screenPos = hud.GetScaleformPoint( screenPos.X, screenPos.Y );
	}
	
	return true;
}

function GetOppositeCameraScreenPos( worldPos : Vector, out x : float, out y : float )
{
	var camera : CCustomCamera;
	var oppositeCamHeading : float;
	var playerToTargetHeading	: float;
	var angleDiff : float;
	
	camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
	oppositeCamHeading = camera.GetHeading() + 180.f;
	playerToTargetHeading = VecHeading( worldPos - thePlayer.GetWorldPosition() );
	angleDiff = AngleDistance( oppositeCamHeading, playerToTargetHeading );
	x = -angleDiff/90;
	y = 1.f;
}

function IsPointOnScreen( screenPos : Vector ) : bool
{
	return  screenPos.X >= 0 &&
			screenPos.X < 1920 &&
			screenPos.Y >= 0 &&
			screenPos.Y < 1080;
}
	


exec function showoneliner1( plainText : string )
{
	var hud : CR4ScriptedHud;
	if ( thePlayer.moveTarget )
	{
		hud = (CR4ScriptedHud)theGame.GetHud();
		hud.ShowOneliner( plainText, thePlayer.moveTarget );
	}
}

exec function hideoneliner1()
{
	var hud : CR4ScriptedHud;
	if ( thePlayer.moveTarget )
	{
		hud = (CR4ScriptedHud)theGame.GetHud();
		hud.HideOneliner( thePlayer.moveTarget );
	}
}

exec function dlgshow()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.OnDialogHudShow();
}

exec function dlghide()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.OnDialogHudHide();
}

exec function hudinfo()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.__PrintInfo();
}

exec function HudConsoleMsg( msgText : string )
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.HudConsoleMsg(msgText);
}

exec function HudConsoleTest()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.HudConsoleTest();
}

exec function HudConsoleCleanup()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.HudConsoleCleanup();
}

exec function HudSetDynamic( value : bool )
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hud.SetDynamic( value );
}

exec function HudSetModuleEnabled( moduleName : string,value : bool )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleBase;
	hud = (CR4ScriptedHud)theGame.GetHud();
	module = (CR4HudModuleBase)hud.GetHudModule(moduleName);
	module.SetEnabled(value);
	hud.UpdateHUD();
}

exec function ForceHudScaleRefresh()
{
	var hud : CR4ScriptedHud;
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	if (hud)
	{
		hud.UpdateScaleformStageSize();
		hud.UpdateHudScale();
	}
}

exec function showKnown( show : bool )
{
	var configValue : string;
	var inGameConfigWrapper : CInGameConfigWrapper;
		
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	inGameConfigWrapper.SetVarValue( 'Hud', 'MiminapPoiQuestionMarks', show );
	theGame.SaveUserSettings();

	theGame.GetCommonMapManager().ShowKnownEntities( show );
}

exec function showDisabled( show : bool )
{
	var configValue : string;
	var inGameConfigWrapper : CInGameConfigWrapper;
		
	inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
	inGameConfigWrapper.SetVarValue( 'Hud', 'MinimapPoiCompletedIcons', show );
	theGame.SaveUserSettings();

	theGame.GetCommonMapManager().ShowDisabledEntities( show );
}