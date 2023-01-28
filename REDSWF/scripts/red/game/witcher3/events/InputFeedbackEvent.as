package red.game.witcher3.events
{
   import flash.events.Event;
   import scaleform.clik.events.InputEvent;
   
   public class InputFeedbackEvent extends Event
   {
      
      public static const USER_ACTION:String = "user_action";
       
      
      public var inputEventRef:InputEvent;
      
      public var actionId:int;
      
      public var messageId:int;
      
      public function InputFeedbackEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new InputFeedbackEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("InputFeedbackEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
