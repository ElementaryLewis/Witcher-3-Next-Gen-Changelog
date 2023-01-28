package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   import scaleform.clik.core.UIComponent;
   
   public class CommonMapContainer extends UIComponent
   {
       
      
      private var _pinsLayers:Vector.<Sprite>;
      
      public function CommonMapContainer()
      {
         super();
         this._pinsLayers = new Vector.<Sprite>();
         this._pinsLayers.push(addChild(new Sprite()));
         this._pinsLayers.push(addChild(new Sprite()));
         this._pinsLayers.push(addChild(new Sprite()));
      }
      
      public function addChildPin(param1:uint, param2:MovieClip) : *
      {
         this._pinsLayers[param1].addChild(param2);
      }
      
      public function removeChildPin(param1:uint, param2:MovieClip) : *
      {
         this._pinsLayers[param1].removeChild(param2);
      }
      
      public function UpdatePosition() : *
      {
         x = -HudModuleMinimap2.WorldToMapX(HudModuleMinimap2.m_playerWorldPosX);
         y = -HudModuleMinimap2.WorldToMapY(HudModuleMinimap2.m_playerWorldPosY);
      }
   }
}
