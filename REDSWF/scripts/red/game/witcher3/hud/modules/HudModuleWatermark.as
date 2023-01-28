package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   
   public class HudModuleWatermark extends HudModuleBase
   {
       
      
      public function HudModuleWatermark()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override public function get moduleName() : String
      {
         return "WatermarkModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = true;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
