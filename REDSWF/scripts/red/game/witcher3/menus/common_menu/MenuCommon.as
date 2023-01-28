package red.game.witcher3.menus.common_menu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.ConditionalCloseButton;
   import red.game.witcher3.controls.W3Background;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class MenuCommon extends CoreMenu
   {
      
      protected static const SUBMENU_CLASS_REF:String = "SubMenuRef";
       
      
      public var mcCloseBtn:ConditionalCloseButton;
      
      public var mcMenuHub:MenuHub;
      
      public var mcPlayerDetails:MenuPlayerStats;
      
      public var txtTabName:TextField;
      
      public var mcInpuFeedback:ModuleInputFeedback;
      
      public var mcBlackBackground:W3Background;
      
      public var mcMeditationBackground:MovieClip;
      
      public var mcMenuBackgroundContainer:MovieClip;
      
      protected var _changePageInputFeedback:int = 1;
      
      protected var _changeTabInputFeedback:int = 2;
      
      protected var _exitInputFeedback:int = 3;
      
      protected var _cachedIsGamepad:Boolean;
      
      protected var _navigationEnabled:Boolean;
      
      protected var _blockBackNav:Boolean;
      
      public var visibleScreenRect:Rectangle;
      
      private var _tabsInited:Boolean = false;
      
      private var _cachedMenuID:uint = 4294967295;
      
      private var _cachedMenuState:String = "";
      
      protected var _cachedEnterMenyCalled:Boolean = false;
      
      protected var _requestedMenuId:uint = 0;
      
      protected var _requestedMenuState:String = "";
      
      public function MenuCommon()
      {
         _enableInputValidation = true;
         this._navigationEnabled = true;
         _loadAssets = false;
         this._blockBackNav = false;
         super();
         _enableMouse = false;
         this.mcMenuHub.refInputFeedback = this.mcInpuFeedback;
         this.mcInpuFeedback.clickable = false;
         this.__setProp_mcCloseBtn_Scene1_mcCloseBtn_0();
      }
      
      override public function toString() : String
      {
         return "MenuCommon [" + this.name + "]";
      }
      
      override protected function get menuName() : String
      {
         return "CommonMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"panel.main.setup",[this.initMenuTabs]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"common.input.feedback.setup",[this.handleSetupBindings]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"common.input.navigation.enabled",[this.setNavigationEnabled]));
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,handleInput,false,2,true);
         this.mcInpuFeedback.buttonAlign = "center";
         this.mcMenuHub.addEventListener(MenuHub.OpenMenuCalled,this.onOpenMenuReq,false,0,true);
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
         }
         if(!Extensions.isScaleform)
         {
            this.displayDebugData();
         }
         if(this.mcMeditationBackground)
         {
            this.mcMeditationBackground.visible = false;
         }
         if(this.txtTabName)
         {
            this.txtTabName.visible = false;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.visibleScreenRect = CommonUtils.getScreenRect();
         this.setBackgroundPosition();
      }
      
      public function setBackgroundPosition() : void
      {
         this.mcMenuBackgroundContainer.x = this.visibleScreenRect.x;
      }
      
      public function blockBackNavigation() : void
      {
         this._blockBackNav = true;
      }
      
      public function updateMenuBackgroundImage(param1:String) : void
      {
         var _loc2_:W3UILoader = this.mcMenuBackgroundContainer.getChildByName("mcImageLoader") as W3UILoader;
         if(_loc2_)
         {
            _loc2_.source = param1;
         }
      }
      
      override public function setControllerType(param1:Boolean) : void
      {
         super.setControllerType(param1);
         this._cachedIsGamepad = param1;
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleCtrlChanged,false,0,true);
      }
      
      protected function handleCtrlChanged(param1:ControllerChangeEvent) : void
      {
         if(this._cachedIsGamepad != param1.isGamepad)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnControllerChanged",[param1.isGamepad]));
            this._cachedIsGamepad = param1.isGamepad;
         }
      }
      
      protected function displayDebugData() : void
      {
         var _loc1_:Array = [];
         var _loc2_:KeyBindingData = new KeyBindingData();
         _loc2_.gamepad_navEquivalent = "escape-gamepad_B";
         _loc2_.keyboard_keyCode = 27;
         _loc2_.label = "Some button 1";
         _loc1_.push(_loc2_);
         var _loc3_:KeyBindingData = new KeyBindingData();
         _loc3_.gamepad_navEquivalent = "enter-gamepad_A";
         _loc3_.keyboard_keyCode = 113;
         _loc3_.label = "Some button 2";
         _loc1_.push(_loc3_);
         this.handleSetupBindings(_loc1_);
         var _loc4_:Object = {
            "visible":true,
            "enabled":true,
            "id":0,
            "name":"PreparationMenu",
            "label":"Sub 1",
            "state":""
         };
         var _loc5_:Object = {
            "visible":true,
            "enabled":true,
            "id":1,
            "name":"MeditationMenu",
            "label":"Sub 2",
            "state":""
         };
         var _loc6_:Array = [_loc4_,_loc5_];
         var _loc7_:Object = {
            "visible":true,
            "enabled":true,
            "id":0,
            "icon":"InventoryMenu",
            "label":"Main Tab",
            "subItems":_loc6_
         };
         var _loc8_:Object = {
            "visible":true,
            "enabled":true,
            "id":1,
            "icon":"MapMenu",
            "label":"Map Menu",
            "subItems":_loc6_
         };
         this.initMenuTabs([_loc7_,_loc8_]);
      }
      
      override protected function showAnimation() : void
      {
         visible = true;
      }
      
      protected function onOpenMenuReq(param1:Event) : void
      {
         var _loc2_:MenuHubTabListItem = this.mcMenuHub.currentlySelectedMenu();
         if(_loc2_)
         {
            this.callMenuOpen(_loc2_.data.id,_loc2_.data.state);
         }
         else if(this._cachedMenuID != uint.MAX_VALUE)
         {
            this.callMenuOpen(this._cachedMenuID,this._cachedMenuState);
         }
      }
      
      public function blockMenuClosing(param1:Boolean) : void
      {
         this.mcMenuHub.blockMenuClosing = param1;
         if(Boolean(this.mcCloseBtn) && this.mcMenuHub.currentState == MenuHub.State_Hidden)
         {
            this.mcCloseBtn.visible = !param1;
         }
      }
      
      public function blockHubClosing(param1:Boolean) : void
      {
         this.mcMenuHub.blockHubClosing = param1;
         if(Boolean(this.mcCloseBtn) && this.mcMenuHub.currentState != MenuHub.State_Hidden)
         {
            this.mcCloseBtn.visible = !param1;
         }
      }
      
      public function SetInputFeedbackVisibility(param1:Boolean) : void
      {
         this.mcInpuFeedback.setVisibility(param1);
      }
      
      public function updateTabEnabled(param1:uint, param2:String, param3:Boolean) : *
      {
         this.mcMenuHub.updateTabDataEnabled(param1,param2,param3);
      }
      
      public function setMeditationBackgroundMode(param1:Boolean) : void
      {
         if(Boolean(this.mcMeditationBackground) && Boolean(this.mcBlackBackground))
         {
            this.mcMeditationBackground.visible = param1;
            this.mcBlackBackground.visible = !param1;
            this.mcMenuHub.mcTabBackground.visible = !param1;
         }
      }
      
      override public function SetInitialPanelXOffset(param1:int) : *
      {
      }
      
      public function initMenuTabs(param1:Array) : void
      {
         this._tabsInited = true;
         this.mcMenuHub.setTabdata(param1);
         if(this._cachedMenuID != uint.MAX_VALUE)
         {
            this.mcMenuHub.selectMenu(this._cachedMenuID,this._cachedMenuState);
         }
         if(this._cachedEnterMenyCalled)
         {
            this.mcMenuHub.hide(true);
         }
      }
      
      public function handleForceNextTab() : void
      {
      }
      
      public function handleForcePriorTab() : void
      {
      }
      
      public function setShopInventory(param1:Boolean) : void
      {
         this.mcMenuHub.isShopInventory = param1;
      }
      
      public function setSelectedTab(param1:uint, param2:String) : void
      {
         if(this._tabsInited)
         {
            this.mcMenuHub.selectMenu(param1,param2);
         }
         else
         {
            this._cachedMenuID = param1;
            this._cachedMenuState = param2;
         }
      }
      
      public function enterCurrentlySelectedTab() : void
      {
         if(this._tabsInited)
         {
            this.mcMenuHub.hide(true);
         }
         else
         {
            this._cachedEnterMenyCalled = true;
         }
      }
      
      public function selectMenuTab(param1:uint, param2:String) : void
      {
      }
      
      public function selectSubMenuTab(param1:uint, param2:String) : void
      {
      }
      
      public function onSubMenuClosed() : void
      {
         this.mcMenuHub.handleUp();
         this._requestedMenuId = 0;
         this._requestedMenuState = "";
      }
      
      public function onChildMenuConfigured() : void
      {
         this.mcMenuHub.hide(true);
      }
      
      public function lockOpenTabNavigation(param1:Boolean) : void
      {
         this.mcMenuHub.rblbenabled = !param1;
      }
      
      public function setPlayerDetailsVisible(param1:Boolean) : void
      {
         this.mcPlayerDetails.visible = param1;
      }
      
      public function hubHiddenBegin() : void
      {
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.visible = !this.mcMenuHub.blockMenuClosing;
         }
      }
      
      public function hubHiddenEnd() : void
      {
         if(this.mcCloseBtn)
         {
            this.mcCloseBtn.visible = !this.mcMenuHub.blockHubClosing;
         }
      }
      
      public function updatePlayerLevel(param1:Number, param2:Number, param3:Number) : void
      {
         this.mcPlayerDetails.setLevel(param1,param2,param3);
      }
      
      public function updateWeight(param1:Number, param2:Number) : void
      {
         this.mcPlayerDetails.setWeight(param1,param2);
      }
      
      public function updateMoney(param1:Number) : void
      {
         this.mcPlayerDetails.setMoney(param1);
      }
      
      protected function handleSetupBindings(param1:Object) : void
      {
         this.mcInpuFeedback.handleSetupButtons(param1);
      }
      
      protected function handleIndexChange(param1:ListEvent) : void
      {
      }
      
      protected function createSubPanel(param1:Array, param2:MenuTab, param3:int) : void
      {
      }
      
      protected function removeSubPanel() : void
      {
      }
      
      protected function handleSubIndexChange(param1:ListEvent) : void
      {
      }
      
      protected function callMenuOpen(param1:uint, param2:String = "") : void
      {
         if(!(this._requestedMenuId == param1 && this._requestedMenuState == param2))
         {
            this._requestedMenuId = param1;
            this._requestedMenuState = param2;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestMenu",[param1,param2]));
         }
      }
      
      protected function setNavigationEnabled(param1:Boolean) : void
      {
         this._navigationEnabled = param1;
         this.mcMenuHub.navigationEnabled = param1;
      }
      
      protected function handleClosePressed(param1:ButtonEvent) : void
      {
         if(this._blockBackNav)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnHideChildMenu"));
         }
         else
         {
            this.tryAndNavigateBack();
         }
      }
      
      protected function tryAndNavigateBack() : void
      {
         if(!this.mcMenuHub.blockMenuClosing)
         {
            if(this.mcMenuHub.currentState == MenuHub.State_TopTab)
            {
               closeMenu();
            }
            else if(this.mcMenuHub.currentState == MenuHub.State_BotTab)
            {
               this.mcMenuHub.handleUp();
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnHideChildMenu"));
            }
         }
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         if(!param1.handled && this._navigationEnabled)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
                  if(_loc3_)
                  {
                     if(this.mcMenuHub.currentState == MenuHub.State_TopTab || this.mcMenuHub.currentState == MenuHub.State_Init)
                     {
                        closeMenu();
                        return;
                     }
                  }
                  break;
               case NavigationCode.START:
                  if(_loc4_ && (!_enableInputValidation || (isNavEquivalentValid(_loc2_.navEquivalent) || isKeyCodeValid(_loc2_.code))))
                  {
                     closeMenu();
                  }
                  break;
               default:
                  if(_loc4_)
                  {
                     if(!this._blockBackNav && (_loc2_.code == KeyCode.NUMBER_2 || _loc2_.code == KeyCode.NUMPAD_2))
                     {
                        this.tryAndNavigateBack();
                     }
                  }
            }
         }
         if(_loc4_ && !param1.handled)
         {
            _loc5_ = _loc2_.code;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnHotkeyTriggered",[_loc5_]));
         }
      }
      
      internal function __setProp_mcCloseBtn_Scene1_mcCloseBtn_0() : *
      {
         try
         {
            this.mcCloseBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcCloseBtn.autoRepeat = false;
         this.mcCloseBtn.autoSize = "none";
         this.mcCloseBtn.data = "";
         this.mcCloseBtn.enabled = true;
         this.mcCloseBtn.enableInitCallback = false;
         this.mcCloseBtn.focusable = false;
         this.mcCloseBtn.label = "";
         this.mcCloseBtn.selected = false;
         this.mcCloseBtn.showOnGamepad = false;
         this.mcCloseBtn.showOnMouseKeyboard = true;
         this.mcCloseBtn.toggle = false;
         this.mcCloseBtn.visible = true;
         try
         {
            this.mcCloseBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
