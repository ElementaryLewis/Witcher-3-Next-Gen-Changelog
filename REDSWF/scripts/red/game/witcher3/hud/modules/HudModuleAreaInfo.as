package red.game.witcher3.hud.modules
{
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   
   public class HudModuleAreaInfo extends HudModuleBase
   {
       
      
      public var textField:TextField;
      
      private var showTimer:Timer;
      
      public function HudModuleAreaInfo()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override public function get moduleName() : String
      {
         return "AreaInfoModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = true;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function SetText(param1:String) : void
      {
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(param1);
         this.SetShowTimer();
      }
      
      public function SetShowTimer() : void
      {
         if(!this.showTimer)
         {
            this.showTimer = new Timer(UPDATE_FADE_TIME,1);
            this.showTimer.addEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCounting);
         }
         else
         {
            this.showTimer.reset();
         }
         this.showTimer.start();
      }
      
      public function ResetShowTimer() : void
      {
         if(this.showTimer)
         {
            this.showTimer.reset();
            this.showTimer.start();
         }
      }
      
      public function RemoveShowTimer() : void
      {
         if(this.showTimer)
         {
            this.showTimer.stop();
            this.showTimer = null;
         }
      }
      
      internal function ShowTimerFinishedCounting(param1:TimerEvent) : void
      {
         this.RemoveShowTimer();
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
