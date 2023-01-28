package red.game.witcher3.hud.modules.statbars
{
   import flash.display.MovieClip;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   
   public class HudStatBar extends UIComponent
   {
       
      
      public var mcMask:MovieClip;
      
      public var mcBar:MovieClip;
      
      public var mcSelection:MovieClip;
      
      protected var _originalMaskPosX:Number = -1;
      
      protected var _animationPeriodMS:int = 0;
      
      protected var _percent:Number = NaN;
      
      protected var _oldPercent:Number = NaN;
      
      protected var _newPercent:Number = NaN;
      
      protected var _moreIsBetter:Boolean = true;
      
      protected var _lerpDuration:int = 500;
      
      public function HudStatBar()
      {
         super();
         this._originalMaskPosX = this.mcMask.x;
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function set percent(param1:Number) : void
      {
         var _loc2_:Number = Math.min(1,Math.max(0,param1));
         if(this._percent == _loc2_)
         {
            return;
         }
         this._newPercent = _loc2_;
         invalidateData();
      }
      
      public function get moreIsBetter() : Boolean
      {
         return this._moreIsBetter;
      }
      
      public function set moreIsBetter(param1:Boolean) : void
      {
         this._moreIsBetter = param1;
      }
      
      public function get lerpDuration() : int
      {
         return this._lerpDuration;
      }
      
      public function set lerpDuration(param1:int) : void
      {
         this._lerpDuration = this.lerpDuration;
      }
      
      public function reset() : void
      {
         this._percent = this._newPercent = this._oldPercent = NaN;
         TweenEx.pauseTweenOn(this.mcMask);
         if(this.mcSelection)
         {
            TweenEx.pauseTweenOn(this.mcSelection);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.reset();
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.DATA))
         {
            if(!isNaN(this._newPercent))
            {
               this._oldPercent = this._percent;
               this._percent = this._newPercent;
               this._newPercent = NaN;
               this.updatePercent();
            }
         }
         super.draw();
      }
      
      private function updatePercent() : void
      {
         if(isNaN(this._percent))
         {
            throw new Error("_percent was updated with NaN");
         }
         var _loc1_:Number = this._originalMaskPosX - (1 - this._percent) * this.mcMask.width;
         TweenEx.pauseTweenOn(this.mcMask);
         TweenEx.pauseTweenOn(this.mcSelection);
         var _loc2_:Boolean = isNaN(this._oldPercent) || this._moreIsBetter ? this._percent < this._oldPercent : this._percent > this._oldPercent;
         _loc2_ = true;
         if(_loc2_)
         {
            if(this.mcSelection)
            {
            }
            if(this.mcMask)
            {
            }
            this.mcMask.x = _loc1_;
            this.mcSelection.x = _loc1_ + this.mcMask.width;
         }
         else
         {
            TweenEx.to(this._lerpDuration,this.mcMask,{"x":_loc1_},{"paused":false});
            TweenEx.to(this._lerpDuration,this.mcSelection,{"x":_loc1_ + this.mcMask.width},{"paused":false});
         }
      }
   }
}
