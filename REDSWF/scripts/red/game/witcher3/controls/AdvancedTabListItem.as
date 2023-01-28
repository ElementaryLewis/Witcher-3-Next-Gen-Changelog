package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class AdvancedTabListItem extends TabListItem
   {
       
      
      public var mcText:TextField;
      
      public var mcSelectedHighlight:MovieClip;
      
      public var mcOpened:MovieClip;
      
      public var mcHasNewIcon:MovieClip;
      
      public var txtLabel:W3TextArea;
      
      public var mcNew:MovieClip;
      
      protected var _selectionVisible:Boolean = true;
      
      protected var isOpen:Boolean = false;
      
      public function AdvancedTabListItem()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcOpened)
         {
            this.mcOpened.visible = false;
         }
         if(this.mcHasNewIcon)
         {
            this.mcHasNewIcon.visible = false;
         }
         if(this.mcNew)
         {
            this.mcNew.visible = false;
         }
      }
      
      public function setNewFlag(param1:Boolean) : void
      {
         if(this.mcNew)
         {
            this.mcNew.visible = param1;
         }
      }
      
      public function hasNewFlag() : Boolean
      {
         if(Boolean(this.mcNew) && this.mcNew.visible)
         {
            return true;
         }
         return false;
      }
      
      public function set selectionVisible(param1:Boolean) : void
      {
         this._selectionVisible = param1;
         if(this.mcSelectedHighlight)
         {
            if(!this.isOpen)
            {
               this.mcSelectedHighlight.visible = param1;
            }
         }
      }
      
      override public function setIsOpen(param1:Boolean) : void
      {
         this.isOpen = param1;
         if(this.mcOpened)
         {
            this.mcOpened.visible = param1;
         }
         if(Boolean(this.mcSelectedHighlight) && this._selectionVisible)
         {
            this.mcSelectedHighlight.visible = !param1;
         }
      }
      
      public function set hasNewIcon(param1:Boolean) : void
      {
         if(this.mcHasNewIcon)
         {
            this.mcHasNewIcon.visible = param1;
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(this.mcOpened)
         {
            this.mcOpened.visible = this.isOpen;
         }
         if(this.mcSelectedHighlight)
         {
            if(!this._selectionVisible)
            {
               this.mcSelectedHighlight.visible = false;
            }
            else
            {
               this.mcSelectedHighlight.visible = !this.isOpen;
            }
         }
      }
      
      public function setLabel(param1:String) : void
      {
         if(this.txtLabel)
         {
            this.txtLabel.text = param1;
         }
      }
      
      public function setText(param1:String) : void
      {
         if(this.mcText)
         {
            this.mcText.text = param1;
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(this.mcOpened && param1 && Boolean(param1.icon))
         {
            this.mcOpened.gotoAndStop(param1.icon);
         }
      }
   }
}
