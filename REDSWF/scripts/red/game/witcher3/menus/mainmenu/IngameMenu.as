package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.W3Background;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.modules.SimpleListModule;
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
      
      public static const IGMActionType_Options:uint = 100;
      
      private static const ACTION_CLOSE:uint = 0;
      
      private static const ACTION_SCROLL:uint = 1;
      
      private static const ACTION_USE:uint = 2;
      
      private static const ACTION_Y:uint = 3;
      
      private static const ACTION_X:uint = 4;
      
      private static const ACTION_APPLY_PRESET:uint = 5;
      
      public static const OnOptionPanelClosed:String = "OnOptionPanelClosed";
       
      
      private var importME:IngameMenuEntry;
      
      public var mcInputFeedbackModule:ModuleInputFeedback;
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var menuListModule:SimpleListModule;
      
      public var mcGammaModule:GammaSettingModule;
      
      public var mcHelpModule:StaticOptionModule;
      
      public var mcUIRescaleModule:UIRescaleModule;
      
      public var mcGameMappingModule:GamepadMappingModule;
      
      public var mcOptionListModule:OptionListModule;
      
      public var mcSaveSlotListModule:SaveSlotListModule;
      
      public var mcKeyBindModule:KeyBindsOptionModule;
      
      public var mcBlackBackground:W3Background;
      
      public var mcInputBackground:MovieClip;
      
      public var txtUserName:TextField;
      
      public var txtVersion:TextField;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      public var previousEntries:Vector.<DataProvider>;
      
      public var previousContainers:Vector.<Object>;
      
      public var previousSelections:Vector.<int>;
      
      public var rootData:Array;
      
      private var _isMainMenu:Boolean = false;
      
      private var _ignoreInput:Boolean = false;
      
      private var _hideAnimationPlaying:Boolean = false;
      
      private var _platform:int = 0;
      
      private var _panelMode:Boolean = false;
      
      private var _inPanel:Boolean = false;
      
      private var _fontLoadTimer:Timer;
      
      private var _fontLoadDelay:Number = 1000;
      
      protected var _lastSetShowPresetInputFeedback:Boolean = false;
      
      public function IngameMenu()
      {
         super();
         this.previousEntries = new Vector.<DataProvider>();
         this.previousContainers = new Vector.<Object>();
         this.previousSelections = new Vector.<int>();
         upToCloseEnabled = false;
         this.mcInputFeedbackModule.clickable = false;
         this.mcInputBackground = this.mcInputFeedbackModule["mcInputBackground"] as MovieClip;
         stage.addEventListener(MouseEvent.CLICK,this.onStageClicked,false,1,true);
      }
      
      public function set inPanel(param1:Boolean) : void
      {
         this._inPanel = param1;
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
      
      override protected function configUI() : void
      {
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
         focused = 1;
         if(this.mcBlackBackground)
         {
            this.mcBlackBackground.forceHide();
         }
         if(this.menuListModule)
         {
            this.menuListModule.focusable = false;
            this.menuListModule.titleText = "";
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
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_button_common_select]]",false);
         this.mcInputFeedbackModule.appendButton(ACTION_SCROLL,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",true);
      }
      
      override public function setPlatform(param1:uint) : void
      {
         super.setPlatform(param1);
         this._platform = param1;
         if(this._isMainMenu && this._platform == CommonConstants.PLATFORM_XBOX1)
         {
            this.mcInputFeedbackModule.appendButton(ACTION_Y,NavigationCode.GAMEPAD_Y,-1,"[[panel_button_common_choose_profile]]",true);
         }
      }
      
      public function setIgnoreInput(param1:Boolean) : void
      {
         this._ignoreInput = param1;
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
         var _loc2_:Object = _loc1_.data;
         var _loc3_:int = int(_loc2_.tag);
         var _loc4_:int = int(_loc2_.type);
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
                     if(this._platform == CommonConstants.PLATFORM_XBOX1 && this._isMainMenu)
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
               this.storeCurrentMenuState(param1,true);
               if(this.mcBlackBackground)
               {
                  this.mcBlackBackground.backgroundVisible = param1.type != IGMActionType_UIRescale;
               }
               return false;
         }
         return false;
      }
      
      protected function storeCurrentMenuState(param1:Object, param2:Boolean) : void
      {
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
         if(this.mcHelpModule)
         {
            this.mcHelpModule.hide();
         }
         if(this.mcUIRescaleModule)
         {
            this.mcUIRescaleModule.hide();
         }
         if(this._panelMode)
         {
            stage.visible = false;
            this.closeMenu();
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
            if(this._platform == CommonConstants.PLATFORM_XBOX1)
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
         if(this._platform == CommonConstants.PLATFORM_PS4)
         {
            return "[[panel_mainmenu_deletesave_ps4]]";
         }
         if(this._platform == CommonConstants.PLATFORM_XBOX1)
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
            if(param1[0].id != "EMPTY")
            {
               this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
            }
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
            if(this._platform == CommonConstants.PLATFORM_XBOX1)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame_x1]]",false);
            }
            else if(this._platform == CommonConstants.PLATFORM_PS4)
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame_ps4]]",false);
            }
            else
            {
               this.mcInputFeedbackModule.appendButton(ACTION_USE,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_mainmenu_savegame]]",false);
            }
            this.mcInputFeedbackModule.appendButton(ACTION_CLOSE,NavigationCode.GAMEPAD_B,-1,"[[panel_mainmenu_back]]",true);
            if(param1.length > 1 && param1[0].id != "EMPTY")
            {
               this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
            }
            else
            {
               this.mcInputFeedbackModule.removeButton(ACTION_X,true);
            }
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
               else
               {
                  this.mcInputFeedbackModule.appendButton(ACTION_X,NavigationCode.GAMEPAD_X,KeyCode.DELETE,this.getDeleteSaveString(),true);
               }
            }
         }
      }
      
      public function onSaveScreenshotLoaded() : void
      {
         this.mcSaveSlotListModule.onLoadingScreenshotComplete();
      }
      
      public function setGameLogoLanguage(param1:String) : void
      {
         if(this.menuListModule)
         {
            this.menuListModule.setGameLogoLanguage(param1);
         }
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
      }
   }
}
