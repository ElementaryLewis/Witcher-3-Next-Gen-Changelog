package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   
   public class ItemDragEvent extends Event
   {
      
      public static const START_DRAG:String = "startDrag";
      
      public static const STOP_DRAG:String = "stopDrag";
       
      
      public var targetItem:IDragTarget;
      
      public var targetRecepient:IDropTarget;
      
      public var success:Boolean;
      
      public function ItemDragEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:IDragTarget = null, param5:Boolean = false)
      {
         super(param1,param2,param3);
         this.targetItem = param4;
         this.success = param5;
      }
      
      override public function clone() : Event
      {
         return new ItemDragEvent(type,bubbles,cancelable,this.targetItem);
      }
      
      override public function toString() : String
      {
         return formatToString("ItemDragEvent","type","bubbles","cancelable","tooltipData");
      }
   }
}
