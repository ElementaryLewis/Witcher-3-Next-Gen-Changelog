package red.game.witcher3.menus.common_menu
{
   import flash.events.Event;
   import flash.text.TextField;
   import red.game.witcher3.controls.W3UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class NewItemInfo extends UIComponent
   {
       
      
      public var mcLoader:W3UILoader;
      
      public var tfItemName:TextField;
      
      public var tfItemType:TextField;
      
      private var _gap:Number;
      
      public function NewItemInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         visible = false;
         this._gap = 10;
         super.configUI();
         this.mcLoader.addEventListener(Event.COMPLETE,this.handleComplete,false,0,true);
      }
      
      public function SetItemIcon(param1:String) : void
      {
         this.mcLoader.source = "img://" + param1;
      }
      
      public function SetItemName(param1:String) : void
      {
         this.tfItemName.htmlText = param1;
      }
      
      public function handleComplete(param1:Event) : void
      {
         if(this.tfItemName.textHeight < this.mcLoader.content.height)
         {
            this.tfItemName.y = this.mcLoader.y + this.mcLoader.content.height / 2 - this.tfItemName.textHeight / 2;
         }
         else
         {
            this.tfItemName.y = this.mcLoader.y;
         }
      }
      
      public function SetItemType(param1:String) : void
      {
      }
   }
}
