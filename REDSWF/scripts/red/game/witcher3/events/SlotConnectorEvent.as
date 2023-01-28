package red.game.witcher3.events
{
   import flash.events.Event;
   
   public class SlotConnectorEvent extends Event
   {
      
      public static const EVENT_COMPLETE:String = "connector_complete";
       
      
      public var connectorColor:String;
      
      public function SlotConnectorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:* = "")
      {
         super(param1,param2,param3);
         this.connectorColor = param4;
      }
      
      override public function clone() : Event
      {
         return new SlotConnectorEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SlotConnectorEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
