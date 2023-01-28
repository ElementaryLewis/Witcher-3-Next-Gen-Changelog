package red.game.witcher3.menus.mainmenu
{
   import flash.text.TextField;
   import red.game.witcher3.controls.BaseListItem;
   
   public class KeybindItemRenderer extends BaseListItem
   {
       
      
      public var txtKeybind:TextField;
      
      public var isReset:Boolean;
      
      public function KeybindItemRenderer()
      {
         super();
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
         }
         else
         {
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
