package red.game.witcher3.hud.states
{
   import red.game.witcher3.hud.modules.HudModuleBase;
   
   public class ShowState extends BaseState
   {
       
      
      public function ShowState(param1:HudModuleBase)
      {
         super(param1);
      }
      
      override public function enter() : void
      {
         ownerModule.ShowElementFromState(true,false);
      }
      
      override public function ShowElement(param1:Boolean, param2:Boolean = false) : void
      {
         ownerModule.SaveShowState(param1);
      }
   }
}
