package red.game.witcher3.hud.modules.statbars
{
   import flash.display.MovieClip;
   import scaleform.clik.constants.InvalidationType;
   
   public class HudStatBarStamina extends HudStatBar
   {
       
      
      public var mcBarNeed:MovieClip;
      
      public var mcMaskNeeded:MovieClip;
      
      protected var _percentNeeded:Number = NaN;
      
      public function HudStatBarStamina()
      {
         super();
      }
      
      public function get percentNeeded() : Number
      {
         return _percent;
      }
      
      public function set percentNeeded(param1:Number) : void
      {
         var _loc2_:Number = Math.min(1,Math.max(0,param1));
         this._percentNeeded = _loc2_;
         this.mcBarNeed.gotoAndPlay(2);
         invalidateData();
      }
      
      override public function reset() : void
      {
         super.reset();
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.DATA))
         {
            if(!isNaN(this._percentNeeded))
            {
               this.updateToLowStaminaIndicator();
            }
         }
         super.draw();
      }
      
      private function updateToLowStaminaIndicator() : void
      {
         if(isNaN(this._percentNeeded))
         {
            throw new Error("_percentNeeded was updated with NaN");
         }
         var _loc1_:Number = _originalMaskPosX - (1 - this._percentNeeded) * this.mcMaskNeeded.width;
         this.mcMaskNeeded.x = _loc1_;
      }
   }
}
