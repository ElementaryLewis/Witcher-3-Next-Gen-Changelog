package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   
   public class HudModuleTimeLapse extends HudModuleBase
   {
      
      protected static const FADE_DURATION_TIME_LAPSE:Number = 2000;
       
      
      public var textField:TextField;
      
      public var textFieldSmall:TextField;
      
      public var mcBackground:MovieClip;
      
      protected var hideTimer:Timer;
      
      public function HudModuleTimeLapse()
      {
         addFrameScript(0,this.frame1);
         super();
         isAlwaysDynamic = true;
      }
      
      override public function get moduleName() : String
      {
         return "TimeLapseModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function handleTimelapseTextSet(param1:String) : *
      {
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(param1);
         this.textField.width = this.textField.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.textField.x = -this.textField.width;
         this.scaleBackground();
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function handleTimelapseAdditionalTextSet(param1:String) : *
      {
         this.textFieldSmall.htmlText = CommonUtils.toUpperCaseSafe(param1);
         this.textFieldSmall.width = this.textFieldSmall.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.textFieldSmall.x = -this.textFieldSmall.width;
      }
      
      private function scaleBackground() : void
      {
         var _loc1_:* = Math.max(this.textField.textWidth,this.textFieldSmall.textWidth) + 30;
         var _loc2_:* = this.textField.textHeight + this.textFieldSmall.textHeight + 20;
         this.mcBackground.width = _loc1_;
         this.mcBackground.height = _loc2_;
      }
      
      public function SetShowTime(param1:Number) : void
      {
         RemoveUpdateTimer();
         UPDATE_FADE_TIME = param1;
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      override public function onCutsceneStartedOrEnded(param1:Boolean) : *
      {
         if(param1)
         {
            if(!isInCutscene)
            {
               isInCutscene = true;
               x -= 440;
            }
         }
         else if(isInCutscene)
         {
            isInCutscene = false;
            x += 440;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
