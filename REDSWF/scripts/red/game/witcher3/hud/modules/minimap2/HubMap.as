package red.game.witcher3.hud.modules.minimap2
{
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   
   public class HubMap extends BaseMap
   {
       
      
      public var mcHubMapContainer:HubMapContainer;
      
      public function HubMap()
      {
         super();
      }
      
      override public function SetScale(param1:Number) : *
      {
         var _loc2_:Number = HudModuleMinimap2.GetCoef(false);
         var _loc3_:* = ZOOM_COEF * _loc2_ * param1;
         scaleX = _loc3_;
         scaleY = _loc3_;
      }
   }
}
