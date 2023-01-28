package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class CreditsMenu extends CoreMenu
   {
      
      protected static const FADE_DURATION:Number = 1000;
      
      protected static const STAGE_HEIGHT:Number = 1080;
      
      public static const STOP_VIDEO:String = "StopVideo";
       
      
      public var tfScrollingText1:TextField;
      
      public var tfScrollingText2:TextField;
      
      public var mcCurrentSection:MovieClip;
      
      public var scrollbackground:MovieClip;
      
      public var mcSkipIndicator:MovieClip;
      
      public var mcThanks:MovieClip;
      
      public var mcLovingMemory:MovieClip;
      
      private var _showThankYouNote:Boolean = false;
      
      private var _scrollingTexts:Vector.<String>;
      
      private var _fadeTimer:Timer;
      
      private var _sectionTimer:Timer;
      
      private var _sectionTimerStartTime:Number;
      
      private var _skipButtonShown:Boolean;
      
      private var _displayTime:Number;
      
      private var _delay:Number;
      
      private var _canClose:Boolean = false;
      
      private var _scrollingSpeed:Number = 75;
      
      protected var targetTweens:Vector.<TweenEx>;
      
      private var _restartSectionTimer:Boolean = false;
      
      public function CreditsMenu()
      {
         this._scrollingTexts = new Vector.<String>();
         this.targetTweens = new Vector.<TweenEx>();
         addFrameScript(0,this.frame1);
         super();
         SHOW_ANIM_OFFSET = 0;
         _enableMouse = false;
         this.scrollbackground.alpha = 0;
      }
      
      override protected function get menuName() : String
      {
         return "CreditsMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._fadeTimer = new Timer(3300);
         this._fadeTimer.addEventListener(TimerEvent.TIMER,this.OnFadeTimer,false,0,true);
         this.mcSkipIndicator.alpha = 0;
         var _loc1_:InputFeedbackButton = this.mcSkipIndicator.btnSkip as InputFeedbackButton;
         _loc1_.clickable = false;
         _loc1_.label = "[[panel_button_dialogue_skip]]";
         _loc1_.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.ESCAPE);
         _loc1_.validateNow();
         this.tfScrollingText1.autoSize = "left";
         this.tfScrollingText1.multiline = true;
         this.tfScrollingText1.wordWrap = true;
         this.tfScrollingText2.autoSize = "left";
         this.tfScrollingText2.multiline = true;
         this.tfScrollingText2.wordWrap = true;
         this.mcCurrentSection.alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcThanks.addEventListener(CreditsMenu.STOP_VIDEO,this.lovingMemoryStopVideo);
         this.mcThanks.addEventListener(Event.COMPLETE,this.thankYouFinished);
         this.mcLovingMemory.addEventListener(CreditsMenu.STOP_VIDEO,this.lovingMemoryStopVideo);
         this.mcLovingMemory.addEventListener(Event.COMPLETE,this.lovingMemoryFinished);
      }
      
      public function setCreditsText(param1:String, param2:Number, param3:Number, param4:int, param5:int) : void
      {
         if(param4 > 890)
         {
            this.mcCurrentSection.tfCurrent.htmlText = "<p align=\"right\">" + param1 + "</p>";
            this.mcCurrentSection.tfCurrent.x = -this.mcCurrentSection.tfCurrent.width / 2;
            this.mcCurrentSection.y = 1080;
         }
         else
         {
            this.mcCurrentSection.tfCurrent.htmlText = param1;
            this.mcCurrentSection.tfCurrent.x = 0;
            this.mcCurrentSection.y = 1080;
            this.mcCurrentSection.x = -50 - this.mcCurrentSection.tfCurrent.width;
         }
         this.mcCurrentSection.tfCurrent.height = this.mcCurrentSection.tfCurrent.textHeight + 10;
         this.mcCurrentSection.tfCurrent.y = -this.mcCurrentSection.height / 2;
         this._displayTime = param2;
         this._delay = param3;
         this.mcCurrentSection.alpha = 0;
         this.mcCurrentSection.scaleX = 2;
         this.mcCurrentSection.scaleY = 2;
         this.mcCurrentSection.x = param4;
         this.mcCurrentSection.y = param5;
         GTweener.to(this.mcCurrentSection,0.2,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "x":param4,
            "y":param5
         },{"onComplete":this.handleSectionShowed});
      }
      
      protected function handleSectionShowed(param1:GTween) : void
      {
         var _loc2_:* = this.mcCurrentSection.x + 25;
         GTweener.to(this.mcCurrentSection,this._displayTime,{
            "scaleX":0.9,
            "scaleY":0.9,
            "x":_loc2_
         },{"onComplete":this.handleSectionFinished});
      }
      
      protected function handleSectionFinished(param1:GTween) : void
      {
         if(this._sectionTimer)
         {
            this._sectionTimer.removeEventListener(TimerEvent.TIMER,this.OnSectionTimer);
         }
         this._sectionTimer = new Timer(this._delay * 1000);
         this._sectionTimerStartTime = getTimer();
         this._sectionTimer.start();
         GTweener.to(this.mcCurrentSection,0.2,{"alpha":0});
         this._sectionTimer.addEventListener(TimerEvent.TIMER,this.OnSectionTimer,false,0,true);
      }
      
      private function OnSectionTimer(param1:TimerEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnSectionHidden"));
         this._sectionTimer.stop();
         this._sectionTimer.removeEventListener(TimerEvent.TIMER,this.OnSectionTimer);
      }
      
      private function IsAnyScrollingText() : Boolean
      {
         return this._scrollingTexts.length > 0;
      }
      
      private function GetFirstScrollingText() : String
      {
         if(!this.IsAnyScrollingText())
         {
            return null;
         }
         var _loc1_:String = this._scrollingTexts[0];
         this._scrollingTexts.splice(0,1);
         return _loc1_;
      }
      
      public function setScrollingSpeed(param1:Number) : *
      {
         this._scrollingSpeed = param1;
      }
      
      public function addScrollingText(param1:String) : void
      {
         this._scrollingTexts.push(param1);
      }
      
      public function startScrollingText() : void
      {
         var _loc1_:String = this.GetFirstScrollingText();
         if(!_loc1_)
         {
            return;
         }
         this.scrollbackground.alpha = 1;
         this.ScrollIn(this.tfScrollingText1,_loc1_);
      }
      
      public function setThankYouText(param1:String) : void
      {
         this._showThankYouNote = true;
         this.mcThanks.mcThankYouNote.tfThankYouNote.htmlText = param1;
      }
      
      public function changedConstraintedState(param1:Boolean) : void
      {
         if(param1)
         {
            if(Boolean(this._sectionTimer) && this._sectionTimer.running)
            {
               this._sectionTimer.stop();
               this._sectionTimer.delay -= getTimer() - this._sectionTimerStartTime;
               this._restartSectionTimer = true;
            }
         }
         else if(Boolean(this._sectionTimer) && this._restartSectionTimer)
         {
            this._sectionTimerStartTime = getTimer();
            this._sectionTimer.start();
            this._restartSectionTimer = false;
         }
         GTweener.pauseTweens(this.mcCurrentSection,param1);
         GTweener.pauseTweens(this.tfScrollingText1,param1);
         GTweener.pauseTweens(this.tfScrollingText2,param1);
      }
      
      private function ScrollIn(param1:TextField, param2:String) : *
      {
         var _loc4_:int = 0;
         param1.htmlText = param2;
         var _loc3_:int = STAGE_HEIGHT;
         _loc4_ = STAGE_HEIGHT - param1.height;
         var _loc5_:* = Math.abs(_loc3_ - _loc4_);
         param1.y = _loc3_;
         GTweener.to(param1,_loc5_ / this._scrollingSpeed,{"y":_loc4_},{"onComplete":this.OnScrolledIn});
      }
      
      protected function OnScrolledIn(param1:GTween) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         this.ScrollOut(_loc2_);
         var _loc3_:TextField = this.GetOtherTextField(_loc2_);
         var _loc4_:String;
         if(!(_loc4_ = this.GetFirstScrollingText()))
         {
            return;
         }
         this.ScrollIn(_loc3_,_loc4_);
      }
      
      private function ScrollOut(param1:TextField) : *
      {
         var _loc2_:int = param1.y;
         var _loc3_:int = -param1.height;
         var _loc4_:* = Math.abs(_loc2_ - _loc3_);
         param1.y = _loc2_;
         GTweener.to(param1,_loc4_ / this._scrollingSpeed,{"y":_loc3_},{"onComplete":this.OnScrolledOut});
      }
      
      protected function OnScrolledOut(param1:GTween) : *
      {
         var _loc2_:TextField = param1.target as TextField;
         if(this._scrollingTexts.length == 0)
         {
            if(this._canClose)
            {
               if(this._showThankYouNote)
               {
                  this.mcThanks.gotoAndPlay("start");
               }
               else
               {
                  this.mcLovingMemory.gotoAndPlay("start");
               }
            }
            else
            {
               this._canClose = true;
            }
         }
      }
      
      private function thankYouFinished(param1:Event) : void
      {
         this.mcLovingMemory.gotoAndPlay("start");
      }
      
      private function lovingMemoryStopVideo(param1:Event) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnStopVideo"));
      }
      
      private function lovingMemoryFinished(param1:Event) : void
      {
         closeMenu();
      }
      
      private function GetOtherTextField(param1:TextField) : TextField
      {
         if(param1 == this.tfScrollingText1)
         {
            return this.tfScrollingText2;
         }
         return this.tfScrollingText1;
      }
      
      public function SkipConfirmShow() : void
      {
         this._skipButtonShown = true;
         this._fadeTimer.stop();
         this.effectFade(this.mcSkipIndicator,1,300);
         this._fadeTimer.reset();
         this._fadeTimer.start();
      }
      
      public function SkipConfirmHide() : void
      {
         this._skipButtonShown = false;
         this._fadeTimer.stop();
         this.effectFade(this.mcSkipIndicator,0,300);
      }
      
      private function OnFadeTimer(param1:TimerEvent) : void
      {
         this.SkipConfirmHide();
      }
      
      protected function effectFade(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         this.pauseTweenOn(param1);
         _loc4_ = TweenEx.to(param3,param1,{"alpha":param2},{
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
         var _loc2_:int = int(this.targetTweens.length - 1);
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
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(!param1.handled && _loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
               case NavigationCode.GAMEPAD_X:
                  if(this.mcSkipIndicator.alpha > 0.1)
                  {
                     this.SkipConfirmHide();
                     closeMenu();
                     return;
                  }
                  break;
            }
            this.SkipConfirmShow();
         }
         if(_loc3_ && !param1.handled)
         {
            switch(_loc2_.code)
            {
               case KeyCode.SPACE:
               case KeyCode.ESCAPE:
                  if(this.mcSkipIndicator.alpha > 0.1)
                  {
                     this.SkipConfirmHide();
                     closeMenu();
                     return;
                  }
                  break;
            }
            this.SkipConfirmShow();
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
