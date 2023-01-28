package red.game.witcher3.hud.states
{
   import red.game.witcher3.hud.modules.HudModuleBase;
   
   public class OnDemandState extends BaseState
   {
       
      
      public function OnDemandState(param1:HudModuleBase)
      {
         super(param1);
      }
      
      override public function enter() : void
      {
         var _loc1_:Boolean = ownerModule.GetSavedShowState();
         ownerModule.ShowElementFromState(_loc1_,false);
      }
      
      override public function ShowElement(param1:Boolean, param2:Boolean = false) : void
      {
         ownerModule.ShowElementFromState(param1,param2);
         ownerModule.SaveShowState(param1);
      }
   }
}
