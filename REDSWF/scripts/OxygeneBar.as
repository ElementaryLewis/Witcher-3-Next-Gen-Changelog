package
{
   import red.game.witcher3.hud.modules.statbars.HudStatBar;
   
   public dynamic class OxygeneBar extends HudStatBar
   {
       
      
      public function OxygeneBar()
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
