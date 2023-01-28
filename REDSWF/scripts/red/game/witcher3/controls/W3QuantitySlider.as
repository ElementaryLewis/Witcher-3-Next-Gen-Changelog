package red.game.witcher3.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.controls.Button;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.SliderEvent;
   
   public class W3QuantitySlider extends W3Slider
   {
       
      
      private const BUTTON_WIDTH:Number = 24;
      
      private const BLOCK_PADDING:Number = 5;
      
      private const SLIDER_WIDTH:Number = 331;
      
      public var txtMinValue:TextField;
      
      public var txtMaxValue:TextField;
      
      public var btnLeft:Button;
      
      public var btnRight:Button;
      
      public function W3QuantitySlider()
      {
         super();
         this.btnLeft.addEventListener(ButtonEvent.CLICK,this.handleLeftPress,false,0,true);
         this.btnRight.addEventListener(ButtonEvent.CLICK,this.handleRightPress,false,0,true);
      }
      
      override public function set maximum(param1:Number) : void
      {
         super.maximum = param1;
         this.txtMaxValue.text = _maximum.toString();
         this.txtMaxValue.width = this.txtMaxValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.updateControls();
      }
      
      override public function set minimum(param1:Number) : void
      {
         super.minimum = param1;
         this.txtMinValue.text = _minimum.toString();
         this.updateControls();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         var _loc1_:InputManager = InputManager.getInstance();
         _loc1_.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
         this.updateControls();
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedOnStage,false,0,true);
         }
      }
      
      private function handleAddedOnStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedOnStage);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
      }
      
      private function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this.updateControls();
      }
      
      private function updateControls() : void
      {
         var _loc1_:InputManager = InputManager.getInstance();
         var _loc2_:Boolean = _loc1_.isGamepad();
         if(_loc2_)
         {
            this.btnLeft.visible = false;
            this.btnRight.visible = false;
         }
         else
         {
            this.btnLeft.visible = true;
            this.btnRight.visible = true;
            this.btnLeft.x = track.x - this.BLOCK_PADDING;
            this.btnRight.x = this.SLIDER_WIDTH + this.BLOCK_PADDING;
         }
         invalidateData();
      }
      
      private function handleMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            value += snapInterval;
         }
         else
         {
            value -= snapInterval;
         }
      }
      
      private function handleLeftPress(param1:ButtonEvent) : void
      {
         value -= snapInterval;
      }
      
      private function handleRightPress(param1:ButtonEvent) : void
      {
         value += snapInterval;
      }
      
      override protected function updateThumb() : void
      {
         if(!enabled)
         {
            return;
         }
         var _loc1_:Number = track.width - offsetLeft - offsetRight;
         thumb.x = (_value - _minimum) / (_maximum - _minimum) * _loc1_ - thumb.width / 2 + offsetLeft;
         if(txtValue)
         {
            txtValue.text = _value.toString();
         }
      }
      
      override protected function doDrag(param1:MouseEvent) : void
      {
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Number = _loc2_.x - _dragOffset.x;
         var _loc4_:Number = track.width - offsetLeft - offsetRight;
         var _loc5_:Number = lockValue((_loc3_ - offsetLeft) / _loc4_ * (_maximum - _minimum) + _minimum);
         if(value == _loc5_)
         {
            return;
         }
         _value = _loc5_;
         this.updateThumb();
         if(liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGE,false,true,_value));
         }
      }
      
      override protected function trackPress(param1:MouseEvent) : void
      {
         _trackPressed = true;
         track.focused = _focused;
         var _loc2_:Number = track.width - offsetLeft - offsetRight;
         var _loc3_:Number = lockValue((param1.localX * scaleX - offsetLeft) / _loc2_ * (_maximum - _minimum) + _minimum);
         if(value == _loc3_)
         {
            return;
         }
         value = _loc3_;
         if(!liveDragging)
         {
            dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGE,false,true,_value));
         }
         _trackDragMouseIndex = 0;
         _dragOffset = {"x":0};
      }
   }
}
