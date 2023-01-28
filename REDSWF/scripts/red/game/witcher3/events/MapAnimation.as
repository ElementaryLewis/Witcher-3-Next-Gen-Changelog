package red.game.witcher3.events
{
   import flash.events.Event;
   
   public class MapAnimation extends Event
   {
      
      public static const COMPLETE_HIDE:String = "MapAnimation_COMPLETE_HIDE";
      
      public static const COMPLETE_SHOW:String = "MapAnimation_COMPLETE_SHOW";
      
      public static const AREA_CHANGED:String = "MapAnimation_AREA_CHANGED";
       
      
      public function MapAnimation(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new MapAnimation(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("MapAnimation","type","bubbles","cancelable","eventPhase");
      }
   }
}
