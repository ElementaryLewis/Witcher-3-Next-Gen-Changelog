package red.game.witcher3.events
{
   import flash.events.Event;
   import red.game.witcher3.data.StaticMapPinData;
   
   public class MapContextEvent extends Event
   {
      
      public static const CONTEXT_CHANGE:String = "contextChange";
       
      
      public var tooltipData:Object;
      
      public var active:Boolean;
      
      public var mapppinData:StaticMapPinData;
      
      public function MapContextEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new MapContextEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("MapContextEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
