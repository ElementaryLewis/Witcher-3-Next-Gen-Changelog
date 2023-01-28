package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.controls.UILoader;
   
   public class BookItemRenderer extends ListItemRenderer
   {
       
      
      public var mcNewIcon:MovieClip;
      
      public var mcQuest:MovieClip;
      
      public var mcSelection:MovieClip;
      
      protected var _imageLoader:UILoader;
      
      public function BookItemRenderer()
      {
         super();
         this.mcSelection.visible = false;
         this.mcNewIcon.visible = false;
         this.mcQuest.visible = false;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.mcSelection.visible = selected;
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            visible = false;
            return;
         }
         visible = true;
         if(this._imageLoader)
         {
            this._imageLoader.y = -10;
            this._imageLoader.unload();
            removeChild(this._imageLoader);
            this._imageLoader = null;
         }
         if(param1.iconPath)
         {
            this._imageLoader = new UILoader();
            this._imageLoader.source = param1.iconPath;
            addChild(this._imageLoader);
         }
         if(param1.isQuestItem)
         {
            this.mcQuest.visible = true;
            this.mcQuest.gotoAndStop(param1.questTag);
         }
         else
         {
            this.mcQuest.visible = false;
         }
         this.mcNewIcon.visible = param1.isNewItem;
         addChild(this.mcQuest);
         addChild(this.mcNewIcon);
      }
   }
}
