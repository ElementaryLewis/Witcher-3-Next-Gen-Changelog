package red.game.witcher3.controls
{
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.events.GameEvent;
   import scaleform.clik.controls.Slider;
   import scaleform.clik.events.SliderEvent;
   
   public class W3Slider extends Slider
   {
       
      
      public var txtValue:TextField;
      
      public var previousValue:Number = -1;
      
      private var errorTimer:Timer;
      
      protected var _lockedValue:Number = -1;
      
      protected var _gEvent:GameEvent = null;
      
      protected var _skipValue:Number = -1;
      
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
      
      public function get gEvent() : GameEvent
      {
         return this._gEvent;
      }
      
      public function set gEvent(param1:GameEvent) : void
      {
         this._gEvent = param1;
      }
      
      public function get lockedValue() : Number
      {
         return this._lockedValue;
      }
      
      public function set lockedValue(param1:Number) : void
      {
         this._lockedValue = param1;
      }
      
      public function get skipValue() : Number
      {
         return this._skipValue;
      }
      
      public function set skipValue(param1:Number) : void
      {
         this._skipValue = param1;
      }
      
      private function checkSkipValue(param1:Number) : Number
      {
         if(param1 == this.skipValue && this.skipValue >= 0)
         {
            if(param1 > _value)
            {
               param1 += 1;
               if(this._gEvent != null)
               {
                  dispatchEvent(this._gEvent);
               }
            }
            else if(param1 < _value)
            {
               param1--;
               if(this._gEvent != null)
               {
                  dispatchEvent(this._gEvent);
               }
            }
         }
         return param1;
      }
      
      override public function set value(param1:Number) : void
      {
         var _loc2_:Number = param1;
         if(_loc2_ >= this._lockedValue && this._lockedValue >= 0)
         {
            if(this._gEvent != null)
            {
               dispatchEvent(this._gEvent);
            }
            return;
         }
         _loc2_ = this.checkSkipValue(_loc2_);
         if(_loc2_ > maximum || _loc2_ < minimum)
         {
            if(this.previousValue != _loc2_ && this._enableSounds)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_slider_move_failed"]));
            }
            this.previousValue = _loc2_;
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
         super.value = _loc2_;
         if(this.txtValue)
         {
            this.txtValue.text = _value.toString();
         }
      }
      
      override protected function doDrag(param1:MouseEvent) : void
      {
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Number = _loc2_.x - _dragOffset.x;
         var _loc4_:Number = _width - offsetLeft - offsetRight;
         var _loc5_:Number;
         if((_loc5_ = lockValue((_loc3_ - offsetLeft) / _loc4_ * (_maximum - _minimum) + _minimum)) >= this._lockedValue && this._lockedValue >= 0)
         {
            if(this._gEvent != null)
            {
               dispatchEvent(this._gEvent);
            }
            return;
         }
         if(_loc5_ != this.checkSkipValue(_loc5_))
         {
            _loc5_ = this.checkSkipValue(_loc5_);
         }
         else if(value == _loc5_)
         {
            return;
         }
         _value = _loc5_;
         updateThumb();
         if(liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGE,false,true,_value));
         }
      }
      
      override protected function trackPress(param1:MouseEvent) : void
      {
         _trackPressed = true;
         track.focused = _focused;
         var _loc2_:Number = _width - offsetLeft - offsetRight;
         var _loc3_:Number = lockValue((param1.localX * scaleX - offsetLeft) / _loc2_ * (_maximum - _minimum) + _minimum);
         if(_loc3_ >= this._lockedValue && this._lockedValue >= 0)
         {
            if(this._gEvent != null)
            {
               dispatchEvent(this._gEvent);
            }
            return;
         }
         if(_loc3_ != this.checkSkipValue(_loc3_))
         {
            _loc3_ = this.checkSkipValue(_loc3_);
         }
         else if(value == _loc3_)
         {
            return;
         }
         this.value = _loc3_;
         if(!liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGE,false,true,_value));
         }
         _trackDragMouseIndex = 0;
         _dragOffset = {"x":0};
      }
      
      public function OnErrorTimer(param1:TimerEvent) : *
      {
         this.errorTimer.stop();
         this.previousValue = -1;
      }
   }
}
