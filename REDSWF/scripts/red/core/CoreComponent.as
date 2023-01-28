package red.core
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import red.core.events.GameEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.managers.RuntimeAssetsManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class CoreComponent extends UIComponent implements IGameAdapter
   {
      
      public static var isColorBlindMode:Boolean;
      
      public static var isArabicAligmentMode:Boolean;
      
      public static var _gameLanguage:String;
       
      
      protected var _inputHandlers:Vector.<UIComponent>;
      
      protected var _inputMgr:InputManager;
      
      protected var _enableInputValidation:Boolean = false;
      
      protected var _enableHoldEmulation:Boolean = true;
      
      protected var _enableInputDeviceCheck:Boolean = true;
      
      protected var pressedButtonsByKeys:Object;
      
      protected var pressedButtonsByNavEquivalent:Object;
      
      public var _NATIVE_registerDataBinding:Function;
      
      public var _NATIVE_unregisterDataBinding:Function;
      
      public var _NATIVE_registerChild:Function;
      
      public var _NATIVE_unregisterChild:Function;
      
      public var _NATIVE_callGameEvent:Function;
      
      public var _NATIVE_registerRenderTarget:Function;
      
      public var _NATIVE_unregisterRenderTarget:Function;
      
      public function CoreComponent()
      {
         this.pressedButtonsByKeys = {};
         this.pressedButtonsByNavEquivalent = {};
         super();
         this._inputMgr = InputManager.getInstance();
         this._inputHandlers = new Vector.<UIComponent>();
         addEventListener(GameEvent.CALL,this.handleGameEvent,false,int.MAX_VALUE,true);
         addEventListener(GameEvent.REGISTER,this.handleRegisterDataBinding,false,0,true);
         addEventListener(GameEvent.UNREGISTER,this.handleUnregisterDataBinding,false,0,true);
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init,false,int.MAX_VALUE,true);
         }
      }
      
      public static function set gameLanguage(param1:String) : void
      {
         _gameLanguage = param1;
         CommonUtils.setTurkish(param1 == "TR");
      }
      
      public static function get gameLanguage() : String
      {
         return _gameLanguage;
      }
      
      public function swapAcceptCancel(param1:Boolean) : void
      {
         InputManager.getInstance().swapAcceptCancel = param1;
         InputDelegate.getInstance().swapAcceptCancel = param1;
      }
      
      public function resetInput() : void
      {
         InputManager.getInstance().reset();
      }
      
      public function setControllerType(param1:Boolean) : void
      {
         InputManager.getInstance().setControllerType(param1);
      }
      
      public function setPlatform(param1:uint) : void
      {
         InputManager.getInstance().setPlatformType(param1);
      }
      
      public function lockControlScheme(param1:uint) : void
      {
         InputManager.getInstance().lockedControlScheme = param1;
      }
      
      public function setGamepadType(param1:uint) : void
      {
         InputManager.getInstance().gamepadType = param1;
      }
      
      public function forceInputFeedbackUpdate() : void
      {
         InputManager.getInstance().forceInputFeedbackUpdate();
      }
      
      public function setArabicAligmentMode(param1:Boolean) : void
      {
         isArabicAligmentMode = param1;
      }
      
      private function init(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init,false);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false,int.MIN_VALUE,true);
         this.onCoreInit();
      }
      
      protected function onCoreInit() : void
      {
      }
      
      protected function onCoreCleanup() : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._inputMgr.init(stage,this._enableHoldEmulation,this._enableInputDeviceCheck);
         if(this._enableInputValidation)
         {
            this.enableInputValidations(true);
         }
      }
      
      override public function toString() : String
      {
         return "CoreComponent [ " + this.name + " ]";
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false);
         RuntimeAssetsManager.getInstanse().unloadLibrary();
      }
      
      private function handleGameEvent(param1:GameEvent) : void
      {
         param1.stopImmediatePropagation();
         this.callGameEvent(param1.eventName,param1.eventArgs);
      }
      
      private function handleRegisterDataBinding(param1:GameEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:String = param1.eventName;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         if(param1.eventArgs.length > 0)
         {
            _loc3_ = param1.eventArgs[0] as Object;
         }
         if(param1.eventArgs.length > 1)
         {
            _loc4_ = param1.eventArgs[1] as Object;
         }
         if(param1.eventArgs.length > 2)
         {
            _loc5_ = param1.eventArgs[2] as Boolean;
         }
         this.registerDataBinding(_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      private function handleUnregisterDataBinding(param1:GameEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:String = param1.eventName;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param1.eventArgs.length > 0)
         {
            _loc3_ = param1.eventArgs[0] as Object;
         }
         if(param1.eventArgs.length > 1)
         {
            _loc4_ = param1.eventArgs[1] as Object;
         }
         this.unregisterDataBinding(_loc2_,_loc3_,_loc4_);
      }
      
      public function registerDataBinding(param1:String, param2:Object, param3:Object = null, param4:Boolean = false) : void
      {
         if(this._NATIVE_registerDataBinding != null)
         {
            this._NATIVE_registerDataBinding(param1,param2,param3,param4);
         }
      }
      
      public function unregisterDataBinding(param1:String, param2:Object, param3:Object = null) : void
      {
         if(this._NATIVE_unregisterDataBinding != null)
         {
            this._NATIVE_unregisterDataBinding(param1,param2,param3);
         }
      }
      
      public function registerChild(param1:DisplayObject, param2:String) : void
      {
         if(this._NATIVE_registerChild != null)
         {
            this._NATIVE_registerChild(param1,param2);
         }
      }
      
      public function unregisterChild() : void
      {
         if(this._NATIVE_unregisterChild != null)
         {
            this._NATIVE_unregisterChild();
         }
      }
      
      public function callGameEvent(param1:String, param2:Array) : void
      {
         if(this._NATIVE_callGameEvent != null)
         {
            this._NATIVE_callGameEvent(param1,param2);
         }
      }
      
      public function registerRenderTarget(param1:String, param2:uint, param3:uint) : void
      {
         if(this._NATIVE_registerRenderTarget != null)
         {
            this._NATIVE_registerRenderTarget(param1,param2,param3);
         }
      }
      
      public function unregisterRenderTarget(param1:String) : void
      {
         if(this._NATIVE_unregisterRenderTarget != null)
         {
            this._NATIVE_unregisterRenderTarget(param1);
         }
      }
      
      protected function enableInputValidations(param1:Boolean) : void
      {
         var _loc2_:InputDelegate = InputDelegate.getInstance();
         _loc2_.removeEventListener(InputEvent.INPUT,this.handleInputValidation,false);
         if(param1)
         {
            _loc2_.addEventListener(InputEvent.INPUT,this.handleInputValidation,false,0,true);
         }
      }
      
      protected function handleInputValidation(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_DOWN;
         if(_loc3_)
         {
            this.pressedButtonsByNavEquivalent[_loc2_.navEquivalent] = true;
            this.pressedButtonsByKeys[_loc2_.code] = true;
         }
      }
      
      public function isInputValidationEnabled() : Boolean
      {
         return this._enableInputValidation;
      }
      
      public function isKeyCodeValid(param1:int) : Boolean
      {
         if(this._enableInputValidation)
         {
            return Boolean(this.pressedButtonsByKeys[param1]);
         }
         return true;
      }
      
      public function isNavEquivalentValid(param1:String) : Boolean
      {
         if(this._enableInputValidation)
         {
            return Boolean(this.pressedButtonsByNavEquivalent[param1]);
         }
         return true;
      }
   }
}
