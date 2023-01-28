package
{
   import red.game.witcher3.hud.modules.wolfHead.StaminaIndicator;
   
   public dynamic class StaminaStatusIndicator extends StaminaIndicator
   {
       
      
      public function StaminaStatusIndicator()
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
