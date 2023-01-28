package red.game.witcher3.menus.worldmap
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import scaleform.clik.core.UIComponent;
   
   public class HubMapPreviewZoomContainer extends UIComponent
   {
       
      
      private var _loader:HubMapTileLoader;
      
      public function HubMapPreviewZoomContainer()
      {
         super();
      }
      
      public function SetMapSettings(param1:String) : *
      {
         var _loc2_:* = "img://maps/" + param1 + "/level0/tile0x0.jpg";
         this._loader = new HubMapTileLoader();
         this._loader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleImageFailed,false,0,true);
         addChild(this._loader);
         this._loader.source = _loc2_;
      }
      
      protected function handleImageLoaded(param1:Event) : void
      {
         var _loc2_:Bitmap = Bitmap(param1.target.content);
         if(_loc2_)
         {
            _loc2_.smoothing = true;
            this._loader.x = -_loc2_.width / 2;
            this._loader.y = -_loc2_.height / 2;
         }
      }
      
      protected function handleImageFailed(param1:Event) : void
      {
      }
   }
}
