package red.game.witcher3.utils
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class FiniteStateMachine
   {
       
      
      private var stateList:Dictionary;
      
      private var currentStateName:String = "";
      
      private var nextState:String = "";
      
      private var prevStateName:String = "";
      
      private var updateTimer:Timer;
      
      private var disallowStateChangeFunc:Function;
      
      public function FiniteStateMachine()
      {
         super();
         this.stateList = new Dictionary();
         this.updateTimer = new Timer(20,0);
         this.updateTimer.addEventListener(TimerEvent.TIMER,this.updateStates);
         this.updateTimer.start();
      }
      
      public function get previousState() : String
      {
         return this.prevStateName;
      }
      
      public function get currentState() : String
      {
         return this.currentStateName;
      }
      
      public function set pauseOnStateChangeIfFunc(param1:Function) : void
      {
         this.disallowStateChangeFunc = param1;
      }
      
      public function get awaitingNextState() : Boolean
      {
         return this.currentStateName != this.nextState;
      }
      
      public function AddState(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:FSMState;
         (_loc5_ = new FSMState()).stateTag = param1;
         _loc5_.enterStateCallback = param2;
         _loc5_.updateStateCallback = param3;
         _loc5_.leaveStateCallback = param4;
         this.stateList[param1] = _loc5_;
         if(this.currentStateName == "" && this.nextState == "")
         {
            this.nextState = param1;
         }
      }
      
      public function ChangeState(param1:String) : void
      {
         if(this.stateList[this.nextState])
         {
            this.nextState = param1;
         }
      }
      
      public function ForceUpdateState() : void
      {
         this.updateStates();
      }
      
      private function updateStates(param1:TimerEvent = null) : void
      {
         if(this.nextState != this.currentStateName && this.disallowStateChangeFunc && this.disallowStateChangeFunc())
         {
            return;
         }
         if(this.nextState != this.currentStateName && this.stateList[this.nextState] != null)
         {
            if(Boolean(this.stateList[this.currentStateName]) && Boolean(this.stateList[this.currentStateName].leaveStateCallback))
            {
               this.stateList[this.currentStateName].leaveStateCallback();
            }
            this.prevStateName = this.currentStateName;
            this.currentStateName = this.nextState;
            if(Boolean(this.stateList[this.nextState]) && Boolean(this.stateList[this.nextState].enterStateCallback))
            {
               this.stateList[this.nextState].enterStateCallback();
            }
         }
         if(this.currentStateName == "")
         {
            return;
         }
         if(this.stateList[this.currentStateName].updateStateCallback)
         {
            this.stateList[this.currentStateName].updateStateCallback();
         }
         if(this.nextState != this.currentStateName && this.disallowStateChangeFunc && this.disallowStateChangeFunc())
         {
            return;
         }
         if(this.nextState != this.currentStateName && this.stateList[this.nextState] != null)
         {
            if(Boolean(this.stateList[this.currentStateName]) && Boolean(this.stateList[this.currentStateName].leaveStateCallback))
            {
               this.stateList[this.currentStateName].leaveStateCallback();
            }
            this.prevStateName = this.currentStateName;
            this.currentStateName = this.nextState;
            if(Boolean(this.stateList[this.nextState]) && Boolean(this.stateList[this.nextState].enterStateCallback))
            {
               this.stateList[this.nextState].enterStateCallback();
            }
         }
      }
   }
}
