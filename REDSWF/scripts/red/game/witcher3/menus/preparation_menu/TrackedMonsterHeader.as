package red.game.witcher3.menus.preparation_menu
{
   import flash.display.Bitmap;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.text.TextField;
   import red.game.witcher3.controls.InvisibleComponent;
   import red.game.witcher3.controls.W3UILoaderSlot;
   import scaleform.clik.core.UIComponent;
   
   public class TrackedMonsterHeader extends UIComponent
   {
       
      
      public var txtMonsterSource:TextField;
      
      public var txtMonsterName:TextField;
      
      public var mcImageLoaderPos:InvisibleComponent;
      
      protected var _imageLoader:W3UILoaderSlot;
      
      public function TrackedMonsterHeader()
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
            this.txtMonsterName.visible = false;
         }
         else
         {
            this.txtMonsterName.visible = true;
            this.txtMonsterName.text = data.monsterName;
         }
         this.txtMonsterSource.text = data.trackTypeStr;
         this.setupIconImage(data.monsterIconPath);
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
         addChild(this._imageLoader);
         this._imageLoader.x = this.mcImageLoaderPos.x;
         this._imageLoader.y = this.mcImageLoaderPos.y;
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
