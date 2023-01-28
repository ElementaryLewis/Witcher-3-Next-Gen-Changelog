package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.core.utils.InputUtils;
   import red.game.witcher3.controls.W3Slider;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class UIRescaleModule extends CoreMenuModule
   {
      
      private static const MAX_H_SCALE:Number = 1;
      
      private static const MIN_H_SCALE:Number = 0.9;
      
      private static const MAX_V_SCALE:Number = 1;
      
      private static const MIN_V_SCALE:Number = 0.9;
      
      private static const MIN_OPACITY:Number = 0.2;
      
      private static const MAX_OPACITY:Number = 1;
      
      private static const RESIZE_SCALE_BASE_FACTOR:Number = 0.0075;
      
      private static const RESIZE_SCALE_STICK_SPEED_CAP:Number = 0.05;
       
      
      protected var _updatingScale:Boolean = false;
      
      public var hSlider:W3Slider;
      
      public var vSlider:ScrollBar;
      
      public var mcSampleFrame:MovieClip;
      
      public var mcSampleScaleFrame:MovieClip;
      
      public var mcPCBackground:MovieClip;
      
      private var baseSampleScaleX:Number;
      
      private var baseSampleScaleY:Number;
      
      public var mcScaleFrame:MovieClip;
      
      public var txtExplanation:TextField;
      
      private var initialHScale:Number;
      
      private var initialVScale:Number;
      
      private var gapH:Number;
      
      private var gapV:Number;
      
      private var numValuesV:int;
      
      public var _lastSentHValue:Number;
      
      public var _lastSentVValue:Number;
      
      public function UIRescaleModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setupSliders();
         this.showPCControllers(!InputManager.getInstance().isGamepad());
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         if(this.mcSampleScaleFrame)
         {
            this.baseSampleScaleX = this.mcSampleScaleFrame.scaleX;
            this.baseSampleScaleY = this.mcSampleScaleFrame.scaleY;
         }
         enabled = false;
         visible = false;
         alpha = 0;
      }
      
      public function SetInitialScaleHorizontal(param1:Number) : *
      {
         this.initialHScale = this.mcScaleFrame.scaleX;
      }
      
      public function SetInitialScaleVertical(param1:Number) : *
      {
         this.initialVScale = this.mcScaleFrame.scaleY;
      }
      
      public function show(param1:Object) : void
      {
         this.showWithScale(param1.initialHScale,param1.initialVScale);
      }
      
      public function showWithScale(param1:Number, param2:Number) : void
      {
         visible = true;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         this.SetInitialScaleHorizontal(param1);
         this.SetInitialScaleVertical(param2);
         this.updateScale(Math.min(Math.max(param1,MIN_H_SCALE),MAX_H_SCALE),Math.min(Math.max(param2,MIN_V_SCALE),MAX_V_SCALE));
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            enabled = false;
            GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.onHideComplete});
         }
      }
      
      protected function onHideComplete(param1:GTween) : void
      {
         visible = false;
      }
      
      protected function setupSliders() : void
      {
         if(Boolean(this.hSlider) && Boolean(this.vSlider))
         {
            this.gapH = MAX_H_SCALE - MIN_H_SCALE;
            this.hSlider.snapping = false;
            this.hSlider.offsetLeft = 35;
            this.hSlider.offsetRight = 35;
            this.hSlider.maximum = MAX_H_SCALE;
            this.hSlider.minimum = MIN_H_SCALE;
            this.hSlider.value = MAX_H_SCALE;
            this.hSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.onSliderValueChanged,false,0,false);
            this.hSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onHSliderMouseOut,false,0,true);
            this.hSlider.validateNow();
            this.gapV = MAX_V_SCALE - MIN_V_SCALE;
            this.numValuesV = this.gapV / RESIZE_SCALE_BASE_FACTOR;
            this.vSlider.setScrollProperties(5,0,this.numValuesV,1);
            this.vSlider.addEventListener(Event.SCROLL,this.onScrollbarValue,false,0,true);
            this.vSlider.addEventListener(Event.CHANGE,this.onScrollbarValue,false,0,true);
            this.vSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onVSliderMouseOut,false,0,true);
            this.vSlider.validateNow();
         }
      }
      
      public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:* = false;
         var _loc4_:InputAxisData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(visible)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            if(!param1.handled)
            {
               if(_loc2_.code == KeyCode.PAD_LEFT_STICK_AXIS)
               {
                  _loc4_ = InputAxisData(_loc2_.value);
                  _loc5_ = InputUtils.getMagnitude(_loc4_.xvalue,_loc4_.yvalue);
                  _loc6_ = _loc5_ * _loc5_ * _loc5_;
                  _loc7_ = RESIZE_SCALE_BASE_FACTOR;
                  this.updateScale(Math.min(Math.max(this.mcScaleFrame.scaleX - _loc7_ * _loc4_.xvalue,MIN_H_SCALE),MAX_H_SCALE),Math.min(Math.max(this.mcScaleFrame.scaleY + _loc7_ * _loc4_.yvalue,MIN_V_SCALE),MAX_V_SCALE));
                  param1.handled = true;
               }
               else
               {
                  CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
                  _loc8_ = 0;
                  _loc9_ = 0;
                  switch(_loc2_.navEquivalent)
                  {
                     case NavigationCode.GAMEPAD_B:
                        if(_loc3_)
                        {
                           this.handleNavigateBack();
                        }
                        break;
                     case NavigationCode.UP:
                        if(!_loc2_.fromJoystick)
                        {
                           _loc9_ = RESIZE_SCALE_BASE_FACTOR;
                        }
                        break;
                     case NavigationCode.DOWN:
                        if(!_loc2_.fromJoystick)
                        {
                           _loc9_ = -RESIZE_SCALE_BASE_FACTOR;
                        }
                        break;
                     case NavigationCode.LEFT:
                        if(!_loc2_.fromJoystick)
                        {
                           _loc8_ = RESIZE_SCALE_BASE_FACTOR;
                        }
                        break;
                     case NavigationCode.RIGHT:
                        if(!_loc2_.fromJoystick)
                        {
                           _loc8_ = -RESIZE_SCALE_BASE_FACTOR;
                        }
                  }
                  if(_loc8_ != 0 || _loc9_ != 0)
                  {
                     this.updateScale(Math.min(Math.max(this.mcScaleFrame.scaleX + _loc8_,MIN_H_SCALE),MAX_H_SCALE),Math.min(Math.max(this.mcScaleFrame.scaleY + _loc9_,MIN_V_SCALE),MAX_V_SCALE));
                  }
               }
            }
         }
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this.showPCControllers(!param1.isGamepad);
      }
      
      public function showPCControllers(param1:Boolean) : void
      {
         if(this.hSlider)
         {
            this.hSlider.visible = param1;
         }
         if(this.vSlider)
         {
            this.vSlider.visible = param1;
         }
         if(this.mcSampleFrame)
         {
            this.mcSampleFrame.visible = param1;
         }
         if(this.mcSampleScaleFrame)
         {
            this.mcSampleScaleFrame.visible = param1;
         }
         if(this.mcPCBackground)
         {
            this.mcPCBackground.visible = param1;
         }
      }
      
      protected function onHSliderMouseOut(param1:MouseEvent) : void
      {
         this.hSlider.focused = 0;
      }
      
      protected function onVSliderMouseOut(param1:MouseEvent) : void
      {
         this.vSlider.focused = 0;
      }
      
      protected function onSliderValueChanged(param1:SliderEvent) : void
      {
         if(!this._updatingScale)
         {
            this.updateScale(this.getConvertedHSliderValue(),this.getScrollBarVValue());
         }
      }
      
      protected function onScrollbarValue(param1:Event) : void
      {
         if(!this._updatingScale)
         {
            this.updateScale(this.getConvertedHSliderValue(),this.getScrollBarVValue());
         }
      }
      
      protected function getConvertedHSliderValue() : Number
      {
         return MAX_H_SCALE - (this.hSlider.value - MIN_H_SCALE);
      }
      
      protected function updateScale(param1:Number, param2:Number) : void
      {
         this.mcScaleFrame.scaleX = Math.min(Math.max(param1,MIN_H_SCALE),MAX_H_SCALE);
         this.mcScaleFrame.scaleY = Math.min(Math.max(param2,MIN_V_SCALE),MAX_V_SCALE);
         if(param1 != this._lastSentHValue || param2 != this._lastSentVValue)
         {
            this._lastSentHValue = param1;
            this._lastSentVValue = param2;
            if(Boolean(this.hSlider) && Boolean(this.vSlider))
            {
               this._updatingScale = true;
               this.hSlider.value = MAX_H_SCALE - (param1 - MIN_H_SCALE);
               this.setScrollbarVValue(param2);
               this._updatingScale = false;
            }
            if(this.mcSampleScaleFrame)
            {
               this.mcSampleScaleFrame.scaleX = this.baseSampleScaleX * param1;
               this.mcSampleScaleFrame.scaleY = this.baseSampleScaleY * param2;
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUpdateRescale",[this.mcScaleFrame.scaleX,this.mcScaleFrame.scaleY]));
         }
      }
      
      protected function getScrollBarVValue() : Number
      {
         return MIN_V_SCALE + RESIZE_SCALE_BASE_FACTOR * (this.numValuesV - this.vSlider.position);
      }
      
      protected function setScrollbarVValue(param1:Number) : void
      {
         var _loc2_:int = this.numValuesV - (param1 - MIN_V_SCALE) / RESIZE_SCALE_BASE_FACTOR;
         this.vSlider.position = _loc2_;
         this.vSlider.validateNow();
      }
      
      public function onRightClick(param1:MouseEvent) : void
      {
         if(visible)
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleNavigateBack() : void
      {
         dispatchEvent(new Event(IngameMenu.OnOptionPanelClosed,false,false));
      }
   }
}
