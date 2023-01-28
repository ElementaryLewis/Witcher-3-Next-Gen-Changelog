package red.game.witcher3.menus.preparation_menu
{
   import flash.display.Bitmap;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import red.game.witcher3.controls.InvisibleComponent;
   import red.game.witcher3.controls.W3UILoaderSlot;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   
   public class TrackedMonsterInfo extends UIComponent
   {
       
      
      public var mcScrollbar:ScrollBar;
      
      public var txtDescription:W3TextArea;
      
      public var mcBgImageGuide:InvisibleComponent;
      
      protected var _imageLoader:W3UILoaderSlot;
      
      public function TrackedMonsterInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function setupMonsterInfo(data:Object) : void
      {
         if(!data)
         {
            return;
         }
         if(data.trackType == 0)
         {
            visible = false;
            this.unloadIcon();
         }
         else
         {
            visible = true;
            this.setupIconImage("textures/journal/bestiary/" + data.bgImgPath);
            this.txtDescription.htmlText = data.txtDesc;
         }
      }
      
      protected function setupIconImage(iconPath:String) : void
      {
         this.unloadIcon();
         this._imageLoader = new W3UILoaderSlot();
         this._imageLoader.maintainAspectRatio = false;
         this._imageLoader.autoSize = false;
         this._imageLoader.addEventListener(Event.COMPLETE,this.handleIconLoaded,false,0,true);
         this._imageLoader.source = "img://" + iconPath;
         this._imageLoader.mouseChildren = false;
         this._imageLoader.mouseEnabled = false;
         addChildAt(this._imageLoader,this.numChildren);
         this._imageLoader.x = this.mcBgImageGuide.x;
         this._imageLoader.y = this.mcBgImageGuide.y;
         addChild(this.mcScrollbar);
         addChild(this.txtDescription);
      }
      
      protected function unloadIcon() : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleIconLoaded);
            removeChild(this._imageLoader);
            this._imageLoader = null;
         }
      }
      
      protected function handleIconLoaded(event:Event) : void
      {
         var image:Bitmap = Bitmap(event.target.content);
         if(image)
         {
            image.smoothing = true;
            image.pixelSnapping = PixelSnapping.NEVER;
         }
      }
   }
}
