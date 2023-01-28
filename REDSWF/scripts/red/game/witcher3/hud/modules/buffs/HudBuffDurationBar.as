package red.game.witcher3.hud.modules.buffs
{
   import flash.display.MovieClip;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   
   public class HudBuffDurationBar extends UIComponent
   {
       
      
      public var mcMaskLeft:MovieClip;
      
      public var mcMaskRight:MovieClip;
      
      public var mcBuffShapeLeft:MovieClip;
      
      public var mcBuffShapeRight:MovieClip;
      
      private var _originalMaskLeftRotZ:Number = -1;
      
      private var _originalMaskRightRotZ:Number = -1;
      
      protected var _percent:Number = NaN;
      
      protected var _oldPercent:Number = NaN;
      
      protected var _newPercent:Number = NaN;
      
      public function HudBuffDurationBar()
      {
         super();
         this._originalMaskLeftRotZ = this.mcMaskLeft.rotationZ;
         this._originalMaskRightRotZ = this.mcMaskRight.rotationZ;
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
      
      public function reset() : void
      {
         this._percent = this._newPercent = this._oldPercent = NaN;
      }
      
      public function setPositive(param1:*) : void
      {
         var _loc2_:String = null;
         if(param1 == 0)
         {
            _loc2_ = "negative";
         }
         else if(param1 == 1)
         {
            _loc2_ = "positive";
         }
         else if(param1 == 2)
         {
            _loc2_ = "neutral";
         }
         this.mcBuffShapeLeft.gotoAndStop(_loc2_);
         this.mcBuffShapeRight.gotoAndStop(_loc2_);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
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
         if(this._percent <= 0.5)
         {
            this.mcMaskRight.rotationZ = 0;
            this.mcMaskLeft.rotationZ = -360 * this.percent;
         }
         else
         {
            this.mcMaskRight.rotationZ = -360 * (this.percent - 0.5);
            this.mcMaskLeft.rotationZ = -180;
         }
      }
   }
}
