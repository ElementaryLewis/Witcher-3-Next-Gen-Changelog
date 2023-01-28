package red.game.witcher3.hud.modules
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import fl.motion.easing.*;
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.CoreHudModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.states.*;
   import red.game.witcher3.utils.motion.TweenEx;
   
   public class HudModuleBase extends CoreHudModule
   {
      
      protected static const TOGGLE_DURATION:Number = 0.6;
      
      protected static const FADE_DURATION:Number = 1000;
       
      
      public var mcTutorialHighlight:MovieClip;
      
      protected var UPDATE_FADE_TIME:Number = 3000;
      
      protected var OPACITY_MAX:Number = 0.8;
      
      protected var OPACITY_MIN:Number = 0.2;
      
      protected var targetTweens:Vector.<TweenEx>;
      
      protected var _ShowState:Boolean = false;
      
      protected var updateTimer:Timer;
      
      public var stateMachine:StateMachine;
      
      public var isAlwaysDynamic:Boolean = false;
      
      public var isEnabled:Boolean = true;
      
      public var desiredScale:Number = 1;
      
      public var desiredAlpha:Number = 0;
      
      protected var dontRescale:Boolean;
      
      protected var _shown:Boolean;
      
      protected var isInCutscene:Boolean;
      
      public function HudModuleBase()
      {
         this.targetTweens = new Vector.<TweenEx>();
         super();
         visible = false;
         if(this.mcTutorialHighlight)
         {
            this.mcTutorialHighlight.visible = false;
         }
         this.SetupStates();
         _enableHoldEmulation = false;
         _enableInputDeviceCheck = false;
      }
      
      public function SetupStates() : *
      {
         this.stateMachine = new StateMachine();
         this.stateMachine.addState("Show",new ShowState(this),[]);
         this.stateMachine.addState("Hide",new HideState(this),[]);
         this.stateMachine.addState("OnDemand",new OnDemandState(this),[]);
         this.stateMachine.addState("OnUpdate",new OnUpdateState(this),[]);
         this.stateMachine.setState("Hide");
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function SetMaxOpacity(param1:Number) : *
      {
         this.OPACITY_MAX = Math.max(this.OPACITY_MIN,param1);
      }
      
      public function SetEnabled(param1:Boolean) : *
      {
         this.isEnabled = param1;
         if(!this.isEnabled)
         {
            this.SetState("Hide");
            this.alpha = 0;
            this.desiredAlpha = 0;
         }
      }
      
      public function getState() : String
      {
         return this.stateMachine.getState();
      }
      
      public function SetState(param1:String) : *
      {
         if(param1 == null)
         {
            return;
         }
         if(!this.isEnabled)
         {
            this.stateMachine.setState("Hide");
         }
         else
         {
            this.stateMachine.setState(param1);
         }
      }
      
      public function ShowElement(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param3)
         {
            this.ShowElementFromState(param1,param2);
         }
         else
         {
            this.stateMachine.ShowElement(param1,param2);
         }
      }
      
      public function SetScaleFromWS(param1:Number) : void
      {
         this.SetScaleAnimation(this,param1,FADE_DURATION);
      }
      
      public function ShowElementFromState(param1:Boolean, param2:Boolean = false) : void
      {
         if(this._shown == param1)
         {
            return;
         }
         this._shown = param1;
         if(param2)
         {
            if(param1)
            {
               if(!visible)
               {
                  visible = true;
               }
               alpha = this.OPACITY_MAX;
               this.desiredAlpha = this.OPACITY_MAX;
            }
            else
            {
               if(visible)
               {
                  visible = false;
               }
               alpha = 0;
               this.desiredAlpha = 0;
            }
         }
         else if(param1)
         {
            this.fadeIn();
         }
         else
         {
            this.fadeOut();
         }
      }
      
      protected function fadeIn() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = this.scaleX == this.desiredScale && this.scaleY == this.desiredScale;
         if(alpha == this.OPACITY_MAX && _loc2_)
         {
            GTweener.removeTweens(this);
            visible = true;
            this.desiredAlpha = alpha;
            return;
         }
         if(!visible)
         {
            visible = true;
         }
         if(alpha != this.OPACITY_MAX)
         {
            this.desiredAlpha = this.OPACITY_MAX;
            _loc1_ = {"alpha":this.OPACITY_MAX};
         }
         if(!this.dontRescale && !_loc2_)
         {
            if(!_loc1_)
            {
               _loc1_ = {};
            }
            _loc1_.scaleX = this.desiredScale;
            _loc1_.scaleY = this.desiredScale;
         }
         GTweener.removeTweens(this);
         if(_loc1_)
         {
            GTweener.to(this,TOGGLE_DURATION,_loc1_,{
               "ease":Sine.easeOut,
               "onComplete":this.handleModuleShown
            });
         }
      }
      
      protected function fadeOut() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = this.scaleX == this.desiredScale && this.scaleY == this.desiredScale;
         if(alpha == 0 && _loc2_)
         {
            GTweener.removeTweens(this);
            visible = false;
            this.desiredAlpha = alpha;
            return;
         }
         this.desiredAlpha = 0;
         if(alpha != this.desiredAlpha)
         {
            _loc1_ = {"alpha":0};
         }
         if(!this.dontRescale && !_loc2_)
         {
            if(!_loc1_)
            {
               _loc1_ = {};
            }
            _loc1_.scaleX = this.desiredScale;
            _loc1_.scaleY = this.desiredScale;
         }
         GTweener.removeTweens(this);
         if(_loc1_)
         {
            GTweener.to(this,TOGGLE_DURATION,_loc1_,{
               "ease":Sine.easeOut,
               "onComplete":this.handleModuleHidden
            });
         }
      }
      
      protected function handleModuleShown(param1:GTween) : void
      {
      }
      
      protected function handleModuleHidden(param1:GTween) : void
      {
         visible = false;
      }
      
      public function SaveShowState(param1:Boolean) : void
      {
         this._ShowState = param1;
      }
      
      public function GetSavedShowState() : Boolean
      {
         return this._ShowState;
      }
      
      public function SetUpdateTimer() : void
      {
         if(!this.updateTimer)
         {
            this.updateTimer = new Timer(this.UPDATE_FADE_TIME,1);
            this.updateTimer.addEventListener(TimerEvent.TIMER,this.UpdateTimerFinishedCounting);
         }
         else
         {
            this.updateTimer.reset();
         }
         this.updateTimer.start();
      }
      
      public function ResetUpdateTimer() : void
      {
         if(this.updateTimer)
         {
            this.updateTimer.reset();
            this.updateTimer.start();
         }
      }
      
      public function RemoveUpdateTimer() : void
      {
         if(this.updateTimer)
         {
            this.updateTimer.stop();
            this.updateTimer.removeEventListener(TimerEvent.TIMER,this.UpdateTimerFinishedCounting);
            this.updateTimer = null;
         }
      }
      
      internal function UpdateTimerFinishedCounting(param1:TimerEvent) : void
      {
         this.RemoveUpdateTimer();
         this.ShowElementFromState(false,false);
      }
      
      public function OnUpdate(param1:GameEvent) : void
      {
         if(!this.updateTimer)
         {
            this.SetUpdateTimer();
            this.ShowElementFromState(true,false);
         }
         else
         {
            this.ResetUpdateTimer();
         }
      }
      
      protected function effectFade(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         this.pauseTweenOn(param1);
         this.desiredAlpha = param2;
         _loc4_ = TweenEx.to(param3,param1,{
            "scaleX":this.desiredScale,
            "scaleY":this.desiredScale,
            "alpha":param2
         },{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":this.handleTweenComplete
         });
         this.targetTweens.push(_loc4_);
      }
      
      protected function handleTweenComplete(param1:TweenEx) : void
      {
         this.pauseTweenOn(param1.target);
      }
      
      protected function pauseTweenOn(param1:Object) : *
      {
         var _loc2_:int = 0;
         _loc2_ = int(this.targetTweens.length - 1);
         while(_loc2_ > -1)
         {
            if(param1 == this.targetTweens[_loc2_].target)
            {
               this.targetTweens[_loc2_].paused = true;
               this.targetTweens.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
      
      protected function SetScaleAnimation(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         this.pauseTweenOn(param1);
         this.desiredScale = param2;
         _loc4_ = TweenEx.to(param3,param1,{
            "scaleX":param2,
            "scaleY":param2,
            "alpha":this.desiredAlpha
         },{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":this.handleTweenComplete
         });
         this.targetTweens.push(_loc4_);
      }
      
      public function ShowTutorialHighlight(param1:Boolean, param2:String) : *
      {
         if(this.mcTutorialHighlight)
         {
            if(param1)
            {
               this.mcTutorialHighlight.gotoAndStop(param2);
            }
            this.mcTutorialHighlight.visible = param1;
         }
      }
      
      override public function toString() : String
      {
         return "HudModuleBase [ " + this.moduleName + " ]";
      }
      
      public function onCutsceneStartedOrEnded(param1:Boolean) : *
      {
      }
   }
}
