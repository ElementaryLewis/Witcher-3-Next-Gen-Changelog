package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import red.core.CoreComponent;
   
   public class InventoryStatsListItem extends W3StatisticsListItem
   {
       
      
      public var mcIcon:MovieClip;
      
      public function InventoryStatsListItem()
      {
         super();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            if(this.mcIcon)
            {
               this.mcIcon.gotoAndStop(param1.iconTag);
            }
            validateNow();
         }
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.htmlText = "<p align=\"right\">" + _label + "</p>";
               return;
            }
            textField.htmlText = _label;
         }
      }
   }
}
