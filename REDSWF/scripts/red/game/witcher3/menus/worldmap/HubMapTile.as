package red.game.witcher3.menus.worldmap
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.GlowFilter;
   
   public class HubMapTile
   {
       
      
      internal var _filename:String;
      
      internal var _tileX:int;
      
      internal var _tileY:int;
      
      internal var _shiftX:Number;
      
      internal var _shiftY:Number;
      
      internal var _tileScale:Number;
      
      internal var _fixedTileScale:Number;
      
      internal var _container:MovieClip;
      
      internal var _isLoading:Boolean = false;
      
      internal var _loader:HubMapTileLoader;
      
      public function HubMapTile(param1:String, param2:int, param3:int, param4:Number, param5:Number, param6:Number, param7:MovieClip)
      {
         super();
         this._filename = param1;
         this._tileX = param2;
         this._tileY = param3;
         this._shiftX = param4;
         this._shiftY = param5;
         this._tileScale = param6;
         this._fixedTileScale = this._tileScale;
         this._container = param7;
         this._loader = new HubMapTileLoader();
         this._loader.x -= this._shiftX;
         this._loader.y -= this._shiftY;
         this._loader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleImageFailed,false,0,true);
      }
      
      public function ShowTile(param1:Boolean) : *
      {
         if(!this._loader)
         {
            return;
         }
         if(param1)
         {
            if(this._loader.source != this._filename)
            {
               this._isLoading = true;
               this._loader.source = this._filename;
               this._container.addChild(this._loader);
            }
         }
         else if(this._loader.source)
         {
            this._container.removeChild(this._loader);
            this._loader.source = null;
         }
      }
      
      public function IsLoader() : Boolean
      {
         return this._loader != null;
      }
      
      protected function handleImageLoaded(param1:Event) : void
      {
         this._isLoading = false;
         var _loc2_:Bitmap = Bitmap(param1.target.content);
         if(_loc2_)
         {
            _loc2_.smoothing = true;
            _loc2_.pixelSnapping = PixelSnapping.ALWAYS;
            _loc2_.scaleX /= this._fixedTileScale;
            _loc2_.scaleY /= this._fixedTileScale;
         }
      }
      
      protected function handleImageFailed(param1:Event) : void
      {
         this._isLoading = false;
      }
      
      public function UpdateDebugBorders() : *
      {
         if(MapMenu.m_showDebugBorders)
         {
            this._loader.filters = [new GlowFilter(16711680,1,6,6,2,1,true)];
         }
         else
         {
            this._loader.filters = [];
         }
      }
   }
}
