package red.game.witcher3.hud.modules.wolfHead
{
   import flash.display.MovieClip;
   import scaleform.clik.controls.StatusIndicator;
   
   public class W3StatIndicator extends StatusIndicator
   {
       
      
      public var mcBackgroundHealth:MovieClip;
      
      public function W3StatIndicator()
      {
         super();
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
   }
}
