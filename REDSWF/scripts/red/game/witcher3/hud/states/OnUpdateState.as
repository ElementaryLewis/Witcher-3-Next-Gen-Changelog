package red.game.witcher3.hud.states
{
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.modules.HudModuleBase;
   
   public class OnUpdateState extends BaseState
   {
       
      
      public function OnUpdateState(param1:HudModuleBase)
      {
         super(param1);
      }
      
      override public function enter() : void
      {
         ownerModule.ShowElementFromState(false,false);
         ownerModule.addEventListener(GameEvent.UPDATE,ownerModule.OnUpdate,false,0,true);
      }
      
      override public function exit() : void
      {
         ownerModule.removeEventListener(GameEvent.UPDATE,ownerModule.OnUpdate,false);
         ownerModule.RemoveUpdateTimer();
      }
   }
}
