package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   
   public class InteriorMap extends BaseMap
   {
       
      
      public var mcInteriorMapContainer:InteriorMapContainer;
      
      public var mcInteriorBackground:MovieClip;
      
      public function InteriorMap()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function SetScale(param1:Number) : *
      {
         var _loc2_:Number = HudModuleMinimap2.GetCoef(true);
         var _loc3_:* = ZOOM_COEF * _loc2_ * param1;
         scaleX = _loc3_;
         scaleY = _loc3_;
         this.mcInteriorBackground.scaleX = 1 / actualScaleX;
         this.mcInteriorBackground.scaleY = 1 / actualScaleY;
      }
   }
}
