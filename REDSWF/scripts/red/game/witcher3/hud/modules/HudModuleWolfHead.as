package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.modules.signinfo.HudItemInfo;
   import red.game.witcher3.hud.modules.wolfHead.StaminaIndicator;
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   import red.game.witcher3.hud.modules.wolfHead.WolfMedallion;
   import scaleform.clik.motion.Tween;
   
   public class HudModuleWolfHead extends HudModuleBase
   {
       
      
      public var mcHealthBar:W3StatIndicator;
      
      public var mcToxicityBar:W3StatIndicator;
      
      public var mcExperienceBar:W3StatIndicator;
      
      public var mcLockedToxicityBar:W3StatIndicator;
      
      public var mcStaminaBar:StaminaIndicator;
      
      public var mcWolfsHead:WolfMedallion;
      
      public var mcAdrenalinePoints:MovieClip;
      
      public var mcBckCircle:MovieClip;
      
      public var mcSignText:MovieClip;
      
      public var mcSignSlot:HudItemInfo;
      
      public var mcSkull:MovieClip;
      
      public var mcSkullBck:MovieClip;
      
      public var mSignReady:MovieClip;
      
      public var mcNewLevelIndcator:MovieClip;
      
      public var mcFocusProgressbar:MovieClip;
      
      public var mcMutationFeedback:MovieClip;
      
      public var focusbar:MovieClip;
      
      private var mcSignTextTween:Tween;
      
      private var m_neededStaminaTimeOutID:uint;
      
      private var m_signTextTimeOutID:uint;
      
      private var pendingSignText:String = "";
      
      private var isCiriMainPlayer:Boolean = false;
      
      private var isAlwaysDisplayed:Boolean = false;
      
      private var greenHealthBar:MovieClip;
      
      private var _mutationFeedbackTimer:Timer;
      
      public function HudModuleWolfHead()
      {
         super();
         this.__setProp_mcStaminaBar_Scene1_mcStaminaBar_0();
         this.__setProp_mcToxicityBar_Scene1_mcToxicityBar_0();
         this.__setProp_mcLockedToxicityBar_Scene1_mcLockedToxicityBar_0();
         this.__setProp_mcHealthBar_Scene1_mcHealthBar_0();
         this.__setProp_mcExperienceBar_Scene1_mcExperienceBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "WolfHeadModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.focusbar = this.mcAdrenalinePoints.getChildByName("mcFocusProgressbar") as MovieClip;
         alpha = 0;
         this.mcNewLevelIndcator.visible = false;
         this.greenHealthBar = this.mcHealthBar["mcBar"];
         if(this.mcMutationFeedback)
         {
            this.mcMutationFeedback.visible = false;
         }
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setVitality(param1:Number) : *
      {
         var _loc2_:Number = param1 * 100;
         this.mcHealthBar.value = _loc2_;
         this.mcHealthBar.mcBackgroundHealth.value = _loc2_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function setStamina(param1:Number) : *
      {
         this.mcStaminaBar.value = param1 * 100;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         if(param1 == 1)
         {
            this.setSignIconDimmed(false);
            this.mSignReady.gotoAndPlay("show");
         }
         else
         {
            this.setSignIconDimmed(true);
         }
      }
      
      public function setToxicity(param1:Number) : *
      {
         if(!this.isCiriMainPlayer)
         {
            this.mcToxicityBar.value = param1 * 100;
            if(param1 >= 0.5)
            {
               this.UpdateGreenHealthBar(param1);
            }
            else
            {
               this.greenHealthBar.gotoAndStop(1);
            }
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
      }
      
      private function UpdateGreenHealthBar(param1:Number) : *
      {
         var _loc2_:Number = (param1 - 0.5) / 0.5 * 50;
         this.greenHealthBar.gotoAndStop(Math.round(_loc2_));
      }
      
      public function setExperience(param1:Number) : *
      {
         this.mcExperienceBar.value = param1 * 100;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function setLockedToxicity(param1:Number) : *
      {
         if(!this.isCiriMainPlayer)
         {
            this.mcLockedToxicityBar.value = param1 * 100;
         }
      }
      
      public function setDeadlyToxicity(param1:Boolean) : *
      {
         if(!this.isCiriMainPlayer)
         {
            if(param1)
            {
               this.mcSkull.gotoAndStop("deadly");
            }
            else
            {
               this.mcSkull.gotoAndStop("normal");
            }
         }
      }
      
      public function showStaminaNeeded(param1:Number) : *
      {
         this.mcStaminaBar.ShowAmountNeeded(param1);
         clearTimeout(this.m_neededStaminaTimeOutID);
         this.m_neededStaminaTimeOutID = setTimeout(this.hideStaminaNeeded,2000);
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function hideStaminaNeeded() : *
      {
         clearTimeout(this.m_neededStaminaTimeOutID);
         this.mcStaminaBar.HideAmountNeeded();
      }
      
      public function switchWolfActivation(param1:Boolean) : *
      {
         if(param1)
         {
            this.mcWolfsHead.StartGlow();
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
         else
         {
            this.mcWolfsHead.StopGlow();
         }
      }
      
      public function setSignIcon(param1:String) : void
      {
         this.mcSignSlot.IconName = param1;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function setSignText(param1:String) : void
      {
         this.mcSignText.textField.text = param1;
         if(stateMachine.current != "Hide")
         {
            this.mcSignText.alpha = 1;
            this.pendingSignText = "";
            clearTimeout(this.m_signTextTimeOutID);
            this.m_signTextTimeOutID = setTimeout(this.hideSignText,2000);
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
         else
         {
            this.pendingSignText = param1;
         }
      }
      
      public function hideSignText() : *
      {
         clearTimeout(this.m_signTextTimeOutID);
         if(this.mcSignTextTween)
         {
            this.mcSignTextTween.paused = true;
         }
         this.mcSignTextTween = new Tween(500,this.mcSignText,{"alpha":0},{"paused":false});
      }
      
      override public function SetState(param1:String) : *
      {
         super.SetState(param1);
         if(param1 != "Hide" && this.pendingSignText != "")
         {
            this.setSignText(this.pendingSignText);
         }
      }
      
      public function setSignIconDimmed(param1:Boolean) : void
      {
         this.mcSignSlot.IconDimmed = param1;
      }
      
      public function setFocusPoints(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = this.mcAdrenalinePoints.getChildByName("mcblink") as MovieClip;
         var _loc4_:uint = 1;
         while(_loc4_ < 4)
         {
            _loc2_ = this.mcAdrenalinePoints.getChildByName("mcFocusPoint" + _loc4_) as MovieClip;
            _loc2_.adrenaline_glow.gotoAndPlay(1);
            if(_loc4_ <= param1)
            {
               _loc2_.gotoAndStop("reserved_up");
            }
            else
            {
               _loc2_.gotoAndStop("up");
               _loc2_.adrenaline_glow.gotoAndStop(1);
            }
            _loc4_++;
         }
         _loc3_.gotoAndPlay("play");
      }
      
      public function UpdateFocusPointsBar(param1:Number) : void
      {
         if(this.focusbar)
         {
            this.focusbar.value = param1 * 100 / 3;
         }
      }
      
      public function lockFocusPoints(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 1;
         while(_loc3_ <= param1)
         {
            _loc2_ = this.mcAdrenalinePoints.getChildByName("mcFocusPoint" + _loc3_) as MovieClip;
            _loc2_.gotoAndStop("locked");
            _loc3_++;
         }
      }
      
      public function setCiriAsMainCharacter(param1:Boolean) : *
      {
         this.isCiriMainPlayer = param1;
         this.mcSkull.visible = !param1;
         this.mcSkullBck.visible = !param1;
         this.mcToxicityBar.visible = !param1;
         this.mcAdrenalinePoints.visible = !param1;
         if(param1)
         {
            this.mcWolfsHead.SetMedalionGraphic("cat");
            this.mcStaminaBar.SetStaminaBarGraphic("cat");
            this.mcWolfsHead.StopGlow();
         }
         else
         {
            this.mcWolfsHead.SetMedalionGraphic("wolf");
            this.mcStaminaBar.SetStaminaBarGraphic("wolf");
            this.mcWolfsHead.StopGlow();
         }
      }
      
      public function setCoatOfArms(param1:Boolean) : *
      {
         if(param1)
         {
            this.mcWolfsHead.SetMedalionGraphic("coat_of_arms");
         }
         else
         {
            this.mcWolfsHead.SetMedalionGraphic("wolf");
         }
      }
      
      public function setShowNewLevelIndicator(param1:Boolean) : *
      {
         this.mcNewLevelIndcator.visible = param1;
      }
      
      override public function SetEnabled(param1:Boolean) : *
      {
         isEnabled = param1;
         if(!isEnabled)
         {
            this.SetState("Hide");
            this.alpha = 0;
            this.desiredAlpha = 0;
         }
         else if(this.isAlwaysDisplayed)
         {
            this.SetState("OnUpdate");
            this.setAlwaysDisplayed(this.isAlwaysDisplayed);
         }
      }
      
      override public function ShowElement(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param3)
         {
            if(!this.isAlwaysDisplayed)
            {
               ShowElementFromState(param1,param2);
            }
         }
         else
         {
            stateMachine.ShowElement(param1,param2);
         }
      }
      
      public function setAlwaysDisplayed(param1:Boolean) : *
      {
         this.isAlwaysDisplayed = param1;
         if(param1)
         {
            RemoveUpdateTimer();
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
      }
      
      override internal function UpdateTimerFinishedCounting(param1:TimerEvent) : void
      {
         if(this.isAlwaysDisplayed)
         {
            RemoveUpdateTimer();
            return;
         }
         super.UpdateTimerFinishedCounting(param1);
      }
      
      public function showMutationFeedback(param1:int) : *
      {
         if(this.mcMutationFeedback)
         {
            if(this._mutationFeedbackTimer)
            {
               this._mutationFeedbackTimer.stop();
               this._mutationFeedbackTimer = null;
            }
            switch(param1)
            {
               case 0:
                  this.mcMutationFeedback.visible = false;
                  break;
               case 1:
                  this.mcMutationFeedback.visible = true;
                  this._mutationFeedbackTimer = new Timer(1000,1);
                  this._mutationFeedbackTimer.addEventListener(TimerEvent.TIMER,this.handleTimerFinished,false,0,true);
                  this._mutationFeedbackTimer.start();
                  break;
               case 2:
                  this.mcMutationFeedback.visible = true;
            }
         }
      }
      
      private function handleTimerFinished(param1:TimerEvent) : void
      {
         this.mcMutationFeedback.visible = false;
         this._mutationFeedbackTimer.stop();
         this._mutationFeedbackTimer = null;
      }
      
      internal function __setProp_mcStaminaBar_Scene1_mcStaminaBar_0() : *
      {
         try
         {
            this.mcStaminaBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcStaminaBar.enabled = true;
         this.mcStaminaBar.enableInitCallback = false;
         this.mcStaminaBar.maximum = 100;
         this.mcStaminaBar.minimum = 0;
         this.mcStaminaBar.value = 80;
         this.mcStaminaBar.visible = true;
         try
         {
            this.mcStaminaBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcToxicityBar_Scene1_mcToxicityBar_0() : *
      {
         try
         {
            this.mcToxicityBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcToxicityBar.enabled = true;
         this.mcToxicityBar.enableInitCallback = false;
         this.mcToxicityBar.maximum = 100;
         this.mcToxicityBar.minimum = 0;
         this.mcToxicityBar.value = 10;
         this.mcToxicityBar.visible = true;
         try
         {
            this.mcToxicityBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcLockedToxicityBar_Scene1_mcLockedToxicityBar_0() : *
      {
         try
         {
            this.mcLockedToxicityBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcLockedToxicityBar.enabled = true;
         this.mcLockedToxicityBar.enableInitCallback = false;
         this.mcLockedToxicityBar.maximum = 100;
         this.mcLockedToxicityBar.minimum = 0;
         this.mcLockedToxicityBar.value = 0;
         this.mcLockedToxicityBar.visible = true;
         try
         {
            this.mcLockedToxicityBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHealthBar_Scene1_mcHealthBar_0() : *
      {
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcHealthBar.enabled = true;
         this.mcHealthBar.enableInitCallback = false;
         this.mcHealthBar.maximum = 100;
         this.mcHealthBar.minimum = 0;
         this.mcHealthBar.value = 80;
         this.mcHealthBar.visible = true;
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcExperienceBar_Scene1_mcExperienceBar_0() : *
      {
         try
         {
            this.mcExperienceBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcExperienceBar.enabled = true;
         this.mcExperienceBar.enableInitCallback = false;
         this.mcExperienceBar.maximum = 100;
         this.mcExperienceBar.minimum = 0;
         this.mcExperienceBar.value = 1;
         this.mcExperienceBar.visible = true;
         try
         {
            this.mcExperienceBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
