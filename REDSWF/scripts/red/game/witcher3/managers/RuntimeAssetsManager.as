package red.game.witcher3.managers
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import scaleform.gfx.Extensions;
   
   public class RuntimeAssetsManager extends EventDispatcher
   {
      
      private static const GAME_ASSETS_LIB_PATH:String = "swf/common/ComponentsLib.swf";
      
      private static const DEBUG_ASSETS_LIB_PATH:String = "../common/ComponentsLib.swf";
      
      private static var _instance:RuntimeAssetsManager;
       
      
      private var _isLoaded:Boolean;
      
      private var _isLoading:Boolean;
      
      private var _loader:Loader;
      
      private var _loadCallback:Function;
      
      public function RuntimeAssetsManager()
      {
         super();
         this._isLoading = false;
         this._isLoaded = false;
      }
      
      public static function getInstanse() : RuntimeAssetsManager
      {
         if(!_instance)
         {
            _instance = new RuntimeAssetsManager();
         }
         return _instance;
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function set isLoaded(param1:Boolean) : void
      {
      }
      
      public function loadLibrary(param1:Function = null) : void
      {
         this._loadCallback = param1;
         if(this._isLoading)
         {
            return;
         }
         if(this._isLoaded)
         {
            this.tryCallback();
         }
         else
         {
            this.loadAssets();
         }
      }
      
      public function unloadLibrary() : void
      {
         if(this._loader)
         {
            this._loader.unloadAndStop(true);
            this._loader = null;
            this._isLoaded = false;
            this._isLoading = false;
         }
      }
      
      public function getAsset(param1:String) : DisplayObject
      {
         var DisplayItemClass:Class = null;
         var DisplayItem:DisplayObject = null;
         var assetDefinition:String = param1;
         if(!this._isLoaded)
         {
            throw new Error("RuntimeAssetsManager is not loaded!");
         }
         try
         {
            DisplayItemClass = this._loader.contentLoaderInfo.applicationDomain.getDefinition(assetDefinition) as Class;
            DisplayItem = new DisplayItemClass() as DisplayObject;
            if(DisplayItem)
            {
               return DisplayItem;
            }
            return new Bitmap(new DisplayItemClass());
         }
         catch(err:Error)
         {
            return null;
         }
      }
      
      protected function tryCallback() : void
      {
         if(this._loadCallback != null)
         {
            this._loadCallback();
         }
      }
      
      protected function loadAssets() : void
      {
         var _loc1_:String = Extensions.isScaleform ? GAME_ASSETS_LIB_PATH : DEBUG_ASSETS_LIB_PATH;
         var _loc2_:LoaderContext = new LoaderContext();
         var _loc3_:ApplicationDomain = ApplicationDomain.currentDomain;
         _loc2_.applicationDomain = _loc3_;
         this._loader = new Loader();
         this._loader.load(new URLRequest(_loc1_),_loc2_);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleAssetsLoaded,false,0,true);
         this._isLoading = true;
      }
      
      protected function handleAssetsLoaded(param1:Event) : void
      {
         this._isLoaded = true;
         this._isLoading = false;
         this._loadCallback = null;
         this.tryCallback();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
