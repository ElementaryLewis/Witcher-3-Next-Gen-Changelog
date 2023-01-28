package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import red.core.CoreComponent;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.AspectRatio;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3Background;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.modules.SimpleListModule;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class IngameMenu extends CoreMenu
   {
      
      public static const IGMActionType_CommonMenu:uint = 0;
      
      public static const IGMActionType_Close:uint = 1;
      
      public static const IGMActionType_MenuHolder:uint = 2;
      
      public static const IGMActionType_MenuLastHolder:uint = 3;
      
      public static const IGMActionType_Load:uint = 4;
      
      public static const IGMActionType_Save:uint = 5;
      
      public static const IGMActionType_Quit:uint = 6;
      
      public static const IGMActionType_Preset:uint = 7;
      
      public static const IGMActionType_Toggle:uint = 8;
      
      public static const IGMActionType_List:uint = 9;
      
      public static const IGMActionType_Slider:uint = 10;
      
      public static const IGMActionType_LoadLastSave:uint = 11;
      
      public static const IGMActionType_Tutorials:uint = 12;
      
      public static const IGMActionType_Credits:uint = 13;
      
      public static const IGMActionType_Help:uint = 14;
      
      public static const IGMActionType_Controls:uint = 15;
      
      public static const IGMActionType_ControllerHelp:uint = 16;
      
      public static const IGMActionType_NewGame:uint = 17;
      
      public static const IGMActionType_CloseGame:uint = 18;
      
      public static const IGMActionType_UIRescale:uint = 19;
      
      public static const IGMActionType_Gamma:uint = 20;
      
      public static const IGMActionType_DbgStartQuest:uint = 21;
      
      public static const IGMActionType_Gwint:uint = 22;
      
      public static const IGMActionType_ImportSave:uint = 23;
      
      public static const IGMActionType_KeyBinds:uint = 24;
      
      public static const IGMActionType_Back:uint = 25;
      
      public static const IGMActionType_NewGamePlus:uint = 26;
      
      public static const IGMActionType_InstalledDLC:uint = 27;
      
      public static const IGMActionType_Button:uint = 28;
      
      public static const IGMActionType_ToggleRender:uint = 29;
      
      public static const IGMActionType_Gog:uint = 30;
      
      public static const IGMActionType_TelemetryConsent:uint = 31;
      
      public static const IGMActionType_ListWithCondition:uint = 32;
      
      public static const IGMActionType_Stepper:uint = 33;
      
      public static const IGMActionType_ToggleStepper:uint = 34;
      
      public static const IGMActionType_Separator:uint = 35;
      
      public static const IGMActionType_SubtleSeparator:uint = 36;
      
      public static const IGMActionType_Options:uint = 100;
      
      private static const ACTION_CLOSE:uint = 0;
      
      private static const ACTION_SCROLL:uint = 1;
      
      private static const ACTION_USE:uint = 2;
      
      private static const ACTION_Y:uint = 3;
      
      private static const ACTION_X:uint = 4;
      
      private static const ACTION_APPLY_PRESET:uint = 5;
      
      private static const ACTION_DOWNLOAD:uint = 66;
      
      public static const CST_CLOUD = 30;
      
      public static const OnOptionPanelClosed:String = "OnOptionPanelClosed";
      
      public static var _DLSSIsSupported:Boolean = true;
      
      public static var _RTEnabled:Boolean = true;
      
      public static var AAModeIntTag:uint = 0;
      
      public static var Virtual_SSAOSolutionIntTag:uint = 0;
       
      
      private var importME:IngameMenuEntry;
      
      public var mcInputFeedbackModule:ModuleInputFeedback;
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var menuListModule:SimpleListModule;
      
      public var mcCustomDialogEp1:MovieClip;
      
      public var mcCustomDialogEp2:MovieClip;
      
      public var mcCustomDialogGOTY:MovieClip;
      
      public var mcCustomDialogGalaxySignIn:MovieClip;
      
      public var mcRewardsTable:MovieClip;
      
      public var mcCustomDialogTelemetry:MovieClip;
      
      public var mcTermsOfUseDialog:MovieClip;
      
      public var mcErrorDialog:MovieClip;
      
      public var mcCloudSavesModalDialog:MovieClip;
      
      public var mcGammaModule:GammaSettingModule;
      
      public var mcHelpModule:StaticOptionModule;
      
      public var mcUIRescaleModule:UIRescaleModule;
      
      public var mcGameMappingModule:GamepadMappingModule;
      
      public var mcOptionListModule:OptionListModule;
      
      public var mcSaveSlotListModule:SaveSlotListModule;
      
      public var mcKeyBindModule:KeyBindsOptionModule;
      
      public var mcInstalledDLCModule:InstalledDLCModule;
      
      public var mcExpansionIcons:MovieClip;
      
      public var mcWeibo:MovieClip;
      
      public var _lastRequestedUrl:String;
      
      public var mcBlackBackground:W3Background;
      
      public var mcInputBackground:MovieClip;
      
      public var txtUserName:TextField;
      
      public var txtVersion:TextField;
      
      public var txtFrameRateMode:TextField;
      
      public var mcCloudSaveButton:InputFeedbackButton;
      
      public var brCloudSaveBorder:DisplayObject;
      
      public var isCloudUserSignedIn:Boolean = false;
      
      protected var expansionIconsEnabled:Boolean = false;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      public var previousEntries:Vector.<DataProvider>;
      
      public var previousContainers:Vector.<Object>;
      
      public var previousSelections:Vector.<int>;
      
      public var rootData:Array;
      
      private var _isMainMenu:Boolean = false;
      
      private var _ignoreInput:Boolean = false;
      
      public var _hardwareCursorOn:Boolean = false;
      
      public var _telemetryConsent:Boolean = false;
      
      public var _consentPopupWasShown:Boolean = false;
      
      public var _waitingQRCodePicture:Boolean = false;
      
      public var _hidNavButtUse:Boolean = false;
      
      public var _hidNavButtStick:Boolean = false;
      
      public var _hidNavButtProfile:Boolean = false;
      
      private var _hideAnimationPlaying:Boolean = false;
      
      private var _platform:int = 0;
      
      private var _isPlatformXBox:Boolean = false;
      
      private var _isPlatformPlayStation:Boolean = false;
      
      private var _panelMode:Boolean = false;
      
      private var _enableWeiboLink:Boolean = false;
      
      private var _inPanel:Boolean = false;
      
      private var _currentDialogIndex:int = -1;
      
      private var _queuedDialogIndices:Vector.<int>;
      
      private var _currentDialogTimer:Timer;
      
      private var _fontLoadTimer:Timer;
      
      private var _fontLoadDelay:Number = 1000;
      
      protected var _lastSetShowPresetInputFeedback:Boolean = false;
      
      public function IngameMenu()
      {
         this._queuedDialogIndices = new Vector.<int>();
         super();
         this.previousEntries = new Vector.<DataProvider>();
         this.previousContainers = new Vector.<Object>();
         this.previousSelections = new Vector.<int>();
         upToCloseEnabled = false;
         this.mcExpansionIcons.visible = false;
         this.mcWeibo.visible = false;
         this.mcInputFeedbackModule.clickable = false;
         this.mcInputFeedbackModule.showBackground = true;
         this.mcInputBackground = this.mcInputFeedbackModule["mcInputBackground"] as MovieClip;
         stage.addEventListener(MouseEvent.CLICK,this.onStageClicked,false,1,true);
         this.mcBlackBackground.visibilityChangeCallback = this.onBackgroundVisibilityChanged;
      }
      
      public function set inPanel(param1:Boolean) : void
      {
         this._inPanel = param1;
         if(param1 && Boolean(this.mcWeibo))
         {
            this.mcWeibo.visible = false;
         }
         if(param1 && this.mcExpansionIcons != null)
         {
            this.mcExpansionIcons.visible = false;
         }
         if(this.menuListModule)
         {
            this.menuListModule.lockSelection = this._inPanel;
         }
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.visible = this._inPanel;
         }
      }
      
      public function get inPanel() : Boolean
      {
         return this._inPanel;
      }
      
      public function onBackgroundVisibilityChanged(param1:Boolean) : void
      {
         this.mcInputFeedbackModule.showBackground = !param1;
      }
      
      public function setGogCloudState(param1:Object) : *
      {
         this.isCloudUserSignedIn = param1.isUserSignedIn;
      }
      
      public function SetCloudSaveVisibility(param1:Boolean) : void
      {
         if(this.brCloudSaveBorder)
         {
            this.brCloudSaveBorder.visible = false;
         }
         if(this.mcCloudSaveButton)
         {
            this.mcCloudSaveButton.visible = false;
            this.mcCloudSaveButton.clickable = false;
            this.mcCloudSaveButton.label = "[[ui_gog_cloud_saves_sign_in]]";
            this.mcCloudSaveButton.setDataFromStage(NavigationCode.GAMEPAD_L2,KeyCode.NUMBER_1);
            this.mcCloudSaveButton.validateNow();
         }
         if(param1)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_APPLY_PRESET,NavigationCode.GAMEPAD_L2,KeyCode.C,"[[ui_gog_cloud_saves_title]]",true);
         }
         else
         {
            this.mcInputFeedbackModule.removeButton(ACTION_APPLY_PRESET,true);
         }
      }
      
      override protected function configUI() : void
      {
         var _loc1_:MovieClip = null;
         super.configUI();
         this.inPanel = false;
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         if(this.txtUserName)
         {
            this.txtUserName.text = "";
         }
         if(this.txtVersion)
         {
            this.txtVersion.text = "";
         }
         this.SetCloudSaveVisibility(false);
         if(this.mcCustomDialogEp1)
         {
            this.closeCustomDialog(1,false);
         }
         if(this.mcCustomDialogEp2)
         {
            this.closeCustomDialog(2,false);
         }
         if(this.mcCustomDialogGOTY)
         {
            this.closeCustomDialog(3,false);
         }
         this.closeGalaxySignInDialog();
         if(this.mcCustomDialogTelemetry)
         {
            this.mcCustomDialogTelemetry.visible = false;
         }
         if(this.mcErrorDialog)
         {
            this.mcErrorDialog.visible = false;
         }
         if(this.mcCloudSavesModalDialog)
         {
            this.mcCloudSavesModalDialog.visible = false;
         }
         if(this.mcRewardsTable)
         {
            this.mcRewardsTable.visible = false;
         }
         if(this.mcTermsOfUseDialog)
         {
            this.mcTermsOfUseDialog.visible = false;
         }
         this._lastRequestedUrl = "Requested. Please wait";
         focused = 1;
         if(this.mcBlackBackground)
         {
            this.mcBlackBackground.forceHide();
         }
         if(this.menuListModule)
         {
            this.menuListModule.focusable = false;
            this.menuListModule.titleText = "";
            _loc1_ = this.menuListModule.getChildByName("MenuContinue") as MovieClip;
            if(_loc1_)
            {
               _loc1_.visible = false;
            }
         }
         if(this.txtFrameRateMode)
         {
            this.txtFrameRateMode.visible = false;
         }
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
         }
         if(this.mcGammaModule)
         {
            this.mcGammaModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcKeyBindModule)
         {
            this.mcKeyBindModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcInstalledDLCModule)
         {
            this.mcInstalledDLCModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcHelpModule)
         {
            this.mcHelpModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcUIRescaleModule)
         {
            this.mcUIRescaleModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcGameMappingModule)
         {
            this.mcGameMappingModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcOptionListModule)
         {
            this.mcOptionListModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
         }
         if(this.mcSaveSlotListModule)
         {
            this.mcSaveSlotListModule.addEventListener(OnOptionPanelClosed,this.handlePanelClosed,false,0,true);
            this.mcSaveSlotListModule.mcScrollingList.addEventListener(ListEvent.INDEX_CHANGE,this.onSaveSlotSelected,false,0,true);
         }
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.entries",[this.handleEntriesSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.addloading",[this.handleAddLoadingOption]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.gamepad.mappings",[this.handleGamepadInfoRecieved]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.loadSlots",[this.handleRecievedLoadSlots]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.saveSlots",[this.handleRecievedSaveSlots]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.importSlots",[this.handleReceivedImportSlots]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.newGamePlusSlots",[this.handleReceivedNewGamePlusSlots]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.uirescale",[this.handleSetUIRescale]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.options.entries",[this.handleOptionsSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.optionValueChanges",[this.handleOptionValuesUpdated]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.keybindValues",[this.handleKeybindValuesSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.installedDLCs",[this.handleInstalledDLCsSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.bigMessage1",[this.prepareBigMessageEp1]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.bigMessage2",[this.prepareBigMessageEp2]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.bigMessage3",[this.prepareBigMessageGOTY]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.bigMessage4",[this.prepareBigMessageGalaxySignIn]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.framerateModeTooltip",[this.handleSetFramrateModeTooltip]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.TelemetryModalWindow",[this.setDataTelemetryModalWindow]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.ErrorHandleWindow",[this.setErrorHandlingWindow]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.RewardsTableWindow",[this.setGalaxyRewardsWindow]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.AccountsTermsOfUseWindow",[this.setTermsOfUseWindow]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"ingamemenu.gogCloudState",[this.setGogCloudState]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",false);
         this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",true);
      }
      
      public function setExpansionText(param1:String, param2:String) : void
      {
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         if(this.mcExpansionIcons)
         {
            this.mcExpansionIcons.visible = true;
            this.expansionIconsEnabled = true;
            _loc3_ = this.mcExpansionIcons.getChildByName("txtEp1") as TextField;
            if(_loc3_ != null)
            {
               _loc3_.htmlText = param1;
            }
            if((_loc4_ = this.mcExpansionIcons.getChildByName("txtEp2") as TextField) != null)
            {
               _loc4_.htmlText = param2;
            }
         }
      }
      
      override public function setPlatform(param1:uint) : void
      {
         super.setPlatform(param1);
         this._platform = param1;
         this._isPlatformXBox = _inputMgr.isXboxPlatform();
         this._isPlatformPlayStation = _inputMgr.isPsPlatform();
         if(this._isMainMenu && this._platform == PlatformType.PLATFORM_XBOX1)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_Y,NavigationCode.GAMEPAD_Y,-1,"[[panel_button_common_choose_profile]]",true);
         }
      }
      
      public function setIgnoreInput(param1:Boolean) : void
      {
         this._ignoreInput = param1;
      }
      
      public function setHardwareCursorOn(param1:Boolean) : void
      {
         this._hardwareCursorOn = param1;
      }
      
      private function getCustomDialogByIndex(param1:int) : MovieClip
      {
         switch(param1)
         {
            case 1:
            case 2:
               return getChildByName("mcCustomDialogEp" + param1) as MovieClip;
            case 3:
               return getChildByName("mcCustomDialogGOTY") as MovieClip;
            case 4:
               return getChildByName("mcCustomDialogGalaxySignIn") as MovieClip;
            default:
               return null;
         }
      }
      
      public function handleSetFramrateModeTooltip(param1:Object) : *
      {
         this.txtFrameRateMode.visible = param1.isVisible;
         if(param1.text)
         {
            this.txtFrameRateMode.text = param1.text;
         }
      }
      
      public function prepareBigMessageEp1(param1:Object) : *
      {
         this.prepareBigMessage(param1);
      }
      
      public function prepareBigMessageEp2(param1:Object) : void
      {
         this.prepareBigMessage(param1);
      }
      
      public function prepareBigMessage(param1:Object) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:MovieClip = this.getCustomDialogByIndex(param1.index);
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.visible = true;
         this.setMessageTextValue(_loc2_,"tfTitle1",param1.tfTitle1,true);
         this.setMessageTextValue(_loc2_,"tfTitle2",param1.tfTitle2,true);
         this.setMessageTextValue(_loc2_,"tfTitlePath1",param1.tfTitlePath1,true,"mcPathTitle");
         this.setMessageTextValue(_loc2_,"tfTitlePath2",param1.tfTitlePath2,true,"mcPathTitle");
         this.setMessageTextValue(_loc2_,"tfTitlePath3",param1.tfTitlePath3,true,"mcPathTitle");
         this.setMessageTextValue(_loc2_,"tfDescPath1",param1.tfDescPath1,false,"mcPathDescription");
         this.setMessageTextValue(_loc2_,"tfDescPath2",param1.tfDescPath2,false,"mcPathDescription");
         this.setMessageTextValue(_loc2_,"tfDescPath3",param1.tfDescPath3,false,"mcPathDescription");
         this.setMessageTextValue(_loc2_,"tfWarning1",param1.tfWarning,false,"mcPathWarning");
         this.setMessageTextValue(_loc2_,"tfWarning2",param1.tfWarning,false,"mcPathWarning");
         this.setMessageTextValue(_loc2_,"tfGoodLuck",param1.tfGoodLuck,true);
         if(this._queuedDialogIndices)
         {
            this._queuedDialogIndices[this._queuedDialogIndices.length] = param1.index;
         }
         this.showNextCustomDialog();
         return true;
      }
      
      public function prepareBigMessageGOTY(param1:Object) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:MovieClip = this.getCustomDialogByIndex(param1.index);
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.visible = true;
         this.setMessageTextValue(_loc2_,"tfTitle1",param1.tfTitle1,true);
         this.setMessageTextValue(_loc2_,"tfContent",param1.tfContent,false);
         this.setMessageTextValue(_loc2_,"tfTitleEnd",param1.tfTitleEnd,true);
         if(this._queuedDialogIndices)
         {
            this._queuedDialogIndices[this._queuedDialogIndices.length] = param1.index;
         }
         this.showNextCustomDialog();
         return true;
      }
      
      public function prepareBigMessageGalaxySignIn(param1:Object) : Boolean
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return false;
         }
         var _loc2_:MovieClip = this.getCustomDialogByIndex(param1.index);
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.visible = true;
         this.setMessageTextValue(_loc2_,"tfTitleSignIn",param1.tfTitleSignIn,false);
         this.setMessageTextValue(_loc2_,"tfContentSignInTopA",param1.tfContentSignInTopA,false);
         this.setMessageTextValue(_loc2_,"tfContentSignInTopB",param1.tfContentSignInTopB,false);
         this.setMessageTextValue(_loc2_,"tfContentSignIn2",param1.tfContentSignIn2,false);
         this.setMessageTextValue(_loc2_,"tfContentSignIn3",param1.tfContentSignIn3,false);
         this.setMessageTextValue(_loc2_,"tfLink1",param1.tfLink1,false);
         var _loc3_:W3UILoader = this.mcCustomDialogGalaxySignIn.getChildByName("mcQrCodeLoader") as W3UILoader;
         if(_loc3_)
         {
            _loc3_.visible = false;
            _loc3_.source = "";
         }
         if(param1.isPlatformPC)
         {
            (_loc5_ = _loc2_.getChildByName("textFieldBackground") as MovieClip).visible = false;
         }
         if(this._queuedDialogIndices)
         {
            this._queuedDialogIndices[this._queuedDialogIndices.length] = param1.index;
         }
         var _loc4_:InputFeedbackButton;
         if(_loc4_ = _loc2_.getChildByName("mcCancelButton") as InputFeedbackButton)
         {
            _loc6_ = 227;
            _loc4_.x = 513 + _loc6_;
            if(_loc7_ = _loc2_.getChildByName("brEscBorder") as DisplayObject)
            {
               _loc7_.x = 468 + _loc6_;
               _loc7_.visible = false;
            }
            _loc4_.visible = true;
            _loc4_.clickable = true;
            _loc4_.label = "[[panel_common_cancel]]";
            _loc4_.setShiftForGamepad(26,0);
            _loc4_.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
            _loc4_.addEventListener(ButtonEvent.PRESS,this.showBigMessageFinished4,false,0,true);
            _loc4_.validateNow();
         }
         this.setupTermsButton(_loc2_);
         this.hideNavButtonsMainMenu();
         return true;
      }
      
      public function closeGalaxySignInDialog() : *
      {
         if(this.mcCustomDialogGalaxySignIn)
         {
            if(this.mcCustomDialogGalaxySignIn.visible)
            {
               this.showNavButtonsMainMenu();
            }
            this.mcCustomDialogGalaxySignIn.visible = false;
         }
      }
      
      public function ShowCloudModal(param1:String) : *
      {
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         var _loc7_:InputFeedbackButton = null;
         if(!this.mcCloudSavesModalDialog)
         {
            return;
         }
         var _loc4_:TextField;
         if((_loc4_ = this.mcCloudSavesModalDialog.getChildByName("tfPersonaName") as TextField) != null)
         {
            _loc4_.htmlText = param1;
         }
         _loc2_ = _loc4_;
         if((_loc4_ = this.mcCloudSavesModalDialog.getChildByName("tfTitle") as TextField) != null)
         {
            _loc4_.htmlText = "[[ui_gog_cloud_saves_title]]";
         }
         if((_loc4_ = this.mcCloudSavesModalDialog.getChildByName("tfExplain") as TextField) != null)
         {
            _loc4_.htmlText = "[[ui_gog_cloud_saves_explained]]";
         }
         if((_loc4_ = this.mcCloudSavesModalDialog.getChildByName("tfLoggedIn") as TextField) != null)
         {
            _loc4_.htmlText = "[[ui_gog_cloud_logged_in]]";
         }
         _loc3_ = _loc4_;
         var _loc5_:TextFormat = new TextFormat();
         if(CoreComponent.isArabicAligmentMode)
         {
            _loc2_.x = -146.05;
            _loc3_.x = 220.05;
            _loc5_.align = "right";
            _loc2_.setTextFormat(_loc5_);
            _loc5_.align = "left";
            _loc3_.setTextFormat(_loc5_);
         }
         else
         {
            _loc2_.x = 220.05;
            _loc3_.x = -146.05;
            _loc5_.align = "left";
            _loc2_.setTextFormat(_loc5_);
            _loc5_.align = "right";
            _loc3_.setTextFormat(_loc5_);
         }
         if(this._platform != PlatformType.PLATFORM_PC)
         {
            if(!(_loc7_ = this.mcCloudSavesModalDialog.getChildByName("mcSignOutButton") as InputFeedbackButton))
            {
               return;
            }
            _loc7_.visible = true;
            _loc7_.clickable = true;
            _loc7_.label = "[[ui_gog_button_signout]]";
            _loc7_.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.Q);
            _loc7_.addEventListener(ButtonEvent.PRESS,this.feedbackRewardsWindow,false,0,false);
            _loc7_.validateNow();
         }
         var _loc6_:InputFeedbackButton;
         if(!(_loc6_ = this.mcCloudSavesModalDialog.getChildByName("mcAcceptButton") as InputFeedbackButton))
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.clickable = true;
         _loc6_.label = "[[panel_common_accept]]";
         _loc6_.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
         _loc6_.addEventListener(ButtonEvent.PRESS,this.feedbackRewardsWindow,false,0,false);
         _loc6_.validateNow();
         if(this._platform == PlatformType.PLATFORM_PC)
         {
            _loc6_.x = 146.6;
            _loc6_.setShiftForGamepad(10,0);
         }
         else
         {
            _loc6_.x = 317.65;
            _loc6_.setShiftForGamepad(20,0);
         }
         if(this.mcInputFeedbackModule)
         {
            this.mcInputFeedbackModule.setVisibility(false);
         }
         this.mcCloudSavesModalDialog.visible = true;
      }
      
      public function GalaxyQRSignInCancel() : *
      {
         this.closeGalaxySignInDialog();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnGalaxyQRSignInCancel"));
      }
      
      public function QRCodeReadyToLoad(param1:String) : *
      {
         if(this._lastRequestedUrl != param1)
         {
            this._lastRequestedUrl = param1;
         }
         if(!this.mcCustomDialogGalaxySignIn)
         {
            return;
         }
         var _loc2_:W3UILoader = this.mcCustomDialogGalaxySignIn.getChildByName("mcQrCodeLoader") as W3UILoader;
         if(_loc2_)
         {
            _loc2_.source = "qrcode.qrcode";
            _loc2_.visible = true;
            _loc2_.validateNow();
         }
         var _loc3_:TextField = this.mcCustomDialogGalaxySignIn.getChildByName("tfLink1") as TextField;
         _loc3_.addEventListener(MouseEvent.CLICK,this.handleTfUrl,false,0,true);
         if(_loc3_.htmlText != this._lastRequestedUrl)
         {
            _loc3_.htmlText = this._lastRequestedUrl;
         }
      }
      
      protected function handleTfUrl() : *
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnVisitSignInPage"));
      }
      
      public function setDataTelemetryModalWindow(param1:Object) : Boolean
      {
         if(!param1 || !this.mcCustomDialogTelemetry)
         {
            this._consentPopupWasShown = false;
            return false;
         }
         this.mcCustomDialogTelemetry.visible = true;
         this.setMessageTextValue(this.mcCustomDialogTelemetry,"tfTelemetryTitle",param1.tfTelemetryTitle,false);
         this.setMessageTextValue(this.mcCustomDialogTelemetry,"tfTelemetryContent",param1.tfTelemetryContent,false);
         this.setMessageTextValue(this.mcCustomDialogTelemetry,"tfTelemetryContent2",param1.tfTelemetryContent2,false);
         this.setMessageTextValue(this.mcCustomDialogTelemetry,"tfTelemetryFooter",param1.tfTelemetryFooter,false);
         this.setMessageTextValue(this.mcCustomDialogTelemetry,"tfTelemetryFooter2",param1.tfTelemetryFooter2,false);
         var _loc2_:InputFeedbackButton = this.mcCustomDialogTelemetry.getChildByName("mcAcceptButton") as InputFeedbackButton;
         var _loc3_:InputFeedbackButton = this.mcCustomDialogTelemetry.getChildByName("mcCancelButton") as InputFeedbackButton;
         if(!_loc2_ || !_loc3_)
         {
            this._consentPopupWasShown = false;
            return false;
         }
         _loc2_.visible = true;
         _loc2_.clickable = true;
         _loc2_.label = "[[ui_gog_tel_consent_yes]]";
         _loc2_.setShiftForGamepad(15,0);
         _loc2_.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
         _loc2_.addEventListener(ButtonEvent.PRESS,this.feedbackTelemetryDialogAccept,false,0,true);
         _loc2_.validateNow();
         _loc3_.visible = true;
         _loc3_.clickable = true;
         _loc3_.label = "[[ui_gog_tel_consent_no]]";
         _loc3_.setShiftForGamepad(29,4);
         _loc3_.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
         _loc3_.addEventListener(ButtonEvent.PRESS,this.feedbackTelemetryDialogCancel,false,0,true);
         _loc3_.validateNow();
         this._consentPopupWasShown = true;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConsentPopupWasShown",[this._consentPopupWasShown]));
         return true;
      }
      
      private function feedbackViewTerms(param1:ButtonEvent) : void
      {
         this.setTermsOfUseWindow(null);
      }
      
      private function setupTermsButton(param1:MovieClip) : void
      {
         var _loc2_:InputFeedbackButton = param1.getChildByName("mcTermsButton") as InputFeedbackButton;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:DisplayObject = param1.getChildByName("brTermsBorder") as DisplayObject;
         if(_loc3_)
         {
            _loc3_.visible = false;
         }
         _loc2_.visible = false;
      }
      
      private function feedbackTelemetryDialogAccept(param1:ButtonEvent) : void
      {
         if(this.mcCustomDialogTelemetry)
         {
            this.mcCustomDialogTelemetry.visible = false;
            this._telemetryConsent = true;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTelemetryConsentChanged",[this._telemetryConsent]));
         }
      }
      
      private function feedbackTelemetryDialogCancel(param1:ButtonEvent) : void
      {
         if(this.mcCustomDialogTelemetry)
         {
            this.mcCustomDialogTelemetry.visible = false;
            this._telemetryConsent = false;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnTelemetryConsentChanged",[this._telemetryConsent]));
         }
      }
      
      public function setErrorHandlingWindow(param1:Object) : *
      {
         if(!param1 || !this.mcErrorDialog)
         {
            return false;
         }
         this.closeGalaxySignInDialog();
         this.mcErrorDialog.visible = true;
         this.setMessageTextValue(this.mcErrorDialog,"tfTitleError",param1.tfTitleError,false);
         this.setMessageTextValue(this.mcErrorDialog,"tfDescription",param1.tfDescription,false);
         var _loc2_:InputFeedbackButton = this.mcErrorDialog.getChildByName("mcTryButton") as InputFeedbackButton;
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_.visible = true;
         _loc2_.clickable = true;
         _loc2_.label = "[[ui_gog_error_close_button]]";
         _loc2_.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.ENTER);
         _loc2_.addEventListener(ButtonEvent.PRESS,this.feedbackErrorHandling,false,0,false);
         _loc2_.validateNow();
      }
      
      public function hideErrorHandlingWindow() : void
      {
         if(this.mcErrorDialog)
         {
            this.mcErrorDialog.visible = false;
         }
      }
      
      private function feedbackRewardsWindow(param1:ButtonEvent) : void
      {
         if(this.mcRewardsTable)
         {
            this.mcRewardsTable.visible = false;
         }
         if(this.mcCloudSavesModalDialog)
         {
            this.mcCloudSavesModalDialog.visible = false;
         }
         if(this.mcInputFeedbackModule)
         {
            this.mcInputFeedbackModule.setVisibility(true);
         }
      }
      
      private function setRewardCellContents(param1:String, param2:Boolean, param3:String, param4:String) : void
      {
         var _loc5_:TextField = null;
         var _loc8_:TextFormat = null;
         if(_loc5_ = this.mcRewardsTable.getChildByName("tf" + param1 + "desc") as TextField)
         {
            _loc5_.visible = param2;
            if(param2)
            {
               if(CoreComponent.isArabicAligmentMode)
               {
                  _loc5_.htmlText = "<p align=\"right\">" + "[[ui_gog_reward_" + param4 + "]]" + "</p>";
               }
               else
               {
                  _loc5_.htmlText = "<p align=\"left\">" + "[[ui_gog_reward_" + param4 + "]]" + "</p>";
               }
            }
         }
         if(_loc5_ = this.mcRewardsTable.getChildByName("tf" + param1 + "title") as TextField)
         {
            _loc5_.visible = param2;
            if(param2)
            {
               _loc8_ = new TextFormat();
               if(CoreComponent.isArabicAligmentMode)
               {
                  _loc5_.htmlText = "<p align=\"right\">" + "[[ui_gog_reward_" + param3 + "]]" + "</p>";
                  _loc8_.font = "$NormalFont";
               }
               else
               {
                  _loc5_.htmlText = "<p align=\"left\">" + "[[ui_gog_reward_" + param3 + "]]" + "</p>";
                  _loc8_.font = "$BoldFont";
               }
               _loc5_.setTextFormat(_loc8_);
            }
         }
         var _loc6_:W3UILoader;
         if(_loc6_ = this.mcRewardsTable.getChildByName("mc" + param1 + "loader") as W3UILoader)
         {
            _loc6_.visible = param2;
            if(param2)
            {
               _loc6_.source = "img://icons/inventory/armors/gog_rwd_" + param3 + ".png";
            }
         }
         var _loc7_:DisplayObject;
         if(_loc7_ = this.mcRewardsTable.getChildByName("tf" + param1 + "back") as DisplayObject)
         {
            _loc7_.visible = param2;
         }
      }
      
      public function setGalaxyRewardsWindow(param1:Object) : *
      {
         var _loc5_:InputFeedbackButton = null;
         if(!param1 || !this.mcRewardsTable)
         {
            return false;
         }
         this.mcRewardsTable.visible = true;
         this.setMessageTextValue(this.mcRewardsTable,"tfTitleRewards",param1.tfTitleRewards,true);
         this.setMessageTextValue(this.mcRewardsTable,"tfTitleLink",param1.tfTitleLink,false);
         this.setMessageTextValue(this.mcRewardsTable,"tfTopDescription",param1.tfTopDescription,false);
         this.setMessageTextValue(this.mcRewardsTable,"tfRoachDescription",param1.tfRoachDescription,false);
         this.setRewardCellContents("Cell_1_1",param1.bCell_1_1on,param1.tfCell_1_1title,param1.tfCell_1_1desc);
         this.setRewardCellContents("Cell_1_2",param1.bCell_1_2on,param1.tfCell_1_2title,param1.tfCell_1_2desc);
         this.setRewardCellContents("Cell_2_1",param1.bCell_2_1on,param1.tfCell_2_1title,param1.tfCell_2_1desc);
         this.setRewardCellContents("Cell_2_2",param1.bCell_2_2on,param1.tfCell_2_2title,param1.tfCell_2_2desc);
         this.setRewardCellContents("Cell_3_1",param1.bCell_3_1on,param1.tfCell_3_1title,param1.tfCell_3_1desc);
         this.setRewardCellContents("Cell_3_2",param1.bCell_3_2on,param1.tfCell_3_2title,param1.tfCell_3_2desc);
         this.setRewardCellContents("Cell_4_1",param1.bCell_4_1on,param1.tfCell_4_1title,param1.tfCell_4_1desc);
         this.setRewardCellContents("Cell_4_2",param1.bCell_4_2on,param1.tfCell_4_2title,param1.tfCell_4_2desc);
         this.setRewardCellContents("Cell_5_1",param1.bCell_5_1on,param1.tfCell_5_1title,param1.tfCell_5_1desc);
         this.setRewardCellContents("Cell_5_2",param1.bCell_5_2on,param1.tfCell_5_2title,param1.tfCell_5_2desc);
         var _loc2_:InputFeedbackButton = this.mcRewardsTable.getChildByName("mcTryButton") as InputFeedbackButton;
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.visible = true;
         _loc2_.clickable = true;
         _loc2_.label = "[[panel_common_accept]]";
         _loc2_.x = 1276;
         _loc2_.setShiftForGamepad(20,0);
         _loc2_.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
         _loc2_.addEventListener(ButtonEvent.PRESS,this.feedbackRewardsWindow,false,0,false);
         _loc2_.validateNow();
         if(this._platform != PlatformType.PLATFORM_PC)
         {
            if(!(_loc5_ = this.mcRewardsTable.getChildByName("mcUnlinkButton") as InputFeedbackButton))
            {
               return false;
            }
            _loc5_.visible = true;
            _loc5_.clickable = true;
            _loc5_.label = "[[ui_gog_button_signout]]";
            _loc5_.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.Q);
            _loc5_.addEventListener(ButtonEvent.PRESS,this.feedbackRewardsWindow,false,0,false);
            _loc5_.validateNow();
         }
         this.setupTermsButton(this.mcRewardsTable);
         this.hideNavButtonsMainMenu();
         var _loc3_:DisplayObject = this.mcRewardsTable.getChildByName("brTryBorder") as DisplayObject;
         if(_loc3_)
         {
            _loc3_.visible = false;
         }
         var _loc4_:DisplayObject;
         if(_loc4_ = this.mcRewardsTable.getChildByName("brUnlinkBorder") as DisplayObject)
         {
            _loc4_.visible = false;
         }
      }
      
      private function hideNavButtonsMainMenu() : void
      {
         if(this.mcInputFeedbackModule)
         {
            this._hidNavButtUse = this.mcInputFeedbackModule.removeButton(ACTION_USE,true);
            this._hidNavButtStick = this.mcInputFeedbackModule.removeButton(ACTION_SCROLL,true);
            this._hidNavButtProfile = this.mcInputFeedbackModule.removeButton(ACTION_Y,true);
            this.mcInputFeedbackModule.removeButton(ACTION_X,true);
            this.mcInputFeedbackModule.removeButton(ACTION_CLOSE,true);
         }
      }
      
      private function showNavButtonsMainMenu() : void
      {
         if(this._hidNavButtUse)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
         }
         if(this._hidNavButtStick)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",true);
         }
         if(this._hidNavButtProfile)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_Y,NavigationCode.GAMEPAD_Y,-1,"[[panel_button_common_choose_profile]]",true);
         }
      }
      
      private function showNavButtonsSaves() : void
      {
         if(this._hidNavButtUse)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
         }
         if(this._hidNavButtStick)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",true);
         }
         if(this._hidNavButtProfile)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_Y,NavigationCode.GAMEPAD_Y,-1,"[[panel_button_common_choose_profile]]",true);
         }
      }
      
      private function feedbackTermsOfUse(param1:ButtonEvent) : void
      {
         if(this.mcTermsOfUseDialog)
         {
            this.mcTermsOfUseDialog.visible = false;
         }
      }
      
      private function chooseTermsOfUseText() : String
      {
         return "[[ui_gog_terms_big_text_xb1]]";
      }
      
      public function setTermsOfUseWindow(param1:Object) : *
      {
         return false;
      }
      
      public function DLSSIsSupported(param1:Boolean, param2:uint) : *
      {
         _DLSSIsSupported = param1;
         if(AAModeIntTag == 0)
         {
            AAModeIntTag = param2;
         }
      }
      
      public function RTEnabled(param1:Boolean, param2:uint) : *
      {
         _RTEnabled = param1;
         if(Virtual_SSAOSolutionIntTag == 0)
         {
            Virtual_SSAOSolutionIntTag = param2;
         }
      }
      
      private function feedbackErrorHandling(param1:ButtonEvent) : void
      {
         if(this.mcErrorDialog)
         {
            this.mcErrorDialog.visible = false;
         }
      }
      
      private function showNextCustomDialog() : *
      {
         if(this._currentDialogIndex == -1)
         {
            if(this._queuedDialogIndices.length > 0)
            {
               this._currentDialogIndex = this._queuedDialogIndices[0];
               this.showBigMessageByIndex(this._currentDialogIndex);
            }
         }
      }
      
      public function showBigMessageByIndex(param1:int) : void
      {
         var _loc2_:MovieClip = this.getCustomDialogByIndex(param1);
         if(_loc2_)
         {
            this.showBigMessage(_loc2_);
         }
      }
      
      private function showBigMessage(param1:MovieClip) : *
      {
         param1.gotoAndPlay(2);
         var _loc2_:MovieClip = param1.getChildByName("animTitleGlow1") as MovieClip;
         var _loc3_:MovieClip = param1.getChildByName("animTitleGlow2") as MovieClip;
         var _loc4_:MovieClip = param1.getChildByName("animTitleGlow3") as MovieClip;
         if(_loc2_)
         {
            _loc2_.gotoAndPlay(2);
         }
         if(_loc3_)
         {
            _loc3_.gotoAndPlay(2);
         }
         if(_loc4_)
         {
            _loc4_.gotoAndPlay(2);
         }
         this.createDialogTimer();
         var _loc5_:InputFeedbackButton;
         if((_loc5_ = param1.getChildByName("mcOkButton") as InputFeedbackButton) != null)
         {
            _loc5_.visible = false;
         }
      }
      
      private function createDialogTimer() : *
      {
         this.removeDialogTimer();
         this._currentDialogTimer = new Timer(5000);
         this._currentDialogTimer.addEventListener(TimerEvent.TIMER,this.handleCurrentDialogTimer,false,0,true);
         this._currentDialogTimer.start();
      }
      
      private function removeDialogTimer() : *
      {
         if(this._currentDialogTimer)
         {
            this._currentDialogTimer.stop();
            this._currentDialogTimer.removeEventListener(TimerEvent.TIMER,this.handleCurrentDialogTimer);
            this._currentDialogTimer = null;
         }
      }
      
      private function handleCurrentDialogTimer(param1:TimerEvent) : *
      {
         var _loc3_:InputFeedbackButton = null;
         var _loc2_:MovieClip = this.getCustomDialogByIndex(this._currentDialogIndex);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getChildByName("mcOkButton") as InputFeedbackButton;
            if(_loc3_ != null)
            {
               _loc3_.visible = true;
               _loc3_.clickable = true;
               _loc3_.label = "[[panel_common_ok]]";
               _loc3_.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.E);
               if(_loc2_ == this.mcCustomDialogEp1)
               {
                  _loc3_.addEventListener(ButtonEvent.PRESS,this.showBigMessageFinished1,false,0,true);
               }
               else if(_loc2_ == this.mcCustomDialogEp2)
               {
                  _loc3_.addEventListener(ButtonEvent.PRESS,this.showBigMessageFinished2,false,0,true);
               }
               else if(_loc2_ == this.mcCustomDialogGOTY)
               {
                  _loc3_.addEventListener(ButtonEvent.PRESS,this.showBigMessageFinished3,false,0,true);
               }
               _loc3_.validateNow();
            }
         }
         this.removeDialogTimer();
      }
      
      private function closeCustomDialog(param1:int, param2:Boolean = true) : *
      {
         if(this._currentDialogTimer)
         {
            return;
         }
         var _loc3_:MovieClip = this.getCustomDialogByIndex(param1);
         if(_loc3_)
         {
            _loc3_.visible = false;
            if(param2)
            {
               this._currentDialogIndex = -1;
               if(this._queuedDialogIndices.length > 0)
               {
                  this._queuedDialogIndices.splice(0,1);
               }
               this.showNextCustomDialog();
            }
         }
      }
      
      private function setMessageTextValue(param1:MovieClip, param2:String, param3:String, param4:Boolean = false, param5:String = "") : void
      {
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         if(param5 == "")
         {
            _loc6_ = param1.getChildByName(param2) as TextField;
         }
         else
         {
            _loc6_ = (_loc7_ = param1.getChildByName(param5) as MovieClip).getChildByName(param2) as TextField;
         }
         if(_loc6_ != null)
         {
            if(param3)
            {
               if(param4)
               {
                  _loc6_.htmlText = CommonUtils.toUpperCaseSafe(param3);
               }
               else
               {
                  _loc6_.htmlText = param3;
               }
               _loc6_.visible = true;
            }
            else
            {
               _loc6_.visible = false;
            }
         }
      }
      
      protected function showBigMessageFinished1(param1:ButtonEvent) : void
      {
         this.closeCustomDialog(1);
      }
      
      protected function showBigMessageFinished2(param1:ButtonEvent) : void
      {
         this.closeCustomDialog(2);
      }
      
      protected function showBigMessageFinished3(param1:ButtonEvent) : void
      {
         this.closeCustomDialog(3);
      }
      
      protected function showBigMessageFinished4(param1:ButtonEvent) : void
      {
         this.GalaxyQRSignInCancel();
      }
      
      public function updateInputFeedback() : void
      {
         if(this.mcInputFeedbackModule)
         {
            this.mcInputFeedbackModule.buttonsContainer.visible = false;
         }
         if(!this._fontLoadTimer)
         {
            this._fontLoadTimer = new Timer(this._fontLoadDelay);
            this._fontLoadTimer.addEventListener(TimerEvent.TIMER,this.delayedUpdateInputFeedback,false,0,true);
         }
         this._fontLoadTimer.reset();
         this._fontLoadTimer.start();
      }
      
      public function delayedUpdateInputFeedback(param1:Event = null) : void
      {
         if(this._fontLoadTimer)
         {
            this._fontLoadTimer.stop();
            this._fontLoadTimer.removeEventListener(TimerEvent.TIMER,this.delayedUpdateInputFeedback,false);
            this._fontLoadTimer = null;
         }
         if(this.mcInputFeedbackModule)
         {
            this.mcInputFeedbackModule.refreshButtonList();
            this.mcInputFeedbackModule.buttonsContainer.visible = true;
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         visible = param1;
      }
      
      public function setPanelMode(param1:Boolean) : void
      {
         this._panelMode = param1;
         this.inPanel = param1;
         this.menuListModule.visible = !param1;
      }
      
      override protected function get menuName() : String
      {
         return "IngameMenu";
      }
      
      override protected function closeMenu() : void
      {
         var _loc1_:InputManager = null;
         _loc1_ = InputManager.getInstance();
         _loc1_.reset();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnBack"));
      }
      
      override protected function showAnimation() : void
      {
         visible = true;
         alpha = 0;
         GTweener.to(this,SHOW_ANIM_DURATION,{"alpha":1},{
            "ease":Exponential.easeOut,
            "onComplete":handleShowAnimComplete
         });
      }
      
      override protected function hideAnimation() : void
      {
         if(!this._hideAnimationPlaying)
         {
            this._hideAnimationPlaying = true;
            GTweener.removeTweens(this);
            GTweener.to(this,0.3,{"alpha":0},{
               "ease":Exponential.easeOut,
               "onComplete":handleHideAnimComplete
            });
         }
      }
      
      public function setForceBackgroundVisible(param1:Boolean) : void
      {
         if(this.mcBlackBackground)
         {
            this.mcBlackBackground.backgroundForceVisible = param1;
         }
      }
      
      public function setCurrentUsername(param1:String) : void
      {
         if(this.txtUserName)
         {
            this.txtUserName.text = param1;
         }
      }
      
      public function setVersion(param1:String) : void
      {
         if(this.txtVersion)
         {
            this.txtVersion.text = param1;
         }
      }
      
      public function removeOption(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         if(this.rootData != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.rootData.length)
            {
               _loc3_ = this.rootData[_loc2_];
               if(_loc3_.tag == param1)
               {
                  this.rootData.splice(_loc2_,1);
                  _loc4_ = true;
                  break;
               }
               _loc2_++;
            }
         }
         if(_loc4_)
         {
            this.refreshRootData();
         }
      }
      
      protected function handleEntriesSet(param1:Array) : void
      {
         this.rootData = param1;
         while(this.previousContainers.length > 0)
         {
            this.handleNavigateBack();
         }
         this.setListData(new DataProvider(this.rootData));
      }
      
      protected function refreshRootData() : void
      {
         if(this.previousContainers.length == 0)
         {
            this.setListData(new DataProvider(this.rootData),this.menuListModule.mcList.selectedIndex);
         }
         else
         {
            if(this.previousContainers.length == 1 && this.inPanel == true)
            {
               this.setListData(new DataProvider(this.rootData),this.menuListModule.mcList.selectedIndex);
            }
            this.previousEntries[0] = new DataProvider(this.rootData);
         }
      }
      
      protected function handleAddLoadingOption(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = -1;
         _loc2_ = 0;
         while(_loc2_ < this.rootData.length)
         {
            if(this.rootData[_loc2_].type == IGMActionType_Load)
            {
               return;
            }
            if(this.rootData[_loc2_].type == IGMActionType_Save)
            {
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         if(_loc3_ != -1)
         {
            this.rootData.splice(_loc3_ + 1,0,param1);
         }
         this.refreshRootData();
      }
      
      protected function setListData(param1:DataProvider, param2:int = 0) : void
      {
         this.menuListModule.setListData(param1,param2);
      }
      
      public function activateMenuListItem() : void
      {
         var _loc1_:BaseListItem = this.menuListModule.mcList.getRendererAt(this.menuListModule.mcList.selectedIndex) as BaseListItem;
         if(!_loc1_ || !_loc1_.data)
         {
            return;
         }
         if(this.mcCustomDialogEp1 != null && this.mcCustomDialogEp1.visible || this.mcCustomDialogEp2 != null && this.mcCustomDialogEp2.visible || this.mcCustomDialogGOTY != null && this.mcCustomDialogGOTY.visible || this.mcCustomDialogGalaxySignIn != null && this.mcCustomDialogGalaxySignIn.visible)
         {
            return;
         }
         var _loc2_:Object = _loc1_.data;
         var _loc3_:int = int(_loc2_.tag);
         var _loc4_:int = int(_loc2_.type);
         if(_loc2_.unavailable)
         {
            return;
         }
         if(this.inPanel)
         {
            if(this.previousContainers.length > 0 && this.previousContainers[this.previousContainers.length - 1] == _loc2_)
            {
               return;
            }
            this.handleNavigateBack();
            if(_loc4_ == IGMActionType_Back)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnItemActivated",[_loc4_,_loc3_]));
               return;
            }
         }
         if(!this.handleEntrySelected(_loc2_))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnItemActivated",[_loc4_,_loc3_]));
         }
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         if(!visible || this._ignoreInput)
         {
            param1.handled = true;
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc4_:* = _loc2_.value == InputValue.KEY_DOWN;
         if(this.mcCustomDialogEp1 != null && this.mcCustomDialogEp1.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.E))
            {
               this.closeCustomDialog(1);
            }
            param1.handled = true;
            return;
         }
         if(this.mcCustomDialogEp2 != null && this.mcCustomDialogEp2.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.E))
            {
               this.closeCustomDialog(2);
            }
            param1.handled = true;
            return;
         }
         if(this.mcCustomDialogGOTY != null && this.mcCustomDialogGOTY.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.E))
            {
               this.closeCustomDialog(3);
            }
            param1.handled = true;
            return;
         }
         if(this.mcErrorDialog != null && this.mcErrorDialog.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_X || _loc2_.code == KeyCode.ENTER))
            {
               this.mcErrorDialog.visible = false;
            }
            param1.handled = true;
            return;
         }
         if(this.mcTermsOfUseDialog != null && this.mcTermsOfUseDialog.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_X || _loc2_.code == KeyCode.ENTER))
            {
               this.mcTermsOfUseDialog.visible = false;
            }
            param1.handled = true;
            return;
         }
         if(this.mcCustomDialogGalaxySignIn != null && this.mcCustomDialogGalaxySignIn.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_B || _loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.ESCAPE))
            {
               this.GalaxyQRSignInCancel();
            }
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_Y || _loc2_.code == KeyCode.T))
            {
               this.setTermsOfUseWindow(null);
            }
            param1.handled = true;
            return;
         }
         if(this.mcCustomDialogTelemetry != null && this.mcCustomDialogTelemetry.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_B || _loc2_.code == KeyCode.ESCAPE))
            {
               this.mcCustomDialogTelemetry.visible = false;
               this._telemetryConsent = false;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnTelemetryConsentChanged",[this._telemetryConsent]));
            }
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.E))
            {
               this.mcCustomDialogTelemetry.visible = false;
               this._telemetryConsent = true;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnTelemetryConsentChanged",[this._telemetryConsent]));
            }
            param1.handled = true;
            return;
         }
         if(this.mcRewardsTable != null && this.mcRewardsTable.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.ENTER))
            {
               this.mcRewardsTable.visible = false;
            }
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_Y || _loc2_.code == KeyCode.T))
            {
               this.setTermsOfUseWindow(null);
            }
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_X || _loc2_.code == KeyCode.Q) && this._platform != PlatformType.PLATFORM_PC)
            {
               this.mcRewardsTable.visible = false;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnGalaxyUnlinkAccounts"));
            }
            if(!this.mcRewardsTable.visible)
            {
               this.showNavButtonsMainMenu();
            }
            param1.handled = true;
            return;
         }
         if(this.mcCloudSavesModalDialog != null && this.mcCloudSavesModalDialog.visible)
         {
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.ENTER))
            {
               this.mcCloudSavesModalDialog.visible = false;
               this.mcInputFeedbackModule.setVisibility(true);
            }
            if(_loc3_ && (_loc2_.navEquivalent == NavigationCode.GAMEPAD_X || _loc2_.code == KeyCode.Q) && this._platform != PlatformType.PLATFORM_PC)
            {
               this.mcCloudSavesModalDialog.visible = false;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnGalaxyUnlinkAccounts"));
               this.handleNavigateBack();
               this.mcInputFeedbackModule.setVisibility(true);
            }
            param1.handled = true;
            return;
         }
         if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_A && _loc2_.code == KeyCode.SPACE)
         {
            _loc2_.navEquivalent = "";
         }
         if(_loc3_ && !param1.handled)
         {
            if(_loc2_.code == KeyCode.E)
            {
               if(!this.inPanel)
               {
                  param1.handled = true;
                  this.activateMenuListItem();
               }
            }
            else
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_A:
                     if(!this.inPanel)
                     {
                        param1.handled = true;
                        this.activateMenuListItem();
                     }
                     break;
                  case NavigationCode.GAMEPAD_B:
                     if(!this.inPanel && Boolean(_loc2_.code))
                     {
                        if(this.handleNavigateBack())
                        {
                           param1.handled = true;
                        }
                        else if(!this._isMainMenu)
                        {
                           this.hideAnimation();
                           param1.handled = true;
                           param1.stopImmediatePropagation();
                        }
                     }
                     break;
                  case NavigationCode.GAMEPAD_Y:
                     if(this._platform == PlatformType.PLATFORM_XBOX1 && this._isMainMenu)
                     {
                        dispatchEvent(new GameEvent(GameEvent.CALL,"OnProfileChange",[]));
                     }
               }
            }
         }
         if(!this.inPanel)
         {
            this.menuListModule.mcList.handleInput(param1);
         }
         else
         {
            this.mcKeyBindModule.handleInputNavigate(param1);
            this.mcOptionListModule.handleInputNavigate(param1);
            this.mcSaveSlotListModule.handleInputNavigate(param1);
            this.mcGameMappingModule.handleInputNavigate(param1);
            this.mcGammaModule.handleInputNavigate(param1);
            this.mcHelpModule.handleInputNavigate(param1);
            this.mcUIRescaleModule.handleInputNavigate(param1);
            this.mcInstalledDLCModule.handleInputNavigate(param1);
         }
      }
      
      protected function handleOptionsSet(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         _loc2_ = 0;
         while(_loc2_ < this.rootData.length)
         {
            _loc3_ = this.rootData[_loc2_];
            if(_loc3_.type == IGMActionType_Options)
            {
               _loc3_.subElements = param1;
               break;
            }
            _loc2_++;
         }
         this.refreshRootData();
         if(this.expansionIconsEnabled && this.mcExpansionIcons != null)
         {
            this.mcExpansionIcons.visible = false;
         }
         if(this.mcWeibo)
         {
            this.mcWeibo.visible = false;
         }
         this.inPanel = false;
         this.previousEntries.push(this.menuListModule.mcList.dataProvider);
         this.previousContainers.push(_loc3_);
         this.previousSelections.push(this.menuListModule.mcList.selectedIndex);
         if(!this.inPanel)
         {
            this.menuListModule.titleText = _loc3_.listTitle;
         }
         this.setListData(new DataProvider(_loc3_.subElements));
         this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
         this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
         if(this.mcBlackBackground)
         {
            this.mcBlackBackground.backgroundVisible = false;
         }
      }
      
      public function forceEnterCurrentEntry() : void
      {
         var _loc1_:BaseListItem = this.menuListModule.mcList.getRendererAt(this.menuListModule.mcList.selectedIndex) as BaseListItem;
         if(_loc1_)
         {
            if(this.inPanel)
            {
               this.handleNavigateBack();
            }
            this.storeCurrentMenuState(_loc1_.data,false);
            this.setListData(new DataProvider(_loc1_.data.subElements),_loc1_.data.id == "NewGame" ? 1 : 0);
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = false;
            }
         }
      }
      
      protected function handleEntrySelected(param1:Object) : Boolean
      {
         switch(param1.type)
         {
            case IGMActionType_Back:
               this.handleNavigateBack();
               return true;
            case IGMActionType_Options:
               if(!param1.subElements || param1.subElements.length == 0)
               {
                  return false;
               }
               break;
            case IGMActionType_Gog:
               return false;
            case IGMActionType_TelemetryConsent:
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = false;
               }
               return false;
            case IGMActionType_MenuHolder:
               this.storeCurrentMenuState(param1,false);
               this.setListData(new DataProvider(param1.subElements),param1.id == "NewGame" ? 1 : 0);
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = false;
               }
               return false;
            case IGMActionType_MenuLastHolder:
               if(param1.subElements[0].type == IGMActionType_Gamma)
               {
                  this.storeCurrentMenuState(param1,true);
                  if(this.mcInputBackground)
                  {
                     this.mcInputBackground.visible = false;
                  }
                  if(this.menuListModule)
                  {
                     this.menuListModule.visible = false;
                  }
                  if(this.mcBlackBackground)
                  {
                     this.mcBlackBackground.backgroundVisible = true;
                  }
                  this.mcInputFeedbackModule.removeButton(ACTION_USE);
                  this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",true);
                  this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
                  this.mcGammaModule.showWithData(param1.subElements[0]);
                  return false;
               }
               this.storeCurrentMenuState(param1,true);
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnItemActivated",[param1.type,param1.tag]));
               this.mcOptionListModule.showWithData(param1.subElements);
               this.mcInputFeedbackModule.removeButton(ACTION_USE);
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = true;
               }
               return true;
               break;
            case IGMActionType_Close:
               this.hideAnimation();
               return false;
            case IGMActionType_KeyBinds:
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
               this.storeCurrentMenuState(param1,true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = true;
               }
               return false;
            case IGMActionType_ControllerHelp:
               this.mcInputFeedbackModule.removeButton(ACTION_USE,true);
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
               this.storeCurrentMenuState(param1,true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = true;
               }
               return false;
            case IGMActionType_Help:
            case IGMActionType_Save:
            case IGMActionType_Load:
            case IGMActionType_ImportSave:
            case IGMActionType_UIRescale:
            case IGMActionType_NewGamePlus:
            case IGMActionType_InstalledDLC:
               this.storeCurrentMenuState(param1,true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = param1.type != IGMActionType_UIRescale;
               }
               return false;
            case IGMActionType_ToggleRender:
               return false;
         }
         return false;
      }
      
      protected function storeCurrentMenuState(param1:Object, param2:Boolean) : void
      {
         if(this.expansionIconsEnabled && this.mcExpansionIcons != null)
         {
            this.mcExpansionIcons.visible = false;
         }
         if(this.mcWeibo)
         {
            this.mcWeibo.visible = false;
         }
         this.inPanel = param2;
         this.previousEntries.push(this.menuListModule.mcList.dataProvider);
         this.previousContainers.push(param1);
         this.previousSelections.push(this.menuListModule.mcList.selectedIndex);
         if(!this.inPanel)
         {
            this.menuListModule.titleText = param1.listTitle;
         }
      }
      
      protected function onStageClicked(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            if(!this._isMainMenu && (this.previousContainers.length == 0 || this._panelMode))
            {
               this.closeMenu();
            }
            else if(!this.inPanel)
            {
               this.handleNavigateBack();
            }
            else
            {
               if(this.mcOptionListModule)
               {
                  this.mcOptionListModule.onRightClick(param1);
               }
               if(this.mcSaveSlotListModule)
               {
                  this.mcSaveSlotListModule.onRightClick(param1);
               }
               if(this.mcGameMappingModule)
               {
                  this.mcGameMappingModule.onRightClick(param1);
               }
               if(this.mcGammaModule)
               {
                  this.mcGammaModule.onRightClick(param1);
               }
               if(this.mcKeyBindModule)
               {
                  this.mcKeyBindModule.onRightClick(param1);
               }
               if(this.mcInstalledDLCModule)
               {
                  this.mcInstalledDLCModule.onRightClick(param1);
               }
               if(this.mcHelpModule)
               {
                  this.mcHelpModule.onRightClick(param1);
               }
               if(this.mcUIRescaleModule)
               {
                  this.mcUIRescaleModule.onRightClick(param1);
               }
            }
         }
         if(this.mcKeyBindModule)
         {
            this.mcKeyBindModule.onMouseClick(param1);
         }
      }
      
      protected function handleClosePressed(param1:ButtonEvent) : void
      {
         if(this.inPanel)
         {
            if(this.mcOptionListModule.visible)
            {
               this.mcOptionListModule.handleNavigateBack();
            }
            else
            {
               this.handleNavigateBack();
            }
         }
      }
      
      public function handleNavigateBack() : Boolean
      {
         var _loc1_:DataProvider = null;
         var _loc2_:int = 0;
         if(Boolean(this.mcOptionListModule) && this.mcOptionListModule.visible)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionPanelNavigateBack"));
         }
         if(this.menuListModule)
         {
            this.menuListModule.visible = true;
         }
         if(this.mcInputBackground)
         {
            this.mcInputBackground.visible = true;
         }
         if(this.mcOptionListModule)
         {
            this.mcOptionListModule.hide();
         }
         if(this.mcSaveSlotListModule)
         {
            this.mcSaveSlotListModule.hide();
         }
         if(this.mcGameMappingModule)
         {
            this.mcGameMappingModule.hide();
         }
         if(this.mcGammaModule)
         {
            this.mcGammaModule.hide();
         }
         if(this.mcKeyBindModule)
         {
            this.mcKeyBindModule.hide();
         }
         if(this.mcInstalledDLCModule)
         {
            this.mcInstalledDLCModule.hide();
         }
         if(this.mcHelpModule)
         {
            this.mcHelpModule.hide();
         }
         if(this.mcUIRescaleModule)
         {
            this.mcUIRescaleModule.hide();
         }
         this.SetCloudSaveVisibility(false);
         if(this._panelMode)
         {
            stage.visible = false;
            this.closeMenu();
            if(this.expansionIconsEnabled && this.mcExpansionIcons != null && this.previousContainers.length == 0)
            {
               this.mcExpansionIcons.visible = true;
            }
            if(this._enableWeiboLink && !this._panelMode && this.previousContainers.length == 0)
            {
               this.mcWeibo.visible = true;
            }
            return true;
         }
         if(this.previousContainers.length > 0)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnNavigatedBack"));
            _loc1_ = this.previousEntries[this.previousEntries.length - 1];
            _loc2_ = this.previousSelections[this.previousSelections.length - 1];
            this.previousEntries.pop();
            this.previousSelections.pop();
            this.setListData(_loc1_,_loc2_);
            this.mcInputFeedbackModule.removeButton(ACTION_DOWNLOAD,false);
            this.mcInputFeedbackModule.removeButton(ACTION_X,true);
            this.previousContainers.pop();
            if(this.previousContainers.length > 0)
            {
               this.menuListModule.titleText = this.previousContainers[this.previousContainers.length - 1].listTitle;
               this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",false);
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
            }
            else
            {
               this.menuListModule.titleText = "";
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = false;
               }
               if(!this._isMainMenu)
               {
                  this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_button_common_exit]]",false);
               }
               else
               {
                  this.mcInputFeedbackModule.removeButton(ACTION_CLOSE);
               }
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",true);
            }
            this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",false);
            this.mcInputFeedbackModule.removeButton(ACTION_X,true);
            this.inPanel = false;
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = false;
            }
            if(this.expansionIconsEnabled && this.mcExpansionIcons != null && this.previousContainers.length == 0)
            {
               this.mcExpansionIcons.visible = true;
            }
            if(this._enableWeiboLink && this.previousContainers.length == 0)
            {
               this.mcWeibo.visible = true;
            }
            return true;
         }
         return false;
      }
      
      public function updateOptionValue(param1:uint, param2:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:Object = null;
         if((_loc5_ = this.findOptionDataRecursive(param1,this.rootData)) != null)
         {
            _loc5_.current = param2;
            _loc5_.startingValue = param2;
         }
      }
      
      public function updateOptionLabel(param1:uint, param2:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:Object = null;
         if((_loc5_ = this.findOptionDataRecursive(param1,this.rootData)) != null)
         {
            _loc5_.label = param2;
            this.menuListModule.updateSelectedItemText(param2);
         }
      }
      
      private function findOptionDataRecursive(param1:uint, param2:Object) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         if(param2 is Array)
         {
            _loc6_ = param2 as Array;
         }
         else
         {
            if(!(param2 != null && param2.hasOwnProperty("tag")))
            {
               return null;
            }
            if(param2.tag == param1)
            {
               return param2;
            }
            _loc6_ = param2.subElements as Array;
         }
         if(_loc6_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               if((_loc5_ = this.findOptionDataRecursive(param1,_loc6_[_loc3_])) != null)
               {
                  return _loc5_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public function setIsMainMenu(param1:Boolean) : void
      {
         this._isMainMenu = param1;
         if(!this._isMainMenu)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_button_common_exit]]",true);
         }
         else
         {
            if(this._platform == PlatformType.PLATFORM_XBOX1)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_Y,NavigationCode.GAMEPAD_Y,-1,"[[panel_button_common_choose_profile]]",true);
            }
            this.mcInputFeedbackModule.removeButton(ACTION_CLOSE);
         }
      }
      
      protected function handlePanelClosed(param1:Event) : void
      {
         this.handleNavigateBack();
      }
      
      protected function handleGamepadInfoRecieved(param1:Array) : void
      {
         if(this.mcGameMappingModule)
         {
            this.mcGameMappingModule.showWithData(param1,this._platform);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      public function getDeleteSaveString() : String
      {
         if(this._isPlatformPlayStation)
         {
            return "[[panel_mainmenu_deletesave_ps4]]";
         }
         if(this._isPlatformXBox)
         {
            return "[[panel_mainmenu_deletesave_x1]]";
         }
         return "[[panel_mainmenu_deletesave]]";
      }
      
      protected function handleRecievedLoadSlots(param1:Array) : void
      {
         if(Boolean(this.mcSaveSlotListModule) && param1.length > 0)
         {
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = true;
            }
            this.mcSaveSlotListModule.showWithData(param1,SaveSlotListModule.SLOT_MODE_LOAD);
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_loadgame]]",false);
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
            if(param1[0].id != "EMPTY" && param1[0].cloudStatus != CST_CLOUD)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
            }
            this.SetCloudSaveVisibility(true);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleRecievedSaveSlots(param1:Array) : void
      {
         if(Boolean(this.mcSaveSlotListModule) && param1.length > 0)
         {
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = true;
            }
            this.mcSaveSlotListModule.showWithData(param1,SaveSlotListModule.SLOT_MODE_SAVES);
            if(this._isPlatformXBox)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame_x1]]",false);
            }
            else if(this._isPlatformPlayStation)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame_ps4]]",false);
            }
            else
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame]]",false);
            }
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
            if(param1.length > 1 && param1[0].id != "EMPTY" && param1[0].cloudStatus != CST_CLOUD)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
            }
            else
            {
               this.mcInputFeedbackModule.removeButton(ACTION_X,true);
            }
            this.SetCloudSaveVisibility(true);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleReceivedImportSlots(param1:Array) : void
      {
         if(Boolean(this.mcSaveSlotListModule) && param1.length > 0)
         {
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = true;
            }
            this.mcSaveSlotListModule.showWithData(param1,SaveSlotListModule.SLOT_MODE_IMPORT);
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",false);
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleReceivedNewGamePlusSlots(param1:Array) : void
      {
         if(Boolean(this.mcSaveSlotListModule) && param1.length > 0)
         {
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = true;
            }
            this.mcSaveSlotListModule.showWithData(param1,SaveSlotListModule.SLOT_MODE_NEWGAME_PLUS);
            this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",false);
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleSetUIRescale(param1:Object) : void
      {
         if(this.mcUIRescaleModule)
         {
            if(this.mcBlackBackground)
            {
               this.mcBlackBackground.backgroundVisible = false;
            }
            this.mcUIRescaleModule.show(param1);
            this.mcInputFeedbackModule.removeButton(ACTION_USE,true);
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
         }
         else
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleKeybindValuesSet(param1:Array) : void
      {
         this.mcKeyBindModule.showWithData(param1);
      }
      
      protected function handleInstalledDLCsSet(param1:Array) : void
      {
         this.mcInstalledDLCModule.showWithData(param1);
         this.mcInputFeedbackModule.removeButton(ACTION_USE,true);
         if(param1.length < 2)
         {
            this.mcInputFeedbackModule.removeButton(ACTION_SCROLL,true);
         }
      }
      
      public function showHelpPanel() : void
      {
         if(this.mcBlackBackground)
         {
            this.mcBlackBackground.backgroundVisible = true;
         }
         this.mcHelpModule.show();
         this.mcInputFeedbackModule.removeButton(ACTION_USE,true);
         this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
      }
      
      protected function onSaveSlotSelected(param1:ListEvent) : void
      {
         var _loc2_:SaveSlotItemRenderer = null;
         if(this.mcSaveSlotListModule.slotMode != SaveSlotListModule.SLOT_MODE_IMPORT)
         {
            _loc2_ = this.mcSaveSlotListModule.mcScrollingList.getSelectedRenderer() as SaveSlotItemRenderer;
            if(Boolean(_loc2_) && Boolean(_loc2_.data))
            {
               if(_loc2_.data.tag == -1)
               {
                  this.mcInputFeedbackModule.removeButton(ACTION_X,true);
               }
               else if(_loc2_.data.cloudStatus == CST_CLOUD)
               {
                  this.mcInputFeedbackModule.removeButton(ACTION_X,true);
               }
               else if(this.mcSaveSlotListModule.slotMode != SaveSlotListModule.SLOT_MODE_NEWGAME_PLUS)
               {
                  this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
               }
            }
         }
      }
      
      public function updateSaveSlot() : void
      {
         var timer:Timer = new Timer(200,1);
         timer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
         {
            if(mcSaveSlotListModule.enabled)
            {
               onSaveSlotSelected(null);
            }
         });
         timer.start();
      }
      
      public function onSaveScreenshotLoaded() : void
      {
         this.mcSaveSlotListModule.onLoadingScreenshotComplete();
      }
      
      public function setGameLogoLanguage(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(this.menuListModule)
         {
            this.menuListModule.setGameLogoLanguage(param1);
         }
         if(this.mcExpansionIcons)
         {
            _loc2_ = this.mcExpansionIcons.getChildByName("HeartsOfStoneImg") as MovieClip;
            if(_loc2_)
            {
               _loc2_.gotoAndStop(param1);
            }
            _loc3_ = this.mcExpansionIcons.getChildByName("BloodAndWineImg") as MovieClip;
            if(_loc3_)
            {
               _loc3_.gotoAndStop(param1);
            }
         }
         if(this.mcCustomDialogEp1)
         {
            _loc4_ = this.mcCustomDialogEp1.getChildByName("HeartsOfStoneImg") as MovieClip;
            if(_loc2_)
            {
               _loc4_.gotoAndStop(param1);
            }
         }
         if(this.mcCustomDialogEp2)
         {
            if(_loc5_ = this.mcCustomDialogEp2.getChildByName("BloodAndWineImg") as MovieClip)
            {
               _loc5_.gotoAndStop(param1);
            }
         }
         this._enableWeiboLink = param1 == "CN" && this._platform == PlatformType.PLATFORM_PC;
         if(this._enableWeiboLink && !this._panelMode)
         {
            this.mcWeibo.visible = true;
            this.mcWeibo.addEventListener(MouseEvent.CLICK,this.handleWeiboClick,false,0,true);
         }
         else
         {
            this.mcWeibo.visible = false;
            this.mcWeibo.removeEventListener(MouseEvent.CLICK,this.handleWeiboClick,false);
         }
      }
      
      protected function handleWeiboClick(param1:MouseEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnVisitWeibo"));
      }
      
      public function showApplyPresetInputFeedback(param1:Boolean) : void
      {
         if(this._lastSetShowPresetInputFeedback == param1)
         {
            return;
         }
         this._lastSetShowPresetInputFeedback = param1;
         if(param1)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_APPLY_PRESET,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_common_apply]]",true);
         }
         else
         {
            this.mcInputFeedbackModule.removeButton(ACTION_APPLY_PRESET,true);
         }
      }
      
      protected function handleOptionValuesUpdated(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:Boolean = false;
         var _loc5_:uint = uint(param1.presetGroupID);
         var _loc6_:Array = param1.optionList as Array;
         var _loc10_:int = 0;
         while(_loc10_ < this.rootData.length)
         {
            if((_loc4_ = this.rootData[_loc10_]).type == IGMActionType_Options)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc10_++;
         }
         if(_loc2_)
         {
            _loc3_ = this.searchForPresetRecursive(_loc2_,_loc5_);
         }
         if(_loc3_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc8_];
               _loc9_ = 0;
               while(_loc9_ < _loc3_.subElements.length)
               {
                  if((_loc4_ = _loc3_.subElements[_loc9_]).tag == _loc7_.optionName)
                  {
                     _loc4_.current = _loc7_.optionValue;
                     _loc4_.startingValue = _loc7_.optionValue;
                     _loc4_.skip = _loc7_.skip;
                     _loc4_.lock = _loc7_.lock;
                     break;
                  }
                  _loc9_++;
               }
               _loc8_++;
            }
            if(this.previousContainers.length > 0 && this.mcOptionListModule.visible)
            {
               _loc11_ = this.previousContainers[this.previousContainers.length - 1];
               _loc12_ = false;
               if(_loc11_)
               {
                  _loc9_ = 0;
                  while(_loc9_ < _loc11_.subElements.length)
                  {
                     if((_loc4_ = _loc11_.subElements[_loc9_]).id == "Presets" && _loc4_.GroupName == _loc5_)
                     {
                        _loc12_ = true;
                        break;
                     }
                     _loc9_++;
                  }
                  if(_loc12_)
                  {
                     this.mcOptionListModule.updateData(_loc3_.subElements as Array);
                  }
               }
            }
            return;
         }
      }
      
      protected function searchForPresetRecursive(param1:Object, param2:uint) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(Boolean(param1) && Boolean(param1.subElements))
         {
            _loc5_ = 0;
            while(_loc5_ < param1.subElements.length)
            {
               if((_loc4_ = param1.subElements[_loc5_]) && _loc4_.id == "Presets" && _loc4_.GroupName == param2)
               {
                  _loc3_ = param1;
                  break;
               }
               if(_loc4_.id != "Presets" && !_loc4_.hasOwnProperty("startingValue") && _loc4_.hasOwnProperty("type") && (_loc4_.type == IGMActionType_MenuHolder || _loc4_.type == IGMActionType_MenuLastHolder))
               {
                  _loc3_ = this.searchForPresetRecursive(_loc4_,param2);
               }
               if(_loc3_ != null)
               {
                  break;
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      override protected function onLastMoveStatusChanged() : *
      {
         if(this.menuListModule)
         {
            this.menuListModule.onLastMoveStatusChanged(_lastMoveWasMouse);
         }
         if(this.mcOptionListModule)
         {
            this.mcOptionListModule.lastMoveWasMouse = _lastMoveWasMouse;
         }
         if(this.mcKeyBindModule)
         {
            this.mcKeyBindModule.lastMoveWasMouse = _lastMoveWasMouse;
         }
         if(this.mcSaveSlotListModule)
         {
            this.mcSaveSlotListModule.lastMoveWasMouse = _lastMoveWasMouse;
         }
         if(this.mcInstalledDLCModule)
         {
            this.mcInstalledDLCModule.lastMoveWasMouse = _lastMoveWasMouse;
         }
      }
      
      public function UpdateAnchorsAspectRatio(param1:int, param2:int) : void
      {
         if(!this.mcUIRescaleModule)
         {
            return;
         }
         var _loc3_:int = AspectRatio.getCurrentAspectRatio(param1,param2);
         switch(_loc3_)
         {
            case AspectRatio.ASPECT_RATIO_DEFAULT:
            case AspectRatio.ASPECT_RATIO_21_9:
               this.mcUIRescaleModule.mcScaleFrame.gotoAndStop(_loc3_);
               break;
            case AspectRatio.ASPECT_RATIO_UNDEFINED:
         }
      }
   }
}
