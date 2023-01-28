package red.game.witcher3.events
{
   import flash.events.Event;
   
   public class SlotConnectorEvent extends Event
   {
      
      public static const EVENT_COMPLETE:String = "connector_complete";
       
      
      public var connectorColor:String;
      
      public function SlotConnectorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, connectorColor:* = "")
      {
         super(type,bubbles,cancelable);
         this.connectorColor = connectorColor;
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
