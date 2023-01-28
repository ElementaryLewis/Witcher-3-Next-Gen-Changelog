package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import scaleform.clik.core.UIComponent;
   
   public class MiniMapPinInstance extends UIComponent
   {
       
      
      public var PinIcon:MovieClip;
      
      public var mcRadius:MovieClip;
      
      public var PinGlow:MovieClip;
      
      public function MiniMapPinInstance()
      {
         super();
         this.PinGlow.visible = false;
      }
   }
}
