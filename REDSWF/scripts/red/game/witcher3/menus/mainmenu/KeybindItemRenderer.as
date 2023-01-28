package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.controls.BaseListItem;
   
   public class KeybindItemRenderer extends BaseListItem
   {
       
      
      public var txtKeybind:TextField;
      
      public var isReset:Boolean;
      
      public var mcLockedIcon:MovieClip;
      
      protected var _safetiesEnabled:Boolean = true;
      
      public function KeybindItemRenderer()
      {
         super();
      }
      
      public function set safetiesEnabled(param1:Boolean) : void
      {
         this._safetiesEnabled = param1;
         if(Boolean(data) && Boolean(data.locked))
         {
            this.mcLockedIcon.visible = this._safetiesEnabled || Boolean(data.permaLocked);
         }
         else
         {
            this.mcLockedIcon.visible = false;
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            if(param1.label == "resetToDefault")
            {
               label = "";
               this.isReset = true;
            }
            else
            {
               label = param1.label;
               this.isReset = false;
            }
            if(this.mcLockedIcon)
            {
               this.mcLockedIcon.visible = Boolean(param1.locked) && (this._safetiesEnabled || Boolean(param1.permaLocked));
            }
         }
         else
         {
            if(this.mcLockedIcon)
            {
               this.mcLockedIcon.visible = false;
            }
            label = "";
            this.isReset = false;
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(data)
         {
            this.txtKeybind.htmlText = data.value;
         }
         else
         {
            this.txtKeybind.htmlText = "";
         }
      }
   }
}
