package
{
   import red.game.witcher3.hud.modules.minimap2.MiniMapPinInstance;
   
   public dynamic class MapPinInstance extends MiniMapPinInstance
   {
       
      
      public function MapPinInstance()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
