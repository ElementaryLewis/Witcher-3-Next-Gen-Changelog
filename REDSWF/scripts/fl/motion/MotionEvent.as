package fl.motion
{
   import flash.events.Event;
   
   public class MotionEvent extends Event
   {
      
      public static const MOTION_START:String = "motionStart";
      
      public static const MOTION_END:String = "motionEnd";
      
      public static const MOTION_UPDATE:String = "motionUpdate";
      
      public static const TIME_CHANGE:String = "timeChange";
       
      
      public function MotionEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new MotionEvent(this.type,this.bubbles,this.cancelable);
      }
   }
}
