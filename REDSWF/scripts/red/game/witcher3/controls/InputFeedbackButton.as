package red.game.witcher3.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.EInputDeviceType;
   import red.game.witcher3.constants.KeyboardKeys;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.Button;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class InputFeedbackButton extends Button
   {
      
      protected static const HOLD_ANIM_STEPS_COUNT:Number = 30;
      
      protected static const HOLD_ANIM_INTERVAL:Number = 20;
      
      protected static const DISABLED_ALPHA = 0.4;
      
      protected static const CLICKABLE_BK_OFFSET = 10;
      
      protected static const INVALIDATE_DISPLAY_DATA:String = "invalidate_display_data";
      
      protected static const GPAD_ICON_SIZE:Number = 64;
      
      protected static const TEXT_PADDING_KEYBOARD:Number = 5;
      
      protected static const TEXT_PADDING_PAD:Number = 1;
      
      protected static const TEXT_OFFSET:Number = 6;
      
      protected static const KEY_LABEL_PADDING:Number = 5;
      
      protected static const HOLD_INT_MAX_ANGLE:Number = 360;
      
      protected static const HOLD_INT_MAX_FRAME:Number = 28;
      
      protected static const HOLD_INT_FIRST_FRAME:Number = 2;
       
      
      public var mcIconXbox:MovieClip;
      
      public var mcIconPS:MovieClip;
      
      public var mcIconPS4:MovieClip;
      
      public var mcIconPS5:MovieClip;
      
      public var mcIconSteam:MovieClip;
      
      public var mcKeyboardIcon:KeyboardButtonIcon;
      
      public var mcMouseIcon:KeyboardButtonMouseIcon;
      
      public var mcHoldAnimation:MovieClip;
      
      public var mcClickRect:MovieClip;
      
      public var tfHoldPrefix:TextField;
      
      public var tfKeyLabel:TextField;
      
      public var holdCallback:Function;
      
      public var addHoldPrefix:Boolean;
      
      protected var _currentWidth:Number;
      
      protected var _targetViewer:DisplayObject;
      
      protected var _bindingData:KeyBindingData;
      
      protected var _isGamepad:Boolean;
      
      protected var _gpadIcon:MovieClip;
      
      protected var _clickable:Boolean = true;
      
      protected var _labelPosition:Number;
      
      protected var _holdTimer:Timer;
      
      protected var _holdProgress:Number;
      
      protected var _holdDuration:Number = -1;
      
      protected var _holdIndicatorMask:Sprite;
      
      protected var _holdIndicator:Sprite;
      
      protected var _posXSource:int = 0;
      
      protected var _shiftXForGamepad:int = 0;
      
      protected var _shiftXForKeyboard:int = 0;
      
      protected var _displayGamepadCode:String = "";
      
      protected var _displayGamepadKeyCode:int = -1;
      
      protected var _displayKeyboardCode:int = -1;
      
      protected var _dataFromStage:Boolean;
      
      protected var _contentInvalid:Boolean = false;
      
      protected var _actualVisibility:Boolean = true;
      
      protected var _lowercaseLabels:Boolean = false;
      
      protected var _overrideTextColor:Number = -1;
      
      protected var _dontSwapAcceptCancel:Boolean;
      
      private var _timerActivated:Boolean = false;
      
      protected var currentPadIconWidth:Number;
      
      public function InputFeedbackButton()
      {
         super();
         constraintsDisabled = true;
         preventAutosizing = true;
         if(this.mcIconXbox)
         {
            this.mcIconXbox.visible = false;
         }
         if(this.mcIconPS)
         {
            this.mcIconPS.visible = false;
         }
         if(this.mcIconPS4)
         {
            this.mcIconPS4.visible = false;
         }
         if(this.mcIconPS5)
         {
            this.mcIconPS5.visible = false;
         }
         if(this.mcKeyboardIcon)
         {
            this.mcKeyboardIcon.visible = false;
         }
         if(this.mcIconSteam)
         {
            this.mcIconSteam.visible = false;
         }
         this._gpadIcon = this.mcIconXbox;
         focusable = false;
         if(textField)
         {
            textField.text = "";
            textField.autoSize = TextFieldAutoSize.LEFT;
         }
         if(this.mcClickRect)
         {
            this.mcClickRect.visible = false;
         }
         if(this.mcHoldAnimation)
         {
            this.mcHoldAnimation.visible = false;
         }
         if(this.tfKeyLabel)
         {
            this.tfKeyLabel.visible = false;
         }
         if(this.mcMouseIcon)
         {
            this.mcMouseIcon.visible = false;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.SetHoldButtonText();
         if(this.tfHoldPrefix)
         {
            this.tfHoldPrefix.visible = false;
         }
      }
      
      public function get dontSwapAcceptCancel() : Boolean
      {
         return this._dontSwapAcceptCancel;
      }
      
      public function set dontSwapAcceptCancel(param1:Boolean) : void
      {
         this._dontSwapAcceptCancel = param1;
      }
      
      public function get overrideTextColor() : Number
      {
         return this._overrideTextColor;
      }
      
      public function set overrideTextColor(param1:Number) : void
      {
         this._overrideTextColor = param1;
      }
      
      public function get lowercaseLabels() : Boolean
      {
         return this._lowercaseLabels;
      }
      
      public function set lowercaseLabels(param1:Boolean) : void
      {
         this._lowercaseLabels = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._actualVisibility = param1;
         this.updateVisibility();
      }
      
      public function get holdDuration() : Number
      {
         return this._holdDuration;
      }
      
      public function set holdDuration(param1:Number) : void
      {
         this._holdDuration = param1;
         InputDelegate.getInstance().removeEventListener(InputEvent.INPUT,this.handleHoldInput,false);
         if(this._holdDuration > 0)
         {
            this.SetHoldButtonText();
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleHoldInput,false,0,true);
         }
         else
         {
            this.stopHoldAnimation();
         }
      }
      
      public function get clickable() : Boolean
      {
         return this._clickable;
      }
      
      public function set clickable(param1:Boolean) : void
      {
         this._clickable = param1;
      }
      
      public function setDataFromStage(param1:String, param2:int, param3:int = -1, param4:Number = 0) : void
      {
         var _loc5_:InputManager;
         (_loc5_ = InputManager.getInstance()).removeEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged);
         _loc5_.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
         this._displayGamepadCode = param1;
         this._displayGamepadKeyCode = param3;
         this._displayKeyboardCode = param2;
         this._dataFromStage = true;
         this.holdDuration = param4;
         this.updateDataFromStage();
         this.SetHoldButtonText();
      }
      
      public function setShiftForGamepad(param1:int = 0, param2:int = 0) : void
      {
         this._posXSource = x;
         this._shiftXForGamepad = param1;
         this._shiftXForKeyboard = param2;
      }
      
      public function getViewWidth() : Number
      {
         if(this.mcClickRect.visible)
         {
            return this.mcClickRect.actualWidth;
         }
         return !!this._currentWidth ? this._currentWidth : width;
      }
      
      public function GetIconSize() : int
      {
         if(this._gpadIcon.visible)
         {
            return GPAD_ICON_SIZE;
         }
         if(this.mcKeyboardIcon.visible)
         {
            return this.mcKeyboardIcon.width;
         }
         return 0;
      }
      
      public function getBindingData() : KeyBindingData
      {
         return this._bindingData;
      }
      
      public function setData(param1:KeyBindingData, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:MovieClip = null;
         this._bindingData = param1;
         if(param3)
         {
            return;
         }
         if(this._bindingData)
         {
            _loc4_ = InputManager.getInstance().isPsPlatform();
            _loc5_ = this.getCurrentPadIcon();
            if(Boolean(this._gpadIcon) && this._gpadIcon != _loc5_)
            {
               this._gpadIcon.visible = false;
            }
            if(this.mcMouseIcon)
            {
               this.mcMouseIcon.visible = false;
            }
            this._gpadIcon = _loc5_;
            this._isGamepad = param2;
            _label = this._bindingData.label;
            if(this._shiftXForGamepad > 0)
            {
               x = this._posXSource;
               if(param2 || _loc4_)
               {
                  x += this._shiftXForGamepad;
               }
               else
               {
                  x += this._shiftXForKeyboard;
               }
            }
            if(this._isGamepad || _loc4_)
            {
               this.displayGamepadIcon();
               if(this.mcHoldAnimation)
               {
                  this.mcHoldAnimation.alpha = 1;
               }
            }
            else
            {
               this.displayKeyboardIcon();
               if(this.mcHoldAnimation)
               {
                  this.mcHoldAnimation.alpha = 0;
               }
            }
         }
         else
         {
            this._contentInvalid = true;
            this.updateVisibility();
         }
      }
      
      protected function getCurrentPadIcon() : MovieClip
      {
         var _loc1_:uint = InputManager.getInstance().gamepadType;
         switch(_loc1_)
         {
            case EInputDeviceType.IDT_PS4:
               if(this.mcIconPS)
               {
                  return this.mcIconPS;
               }
               return this.mcIconPS4;
               break;
            case EInputDeviceType.IDT_PS5:
               if(this.mcIconPS)
               {
                  return this.mcIconPS;
               }
               return this.mcIconPS5;
               break;
            case EInputDeviceType.IDT_Xbox1:
               return this.mcIconXbox;
            case EInputDeviceType.IDT_Steam:
               if(this.mcIconSteam)
               {
                  return this.mcIconSteam;
               }
               return this.mcIconXbox;
               break;
            default:
               return this.mcIconXbox;
         }
      }
      
      public function displayGamepadIcon() : void
      {
         var _loc3_:InputDelegate = null;
         var _loc1_:String = this._bindingData.gamepad_navEquivalent;
         var _loc2_:int = this._bindingData.gamepad_keyCode;
         this.updateText();
         if(_loc1_)
         {
            this.SetupGamepadIcon(_loc1_);
         }
         else if(_loc2_ > 0)
         {
            _loc3_ = InputDelegate.getInstance();
            _loc1_ = _loc3_.inputToNav("key",_loc2_);
            this.SetupGamepadIcon(_loc1_);
         }
         else
         {
            this._contentInvalid = true;
            this.updateVisibility();
         }
      }
      
      public function getCurrentHoldProgress() : Number
      {
         var _loc1_:Number = !!this.mcHoldAnimation ? HOLD_INT_MAX_FRAME : HOLD_INT_MAX_ANGLE;
         return this._holdProgress / _loc1_;
      }
      
      protected function SetHoldButtonText() : void
      {
         if(Boolean(this.tfHoldPrefix) && this.tfHoldPrefix.visible)
         {
            this.tfHoldPrefix.autoSize = TextFieldAutoSize.LEFT;
            this.tfHoldPrefix.text = "[[ControlLayout_hold]]";
            if(!CoreComponent.isArabicAligmentMode)
            {
               this.tfHoldPrefix.text = "[" + this.tfHoldPrefix.text.toUpperCase() + "]";
            }
            else
            {
               this.tfHoldPrefix.text = "*" + this.tfHoldPrefix.text.toUpperCase() + "*";
            }
            this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         }
      }
      
      protected function SetupGamepadIcon(param1:String) : *
      {
         var hitArea:Sprite = null;
         var navCode:String = param1;
         try
         {
            this._gpadIcon.visible = true;
            this._gpadIcon.gotoAndStop(this.getPadIconFrameLabel(navCode));
            this.mcKeyboardIcon.visible = false;
            if(this.mcClickRect)
            {
               this.mcClickRect.visible = false;
            }
            if(this.tfKeyLabel)
            {
               this.tfKeyLabel.visible = false;
            }
            this._contentInvalid = false;
            this.updateVisibility();
            hitArea = this._gpadIcon["viewrect"] as Sprite;
            this.currentPadIconWidth = !!hitArea ? hitArea.width : this._gpadIcon.width;
            this._labelPosition = this.currentPadIconWidth + TEXT_PADDING_PAD;
            this._gpadIcon.x = Math.round(this.currentPadIconWidth / 2);
            this.updateText();
            this._currentWidth = this.currentPadIconWidth + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? this.tfHoldPrefix.width : 0);
            if(this._holdIndicator)
            {
               this._holdIndicator.visible = false;
            }
            this._holdIndicator = this._gpadIcon["holdIndicator"] as Sprite;
            if(this._holdIndicator)
            {
               this._holdIndicator.visible = false;
            }
         }
         catch(err:Error)
         {
         }
      }
      
      protected function getPadIconFrameLabel(param1:String) : String
      {
         var _loc2_:InputManager = InputManager.getInstance();
         if(!this._dontSwapAcceptCancel && _loc2_.swapAcceptCancel)
         {
            if(param1 == NavigationCode.GAMEPAD_A)
            {
               return NavigationCode.GAMEPAD_B;
            }
            if(param1 == NavigationCode.GAMEPAD_B)
            {
               return NavigationCode.GAMEPAD_A;
            }
         }
         return param1;
      }
      
      protected function displayKeyboardIcon() : void
      {
         var _loc2_:String = null;
         var _loc1_:int = this._bindingData.keyboard_keyCode;
         if(_loc1_ > 0)
         {
            _loc2_ = KeyboardKeys.getKeyLabel(_loc1_);
            if(!this.clickable)
            {
               if(Boolean(this.mcMouseIcon) && this.mcMouseIcon.isMouseKey(_loc1_))
               {
                  this.mcMouseIcon.visible = true;
                  this.mcMouseIcon.keyCode = _loc1_;
                  this._labelPosition = this.mcMouseIcon.width + TEXT_PADDING_KEYBOARD;
               }
               else
               {
                  this.mcKeyboardIcon.visible = true;
                  this.mcKeyboardIcon.label = _loc2_;
                  this._labelPosition = this.mcKeyboardIcon.width + TEXT_PADDING_KEYBOARD;
               }
               if(this.tfKeyLabel)
               {
                  this.tfKeyLabel.visible = false;
               }
               if(this.mcClickRect)
               {
                  this.mcClickRect.visible = false;
               }
            }
            else
            {
               if(this.tfKeyLabel)
               {
                  this.tfKeyLabel.x = KEY_LABEL_PADDING;
                  this.tfKeyLabel.visible = true;
                  this.tfKeyLabel.text = _loc2_;
                  if(!CoreComponent.isArabicAligmentMode)
                  {
                     this.tfKeyLabel.text = "[" + CommonUtils.toUpperCaseSafe(this.tfKeyLabel.text) + "]";
                  }
                  else
                  {
                     this.tfKeyLabel.text = "*" + CommonUtils.toUpperCaseSafe(this.tfKeyLabel.text) + "*";
                  }
                  this.tfKeyLabel.width = this.tfKeyLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                  this._labelPosition = this.tfKeyLabel.x + this.tfKeyLabel.textWidth + TEXT_PADDING_KEYBOARD;
               }
               if(this.mcClickRect)
               {
                  this.mcClickRect.visible = true;
               }
            }
            this._contentInvalid = false;
            this._gpadIcon.visible = false;
            this.updateText();
            this._currentWidth = this.mcKeyboardIcon.width + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? this.tfHoldPrefix.width : 0);
         }
         else
         {
            this._contentInvalid = true;
         }
         this.updateVisibility();
      }
      
      public function updateDataFromStage() : void
      {
         var _loc1_:KeyBindingData = null;
         if(this._displayGamepadCode || this._displayKeyboardCode > 0 || this._displayGamepadKeyCode > 0)
         {
            _loc1_ = new KeyBindingData();
            _loc1_.actionId = 0;
            _loc1_.gamepad_navEquivalent = this._displayGamepadCode;
            _loc1_.keyboard_keyCode = this._displayKeyboardCode;
            _loc1_.gamepad_keyCode = this._displayGamepadKeyCode;
            _loc1_.label = !!label ? label : "";
            this._isGamepad = InputManager.getInstance().isGamepad();
            this._dataFromStage = true;
            this.setData(_loc1_,this._isGamepad);
            this.stopHoldAnimation();
         }
      }
      
      protected function updateVisibility() : void
      {
         var _loc1_:* = this._actualVisibility && !this._contentInvalid;
         if(super.visible != _loc1_)
         {
            super.visible = _loc1_;
            this.UpdateHoldAnimation();
         }
      }
      
      protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         if(this._dataFromStage)
         {
            this.SetHoldButtonText();
            this.updateDataFromStage();
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:KeyboardButtonClickArea = null;
         var _loc2_:ColorMatrixFilter = null;
         if(this.tfHoldPrefix)
         {
            if((this.holdDuration > 0 || this.addHoldPrefix) && _label && Boolean(textField))
            {
               this.SetHoldButtonText();
               this.tfHoldPrefix.textColor = this._overrideTextColor > -1 ? uint(this._overrideTextColor) : 16777215;
               this.tfHoldPrefix.autoSize = TextFieldAutoSize.LEFT;
               this.tfHoldPrefix.visible = true;
               this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
               this.tfHoldPrefix.x = this._labelPosition;
               textField.x = this._labelPosition + this.tfHoldPrefix.width;
            }
            else
            {
               this.tfHoldPrefix.visible = false;
               textField.x = this._labelPosition;
            }
         }
         if(_label != null && textField != null)
         {
            if(this._overrideTextColor >= 0)
            {
               textField.textColor = this._overrideTextColor;
               textField.text = _label;
            }
            else
            {
               textField.htmlText = _label;
            }
            if(this._lowercaseLabels)
            {
               textField.text = CommonUtils.toLowerCaseExSafe(textField.text);
            }
            textField.width = textField.textWidth + TEXT_OFFSET;
            if(Boolean(this.mcClickRect) && this.mcClickRect.visible)
            {
               _loc1_ = this.mcClickRect as KeyboardButtonClickArea;
               if(_loc1_)
               {
                  _loc1_.state = state;
                  _loc1_.setActualSize(CLICKABLE_BK_OFFSET + textField.x + textField.width,this.mcClickRect.height);
                  this.mcClickRect.x = 0;
                  this.mcClickRect.y = -this.mcClickRect.height / 2;
                  this.mcClickRect.visible = true;
               }
               else if(this.mcClickRect)
               {
                  this.mcClickRect.visible = false;
               }
            }
         }
         if(enabled)
         {
            this.filters = [];
            alpha = 1;
         }
         else if(this.filters.length < 1)
         {
            _loc2_ = CommonUtils.getDesaturateFilter();
            this.filters = [_loc2_];
            alpha = DISABLED_ALPHA;
         }
      }
      
      private function SpawnHoldAnimationMask() : void
      {
         if(this._holdIndicatorMask == null)
         {
            this._holdIndicatorMask = new Sprite();
            this._holdIndicatorMask.x = this._holdIndicator.x + this._holdIndicator.width / 2;
            this._holdIndicatorMask.y = this._holdIndicator.y;
            addChild(this._holdIndicatorMask);
            this._holdIndicator.mask = this._holdIndicatorMask;
         }
      }
      
      public function startHoldAnimation() : void
      {
         if(!this._holdIndicator)
         {
            return;
         }
         if(this._holdTimer)
         {
            return;
         }
         this.stopHoldAnimation();
         if(!this.mcHoldAnimation)
         {
            this.SpawnHoldAnimationMask();
         }
         else
         {
            this.mcHoldAnimation.visible = true;
            this.mcHoldAnimation.gotoAndStop("Idle");
            if(this.clickable && Boolean(this.mcClickRect["mcHoldAnim"]))
            {
               this.mcClickRect["mcHoldAnim"].gotoAndStop("Idle");
            }
         }
         this._holdTimer = new Timer(HOLD_ANIM_INTERVAL);
         this._holdTimer.addEventListener(TimerEvent.TIMER,this.handleHoldTimer,false,0,true);
         this._holdTimer.start();
         this._holdProgress = 0;
      }
      
      protected function stopHoldAnimation() : void
      {
         if(this._holdTimer)
         {
            this._timerActivated = false;
            this._holdTimer.removeEventListener(TimerEvent.TIMER,this.handleHoldTimer,false);
            this._holdTimer.stop();
            this._holdTimer = null;
         }
         if(this._holdIndicatorMask)
         {
            this._holdIndicatorMask.visible = false;
         }
         if(this._holdIndicator)
         {
            this._holdIndicator.visible = false;
         }
         if(this.mcHoldAnimation)
         {
            this.mcHoldAnimation.visible = false;
            this.mcHoldAnimation.gotoAndStop("Idle");
            if(this.clickable && Boolean(this.mcClickRect["mcHoldAnim"]))
            {
               this.mcClickRect["mcHoldAnim"].gotoAndStop("Idle");
            }
         }
         this._holdProgress = 0;
      }
      
      protected function handleHoldTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = !!this.mcHoldAnimation ? HOLD_INT_MAX_FRAME : HOLD_INT_MAX_ANGLE;
         if(this._holdProgress > _loc2_)
         {
            this.stopHoldAnimation();
            if(this.holdCallback != null && !this._timerActivated)
            {
               this.holdCallback();
               this._timerActivated = true;
            }
            if(this.mcHoldAnimation)
            {
               this.mcHoldAnimation.gotoAndPlay("Done");
            }
            return;
         }
         if(!this.mcHoldAnimation)
         {
            this.SpawnHoldAnimationMask();
         }
         if(this.parent == null || this.visible == false)
         {
            return;
         }
         this.UpdateHoldAnimation();
      }
      
      protected function UpdateHoldAnimation() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!this._holdIndicator || !this._holdIndicatorMask && !this.mcHoldAnimation || this.mcHoldAnimation && !this.mcHoldAnimation.visible || !visible)
         {
            return;
         }
         var _loc3_:Number = !!this.mcHoldAnimation ? HOLD_INT_MAX_FRAME : HOLD_INT_MAX_ANGLE;
         _loc1_ = _loc3_ / (this._holdDuration / HOLD_ANIM_INTERVAL);
         this._holdProgress += _loc1_;
         _loc2_ = Math.min(_loc3_,this._holdProgress);
         if(_loc2_ > 0)
         {
            if(this.mcHoldAnimation)
            {
               this.mcHoldAnimation.visible = true;
               this.mcHoldAnimation.gotoAndStop(HOLD_INT_FIRST_FRAME + _loc2_);
               if(this.clickable && Boolean(this.mcClickRect["mcHoldAnim"]))
               {
                  this.mcClickRect["mcHoldAnim"].gotoAndStop(HOLD_INT_FIRST_FRAME + _loc2_);
               }
            }
            else
            {
               this._holdIndicator.visible = true;
               this._holdIndicatorMask.visible = true;
               this._holdIndicatorMask.graphics.clear();
               CommonUtils.drawPie(this._holdIndicatorMask.graphics,this._holdIndicator.width,HOLD_ANIM_STEPS_COUNT,0,_loc2_);
            }
         }
         else if(this.mcHoldAnimation)
         {
            this.mcHoldAnimation.visible = false;
         }
         else
         {
            this._holdIndicator.visible = false;
            this._holdIndicatorMask.visible = false;
         }
      }
      
      public function handleHoldInput(param1:InputEvent) : void
      {
         var _loc2_:InputManager = null;
         var _loc3_:InputDetails = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(!param1.handled && this._holdDuration > 0 && Boolean(this._bindingData))
         {
            _loc2_ = InputManager.getInstance();
            _loc3_ = param1.details;
            _loc4_ = _loc3_.code;
            _loc5_ = _loc3_.navEquivalent;
            if(_loc2_.swapAcceptCancel)
            {
               if(_loc5_ == NavigationCode.GAMEPAD_A)
               {
                  _loc5_ = NavigationCode.GAMEPAD_B;
                  _loc4_ = int(KeyCode.PAD_B_CIRCLE);
               }
               else if(_loc5_ == NavigationCode.GAMEPAD_B)
               {
                  _loc5_ = NavigationCode.GAMEPAD_A;
                  _loc4_ = int(KeyCode.PAD_A_CROSS);
               }
            }
            if(_loc5_ == this._bindingData.gamepad_navEquivalent || _loc4_ == this._bindingData.keyboard_keyCode || _loc4_ == this._bindingData.gamepad_keyCode)
            {
               if(visible)
               {
                  if(_loc3_.value == InputValue.KEY_DOWN && !this._holdTimer)
                  {
                     this.startHoldAnimation();
                  }
                  else if(_loc3_.value == InputValue.KEY_UP && Boolean(this._holdTimer))
                  {
                     this.stopHoldAnimation();
                  }
               }
            }
         }
      }
      
      public function getOccupiedWidth() : int
      {
         return textField.x + textField.textWidth;
      }
      
      override public function toString() : String
      {
         return "InputFeedbackButton [" + this.name + "] _bindingData: " + this._bindingData;
      }
   }
}
