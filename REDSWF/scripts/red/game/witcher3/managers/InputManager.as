package red.game.witcher3.managers
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import red.game.witcher3.constants.EInputDeviceType;
   import red.game.witcher3.constants.KeyCode;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.events.ControllerChangeEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class InputManager extends EventDispatcher
   {
      
      public static const LOCKED_SCHEME_NONE:uint = 0;
      
      public static const LOCKED_SCHEME_GPAD:uint = 1;
      
      public static const LOCKED_SCHEME_MOUSE:uint = 2;
      
      public static const GAMEPAD_TYPE_XBOX:uint = 0;
      
      public static const GAMEPAD_TYPE_PS4:uint = 1;
      
      public static const GAMEPAD_TYPE_STEAM:uint = 2;
      
      protected static const CHANGE_CONTROLLER_TYPE_DELAY:Number = -1;
      
      protected static const CHANGE_CONTROLLER_MOUSE_DELTA:Number = 3;
      
      protected static const HOLD_DELAY:Number = 500;
      
      protected static const HOLD_INTERVAL:Number = 200;
      
      protected static const HOLD_INTERVAL_MIN:Number = 30;
      
      protected static const HOLD_INTERVAL_SPEED_UP_SCALE:Number = 0.88;
      
      protected static var _instance:InputManager;
       
      
      protected var currentHoldInterval:Number = 200;
      
      private var _inputBlocks:Object;
      
      protected var _inputDelegate:InputDelegate;
      
      protected var _rootStage:DisplayObjectContainer;
      
      protected var _isGamepad:Boolean;
      
      protected var _gpadInputReceived:Boolean;
      
      protected var _pendedGamepadInput:Boolean;
      
      protected var _pressedMap:Object;
      
      protected var _holdTimer:Timer;
      
      protected var _ctrlChangeTimer:Timer;
      
      protected var _bufMouseX:Number = 0;
      
      protected var _bufMouseY:Number = 0;
      
      protected var _platformType:uint = 0;
      
      protected var _initialized:Boolean;
      
      protected var _enableHoldEmulation:Boolean;
      
      protected var _enableInputDeviceCheck:Boolean;
      
      protected var _swapAcceptCancel:Boolean;
      
      protected var _lockedControlScheme:uint = 0;
      
      protected var _gamepadType:uint = 0;
      
      protected var _validatingIsGamepad:Boolean = false;
      
      protected var _validatingPlatformType:uint = 0;
      
      public function InputManager()
      {
         this._inputBlocks = {};
         this._pressedMap = {};
         super();
      }
      
      public static function getInstance() : InputManager
      {
         if(!_instance)
         {
            _instance = new InputManager();
         }
         return _instance;
      }
      
      public function init(param1:DisplayObjectContainer, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(this._initialized)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         if(ExternalInterface.available)
         {
            this._isGamepad = true;
         }
         this._initialized = true;
         this._rootStage = param1;
         this.enableInputDeviceCheck = param3;
         this.enableHoldEmulation = param2;
      }
      
      public function addInputBlocker(param1:Boolean, param2:String = "default") : void
      {
         this._inputBlocks[param2] = param1 ? 1 : 0;
         this.updateInputBlockers();
      }
      
      public function removeInputBlocker(param1:String = "default") : void
      {
         delete this._inputBlocks[param1];
         this.updateInputBlockers();
      }
      
      protected function updateInputBlockers() : void
      {
         var _loc3_:String = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         for(_loc3_ in this._inputBlocks)
         {
            if(!this._inputBlocks[_loc3_])
            {
               _loc2_ = true;
               break;
            }
            _loc1_ = true;
         }
         if(_loc2_ || !_loc1_)
         {
            InputDelegate.getInstance().disableInputEvents(false);
         }
         else
         {
            InputDelegate.getInstance().disableInputEvents(true);
         }
      }
      
      public function forceInputFeedbackUpdate() : void
      {
         this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
      }
      
      public function get gamepadType() : uint
      {
         if(this._platformType == PlatformType.PLATFORM_PS4)
         {
            return GAMEPAD_TYPE_PS4;
         }
         if(this._platformType == PlatformType.PLATFORM_XBOX1)
         {
            return GAMEPAD_TYPE_XBOX;
         }
         if(this._platformType == PlatformType.PLATFORM_PC && this._gamepadType != EInputDeviceType.IDT_PS4 && this._gamepadType != EInputDeviceType.IDT_Steam)
         {
            return EInputDeviceType.IDT_Xbox1;
         }
         return this._gamepadType;
      }
      
      public function set gamepadType(param1:uint) : void
      {
         if(this._gamepadType == EInputDeviceType.IDT_Steam || param1 == EInputDeviceType.IDT_Steam)
         {
            this._gamepadType = param1;
            if(this._gamepadType == EInputDeviceType.IDT_Steam)
            {
               this._lockedControlScheme = LOCKED_SCHEME_GPAD;
               this.setGamepadInputType(true,true);
            }
            else
            {
               this._lockedControlScheme = LOCKED_SCHEME_NONE;
               this.setGamepadInputType(this._isGamepad,true);
            }
            this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
         }
         else
         {
            this._gamepadType = param1;
         }
      }
      
      public function get lockedControlScheme() : uint
      {
         return this._lockedControlScheme;
      }
      
      public function set lockedControlScheme(param1:uint) : void
      {
         if(this.gamepadType == EInputDeviceType.IDT_Steam)
         {
            param1 = LOCKED_SCHEME_GPAD;
         }
         switch(this._lockedControlScheme)
         {
            case LOCKED_SCHEME_GPAD:
               this.setGamepadInputType(true,true);
               break;
            case LOCKED_SCHEME_MOUSE:
               this.setGamepadInputType(false,true);
         }
         this._lockedControlScheme = param1;
      }
      
      public function get swapAcceptCancel() : Boolean
      {
         return this._swapAcceptCancel;
      }
      
      public function set swapAcceptCancel(param1:Boolean) : void
      {
         this._swapAcceptCancel = param1;
         this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
      }
      
      public function get enableInputDeviceCheck() : Boolean
      {
         return this._enableInputDeviceCheck;
      }
      
      public function set enableInputDeviceCheck(param1:Boolean) : void
      {
         this._enableInputDeviceCheck = param1;
         this._rootStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse,false);
         this._rootStage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouse,false);
         this._rootStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouse,false);
         if(this._enableInputDeviceCheck)
         {
            this._rootStage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse,false,0,true);
            this._rootStage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouse,false,0,true);
            this._rootStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouse,false,0,true);
         }
         this.updateInputListeners();
      }
      
      public function get enableHoldEmulation() : Boolean
      {
         return this._enableHoldEmulation;
      }
      
      public function set enableHoldEmulation(param1:Boolean) : void
      {
         this._enableHoldEmulation = param1;
         if(this._holdTimer)
         {
            this._holdTimer.stop();
            this._holdTimer.removeEventListener(TimerEvent.TIMER,this.handleHoldEvent);
            this._holdTimer = null;
         }
         if(this._enableHoldEmulation)
         {
            this._holdTimer = new Timer(HOLD_DELAY);
            this._holdTimer.addEventListener(TimerEvent.TIMER,this.handleHoldEvent,false,0,true);
            this._holdTimer.start();
         }
         this.updateInputListeners();
      }
      
      public function getPlatform() : uint
      {
         return this._platformType;
      }
      
      public function isGamepad() : Boolean
      {
         return this._isGamepad || this._platformType != PlatformType.PLATFORM_PC;
      }
      
      public function setControllerType(param1:Boolean) : void
      {
         if(param1 != this._isGamepad)
         {
            this.setGamepadInputType(param1);
         }
      }
      
      public function setPlatformType(param1:uint) : void
      {
         this._platformType = param1;
         this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
      }
      
      protected function updateInputListeners() : void
      {
         if(this._enableInputDeviceCheck || this._enableHoldEmulation)
         {
            this._inputDelegate = InputDelegate.getInstance();
            this._inputDelegate.addEventListener(InputEvent.INPUT,this.handleDelegatedInput,false,1,true);
         }
         else
         {
            this._inputDelegate = InputDelegate.getInstance();
            this._inputDelegate.removeEventListener(InputEvent.INPUT,this.handleDelegatedInput,false);
            this._inputDelegate = null;
         }
      }
      
      protected function handleHoldEvent(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:InputEvent = null;
         var _loc4_:InputDetails = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:InputDetails = null;
         if(this.currentHoldInterval == HOLD_DELAY)
         {
            this.currentHoldInterval = HOLD_INTERVAL;
         }
         this.currentHoldInterval = Math.max(this.currentHoldInterval * HOLD_INTERVAL_SPEED_UP_SCALE,HOLD_INTERVAL_MIN);
         this._holdTimer.delay = this.currentHoldInterval;
         this._holdTimer.reset();
         this._holdTimer.start();
         for(_loc2_ in this._pressedMap)
         {
            _loc3_ = this._pressedMap[_loc2_] as InputEvent;
            _loc5_ = (_loc4_ = _loc3_.details).code;
            _loc6_ = _loc4_.navEquivalent;
            if(this.swapAcceptCancel)
            {
               if(_loc4_.code == KeyCode.PAD_A_CROSS)
               {
                  _loc5_ = int(KeyCode.PAD_B_CIRCLE);
                  _loc6_ = NavigationCode.GAMEPAD_B;
               }
               else if(_loc4_.code == KeyCode.PAD_B_CIRCLE)
               {
                  _loc5_ = int(KeyCode.PAD_A_CROSS);
                  _loc6_ = NavigationCode.GAMEPAD_A;
               }
            }
            _loc7_ = new InputDetails("key",_loc5_,InputValue.KEY_HOLD,_loc6_,_loc4_.controllerIndex,_loc4_.ctrlKey,_loc4_.altKey,_loc4_.shiftKey,_loc4_.fromJoystick);
            this._inputDelegate.dispatchEvent(new InputEvent(InputEvent.INPUT,_loc7_));
         }
      }
      
      protected function handleDelegatedInput(param1:InputEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:InputDetails = param1.details;
         if(this._platformType == PlatformType.PLATFORM_PC)
         {
            _loc3_ = this.isGamepadCode(_loc2_);
         }
         else
         {
            _loc3_ = true;
         }
         if(this._enableHoldEmulation)
         {
            this.holdProcessing(param1);
         }
         if(_loc3_)
         {
            this._gpadInputReceived = true;
            this.setGamepadInputType(true);
            return;
         }
         if(this._gpadInputReceived || param1.details.value == InputValue.KEY_HOLD)
         {
            this._gpadInputReceived = false;
            return;
         }
         this.setGamepadInputType(false);
      }
      
      protected function holdProcessing(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Number = _loc2_.code;
         if(_loc2_.value == InputValue.KEY_DOWN)
         {
            this._holdTimer.delay = HOLD_DELAY;
            this.currentHoldInterval = HOLD_DELAY;
            this._holdTimer.reset();
            this._holdTimer.start();
            if(!this._pressedMap[_loc3_])
            {
               this._pressedMap[_loc3_] = param1;
            }
         }
         else if(_loc2_.value == InputValue.KEY_UP)
         {
            delete this._pressedMap[_loc3_];
            this._holdTimer.stop();
            this.currentHoldInterval = HOLD_DELAY;
         }
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         var _loc2_:Number = Math.abs(param1.stageX - this._bufMouseX);
         var _loc3_:Number = Math.abs(param1.stageY - this._bufMouseY);
         if(_loc2_ > CHANGE_CONTROLLER_MOUSE_DELTA || _loc3_ > CHANGE_CONTROLLER_MOUSE_DELTA)
         {
            this.setGamepadInputType(false);
         }
         this._bufMouseX = param1.stageX;
         this._bufMouseY = param1.stageY;
      }
      
      protected function setGamepadInputType(param1:Boolean, param2:Boolean = false) : void
      {
         if(!this._ctrlChangeTimer && param1 != this._isGamepad || this._ctrlChangeTimer && param1 != this._pendedGamepadInput)
         {
            if(this._ctrlChangeTimer)
            {
               this._ctrlChangeTimer.removeEventListener(TimerEvent.TIMER,this.delayedFireControllerChangeEvent);
               this._ctrlChangeTimer.stop();
            }
            if(this.lockedControlScheme != LOCKED_SCHEME_NONE && !param2)
            {
               return;
            }
            if(CHANGE_CONTROLLER_TYPE_DELAY > 0)
            {
               this._pendedGamepadInput = param1;
               this._ctrlChangeTimer = new Timer(CHANGE_CONTROLLER_TYPE_DELAY,1);
               this._ctrlChangeTimer.addEventListener(TimerEvent.TIMER,this.delayedFireControllerChangeEvent,false,0,true);
               this._ctrlChangeTimer.start();
            }
            else
            {
               this._isGamepad = param1;
               this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
            }
         }
      }
      
      protected function delayedFireControllerChangeEvent(param1:TimerEvent) : void
      {
         if(this._pendedGamepadInput != this._isGamepad)
         {
            this._isGamepad = this._pendedGamepadInput;
            this.fireCtrlChangeEvent(this._isGamepad,this._platformType);
         }
         if(this._ctrlChangeTimer)
         {
            this._ctrlChangeTimer.removeEventListener(TimerEvent.TIMER,this.delayedFireControllerChangeEvent);
            this._ctrlChangeTimer.stop();
            this._ctrlChangeTimer = null;
         }
      }
      
      protected function fireCtrlChangeEvent(param1:Boolean, param2:uint) : void
      {
         this._validatingIsGamepad = param1;
         this._validatingPlatformType = param2;
         this._rootStage.removeEventListener(Event.ENTER_FRAME,this.validateFireCtrlChangeEvent,false);
         this._rootStage.addEventListener(Event.ENTER_FRAME,this.validateFireCtrlChangeEvent,false,0,true);
      }
      
      protected function validateFireCtrlChangeEvent(param1:Event = null) : void
      {
         var _loc2_:ControllerChangeEvent = new ControllerChangeEvent(ControllerChangeEvent.CONTROLLER_CHANGE);
         this._rootStage.removeEventListener(Event.ENTER_FRAME,this.validateFireCtrlChangeEvent,false);
         _loc2_.isGamepad = this._validatingIsGamepad || this._validatingPlatformType != PlatformType.PLATFORM_PC;
         _loc2_.platformType = this._validatingPlatformType;
         dispatchEvent(_loc2_);
      }
      
      protected function isGamepadCode(param1:InputDetails) : Boolean
      {
         if(param1.fromJoystick)
         {
            return true;
         }
         var _loc2_:Number = param1.code;
         switch(_loc2_)
         {
            case KeyCode.PAD_A_CROSS:
            case KeyCode.PAD_B_CIRCLE:
            case KeyCode.PAD_X_SQUARE:
            case KeyCode.PAD_Y_TRIANGLE:
            case KeyCode.PAD_START:
            case KeyCode.PAD_BACK_SELECT:
            case KeyCode.PAD_DIGIT_UP:
            case KeyCode.PAD_DIGIT_DOWN:
            case KeyCode.PAD_DIGIT_LEFT:
            case KeyCode.PAD_DIGIT_RIGHT:
            case KeyCode.PAD_LEFT_THUMB:
            case KeyCode.PAD_RIGHT_THUMB:
            case KeyCode.PAD_LEFT_SHOULDER:
            case KeyCode.PAD_RIGHT_SHOULDER:
            case KeyCode.PAD_LEFT_TRIGGER:
            case KeyCode.PAD_RIGHT_TRIGGER:
            case KeyCode.PAD_LEFT_STICK_AXIS:
            case KeyCode.PAD_RIGHT_STICK_AXIS:
            case KeyCode.PAD_LEFT_TRIGGER_AXIS:
            case KeyCode.PAD_RIGHT_TRIGGER_AXIS:
            case KeyCode.PAD_RIGHT_STICK_LEFT:
            case KeyCode.PAD_RIGHT_STICK_RIGHT:
            case KeyCode.PAD_RIGHT_STICK_DOWN:
            case KeyCode.PAD_RIGHT_STICK_UP:
               return true;
            default:
               return false;
         }
      }
      
      public function reset() : void
      {
         if(this._pressedMap)
         {
            if(this._holdTimer)
            {
               this._holdTimer.reset();
               this._holdTimer.stop();
            }
            this._pressedMap = {};
         }
      }
   }
}
