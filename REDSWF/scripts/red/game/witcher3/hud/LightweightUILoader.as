package red.game.witcher3.hud
{
   import scaleform.clik.controls.UILoader;
   
   public class LightweightUILoader extends UILoader
   {
       
      
      public function LightweightUILoader()
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
