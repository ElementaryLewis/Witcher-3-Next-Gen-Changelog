package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   
   public class CategoryChangeEvent extends Event
   {
      
      public static const CATEGORY_CHANGED:String = "category_changed";
       
      
      public var categoryIdx:int;
      
      public var categoryItemRenderer:W3DropdownMenuListItem;
      
      public function CategoryChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1)
      {
         this.categoryIdx = param4;
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new CategoryChangeEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("CategoryChangeEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
