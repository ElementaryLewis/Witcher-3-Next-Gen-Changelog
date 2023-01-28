package red.game.witcher3.events
{
   import flash.events.Event;
   
   public class ControllerChangeEvent extends Event
   {
      
      public static const CONTROLLER_CHANGE:String = "controller_change";
       
      
      public var isGamepad:Boolean;
      
      public var platformType:uint;
      
      public function ControllerChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param2,param3);
         this.isGamepad = param4;
      }
      
      override public function clone() : Event
      {
         return new ControllerChangeEvent(type,bubbles,cancelable,this.isGamepad);
      }
   }
}
