package red.game.witcher3.menus.common_menu
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.InputFeedbackEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class ModuleInputFeedback extends UIComponent
   {
      
      protected static const BUTTON_CONTENT_REF:String = "InputFeedbackButtonRef";
      
      protected static const BUTTONS_PADDING:Number = 15;
       
      
      protected var _hotkeyMap:Object;
      
      protected var _gpadSortMap:Vector.<String>;
      
      protected var _kbSortMap:Vector.<int>;
      
      protected var _buttonsList:Vector.<InputFeedbackButton>;
      
      protected var _data:Array;
      
      protected var _isGamepad:Boolean;
      
      protected var _commonButtons:Array;
      
      protected var _canvas:Sprite;
      
      protected var _cachedWidth:Number;
      
      protected var _buttonAlign:String;
      
      protected var _directWsCall:Boolean = true;
      
      protected var _emulateInputEvent:Boolean = true;
      
      protected var _lowercaseLabels:Boolean = false;
      
      protected var _clickable:Boolean = true;
      
      protected var _isVisible:Boolean;
      
      protected var _isActualVisibility:Boolean;
      
      public var filterKeyCodeFunction:Function;
      
      public var filterNavCodeFunction:Function;
      
      public function ModuleInputFeedback()
      {
         super();
         this._hotkeyMap = {};
         this._canvas = new Sprite();
         this._commonButtons = [];
         this._buttonsList = new Vector.<InputFeedbackButton>();
         this._cachedWidth = this.width;
         addChild(this._canvas);
         this.initSortMaps();
         tabEnabled = tabChildren = false;
         this._isVisible = true;
         this.visible = false;
      }
      
      public function get buttonsContainer() : Sprite
      {
         return this._canvas;
      }
      
      public function addHotkey(param1:uint, param2:uint) : void
      {
         var _loc3_:Array = this._hotkeyMap[param1];
         if(Boolean(_loc3_) && _loc3_.indexOf(param2) < 0)
         {
            _loc3_.push(param2);
         }
         else
         {
            this._hotkeyMap[param1] = [param2];
         }
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         this._isVisible = param1;
         this.updateVisibility();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._isActualVisibility = param1;
         this.updateVisibility();
      }
      
      protected function updateVisibility() : void
      {
         super.visible = this._isActualVisibility && this._isVisible;
      }
      
      public function get clickable() : Boolean
      {
         return this._clickable;
      }
      
      public function set clickable(param1:Boolean) : void
      {
         this._clickable = param1;
      }
      
      public function get lowercaseLabels() : Boolean
      {
         return this._lowercaseLabels;
      }
      
      public function set lowercaseLabels(param1:Boolean) : void
      {
         this._lowercaseLabels = param1;
      }
      
      public function get emulateInputEvent() : Boolean
      {
         return this._emulateInputEvent;
      }
      
      public function set emulateInputEvent(param1:Boolean) : void
      {
         this._emulateInputEvent = param1;
      }
      
      public function get directWsCall() : Boolean
      {
         return this._directWsCall;
      }
      
      public function set directWsCall(param1:Boolean) : void
      {
         this._directWsCall = param1;
      }
      
      public function get buttonAlign() : String
      {
         return this._buttonAlign;
      }
      
      public function set buttonAlign(param1:String) : void
      {
         if(param1 == this._buttonAlign)
         {
            return;
         }
         this._buttonAlign = param1;
         this.repositionButtons();
      }
      
      public function handleSetupButtons(param1:Object) : void
      {
         this._data = param1 as Array;
         this.populateData(false);
      }
      
      public function appendButton(param1:int, param2:String, param3:int, param4:String, param5:Boolean = false, param6:int = -1) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc12_:KeyBindingData = null;
         var _loc13_:int = 0;
         var _loc14_:InputFeedbackButton = null;
         var _loc7_:KeyBindingData = new KeyBindingData();
         var _loc10_:int = int(this._commonButtons.length);
         _loc7_.actionId = param1;
         _loc7_.level = 0;
         _loc7_.gamepad_navEquivalent = param2;
         _loc7_.keyboard_keyCode = param3;
         _loc7_.label = param4;
         _loc7_.contextId = param6;
         var _loc11_:* = 0;
         while(_loc11_ < _loc10_)
         {
            if((_loc12_ = this._commonButtons[_loc11_]).actionId == param1 && (_loc12_.contextId == param6 || param6 == -1))
            {
               this._commonButtons[_loc11_] = _loc7_;
               _loc13_ = int(this._buttonsList.length);
               if(_loc14_ = this.getButtonByData(_loc12_))
               {
                  _loc14_.data = _loc7_;
                  _loc14_.validateNow();
               }
               _loc9_ = false;
               _loc8_ = true;
               break;
            }
            _loc11_++;
         }
         if(!_loc8_)
         {
            this._commonButtons.push(_loc7_);
            this.createButton(_loc7_);
            _loc9_ = true;
         }
         if(param5)
         {
            this.repositionButtons();
            if(_loc9_)
            {
               this.populateData();
            }
         }
      }
      
      public function removeButton(param1:int, param2:Boolean = false, param3:int = -1) : void
      {
         var _loc7_:KeyBindingData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:InputFeedbackButton = null;
         var _loc4_:int = int(this._commonButtons.length);
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if((_loc7_ = this._commonButtons[_loc6_]).actionId == param1 && (_loc7_.contextId == param3 || param3 == -1))
            {
               this._commonButtons.splice(_loc6_,1);
               _loc8_ = int(this._buttonsList.length);
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  if((Boolean(_loc10_ = this._buttonsList[_loc9_])) && _loc10_.getBindingData().actionId == param1)
                  {
                     _loc10_.removeEventListener(MouseEvent.CLICK,this.handleButtonClick);
                     this._canvas.removeChild(_loc10_);
                     this._buttonsList.splice(_loc9_,1);
                     _loc5_ = true;
                     break;
                  }
                  _loc9_++;
               }
               break;
            }
            _loc6_++;
         }
         if(param2 && _loc5_)
         {
            this.repositionButtons();
         }
      }
      
      public function disableButton(param1:int, param2:Boolean, param3:int = -1) : void
      {
         var _loc6_:KeyBindingData = null;
         var _loc4_:int = int(this._commonButtons.length);
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            if((_loc6_ = this._commonButtons[_loc5_]).actionId == param1 && (_loc6_.contextId == param3 || param3 == -1))
            {
               _loc6_.disabled = param2;
               break;
            }
            _loc5_++;
         }
         this.populateData();
      }
      
      public function removeAllContextButtons(param1:int) : void
      {
         var _loc3_:KeyBindingData = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._commonButtons.length)
         {
            _loc3_ = this._commonButtons[_loc2_];
            if(_loc3_.contextId == param1)
            {
               this._commonButtons.splice(_loc2_,1);
            }
            else
            {
               _loc2_++;
            }
         }
         this.populateData();
      }
      
      public function refreshButtonList() : void
      {
         this.populateData();
      }
      
      public function clearAllButtons() : void
      {
         this._commonButtons.length = 0;
      }
      
      public function cleanupButtons() : void
      {
         var _loc1_:int = int(this._buttonsList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._canvas.removeChild(this._buttonsList[_loc2_]);
            _loc2_++;
         }
         this._buttonsList.length = 0;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         if(!Extensions.isScaleform)
         {
            this.showDebugData();
         }
      }
      
      private function initSortMaps() : void
      {
         this._gpadSortMap = new Vector.<String>();
         this._kbSortMap = new Vector.<int>();
         this._gpadSortMap.push(NavigationCode.GAMEPAD_START);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_BACK);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_B);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_RBLB);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_RTLT);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_R1);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_L1);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_R2);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_L2);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_R3);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_L3);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_LSTICK_HOLD);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_RSTICK_HOLD);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_RSTICK_SCROLL);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_RSTICK_TAB);
         this._gpadSortMap.push(NavigationCode.DPAD_DOWN);
         this._gpadSortMap.push(NavigationCode.DPAD_LEFT);
         this._gpadSortMap.push(NavigationCode.DPAD_RIGHT);
         this._gpadSortMap.push(NavigationCode.DPAD_UP);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_Y);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_X);
         this._gpadSortMap.push(NavigationCode.GAMEPAD_A);
         this._kbSortMap.push(KeyCode.ESCAPE);
         this._kbSortMap.push(KeyCode.PAGE_DOWN);
         this._kbSortMap.push(KeyCode.PAGE_UP);
         this._kbSortMap.push(KeyCode.UP);
         this._kbSortMap.push(KeyCode.DOWN);
         this._kbSortMap.push(KeyCode.LEFT);
         this._kbSortMap.push(KeyCode.RIGHT);
         this._kbSortMap.push(KeyCode.ENTER);
      }
      
      protected function populateData(param1:Boolean = true) : void
      {
         var dataArray:Array = null;
         var finalList:Array = null;
         var hardReset:Boolean = param1;
         if(!this._data && this._commonButtons.length <= 0)
         {
            this.visible = false;
            InputDelegate.getInstance().removeEventListener(InputEvent.INPUT,this.handleInput,false);
            return;
         }
         try
         {
            dataArray = this._data as Array;
            this._isGamepad = InputManager.getInstance().isGamepad();
            finalList = this.prepareButtonsList(dataArray,this._commonButtons,this._isGamepad);
            if(this._isGamepad)
            {
               finalList.sort(this.sortForGPad);
            }
            else
            {
               finalList.sort(this.sortForKeyboard);
            }
            if(hardReset)
            {
               this.cleanupButtons();
               this.respawnButtons(finalList);
            }
            else
            {
               this.updateButtons(finalList);
            }
            this.repositionButtons();
            this.visible = this._buttonsList.length > 0;
            if(visible)
            {
               InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,10,true);
            }
            else
            {
               InputDelegate.getInstance().removeEventListener(InputEvent.INPUT,this.handleInput,false);
            }
         }
         catch(er:Error)
         {
            visible = false;
            InputDelegate.getInstance().removeEventListener(InputEvent.INPUT,handleInput,false);
         }
      }
      
      protected function respawnButtons(param1:Array) : void
      {
         var _loc4_:KeyBindingData = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_] as KeyBindingData;
            this.createButton(_loc4_);
            _loc3_++;
         }
      }
      
      protected function updateButtons(param1:Array) : void
      {
         var _loc6_:KeyBindingData = null;
         var _loc7_:InputFeedbackButton = null;
         var _loc8_:InputFeedbackButton = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc6_ = param1[_loc4_] as KeyBindingData;
            if(_loc7_ = this.getButtonByData(_loc6_))
            {
               _loc7_.setData(_loc6_,this._isGamepad);
               _loc7_.label = _loc6_.label;
               _loc7_.validateNow();
               _loc3_[_loc7_] = true;
            }
            else
            {
               _loc3_[this.createButton(_loc6_)] = true;
            }
            _loc4_++;
         }
         _loc2_ = int(this._buttonsList.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if((Boolean(_loc8_ = this._buttonsList[_loc5_])) && !_loc3_[_loc8_])
            {
               _loc8_.removeEventListener(MouseEvent.CLICK,this.handleButtonClick);
               this._canvas.removeChild(_loc8_);
               this._buttonsList.splice(_loc5_,1);
               _loc5_--;
               _loc2_--;
            }
            _loc5_++;
         }
      }
      
      protected function createButton(param1:KeyBindingData) : InputFeedbackButton
      {
         var _loc2_:Class = getDefinitionByName(BUTTON_CONTENT_REF) as Class;
         var _loc3_:InputFeedbackButton = new _loc2_() as InputFeedbackButton;
         _loc3_.clickable = this.clickable;
         _loc3_.setData(param1,this._isGamepad);
         _loc3_.lowercaseLabels = this._lowercaseLabels;
         _loc3_.addEventListener(MouseEvent.CLICK,this.handleButtonClick,false,10,true);
         if(param1.disabled)
         {
            _loc3_.enabled = false;
         }
         this._canvas.addChild(_loc3_);
         this._buttonsList.push(_loc3_);
         return _loc3_;
      }
      
      protected function prepareButtonsList(param1:Array, param2:Array, param3:Boolean) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:KeyBindingData = null;
         var _loc10_:* = undefined;
         var _loc11_:KeyBindingData = null;
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:String = param3 ? "gamepad_navEquivalent" : "keyboard_keyCode";
         var _loc7_:int = !!param1 ? int(param1.length) : 0;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc4_.push(param1[_loc8_]);
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < param2.length)
         {
            _loc4_.push(param2[_loc8_]);
            _loc8_++;
         }
         while(_loc4_.length > 0)
         {
            if((_loc10_ = (_loc9_ = _loc4_.pop() as KeyBindingData)[_loc6_]) && _loc10_ != -1)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  _loc11_ = _loc4_[_loc8_] as KeyBindingData;
                  if(_loc10_ == _loc11_[_loc6_])
                  {
                     if(_loc9_.level < _loc11_.level)
                     {
                        _loc9_ = _loc11_;
                     }
                     else if(_loc9_.level == _loc11_.level && _loc9_.actionId < _loc11_.actionId)
                     {
                        _loc9_ = _loc11_;
                     }
                     _loc4_.splice(_loc8_,1);
                  }
                  else
                  {
                     _loc8_++;
                  }
               }
               if(_loc9_)
               {
                  _loc5_.push(_loc9_);
                  _loc9_ = null;
               }
            }
         }
         return _loc5_;
      }
      
      protected function sortForGPad(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this._gpadSortMap.indexOf(param1.gamepad_navEquivalent);
         var _loc4_:int = this._gpadSortMap.indexOf(param2.gamepad_navEquivalent);
         if(_loc3_ == -1)
         {
            _loc3_ = this._gpadSortMap.length + 1;
         }
         if(_loc4_ == -1)
         {
            _loc4_ = this._gpadSortMap.length + 1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      protected function sortForKeyboard(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this._kbSortMap.indexOf(param1.keyboard_keyCode);
         var _loc4_:int = this._kbSortMap.indexOf(param2.keyboard_keyCode);
         if(_loc3_ == -1)
         {
            _loc3_ = this._kbSortMap.length + 1;
         }
         if(_loc4_ == -1)
         {
            _loc4_ = this._kbSortMap.length + 1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(this._isGamepad != param1.isGamepad && (this._data || this._commonButtons.length))
         {
            this.populateData();
         }
      }
      
      protected function repositionButtons() : void
      {
         var _loc5_:InputFeedbackButton = null;
         var _loc1_:Number = 0;
         var _loc2_:int = int(this._buttonsList.length);
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            (_loc5_ = this._buttonsList[_loc4_]).validateNow();
            _loc1_ += -_loc5_.getViewWidth() - (_loc4_ != 0 ? BUTTONS_PADDING : 0);
            _loc5_.x = _loc1_;
            _loc3_ += _loc5_.getViewWidth() + (_loc4_ != 0 ? BUTTONS_PADDING : 0);
            _loc4_++;
         }
         switch(this._buttonAlign)
         {
            case "center":
               this._canvas.x = -((this._cachedWidth - _loc3_) / 2);
               break;
            case "left":
               this._canvas.x = -this._cachedWidth + _loc3_;
               break;
            case "right":
               this._canvas.x = 0;
         }
      }
      
      protected function getButtonByData(param1:KeyBindingData) : InputFeedbackButton
      {
         var _loc6_:InputFeedbackButton = null;
         var _loc7_:KeyBindingData = null;
         var _loc8_:* = undefined;
         var _loc2_:int = int(this._buttonsList.length);
         var _loc3_:String = this._isGamepad ? "gamepad_navEquivalent" : "keyboard_keyCode";
         var _loc4_:* = param1[_loc3_];
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc8_ = (_loc7_ = (_loc6_ = this._buttonsList[_loc5_]).getBindingData())[_loc3_];
            if(Boolean(_loc7_) && _loc4_ == _loc8_)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      protected function handleButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:InputFeedbackButton = null;
         var _loc3_:KeyBindingData = null;
         var _loc4_:InputDetails = null;
         var _loc5_:InputEvent = null;
         if(!this._isGamepad)
         {
            _loc2_ = param1.currentTarget as InputFeedbackButton;
            _loc3_ = _loc2_.getBindingData();
            if(Boolean(_loc3_) && _loc2_.clickable)
            {
               this.activateButton(_loc3_);
               if(this._emulateInputEvent)
               {
                  _loc4_ = new InputDetails("key",_loc3_.keyboard_keyCode,InputValue.KEY_UP,_loc3_.gamepad_navEquivalent);
                  _loc5_ = new InputEvent(InputEvent.INPUT,_loc4_);
                  InputDelegate.getInstance().dispatchEvent(_loc5_);
               }
            }
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:KeyBindingData = null;
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(this.filterKeyCodeFunction != null && this.filterNavCodeFunction != null)
         {
            if(!this.filterKeyCodeFunction(_loc2_.code) || !this.filterNavCodeFunction(_loc2_.navEquivalent))
            {
               return;
            }
         }
         if((_loc2_.navEquivalent || _loc2_.code) && _loc3_)
         {
            if(_loc4_ = this.getBindingData(_loc2_.navEquivalent,_loc2_.code))
            {
               this.activateButton(_loc4_);
               InputManager.getInstance().reset();
            }
         }
      }
      
      protected function activateButton(param1:KeyBindingData, param2:InputEvent = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         if(this._directWsCall)
         {
            _loc4_ = !!param1.actionId ? param1.actionId : 0;
            _loc5_ = !!param1.keyboard_keyCode ? param1.keyboard_keyCode : 0;
            _loc6_ = param1.gamepad_navEquivalent;
            _loc7_ = uint(_loc5_);
            if(InputManager.getInstance().swapAcceptCancel)
            {
               if(_loc6_ == NavigationCode.GAMEPAD_A)
               {
                  _loc6_ == NavigationCode.GAMEPAD_B;
                  _loc7_ = KeyCode.PAD_B_CIRCLE;
               }
               else if(_loc6_ == NavigationCode.GAMEPAD_B)
               {
                  _loc6_ == NavigationCode.GAMEPAD_A;
                  _loc7_ = KeyCode.PAD_A_CROSS;
               }
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnInputHandled",[param1.gamepad_navEquivalent,_loc7_,_loc4_]));
         }
         var _loc3_:InputFeedbackEvent = new InputFeedbackEvent(InputFeedbackEvent.USER_ACTION,true,false);
         _loc3_.inputEventRef = param2;
         _loc3_.actionId = param1.actionId;
         dispatchEvent(_loc3_);
      }
      
      protected function getBindingData(param1:String = "", param2:int = 0) : KeyBindingData
      {
         var _loc5_:KeyBindingData = null;
         var _loc7_:Array = null;
         var _loc8_:* = false;
         var _loc3_:Boolean = InputManager.getInstance().isGamepad();
         var _loc4_:int = int(this._buttonsList.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if(_loc5_ = this._buttonsList[_loc6_].getBindingData())
            {
               _loc7_ = this._hotkeyMap[_loc5_.keyboard_keyCode];
               _loc8_ = false;
               if(_loc7_)
               {
                  _loc8_ = _loc7_.indexOf(param2) > -1;
               }
               if(_loc3_ && _loc5_.gamepad_navEquivalent == param1 || !_loc3_ && (_loc8_ || _loc5_.keyboard_keyCode == param2))
               {
                  return _loc5_;
               }
            }
            _loc6_++;
         }
         if(param1 == NavigationCode.GAMEPAD_B || param2 == KeyCode.ESCAPE)
         {
            (_loc5_ = new KeyBindingData()).gamepad_navEquivalent = NavigationCode.GAMEPAD_B;
            _loc5_.keyboard_keyCode = KeyCode.ESCAPE;
            return _loc5_;
         }
         return null;
      }
      
      override public function toString() : String
      {
         this;
         return ">";
      }
      
      protected function showDebugData() : void
      {
         this.appendButton(0,NavigationCode.GAMEPAD_RSTICK_HOLD,-1,"Ok",false);
         this.appendButton(1,NavigationCode.GAMEPAD_LSTICK_HOLD,-1,"Cancel",false);
         this.visible = true;
      }
   }
}
