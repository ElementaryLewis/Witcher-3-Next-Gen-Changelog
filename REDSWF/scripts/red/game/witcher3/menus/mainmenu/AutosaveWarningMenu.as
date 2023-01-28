package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class AutosaveWarningMenu extends CoreMenu
   {
       
      
      public var mcIndicatorSave:MovieClip;
      
      public var txtAutosaveWarning:TextField;
      
      public var mcSkipButton:InputFeedbackButton;
      
      private var showTimer:Timer;
      
      private var closing:Boolean = false;
      
      private var menuShown:Boolean = false;
      
      public function AutosaveWarningMenu()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override protected function get menuName() : String
      {
         return "AutosaveWarningMenu";
      }
      
      public function showSaveIdicator() : void
      {
         this.mcIndicatorSave.gotoAndPlay("activate");
      }
      
      override public function setPlatform(param1:uint) : void
      {
         super.setPlatform(param1);
         this.mcSkipButton.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.ESCAPE);
         this.mcSkipButton.label = "[[panel_button_dialogue_skip]]";
         this.mcSkipButton.clickable = false;
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:* = false;
         if(this.menuShown && !this.closing)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            if(_loc3_ && _loc2_.navEquivalent == NavigationCode.GAMEPAD_X)
            {
               this.closing = true;
               this.showTimer.stop();
               hideAnimation();
            }
         }
      }
      
      public function setAutosaveMessage(param1:String) : void
      {
         this.txtAutosaveWarning.htmlText = param1;
      }
      
      public function setShowTimerDuration(param1:int) : void
      {
         this.showTimer = new Timer(param1,1);
      }
      
      override protected function handleShowAnimComplete(param1:GTween) : void
      {
         this.menuShown = true;
         super.handleShowAnimComplete(param1);
         this.showSaveIdicator();
         if(!this.showTimer)
         {
            this.showTimer = new Timer(3000,1);
         }
         this.showTimer.addEventListener(TimerEvent.TIMER,this.showTimerEnded);
         this.showTimer.start();
      }
      
      internal function showTimerEnded(param1:TimerEvent) : void
      {
         hideAnimation();
      }
   }
}
