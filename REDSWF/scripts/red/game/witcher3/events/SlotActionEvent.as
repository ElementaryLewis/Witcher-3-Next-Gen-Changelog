package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.interfaces.IBaseSlot;
   
   public class SlotActionEvent extends Event
   {
      
      public static const EVENT_ACTIVATE:String = "event_activate";
      
      public static const EVENT_SECONDARY_ACTION:String = "event_secondary_action";
      
      public static const EVENT_SELECT:String = "event_select";
       
      
      public var actionType:int;
      
      public var targetSlot:IBaseSlot;
      
      public var data:Object;
      
      public var isMouseEvent:Boolean = false;
      
      public function SlotActionEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = 0, param5:IBaseSlot = null)
      {
         super(param1,param2,param3);
         this.actionType = param4;
         this.targetSlot = param5;
      }
      
      override public function clone() : Event
      {
         return new SlotActionEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SlotActionEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
