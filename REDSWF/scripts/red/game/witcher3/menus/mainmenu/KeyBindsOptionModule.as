package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class KeyBindsOptionModule extends StaticOptionModule
   {
      
      protected static const PADDING_BUTTON:Number = 40;
       
      
      private var isSettingKeycode:Boolean = false;
      
      public var mcChangingKeybindDialog:MovieClip;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcResetDefaultsButtonPC:InputFeedbackButton;
      
      public var mcSafetiesEnabledButtonPC:InputFeedbackButton;
      
      public var mcList:W3ScrollingList;
      
      public var mcItemRenderer1:KeybindItemRenderer;
      
      public var mcItemRenderer2:KeybindItemRenderer;
      
      public var mcItemRenderer3:KeybindItemRenderer;
      
      public var mcItemRenderer4:KeybindItemRenderer;
      
      public var mcItemRenderer5:KeybindItemRenderer;
      
      public var mcItemRenderer6:KeybindItemRenderer;
      
      public var mcItemRenderer7:KeybindItemRenderer;
      
      public var mcItemRenderer8:KeybindItemRenderer;
      
      public var mcItemRenderer9:KeybindItemRenderer;
      
      public var mcItemRenderer10:KeybindItemRenderer;
      
      public var mcItemRenderer11:KeybindItemRenderer;
      
      private var _rebindingRenderer:KeybindItemRenderer;
      
      public var _lastMoveWasMouse:Boolean = false;
      
      protected var _smartKeybindingEnabled:Boolean = true;
      
      protected var _mouseEventsRegistered:Boolean = false;
      
      protected var _lastMouseOveredItem:int = -1;
      
      public function KeyBindsOptionModule()
      {
         super();
      }
      
      public function get smartKeybindingEnabled() : Boolean
      {
         return this._smartKeybindingEnabled;
      }
      
      public function set smartKeybindingEnabled(param1:Boolean) : void
      {
         if(this._smartKeybindingEnabled != param1)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSmartKeybindEnabledChanged",[param1]));
         }
         this._smartKeybindingEnabled = param1;
         var _loc2_:String = "";
         var _loc3_:String = param1 ? "[[panel_mainmenu_option_value_off]]" : "[[panel_mainmenu_option_value_on]]";
         var _loc4_:TextField;
         (_loc4_ = new TextField()).text = "[[smart_keybinding_enabled]]";
         _loc2_ += _loc4_.text;
         _loc4_.text = _loc3_;
         _loc2_ += " " + _loc4_.text;
         this.mcSafetiesEnabledButtonPC.label = _loc2_;
         this.mcSafetiesEnabledButtonPC.setDataFromStage("",KeyCode.O);
         this.mcSafetiesEnabledButtonPC.validateNow();
         this.setButtonPosition();
         this.mcItemRenderer1.safetiesEnabled = param1;
         this.mcItemRenderer2.safetiesEnabled = param1;
         this.mcItemRenderer3.safetiesEnabled = param1;
         this.mcItemRenderer4.safetiesEnabled = param1;
         this.mcItemRenderer5.safetiesEnabled = param1;
         this.mcItemRenderer6.safetiesEnabled = param1;
         this.mcItemRenderer7.safetiesEnabled = param1;
         this.mcItemRenderer8.safetiesEnabled = param1;
         this.mcItemRenderer9.safetiesEnabled = param1;
         this.mcItemRenderer10.safetiesEnabled = param1;
         this.mcItemRenderer11.safetiesEnabled = param1;
      }
      
      public function get lastMoveWasMouse() : Boolean
      {
         return this._lastMoveWasMouse;
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         if(!this._lastMoveWasMouse)
         {
            if(this.mcList.selectedIndex == -1)
            {
               this.mcList.selectedIndex = 0;
            }
         }
         else
         {
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
         this.mcChangingKeybindDialog.visible = false;
         this.mcChangingKeybindDialog.mouseEnabled = false;
         this.mcChangingKeybindDialog.mouseChildren = false;
         var _loc1_:InputFeedbackButton = this.mcChangingKeybindDialog.getChildByName("inputFeedbackBtn") as InputFeedbackButton;
         if(_loc1_)
         {
            _loc1_.label = "[[panel_common_cancel]]";
            _loc1_.setDataFromStage("",KeyCode.ESCAPE);
         }
         this.mcResetDefaultsButtonPC.clickable = true;
         this.mcResetDefaultsButtonPC.label = "[[menu_option_reset_to_default]]";
         this.mcResetDefaultsButtonPC.addEventListener(ButtonEvent.PRESS,this.handleResetDefaultPressed,false,0,true);
         this.mcResetDefaultsButtonPC.setDataFromStage("",KeyCode.R);
         this.mcResetDefaultsButtonPC.validateNow();
         this.mcSafetiesEnabledButtonPC.clickable = true;
         this.mcSafetiesEnabledButtonPC.addEventListener(ButtonEvent.PRESS,this.smartKeybindingPressed,false,0,true);
         this.mcSafetiesEnabledButtonPC.setDataFromStage("",KeyCode.O);
         this.mcSafetiesEnabledButtonPC.validateNow();
         if(this.mcScrollbar)
         {
            this.mcScrollbar.addEventListener(Event.SCROLL,this.handleScroll,false,1,true);
         }
      }
      
      public function setButtonPosition() : *
      {
         this.mcResetDefaultsButtonPC.x = this.mcSafetiesEnabledButtonPC.x + this.mcSafetiesEnabledButtonPC.actualWidth + PADDING_BUTTON;
      }
      
      public function showWithData(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc2_:TextField = getChildByName("tfAction") as TextField;
         var _loc3_:TextFormat = new TextFormat();
         if(CoreComponent.isArabicAligmentMode)
         {
            _loc3_.align = "right";
         }
         else
         {
            _loc3_.align = "left";
         }
         _loc2_.setTextFormat(_loc3_);
         var _loc4_:int = -1;
         _loc5_ = -1;
         if(!visible)
         {
            super.show();
            this.smartKeybindingEnabled = true;
            if(this.mcList)
            {
               if(this.mcList.selectedIndex == 0)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
               }
               if(this._lastMoveWasMouse)
               {
                  this.mcList.selectedIndex = -1;
               }
               else
               {
                  this.mcList.selectedIndex = 0;
               }
            }
         }
         else
         {
            _loc4_ = this.mcList.selectedIndex;
            _loc5_ = this.mcList.scrollPosition;
         }
         this.mcList.dataProvider = new DataProvider(param1);
         this.mcList.validateNow();
         this.registerMouseEvents();
         if(_loc4_ != -1 || _loc5_ != -1)
         {
            this.mcList.selectedIndex = _loc4_;
            this.mcList.scrollPosition = _loc5_;
            validateNow();
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         this.unregisteredMouseEvents();
      }
      
      public function registerMouseEvents() : void
      {
         if(!this._mouseEventsRegistered)
         {
            this._mouseEventsRegistered = true;
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseScroll,true,1000,true);
            this.registerMouseEventsForItem(this.mcItemRenderer1);
            this.registerMouseEventsForItem(this.mcItemRenderer2);
            this.registerMouseEventsForItem(this.mcItemRenderer3);
            this.registerMouseEventsForItem(this.mcItemRenderer4);
            this.registerMouseEventsForItem(this.mcItemRenderer5);
            this.registerMouseEventsForItem(this.mcItemRenderer6);
            this.registerMouseEventsForItem(this.mcItemRenderer7);
            this.registerMouseEventsForItem(this.mcItemRenderer8);
            this.registerMouseEventsForItem(this.mcItemRenderer9);
            this.registerMouseEventsForItem(this.mcItemRenderer10);
            this.registerMouseEventsForItem(this.mcItemRenderer11);
         }
      }
      
      public function unregisteredMouseEvents() : void
      {
         if(this._mouseEventsRegistered)
         {
            this._mouseEventsRegistered = false;
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseScroll,false);
            this.unregisterMouseEventsForItem(this.mcItemRenderer1);
            this.unregisterMouseEventsForItem(this.mcItemRenderer2);
            this.unregisterMouseEventsForItem(this.mcItemRenderer3);
            this.unregisterMouseEventsForItem(this.mcItemRenderer4);
            this.unregisterMouseEventsForItem(this.mcItemRenderer5);
            this.unregisterMouseEventsForItem(this.mcItemRenderer6);
            this.unregisterMouseEventsForItem(this.mcItemRenderer7);
            this.unregisterMouseEventsForItem(this.mcItemRenderer8);
            this.unregisterMouseEventsForItem(this.mcItemRenderer9);
            this.unregisterMouseEventsForItem(this.mcItemRenderer10);
            this.unregisterMouseEventsForItem(this.mcItemRenderer11);
         }
      }
      
      protected function registerMouseEventsForItem(param1:KeybindItemRenderer) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onItemClicked,false,0,true);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.onItemDoubleClick,false,0,true);
         param1.doubleClickEnabled = true;
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,0,true);
      }
      
      protected function unregisterMouseEventsForItem(param1:KeybindItemRenderer) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.onItemClicked);
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onItemDoubleClick);
         param1.doubleClickEnabled = false;
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
      }
      
      protected function onItemClicked(param1:MouseEvent) : void
      {
         var _loc3_:KeybindItemRenderer = null;
         if(this.mcChangingKeybindDialog.visible)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.MIDDLE_BUTTON)
         {
            _loc3_ = param1.currentTarget as KeybindItemRenderer;
            if(Boolean(_loc3_) && Boolean(_loc3_.data))
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnClearKeybind",[uint(_loc3_.data.tag)]));
            }
         }
      }
      
      protected function onItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:KeybindItemRenderer = param1.currentTarget as KeybindItemRenderer;
         if(this.mcChangingKeybindDialog.visible)
         {
            return;
         }
         this._lastMouseOveredItem = this.mcList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = _loc2_.index;
         }
      }
      
      protected function onItemMouseOut(param1:MouseEvent) : void
      {
         if(this.mcChangingKeybindDialog.visible)
         {
            return;
         }
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = -1;
         }
      }
      
      protected function onItemDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            this.startChangingKeybind();
         }
      }
      
      private function handleScroll(param1:Event) : void
      {
         var _loc2_:KeybindItemRenderer = null;
         this.mcList.validateNow();
         if(this._lastMouseOveredItem != -1 && this.lastMoveWasMouse)
         {
            _loc2_ = this.mcList.getRendererAt(this._lastMouseOveredItem) as KeybindItemRenderer;
            if(_loc2_)
            {
               this.mcList.selectedIndex = _loc2_.index;
               this.mcList.validateNow();
            }
         }
      }
      
      override public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc4_:uint = 0;
         if(!visible)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(this.mcChangingKeybindDialog.visible)
         {
            if(_loc3_ && !InputManager.getInstance().isGamepad())
            {
               _loc4_ = _loc2_.code;
               if(_loc2_.code == KeyCode.ESCAPE)
               {
                  this.stopChangingKeybind();
                  return;
               }
               if(_loc2_.code == KeyCode.F7 || _loc2_.code == KeyCode.F5 || this.smartKeybindingEnabled && (_loc2_.code == KeyCode.ENTER || _loc2_.code == KeyCode.BACKSPACE || _loc2_.code == KeyCode.K || _loc2_.code == KeyCode.I || _loc2_.code == KeyCode.M || _loc2_.code == KeyCode.J || _loc2_.code == KeyCode.N || _loc2_.code == KeyCode.B || _loc2_.code == KeyCode.G || _loc2_.code == KeyCode.H || _loc2_.code == KeyCode.L || _loc2_.code == KeyCode.O))
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnInvalidKeybindTried",[_loc4_]));
                  return;
               }
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangeKeybind",[uint(this._rebindingRenderer.data.tag),_loc4_]));
               this.stopChangingKeybind();
            }
         }
         else
         {
            if(!param1.handled && _loc3_)
            {
               if(_loc2_.code == KeyCode.ENTER || _loc2_.navEquivalent == NavigationCode.GAMEPAD_A || _loc2_.code == KeyCode.E)
               {
                  this.startChangingKeybind();
               }
               else if(_loc2_.code == KeyCode.R)
               {
                  this.resetKeybinds();
               }
               else if(_loc2_.code == KeyCode.O)
               {
                  this.smartKeybindingEnabled = !this.smartKeybindingEnabled;
               }
            }
            CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
            this.mcList.handleInput(param1);
            if(!param1.handled)
            {
               super.handleInputNavigate(param1);
            }
         }
      }
      
      protected function onMouseScroll(param1:MouseEvent) : void
      {
         if(this.mcChangingKeybindDialog.visible)
         {
            param1.stopImmediatePropagation();
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangeKeybind",[uint(this._rebindingRenderer.data.tag),KeyCode.MOUSEZ]));
            this.stopChangingKeybind();
         }
      }
      
      protected function startChangingKeybind() : void
      {
         var _loc1_:TextField = null;
         if(this.mcChangingKeybindDialog.visible)
         {
            return;
         }
         this._rebindingRenderer = this.mcList.getSelectedRenderer() as KeybindItemRenderer;
         if(!this._rebindingRenderer || this._rebindingRenderer.data == null)
         {
            return;
         }
         if(Boolean(this._rebindingRenderer.data.locked) && (this.smartKeybindingEnabled || this._rebindingRenderer.data.permaLocked))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnLockedKeybindTried"));
         }
         else if(this._rebindingRenderer.isReset)
         {
            this.resetKeybinds();
         }
         else
         {
            _loc1_ = this.mcChangingKeybindDialog.getChildByName("textField") as TextField;
            if(_loc1_)
            {
               _loc1_.htmlText = "[[press_any_key_to_bind_message]]";
               _loc1_.htmlText += this._rebindingRenderer.data.label;
            }
            this.mcChangingKeybindDialog.visible = true;
         }
      }
      
      protected function handleResetDefaultPressed(param1:ButtonEvent) : void
      {
         this.resetKeybinds();
      }
      
      protected function smartKeybindingPressed(param1:ButtonEvent) : void
      {
         this.smartKeybindingEnabled = !this.smartKeybindingEnabled;
      }
      
      protected function resetKeybinds() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnResetKeybinds"));
      }
      
      protected function stopChangingKeybind() : void
      {
         if(!this.mcChangingKeybindDialog.visible)
         {
            return;
         }
         this.mcChangingKeybindDialog.visible = false;
         this._rebindingRenderer = null;
      }
      
      override public function onRightClick(param1:MouseEvent) : void
      {
         if(!this.mcChangingKeybindDialog.visible)
         {
            super.onRightClick(param1);
         }
      }
      
      public function onMouseClick(param1:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_ == null)
         {
            return;
         }
         if(this.mcChangingKeybindDialog.visible && this._rebindingRenderer != null && this._rebindingRenderer.data != null)
         {
            switch(_loc2_.buttonIdx)
            {
               case MouseEventEx.LEFT_BUTTON:
                  _loc3_ = KeyCode.LEFT_MOUSE;
                  break;
               case MouseEventEx.RIGHT_BUTTON:
                  _loc3_ = KeyCode.RIGHT_MOUSE;
                  break;
               case MouseEventEx.MIDDLE_BUTTON:
                  _loc3_ = KeyCode.MIDDLE_MOUSE;
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnChangeKeybind",[uint(this._rebindingRenderer.data.tag),_loc3_]));
            this.stopChangingKeybind();
         }
      }
   }
}
