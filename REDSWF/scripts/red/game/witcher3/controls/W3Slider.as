package red.game.witcher3.controls
{
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.events.GameEvent;
   import scaleform.clik.controls.Slider;
   
   public class W3Slider extends Slider
   {
       
      
      public var txtValue:TextField;
      
      public var previousValue:Number = -1;
      
      private var errorTimer:Timer;
      
      public var isVertical:Boolean = false;
      
      private var _enableSounds:Boolean;
      
      public function W3Slider()
      {
         super();
      }
      
      public function get enableSounds() : Boolean
      {
         return this._enableSounds;
      }
      
      public function set enableSounds(param1:Boolean) : void
      {
         this._enableSounds = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.errorTimer = new Timer(500,1);
         this.errorTimer.addEventListener(TimerEvent.TIMER,this.OnErrorTimer,false,0,true);
      }
      
      override public function set value(param1:Number) : void
      {
         if(param1 > maximum || param1 < minimum)
         {
            if(this.previousValue != param1 && this._enableSounds)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_slider_move_failed"]));
            }
            this.previousValue = param1;
            if(this.errorTimer == null)
            {
               this.errorTimer = new Timer(500,1);
               this.errorTimer.addEventListener(TimerEvent.TIMER,this.OnErrorTimer,false,0,true);
            }
            this.errorTimer.reset();
            this.errorTimer.start();
            return;
         }
         if(this._enableSounds)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_slider_move"]));
         }
         super.value = param1;
         if(this.txtValue)
         {
            this.txtValue.text = _value.toString();
         }
      }
      
      public function OnErrorTimer(param1:TimerEvent) : *
      {
         this.errorTimer.stop();
         this.previousValue = -1;
      }
   }
}
