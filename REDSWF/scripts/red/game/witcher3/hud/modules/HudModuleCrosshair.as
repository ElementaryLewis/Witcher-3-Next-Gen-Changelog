package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   
   public class HudModuleCrosshair extends HudModuleBase
   {
       
      
      public function HudModuleCrosshair()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override public function get moduleName() : String
      {
         return "CrosshairModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = true;
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
