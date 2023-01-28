package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   
   public class HudModuleBossFocus extends HudModuleBase
   {
       
      
      public var mcBossFocus:MovieClip;
      
      public function HudModuleBossFocus()
      {
         super();
      }
      
      override public function get moduleName() : String
      {
         return "BossFocusModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setBossName(param1:String) : *
      {
         this.mcBossFocus.tfBossName.text = param1;
      }
      
      public function setBossHealth(param1:int) : *
      {
         this.mcBossFocus.mcBossHealth.value = param1;
      }
      
      public function setEssenceDamage(param1:Boolean) : *
      {
         if(param1)
         {
            this.mcBossFocus.mcBossHealth.mcHealthBar.gotoAndStop("essence");
         }
         else
         {
            this.mcBossFocus.mcBossHealth.mcHealthBar.gotoAndStop("health");
         }
      }
   }
}
