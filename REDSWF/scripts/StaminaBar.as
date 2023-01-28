package
{
   import red.game.witcher3.hud.modules.statbars.HudStatBarStamina;
   
   public dynamic class StaminaBar extends HudStatBarStamina
   {
       
      
      public function StaminaBar()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
