package red.game.witcher3.menus.overlay
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.UILoader;
   
   public class PaintingPopup extends BasePopup
   {
       
      
      public var txtTitle:TextField;
      
      public var txtDescription:TextField;
      
      private var _imageLoader:UILoader;
      
      public function PaintingPopup()
      {
         super();
         _fixedPosition = true;
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            removeChild(this._imageLoader);
         }
         this._imageLoader = new UILoader();
         this._imageLoader.source = _data.ImagePath;
         this._imageLoader.addEventListener(Event.COMPLETE,this.handleIconLoaded,false,0,true);
         this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadIOError,false,0,true);
         addChild(this._imageLoader);
         visible = false;
      }
      
      private function handleIconLoaded(param1:Event) : void
      {
         var _loc2_:* = 5;
         this._imageLoader.x = -this._imageLoader.actualWidth / 2;
         this._imageLoader.y = this.txtTitle.y + this.txtTitle.textHeight + _loc2_;
         if(this.txtDescription.text)
         {
            this.txtDescription.visible = true;
            this.txtDescription.y = this._imageLoader.y + this._imageLoader.height + _loc2_;
            mcInpuFeedback.y = this.txtDescription.y + this.txtDescription.textHeight + _loc2_;
         }
         else
         {
            this.txtDescription.visible = false;
            mcInpuFeedback.y = this._imageLoader.y + this._imageLoader.actualHeight + _loc2_;
         }
         var _loc3_:Rectangle = CommonUtils.getScreenRect();
         x = _loc3_.x + _loc3_.width / 2;
         y = _loc3_.y + _loc3_.height / 2 - actualHeight / 2;
         visible = true;
      }
      
      private function handleLoadIOError(param1:Event) : void
      {
      }
   }
}
