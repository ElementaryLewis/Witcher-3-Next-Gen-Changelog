package red.game.witcher3.hud.modules.radialmenu
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class RadialMenuSubItemView extends UIComponent
   {
      
      protected static const OVER_GLOW_COLOR:Number = 11508592;
      
      protected static const OVER_GLOW_BLUR:Number = 20;
      
      protected static const OVER_GLOW_STRENGHT:Number = 0.75;
      
      protected static const OVER_GLOW_ALPHA:Number = 0.6;
       
      
      public var tfItemName:TextField;
      
      public var tfItemCounter:TextField;
      
      private var _imageLoader:UILoader;
      
      private var _itemName:String;
      
      private var _iconPath:String;
      
      private var _count:int;
      
      private var _idx:int;
      
      protected var _glowFilter:GlowFilter;
      
      public function RadialMenuSubItemView()
      {
         super();
         visible = false;
      }
      
      public function setData(param1:String, param2:String, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:* = new Namespace("");
         visible = false;
         this._itemName = param1;
         this._iconPath = param2;
         this._count = param4;
         this._idx = param3;
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleImageLoaded,false);
            this._imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadIOError,false);
            removeChild(this._imageLoader);
         }
         if(this._iconPath)
         {
            this._imageLoader = new UILoader();
            this._imageLoader.source = this._iconPath;
            this._imageLoader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
            this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadIOError,false,0,true);
            addChild(this._imageLoader);
         }
         else
         {
            this.handleLoadIOError();
         }
         this.tfItemName.htmlText = this._itemName;
         this.tfItemName.height = this.tfItemName.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(param3 >= 0 && param4 > 1)
         {
            _loc5_ = 5;
            this.tfItemCounter.text = " < " + param3 + "/" + this._count + " > ";
            this.tfItemCounter.visible = true;
            this.tfItemCounter.y = this.tfItemName.y + this.tfItemName.height - _loc5_;
         }
         else
         {
            this.tfItemCounter.visible = false;
         }
      }
      
      public function cleanup() : void
      {
         visible = false;
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         visible = true;
         this._imageLoader.x = -this._imageLoader.actualWidth / 2;
         this._imageLoader.y = -this._imageLoader.actualHeight / 2;
         this.tfItemName.y = this._imageLoader.y + this._imageLoader.height - 5;
         this.tfItemName.x = -this.tfItemName.width / 2;
      }
      
      private function handleLoadIOError(param1:Event = null) : void
      {
         visible = true;
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleImageLoaded,false);
            this._imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadIOError,false);
            removeChild(this._imageLoader);
         }
         this.tfItemName.y = 0;
         this.tfItemName.x = -this.tfItemName.width / 2;
      }
   }
}
