package red.game.witcher3.utils
{
   public class FSMState
   {
       
      
      public var stateTag:String;
      
      public var enterStateCallback:Function;
      
      public var updateStateCallback:Function;
      
      public var leaveStateCallback:Function;
      
      public function FSMState()
      {
         super();
      }
   }
}
