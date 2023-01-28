package red.game.witcher3.menus.gwint
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3MessageQueue;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class GwintTutorial extends UIComponent
   {
      
      public static var mSingleton:GwintTutorial;
       
      
      public var mcTitleText:TextField;
      
      public var mcMainText:TextField;
      
      public var mcMeleeText:TextField;
      
      public var mcRangeText:TextField;
      
      public var mcSiegeText:TextField;
      
      public var mcSecondaryText:TextField;
      
      public var mcAButtonWrapper:MovieClip;
      
      private var startupDelayTimer:Timer;
      
      private var initialDelayActive:Boolean = true;
      
      public var onHideCallback:Function;
      
      public var localizedStringsWithIcons:Array = null;
      
      public var allowX:Boolean = false;
      
      public var currentTutorialFrame:int = 8;
      
      public var showCarouselCB:Function;
      
      public var hideCarouselCB:Function;
      
      public var changeChoiceCB:Function;
      
      public var nextFrameRenderer:Boolean = true;
      
      public var bigSoundPlayed:Boolean = false;
      
      public var messageQueue:W3MessageQueue;
      
      private var _isPaused:Boolean = false;
      
      protected var lastDownWasValid:Boolean = false;
      
      public function GwintTutorial()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         var btnAccept:InputFeedbackButton = null;
         mouseEnabled = false;
         this.visible = false;
         mSingleton = this;
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"gwint.tutorial.strings",[this.onGetTutorialStrings]));
         stage.addEventListener(MouseEvent.CLICK,this.handleClick,false,0,true);
         mouseChildren = false;
         if(this.mcAButtonWrapper)
         {
            btnAccept = this.mcAButtonWrapper.getChildByName("mcFeedbackButton") as InputFeedbackButton;
            if(btnAccept)
            {
               btnAccept.label = "[[panel_continue]]";
               if(InputManager.getInstance().swapAcceptCancel)
               {
                  btnAccept.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.SPACE);
               }
               else
               {
                  btnAccept.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.SPACE);
               }
               btnAccept.clickable = true;
               btnAccept.visible = true;
               btnAccept.validateNow();
            }
         }
      }
      
      public function get active() : Boolean
      {
         return visible && !this._isPaused;
      }
      
      public function get isPaused() : Boolean
      {
         return this._isPaused;
      }
      
      public function set isPaused(value:Boolean) : void
      {
         if(this._isPaused != value)
         {
            if(this._isPaused)
            {
               this.initialDelayActive = true;
               this.startupDelayTimer = new Timer(600,0);
               this.startupDelayTimer.addEventListener(TimerEvent.TIMER,this.updateStartTimer);
               this.startupDelayTimer.start();
               this.lastDownWasValid = false;
            }
            this._isPaused = value;
            if(visible && Boolean(this.messageQueue))
            {
               this.messageQueue.msgsEnabled = this._isPaused;
            }
         }
      }
      
      public function OnTutorialShown(value:Boolean) : *
      {
         this.nextFrameRenderer = true;
         if(value)
         {
            if(!this.bigSoundPlayed)
            {
               this.bigSoundPlayed = true;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_tutorial_big_appear"]));
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_tutorial_notification"]));
            }
         }
         else
         {
            this.bigSoundPlayed = false;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_tutorial_big_disappear"]));
         }
      }
      
      private function updateStartTimer(event:TimerEvent = null) : void
      {
         this.initialDelayActive = false;
         this.startupDelayTimer = null;
      }
      
      public function show() : void
      {
         this.visible = true;
         if(this.startupDelayTimer == null && this.initialDelayActive)
         {
            this.startupDelayTimer = new Timer(600,0);
            this.startupDelayTimer.addEventListener(TimerEvent.TIMER,this.updateStartTimer);
            this.startupDelayTimer.start();
         }
         this.OnTutorialShown(true);
         if(this.messageQueue)
         {
            this.messageQueue.msgsEnabled = false;
         }
         InputFeedbackManager.cleanupButtons();
         gotoAndStop(1);
      }
      
      public function continueTutorial() : void
      {
         nextFrame();
         this.isPaused = false;
         this.hideCarousel();
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         mouseEnabled = value;
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         var details:InputDetails = event.details;
         if((details.navEquivalent == NavigationCode.GAMEPAD_A || details.navEquivalent == NavigationCode.ENTER) && details.value == InputValue.KEY_DOWN)
         {
            this.lastDownWasValid = !this.isPaused && visible;
         }
         if(this.isPaused || !visible)
         {
            return;
         }
         super.handleInput(event);
         var keyUp:* = details.value == InputValue.KEY_UP;
         var keyDown:* = details.value == InputValue.KEY_DOWN;
         if(!event.handled)
         {
            switch(details.navEquivalent)
            {
               case NavigationCode.GAMEPAD_X:
                  if(keyUp && !this.allowX)
                  {
                     break;
                  }
               case NavigationCode.GAMEPAD_A:
               case NavigationCode.ENTER:
                  if(keyUp && this.lastDownWasValid)
                  {
                     event.handled = true;
                     this.incrementTutorial();
                  }
            }
         }
      }
      
      protected function handleClick(event:MouseEvent) : void
      {
         if(this.isPaused || !visible)
         {
            return;
         }
         var superMouseEvent:MouseEventEx = event as MouseEventEx;
         if(superMouseEvent.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            event.stopImmediatePropagation();
            this.incrementTutorial();
         }
      }
      
      protected function incrementTutorial() : void
      {
         if(!this.nextFrameRenderer || this.initialDelayActive)
         {
            return;
         }
         trace("GFX Marcin ",this.currentTutorialFrame,totalFrames);
         if(this.currentTutorialFrame <= totalFrames)
         {
            this.nextFrameRenderer = false;
            ++this.currentTutorialFrame;
            nextFrame();
         }
         else
         {
            this.hide();
         }
      }
      
      protected function hide() : void
      {
         this.visible = false;
         this.OnTutorialShown(false);
         if(this.messageQueue)
         {
            this.messageQueue.msgsEnabled = true;
         }
         if(this.onHideCallback != null)
         {
            this.onHideCallback();
         }
      }
      
      public function showCarousel() : void
      {
         if(this.showCarouselCB != null)
         {
            this.showCarouselCB();
         }
      }
      
      public function hideCarousel() : void
      {
         if(this.hideCarouselCB != null)
         {
            this.hideCarouselCB();
         }
      }
      
      public function showCardAtIndex(index:int) : void
      {
         trace("GFX showCardAtIndex",this.changeChoiceCB);
         if(this.changeChoiceCB != null)
         {
            this.changeChoiceCB(index);
         }
      }
      
      protected function onGetTutorialStrings(stringArray:Array) : void
      {
         this.localizedStringsWithIcons = stringArray;
         if(currentFrame == 1 && this.localizedStringsWithIcons.length > 0 && this.mcMainText != null)
         {
            this.mcMainText.htmlText = this.localizedStringsWithIcons[0];
         }
      }
   }
}
