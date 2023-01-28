package
{
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   
   public dynamic class ToxicityStatusIndicator extends W3StatIndicator
   {
       
      
      public function ToxicityStatusIndicator()
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
