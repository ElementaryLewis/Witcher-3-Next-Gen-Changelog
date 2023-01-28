package red.game.witcher3.hud.modules.journalupdate
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.InputFeedbackButton;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class QuestBookInfo extends UIComponent
   {
       
      
      private const BORDER_PADDING:Number = 20;
      
      private const BLOCK_PADDING:Number = 10;
      
      private const ICON_SIZE:Number = 64;
      
      public var mcBackground:MovieClip;
      
      public var tfItemName:TextField;
      
      public var btnActivate:InputFeedbackButton;
      
      private var _imageLoader:UILoader;
      
      private var _data:Object;
      
      public function QuestBookInfo()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.populateData();
      }
      
      private function populateData() : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            this._imageLoader = null;
         }
         this.btnActivate.clickable = false;
         this.btnActivate.label = this._data.buttonLabel;
         this.btnActivate.setDataFromStage(this._data.gpadCode,this._data.keyCode);
         this._imageLoader = new UILoader();
         this._imageLoader.source = this._data.iconPath;
         this._imageLoader.x = this.BORDER_PADDING;
         this._imageLoader.y = this.BORDER_PADDING;
         this._imageLoader.width = this._imageLoader.height = this.ICON_SIZE;
         addChild(this._imageLoader);
         this.tfItemName.text = this._data.itemName;
         this.tfItemName.width = this.tfItemName.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.tfItemName.x = this._imageLoader.x + this.ICON_SIZE + this.BLOCK_PADDING;
         this.tfItemName.y = this.BORDER_PADDING;
         this.btnActivate.x = this._imageLoader.x + this.ICON_SIZE + this.BLOCK_PADDING;
         this.mcBackground.width = Math.max(this.tfItemName.x + this.tfItemName.width,this.btnActivate.x + this.btnActivate.getViewWidth()) + this.BORDER_PADDING;
         this.mcBackground.height = this.ICON_SIZE + this.BLOCK_PADDING * 2 + this.BORDER_PADDING;
      }
   }
}
