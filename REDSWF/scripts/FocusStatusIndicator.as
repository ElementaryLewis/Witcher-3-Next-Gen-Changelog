package
{
   import red.game.witcher3.hud.modules.wolfHead.FocusIndicator;
   
   public dynamic class FocusStatusIndicator extends FocusIndicator
   {
       
      
      public function FocusStatusIndicator()
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
