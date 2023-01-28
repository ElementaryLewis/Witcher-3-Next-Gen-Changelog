package red.game.witcher3.menus.poster
{
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.NavigationCode;
   
   public class PosterMenu extends CoreMenu
   {
      
      private static const BLOCK_PADDING:Number = 160;
       
      
      public var tfSubtitles:TextField;
      
      public var tfSubtitlesHack:TextField;
      
      public function PosterMenu()
      {
         addFrameScript(0,this.frame1);
         _disableShowAnimation = true;
         super();
         _enableInputValidation = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         InputFeedbackManager.useOverlayPopup = true;
         InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_B,KeyCode.ESCAPE,"[[panel_button_common_exit]]");
      }
      
      override protected function get menuName() : String
      {
         return "PosterMenu";
      }
      
      public function CloseMenu() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      public function SetDescription(param1:String, param2:Boolean) : *
      {
         if(param2)
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfSubtitles.htmlText = "<p align=\"right\">" + param1 + "</p>";
            }
            else
            {
               this.tfSubtitles.htmlText = "<p align=\"left\">" + param1 + "</p>";
            }
         }
         else
         {
            this.tfSubtitles.htmlText = param1;
         }
         if(this.tfSubtitles.textHeight + this.tfSubtitles.y > 1025)
         {
            this.tfSubtitles.y = 1025 - this.tfSubtitles.textHeight;
         }
         else
         {
            this.tfSubtitles.y = 758;
         }
      }
      
      public function SetSubtitlesHack(param1:String, param2:String) : *
      {
         if(Boolean(this.tfSubtitles.htmlText) && this.tfSubtitles.htmlText.length > 0)
         {
            return;
         }
         this.tfSubtitlesHack.htmlText = "<b><font color=\'#FFFFFF\'>" + param1 + "</font>" + param2;
         this.tfSubtitlesHack.height = this.tfSubtitlesHack.textHeight + CommonConstants.SAFE_TEXT_PADDING + 12;
         var _loc3_:Number = 1080 * 0.95;
         this.tfSubtitlesHack.y = _loc3_ - this.tfSubtitlesHack.height - BLOCK_PADDING;
      }
      
      override protected function hideAnimation() : void
      {
         closeMenu();
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
