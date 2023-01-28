package red.game.witcher3.hud.modules.wolfHead
{
   import flash.display.MovieClip;
   
   public class StaminaIndicator extends W3StatIndicator
   {
       
      
      public var mcAmount:MovieClip;
      
      public var mcStaminaBarFill:MovieClip;
      
      public function StaminaIndicator()
      {
         super();
      }
      
      public function ShowAmountNeeded(param1:Number) : *
      {
         this.mcAmount.gotoAndStop(Math.floor(param1 * 100));
      }
      
      public function HideAmountNeeded() : *
      {
         this.mcAmount.gotoAndStop(1);
      }
      
      public function SetStaminaBarGraphic(param1:String) : *
      {
         this.mcStaminaBarFill.gotoAndStop(param1);
      }
   }
}
