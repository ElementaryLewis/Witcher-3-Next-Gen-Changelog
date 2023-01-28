package red.game.witcher3.menus.worldmap
{
   import scaleform.clik.controls.UILoader;
   
   public class HubMapTileLoader extends UILoader
   {
       
      
      public function HubMapTileLoader()
      {
         super();
      }
      
      override public function unload() : void
      {
         if(loader != null)
         {
            visible = _visiblilityBeforeLoad;
            loader.unloadAndStop(false);
         }
         _source = null;
         _loadOK = false;
         _sizeRetries = 0;
      }
   }
}
