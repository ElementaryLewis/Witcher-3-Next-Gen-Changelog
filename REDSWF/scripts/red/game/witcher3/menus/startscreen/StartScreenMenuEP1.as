package red.game.witcher3.menus.startscreen
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class StartScreenMenuEP1 extends CoreMenu
   {
       
      
      protected var closeTimer:Timer;
      
      protected var soundLerpTimer:Timer;
      
      protected var _fadeTime:Number;
      
      public var mcTextShadow:MovieClip;
      
      public var mcGameLogo:MovieClip;
      
      public var textField:TextField;
      
      public function StartScreenMenuEP1()
      {
         addFrameScript(0,this.frame1);
         super();
         upToCloseEnabled = false;
      }
      
      override protected function get menuName() : String
      {
         return "StartScreenMenuEP1";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      override public function setPlatform(param1:uint) : void
      {
         super.setPlatform(param1);
         switch(param1)
         {
            case 0:
            case 3:
               this.textField.htmlText = "[[panel_button_press_any]]";
               break;
            case 1:
               this.textField.htmlText = "[[panel_button_press_any_X1]]";
               break;
            case 2:
               this.textField.htmlText = "[[panel_button_press_any_PS4]]";
         }
      }
      
      public function setDisplayedText(param1:String) : void
      {
         this.textField.htmlText = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_ && !_loc2_.fromJoystick)
         {
            stage.removeEventListener(InputEvent.INPUT,this.handleInput,false);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnKeyPress"));
         }
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
      }
      
      public function startClosingTimer() : void
      {
         this.closeTimer.addEventListener(TimerEvent.TIMER,this.TimerFinishedCounting);
         this.closeTimer.start();
      }
      
      internal function TimerFinishedCounting(param1:TimerEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      internal function TimerSoundVolume(param1:TimerEvent) : void
      {
      }
      
      public function SetFadeDuration(param1:Number) : void
      {
         this._fadeTime = param1;
         this.closeTimer = new Timer(this._fadeTime + 0.1,1);
      }
      
      public function SetIsStageDemo(param1:Boolean) : void
      {
         if(param1)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
      }
      
      public function setGameLogoLanguage(param1:String) : void
      {
         if(this.mcGameLogo)
         {
            this.mcGameLogo.gotoAndStop(param1);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
