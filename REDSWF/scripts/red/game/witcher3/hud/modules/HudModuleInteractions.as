package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class HudModuleInteractions extends HudModuleBase
   {
      
      private static const HOLD_DELAY:Number = 200;
       
      
      public var mcHoldInteraction:MovieClip;
      
      public var mcInteraction:MovieClip;
      
      public var mcIcon:MovieClip;
      
      private var mcFocusInteractionIcon:MovieClip;
      
      private var _btnInteraction:InputFeedbackButton;
      
      private var _btnHoldInteraction:InputFeedbackButton;
      
      private var _holdIndicatorDisplayed:Boolean;
      
      private var _holdIndicatorData:KeyBindingData;
      
      private var _cachedInputEvent:InputEvent;
      
      private var _startHoldShowing:Boolean = false;
      
      private var _holdDelayTimer:Timer;
      
      public function HudModuleInteractions()
      {
         super();
         this.__setProp_mcHoldInteraction_Scene1_Items_0();
         this.__setProp_mcInteraction_Scene1_Layer1_0();
      }
      
      override public function get moduleName() : String
      {
         return "InteractionsModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._btnInteraction = this.mcInteraction.btnInteract as InputFeedbackButton;
         this._btnInteraction.clickable = false;
         this._btnInteraction.dontSwapAcceptCancel = true;
         this._btnHoldInteraction = this.mcHoldInteraction.btnInteract as InputFeedbackButton;
         this._btnHoldInteraction.clickable = false;
         this._btnHoldInteraction.dontSwapAcceptCancel = true;
         visible = true;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleHoldInput,false,0,true);
         if(!Extensions.isScaleform)
         {
            this.showDebugData();
         }
         var _loc1_:Class = getDefinitionByName("tempIcon_new") as Class;
         if(!_loc1_)
         {
            return;
         }
         this.mcFocusInteractionIcon = new _loc1_() as MovieClip;
         if(!_loc1_)
         {
            return;
         }
         this.mcFocusInteractionIcon.visible = false;
         this.mcFocusInteractionIcon.alpha = 1;
         this.mcHoldInteraction.visible = false;
         addChild(this.mcFocusInteractionIcon);
      }
      
      public function SetVisibility(param1:Boolean, param2:Boolean) : *
      {
         this.mcIcon.visible = param1;
         this.mcInteraction.visible = param2;
      }
      
      public function SetVisibilityEx(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean) : *
      {
         this.mcIcon.visible = param1;
         this.mcIcon.mcPicture.visible = param2;
         this.mcInteraction.visible = param3;
         this.mcInteraction.btnInteract.visible = param4;
         this.mcInteraction.mcActionName.visible = param5;
      }
      
      public function SetPositions(param1:Number, param2:Number) : *
      {
         this.mcIcon.x = param1;
         this.mcIcon.y = param2;
         this.mcInteraction.x = param1;
         this.mcInteraction.y = param2 - 40;
      }
      
      public function EnableHoldIndicator(param1:int, param2:int, param3:String, param4:Number) : void
      {
         this._holdIndicatorData = new KeyBindingData();
         this._holdIndicatorData.keyboard_keyCode = param2;
         this._holdIndicatorData.gamepad_keyCode = param1;
         this._holdIndicatorData.label = param3;
         this._holdIndicatorData.holdDuration = param4 * 1000;
         this.destroyHoldTimer();
         _inputMgr.enableHoldEmulation = true;
         InputManager.getInstance().addInputBlocker(false,"HUD_INTERACTION_HOLD");
      }
      
      public function DisableHoldIndicator() : void
      {
         this.destroyHoldTimer();
         this._holdIndicatorData = null;
         this.tryRestoreInteraction();
         _inputMgr.enableHoldEmulation = false;
         InputManager.getInstance().removeInputBlocker("HUD_INTERACTION_HOLD");
      }
      
      public function SetInteractionIcon(param1:String) : *
      {
         this.mcIcon.mcPicture.gotoAndStop(param1);
      }
      
      public function SetInteractionText(param1:String) : *
      {
         this.mcInteraction.mcActionName.tfActionName.text = param1;
      }
      
      public function SetInteractionKey(param1:int, param2:int) : *
      {
         var _loc3_:String = null;
         if(this._btnInteraction)
         {
            _loc3_ = "NONE";
            switch(param1)
            {
               case KeyCode.PAD_B_CIRCLE:
               case KeyCode.PAD_X_SQUARE:
               case KeyCode.PAD_Y_TRIANGLE:
               case KeyCode.PAD_LEFT_TRIGGER:
                  this._btnInteraction.setDataFromStage("",-1,param1);
                  break;
               case KeyCode.PAD_A_CROSS:
               case KeyCode.E:
                  this._btnInteraction.setDataFromStage(NavigationCode.GAMEPAD_A,param2);
                  break;
               default:
                  this._btnInteraction.setDataFromStage("",param2,param1);
            }
         }
      }
      
      public function SetInteractionIconAndText(param1:String, param2:String) : *
      {
         this.SetInteractionIcon(param1);
         this.SetInteractionText(param2);
      }
      
      public function SetInteractionKeyIconAndText(param1:int, param2:int, param3:String, param4:String) : *
      {
         this.SetInteractionKey(param1,param2);
         this.SetInteractionIcon(param3);
         this.SetInteractionText(param4);
      }
      
      public function SetHoldDuration(param1:Number) : void
      {
         if(this._btnInteraction)
         {
            if(param1 > 0)
            {
               param1 *= 1000;
            }
            this._btnInteraction.holdDuration = param1;
         }
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
         SetScaleAnimation(this.mcInteraction,param1,FADE_DURATION);
         SetScaleAnimation(this.mcIcon,param1,FADE_DURATION);
      }
      
      public function AddFocusInteractionIcon(param1:int, param2:String) : void
      {
         if(this.mcFocusInteractionIcon)
         {
            this.mcFocusInteractionIcon.visible = true;
            this.mcFocusInteractionIcon.x = -2000;
            this.mcFocusInteractionIcon.y = -2000;
            this.mcFocusInteractionIcon.scaleX = desiredScale;
            this.mcFocusInteractionIcon.scaleY = desiredScale;
            this.mcFocusInteractionIcon.mcPicture.gotoAndStop(param2);
         }
      }
      
      public function RemoveFocusInteractionIcon(param1:int) : void
      {
         if(this.mcFocusInteractionIcon)
         {
            this.mcFocusInteractionIcon.visible = false;
         }
      }
      
      public function UpdateFocusInteractionIconPosition(param1:int, param2:Number, param3:Number) : void
      {
         if(this.mcFocusInteractionIcon)
         {
            this.mcFocusInteractionIcon.x = param2;
            this.mcFocusInteractionIcon.y = param3;
         }
      }
      
      private function holdDelayIndicator(param1:Event = null) : void
      {
         this._startHoldShowing = true;
         this.destroyHoldTimer();
         if(this._cachedInputEvent)
         {
            this.handleHoldInput(this._cachedInputEvent);
            this._cachedInputEvent = null;
         }
      }
      
      private function handleHoldInput(param1:InputEvent) : void
      {
         if(!this._holdIndicatorData)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:int = this._holdIndicatorData.gamepad_keyCode;
         if(_inputMgr.swapAcceptCancel)
         {
            if(_loc3_ == KeyCode.PAD_A_CROSS)
            {
               _loc3_ = int(KeyCode.PAD_B_CIRCLE);
            }
            else if(_loc3_ == KeyCode.PAD_B_CIRCLE)
            {
               _loc3_ = int(KeyCode.PAD_A_CROSS);
            }
         }
         var _loc4_:Boolean;
         if(!(_loc4_ = _loc2_.code == _loc3_ || _loc2_.code == this._holdIndicatorData.keyboard_keyCode))
         {
            return;
         }
         this._cachedInputEvent = null;
         if(Boolean(this._holdDelayTimer) && _loc2_.value != InputValue.KEY_UP)
         {
            if(_loc2_.value == InputValue.KEY_DOWN)
            {
               this._cachedInputEvent = param1;
            }
            this._holdDelayTimer.reset();
            this._holdDelayTimer.start();
            return;
         }
         if(_loc4_ && !this._holdDelayTimer && !this._startHoldShowing && _loc2_.value != InputValue.KEY_UP)
         {
            if(_loc2_.value == InputValue.KEY_DOWN)
            {
               this._cachedInputEvent = param1;
            }
            this._holdDelayTimer = new Timer(HOLD_DELAY,1);
            this._holdDelayTimer.addEventListener(TimerEvent.TIMER,this.holdDelayIndicator,false,0,true);
            this._holdDelayTimer.start();
            return;
         }
         if(_loc2_.value == InputValue.KEY_DOWN)
         {
            if(!this._holdIndicatorDisplayed)
            {
               this._btnHoldInteraction.holdDuration = 0;
               this._btnHoldInteraction.setDataFromStage("",this._holdIndicatorData.keyboard_keyCode,this._holdIndicatorData.gamepad_keyCode);
               this._btnHoldInteraction.holdDuration = this._holdIndicatorData.holdDuration - HOLD_DELAY;
               this._btnHoldInteraction.validateNow();
               this._btnHoldInteraction.handleHoldInput(param1);
               this._btnHoldInteraction.holdCallback = this.holdCallback;
               this.mcHoldInteraction.mcActionName.tfActionName.text = this._holdIndicatorData.label;
               this.mcHoldInteraction.visible = true;
               this._holdIndicatorDisplayed = true;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestShowHold"));
               this.mcInteraction.alpha = 0;
               pauseTweenOn(this);
            }
         }
         else if(_loc2_.value == InputValue.KEY_UP)
         {
            this.tryRestoreInteraction();
         }
      }
      
      private function holdCallback() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnHoldInteractionCallback"));
         this.tryRestoreInteraction();
      }
      
      private function tryRestoreInteraction() : void
      {
         this._cachedInputEvent = null;
         this._btnHoldInteraction.holdCallback = null;
         this._btnHoldInteraction.setDataFromStage("",-1,-1,0);
         this._btnHoldInteraction.holdDuration = 0;
         this._startHoldShowing = false;
         this._holdIndicatorDisplayed = false;
         this.mcInteraction.alpha = 1;
         this.mcHoldInteraction.visible = false;
         pauseTweenOn(this);
         this.destroyHoldTimer();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestHideHold"));
      }
      
      private function destroyHoldTimer() : void
      {
         if(this._holdDelayTimer)
         {
            this._holdDelayTimer.stop();
            this._holdDelayTimer.removeEventListener(TimerEvent.TIMER,this.holdDelayIndicator,false);
            this._holdDelayTimer = null;
         }
      }
      
      private function showDebugData() : void
      {
         this.SetInteractionKey(KeyCode.PAD_A_CROSS,KeyCode.F);
         ShowElementFromState(true,true);
         this.SetInteractionText("Interact");
      }
      
      internal function __setProp_mcHoldInteraction_Scene1_Items_0() : *
      {
         try
         {
            this.mcHoldInteraction["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcHoldInteraction.autoRepeat = false;
         this.mcHoldInteraction.autoSize = "center";
         this.mcHoldInteraction.data = "";
         this.mcHoldInteraction.enabled = true;
         this.mcHoldInteraction.enableInitCallback = false;
         this.mcHoldInteraction.focusable = true;
         this.mcHoldInteraction.label = "";
         this.mcHoldInteraction.selected = false;
         this.mcHoldInteraction.toggle = false;
         this.mcHoldInteraction.visible = true;
         try
         {
            this.mcHoldInteraction["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcInteraction_Scene1_Layer1_0() : *
      {
         try
         {
            this.mcInteraction["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcInteraction.autoRepeat = false;
         this.mcInteraction.autoSize = "center";
         this.mcInteraction.data = "";
         this.mcInteraction.enabled = true;
         this.mcInteraction.enableInitCallback = false;
         this.mcInteraction.focusable = true;
         this.mcInteraction.label = "";
         this.mcInteraction.selected = false;
         this.mcInteraction.toggle = false;
         this.mcInteraction.visible = true;
         try
         {
            this.mcInteraction["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
