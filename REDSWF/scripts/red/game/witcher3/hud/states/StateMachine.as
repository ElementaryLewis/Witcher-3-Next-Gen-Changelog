package red.game.witcher3.hud.states
{
   public class StateMachine
   {
       
      
      public var current:String;
      
      public var previous:String;
      
      private var states:Object;
      
      public function StateMachine()
      {
         super();
         this.states = new Object();
      }
      
      public function getState() : String
      {
         return this.current;
      }
      
      public function setState(param1:String) : void
      {
         if(this.current == null)
         {
            this.current = param1;
            this.states[this.current].state.enter();
            return;
         }
         if(this.current == param1)
         {
            return;
         }
         this.states[this.current].state.exit();
         this.previous = this.current;
         this.current = param1;
         this.states[this.current].state.enter();
      }
      
      public function ShowElement(param1:Boolean, param2:Boolean = false) : void
      {
         this.states[this.current].state.ShowElement(param1,param2);
      }
      
      public function addState(param1:String, param2:BaseState, param3:Array) : void
      {
         this.states[param1] = {
            "state":param2,
            "from":param3.toString()
         };
      }
   }
}
