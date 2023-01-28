package red.game.witcher3.hud.modules.minimap2
{
   import scaleform.clik.core.UIComponent;
   
   public class BaseMap extends UIComponent
   {
      
      protected static const ZOOM_COEF:Number = 3;
       
      
      public function BaseMap()
      {
         super();
      }
      
      public function SetRotation(param1:Number) : *
      {
      }
      
      public function SetScale(param1:Number) : *
      {
      }
      
      public function UpdatePosition() : Boolean
      {
         return false;
      }
      
      public function ResetZoom() : *
      {
         this.SetScale(1);
      }
   }
}
