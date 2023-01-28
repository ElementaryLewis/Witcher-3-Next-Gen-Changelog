package red.game.witcher3.hud.modules
{
   import fl.transitions.easing.Strong;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.controls.Label;
   
   public class HudModuleMessage extends HudModuleBase
   {
      
      private static const INITIAL_Y_POSITION:Number = 0;
      
      private static const MESSAGE_SHOW_DURATION:Number = 3500;
      
      private static const MESSAGE_FADE_DURATION:Number = 300;
      
      private static const DESTINATION_Y:Number = 0;
       
      
      public var mcMessage:Label;
      
      private var hideTimer:Timer;
      
      public function HudModuleMessage()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override public function get moduleName() : String
      {
         return "MessageModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         alpha = 0;
         registerDataBinding("hud.message",this.OnNewHudMessage);
         this.hideTimer = new Timer(MESSAGE_SHOW_DURATION,1);
         this.hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.OnHideTimerComplete);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      private function OnNewHudMessage(param1:String) : void
      {
         var _loc2_:TweenEx = null;
         if(param1.length == 0)
         {
            this.mcMessage.htmlText = "";
            this.mcMessage.alpha = 0;
            pauseTweenOn(this.mcMessage);
            return;
         }
         this.mcMessage.htmlText = param1;
         this.mcMessage.alpha = 0;
         this.mcMessage.y = -10 - this.mcMessage.height;
         this.mcMessage.invalidateSize();
         this.mcMessage.validateNow();
         visible = true;
         pauseTweenOn(this.mcMessage);
         _loc2_ = TweenEx.to(MESSAGE_FADE_DURATION * 4,this.mcMessage,{"alpha":1},{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":this.StartHideTimer
         });
         targetTweens.push(_loc2_);
      }
      
      private function StartHideTimer() : void
      {
         this.hideTimer.reset();
         this.hideTimer.start();
      }
      
      private function OnHideTimerComplete(param1:TimerEvent) : void
      {
         var _loc2_:TweenEx = null;
         pauseTweenOn(this.mcMessage);
         _loc2_ = TweenEx.to(MESSAGE_FADE_DURATION,this.mcMessage,{"alpha":0},{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":this.OnMessageHidden
         });
         targetTweens.push(_loc2_);
      }
      
      private function OnMessageHidden() : void
      {
         pauseTweenOn(this.mcMessage);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnMessageHidden"));
         visible = false;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
