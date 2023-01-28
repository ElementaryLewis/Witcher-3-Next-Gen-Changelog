package red.game.witcher3.hud.modules.console
{
   import com.gskinner.motion.GTween;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import scaleform.clik.core.UIComponent;
   
   public class ConsoleMessageItem extends UIComponent
   {
      
      protected static const SAFE_TEXT_PADDING:Number = 5;
      
      protected static const ANIM_DURATION:Number = 0.5;
      
      protected static const VANISHING_SCALE:Number = 0.5;
      
      protected static const VANISHING_ROT:Number = -50;
      
      protected static const VANISHING_X_OFFSET:Number = -30;
      
      protected static const APPEARING_SCALE:Number = 0.8;
      
      protected static const APPEARING_ROT:Number = -50;
      
      protected static const APPEARING_X_OFFSET:Number = 30;
       
      
      public var textField:TextField;
      
      protected var _vanishingTween:GTween;
      
      protected var _pendingKill:Boolean;
      
      protected var _lifeTimer:Timer;
      
      public function ConsoleMessageItem()
      {
         super();
      }
      
      public function init(param1:String, param2:Number, param3:Number) : *
      {
         this.textField.htmlText = param1;
         this.textField.width = param3;
         this.textField.multiline = true;
         this.textField.height = this.textField.textHeight + SAFE_TEXT_PADDING;
         this.textField.x = 0;
         this._lifeTimer = new Timer(param2);
         this._lifeTimer.addEventListener(TimerEvent.TIMER,this.handleLifeTimer,false,0,true);
         this._lifeTimer.start();
      }
      
      public function forceRemove() : void
      {
         if(!this._pendingKill)
         {
            this.startHidding();
         }
      }
      
      public function isVanishing() : Boolean
      {
         return this._vanishingTween != null;
      }
      
      public function destroy() : void
      {
         this._pendingKill = true;
      }
      
      protected function handleLifeTimer(param1:TimerEvent = null) : void
      {
         this.startHidding();
      }
      
      protected function startHidding() : void
      {
         alpha = 0;
         this.handleHidden();
      }
      
      protected function handleHidden(param1:GTween = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this.destroy();
         this._pendingKill = true;
      }
   }
}
