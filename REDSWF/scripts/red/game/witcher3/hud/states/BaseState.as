package red.game.witcher3.hud.states
{
   import red.game.witcher3.hud.modules.HudModuleBase;
   
   public class BaseState
   {
       
      
      protected var ownerModule:HudModuleBase;
      
      public function BaseState(param1:HudModuleBase)
      {
         super();
         this.ownerModule = param1;
      }
      
      public function enter() : void
      {
      }
      
      public function exit() : void
      {
      }
      
      public function ShowElement(param1:Boolean, param2:Boolean = false) : void
      {
      }
   }
}
