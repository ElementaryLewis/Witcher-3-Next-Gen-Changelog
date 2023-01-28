package
{
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   
   public dynamic class BackgroundHealthIndicator extends W3StatIndicator
   {
       
      
      public function BackgroundHealthIndicator()
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
