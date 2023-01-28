package red.game.witcher3.hud.modules.minimap2
{
   import scaleform.clik.controls.UILoader;
   
   public class MinimapLoader extends UILoader
   {
       
      
      private var _loading:Boolean = false;
      
      public function MinimapLoader()
      {
         super();
      }
      
      public function IsLoading() : Boolean
      {
         return this._loading;
      }
      
      override public function set source(param1:String) : void
      {
         if(_source == param1)
         {
            return;
         }
         if(param1 == "" || param1 == null)
         {
            this._loading = false;
            if(Boolean(loader) && Boolean(loader.content))
            {
               this.unload();
            }
         }
         else
         {
            this._loading = true;
            load(param1);
         }
      }
      
      public function OnLoadingComplete() : *
      {
         this._loading = false;
      }
      
      public function OnLoadingError() : *
      {
         this._loading = false;
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
