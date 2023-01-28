package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   
   public class HudModuleTest extends HudModuleBase
   {
       
      
      public function HudModuleTest()
      {
         super();
      }
      
      override public function get moduleName() : String
      {
         return "TestModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         x = 470.55;
         y = 55.05;
         z = 100;
         scaleX = 0.75;
         scaleY = 0.75;
         visible = false;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
   }
}
