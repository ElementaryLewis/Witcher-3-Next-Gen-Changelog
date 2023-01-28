package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.clik.events.InputEvent;
   
   public class TabListItem extends BaseListItem
   {
       
      
      public var mcIcon:MovieClip;
      
      public var mcBck:MovieClip;
      
      public function TabListItem()
      {
         super();
      }
      
      public function GetLocKey() : String
      {
         return Boolean(data) && Boolean(data.locKey) ? String(data.locKey) : "";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         if(param1.enabled != null)
         {
            enabled = param1.enabled;
         }
         if(Boolean(this.mcIcon) && Boolean(param1.icon))
         {
            this.mcIcon.gotoAndStop(param1.icon);
         }
      }
      
      public function getIconData() : String
      {
         if(Boolean(data) && Boolean(data.icon))
         {
            return data.icon;
         }
         return "";
      }
      
      public function setIsOpen(param1:Boolean) : void
      {
      }
      
      override protected function updateAfterStateChange() : void
      {
         if(this.mcIcon)
         {
            stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
            if(data)
            {
               this.mcIcon.gotoAndStop(data.icon);
            }
         }
      }
      
      override public function gotoAndPlay(param1:Object, param2:String = null) : void
      {
         super.gotoAndStop(param1,param2);
      }
      
      public function GetCurrentWidth() : Number
      {
         return width + textField.textWidth;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
   }
}
