package red.game.witcher3.menus.meditation
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.core.utils.InputUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class Clock extends UIComponent
   {
      
      internal static var DAWN:int = 6;
      
      internal static var NOON:int = 12;
      
      internal static var DUSK:int = 18;
      
      internal static var NITE:int = 24;
       
      
      public var CurrentTimeHours:int;
      
      public var CurrentTimeMinutes:int;
      
      public var lbName:TextField;
      
      public var lbTimeCurrent:TextField;
      
      public var lbDuration:TextField;
      
      public var lbCurrentHours:TextField;
      
      public var fxArrow:MovieClip;
      
      public var fxCircle:MovieClip;
      
      public var fxButtonN:MovieClip;
      
      public var fxButtonE:MovieClip;
      
      public var fxButtonS:MovieClip;
      
      public var fxButtonW:MovieClip;
      
      public var m_tfDusk:TextField;
      
      public var m_tfNoon:TextField;
      
      public var m_tfDawn:TextField;
      
      public var m_tfMidnight:TextField;
      
      public var fxActiveIconN:MovieClip;
      
      public var fxPassiveIconN:MovieClip;
      
      public var fxActiveIconE:MovieClip;
      
      public var fxPassiveIconE:MovieClip;
      
      public var fxActiveIconS:MovieClip;
      
      public var fxPassiveIconS:MovieClip;
      
      public var fxActiveIconW:MovieClip;
      
      public var fxPassiveIconW:MovieClip;
      
      public var fxIconN:MovieClip;
      
      public var fxIconE:MovieClip;
      
      public var fxIconS:MovieClip;
      
      public var fxIconW:MovieClip;
      
      public var m_mcLabelDawn:MovieClip;
      
      public var m_mcLabelDusk:MovieClip;
      
      public var mcCurrentTime:MovieClip;
      
      private var baseArc:int;
      
      private var val:int;
      
      private var timeSelected:Number;
      
      private var dayHour:int;
      
      private var dayMinutes:int;
      
      public var bHandleInput:Boolean = true;
      
      public function Clock()
      {
         super();
         this.fxButtonN.addEventListener(MouseEvent.CLICK,this.onClick,false,0,false);
         this.fxButtonN.addEventListener(MouseEvent.DOUBLE_CLICK,this.onUse,false,0,false);
         this.fxButtonE.addEventListener(MouseEvent.CLICK,this.onClick,false,0,false);
         this.fxButtonE.addEventListener(MouseEvent.DOUBLE_CLICK,this.onUse,false,0,false);
         this.fxButtonS.addEventListener(MouseEvent.CLICK,this.onClick,false,0,false);
         this.fxButtonS.addEventListener(MouseEvent.DOUBLE_CLICK,this.onUse,false,0,false);
         this.fxButtonW.addEventListener(MouseEvent.CLICK,this.onClick,false,0,false);
         this.fxButtonW.addEventListener(MouseEvent.DOUBLE_CLICK,this.onUse,false,0,false);
         addEventListener("mouseMove",this.onMouseMove,false,0,false);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.hours",[this.OnSetCurrentDayHours]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.minutes",[this.OnSetCurrentDayMinutes]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.blocked",[this.OnBlockClock]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnGetCurrentDayTime"));
      }
      
      internal function OnSetCurrentDayHours(param1:int) : *
      {
         this.dayHour = param1;
         this.CurrentTimeHours = this.dayHour;
         this.CurrentTimeMinutes = this.dayMinutes;
         this.lbCurrentHours.text = String(this.CurrentTimeHours);
         this.baseArc = (180 + this.CurrentTimeHours * (360 / 24) + this.CurrentTimeMinutes * (360 / 24 / 60)) % 360;
         this.fxCircle.fxClip.rotation = this.baseArc;
         var _loc2_:int = 24 * 60;
         var _loc3_:int = this.CurrentTimeHours * 60 + this.CurrentTimeMinutes;
         this.mcCurrentTime.rotationZ = this.baseArc;
         if(this.bHandleInput)
         {
            this.setSelection((12 + this.CurrentTimeHours) / 24 * 360 + 1);
         }
      }
      
      internal function OnSetCurrentDayMinutes(param1:int) : *
      {
         this.dayMinutes = param1;
      }
      
      internal function OnBlockClock(param1:Boolean) : *
      {
         this.bHandleInput = param1;
      }
      
      private function onMouseMove(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         if(this.bHandleInput)
         {
            if(Math.sqrt(this.fxCircle.mouseX * this.fxCircle.mouseX + this.fxCircle.mouseY * this.fxCircle.mouseY) < 150)
            {
               _loc2_ = (360 + 90 + Math.atan2(this.fxCircle.mouseY,this.fxCircle.mouseX) * 180 / Math.PI) % 360;
               this.setSelection(_loc2_);
            }
         }
      }
      
      private function setSelection(param1:*) : void
      {
         if(param1 < 0)
         {
            param1 += 360;
         }
         if(param1 >= 360)
         {
            param1 -= 360;
         }
         this.val = (360 + (param1 - this.baseArc)) % 360;
         this.lbDuration.text = (Math.floor(param1 * 24 / 360 + 12) % 24).toString();
         this.timeSelected = Number(this.lbDuration.text);
         this.fxCircle.fxIconN.visible = false;
         this.fxCircle.fxIconE.visible = false;
         this.fxCircle.fxIconS.visible = false;
         this.fxCircle.fxIconW.visible = false;
         this.m_mcLabelDawn.m_tfDawn.textColor = 14342874;
         this.m_mcLabelDusk.m_tfDusk.textColor = 14342874;
         this.m_tfMidnight.textColor = 14342874;
         this.m_tfNoon.textColor = 14342874;
         this.fxArrow.rotation = param1;
         var _loc2_:int = 0;
         var _loc3_:* = _loc2_ + this.baseArc | 0;
         var _loc4_:* = _loc2_ + param1 | 0;
         if(_loc3_ < _loc4_)
         {
            if(_loc3_ < _loc2_ && _loc4_ > _loc2_)
            {
               this.fxCircle.fxIconN.visible = true;
            }
            if(_loc3_ < _loc2_ + 90 && _loc4_ > _loc2_ + 90)
            {
               this.fxCircle.fxIconE.visible = true;
            }
            if(_loc3_ < _loc2_ + 180 && _loc4_ > _loc2_ + 180)
            {
               this.fxCircle.fxIconS.visible = true;
            }
            if(_loc3_ < _loc2_ + 270 && _loc4_ >= _loc2_ + 270)
            {
               this.fxCircle.fxIconW.visible = true;
            }
         }
         else
         {
            this.fxCircle.fxIconN.visible = true;
            this.fxCircle.fxIconE.visible = true;
            this.fxCircle.fxIconS.visible = true;
            this.fxCircle.fxIconW.visible = true;
            if(_loc4_ < _loc2_ && _loc3_ > _loc2_)
            {
               this.fxCircle.fxIconN.visible = false;
            }
            if(_loc4_ < _loc2_ + 90 && _loc3_ > _loc2_ + 90)
            {
               this.fxCircle.fxIconE.visible = false;
            }
            if(_loc4_ < _loc2_ + 180 && _loc3_ >= _loc2_ + 180)
            {
               this.fxCircle.fxIconS.visible = false;
            }
            if(_loc4_ < _loc2_ + 270 && _loc3_ > _loc2_ + 270)
            {
               this.fxCircle.fxIconW.visible = false;
            }
         }
         this.DrawPie(this.fxCircle.fxClip,this.val,175);
         if(param1 >= 315 && param1 < 360)
         {
            this.m_tfNoon.textColor = 6330543;
         }
         if(param1 >= 0 && param1 < 45)
         {
            this.m_tfNoon.textColor = 6330543;
         }
         else if(param1 < 315 && param1 >= 225)
         {
            this.m_mcLabelDawn.m_tfDawn.textColor = 6330543;
         }
         else if(param1 >= 135 && param1 < 225)
         {
            this.m_tfMidnight.textColor = 6330543;
         }
         else if(param1 >= -180 && param1 < -135)
         {
            this.m_tfMidnight.textColor = 6330543;
         }
         else if(param1 >= 45 && param1 < 135)
         {
            this.m_mcLabelDusk.m_tfDusk.textColor = 6330543;
         }
      }
      
      public function onUse() : void
      {
         if(this.bHandleInput)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMeditate",[this.timeSelected]));
         }
      }
      
      private function onExit() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseMenu"));
      }
      
      private function onClick() : void
      {
         if(this.bHandleInput)
         {
            this.onUse();
         }
      }
      
      private function DrawPie(param1:MovieClip, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = Math.ceil(param2 / 45);
         var _loc5_:Number = -0.5 * Math.PI;
         var _loc6_:Number = param2 / _loc4_ / 180 * Math.PI;
         var _loc7_:Number = param3 - Math.cos(_loc5_) * param3;
         var _loc8_:Number = 0 - Math.sin(_loc5_) * param3;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:Boolean = false;
         var _loc4_:InputAxisData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(this.bHandleInput)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
            switch(_loc2_.code)
            {
               case KeyCode.PAD_LEFT_STICK_AXIS:
                  _loc5_ = (_loc4_ = InputAxisData(_loc2_.value)).xvalue;
                  _loc6_ = _loc4_.yvalue;
                  _loc7_ = InputUtils.getMagnitude(_loc5_,_loc6_);
                  _loc8_ = _loc7_ * _loc7_ * _loc7_;
                  _loc9_ = InputUtils.getAngleRadians(_loc5_,_loc6_);
                  if(_loc7_ < 0.5)
                  {
                     break;
                  }
                  _loc10_ = (360 + 90 - _loc9_ * 180 / Math.PI) % 360;
                  this.setSelection(_loc10_);
                  param1.handled = true;
                  break;
               case KeyCode.PAD_A_CROSS:
                  if(_loc3_)
                  {
                     this.onUse();
                     param1.handled = true;
                     param1.stopImmediatePropagation();
                  }
                  break;
               default:
                  return;
            }
         }
      }
   }
}
