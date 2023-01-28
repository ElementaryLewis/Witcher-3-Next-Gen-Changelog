package
{
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   
   public dynamic class W3StatusIndicator extends W3StatIndicator
   {
       
      
      public function W3StatusIndicator()
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
