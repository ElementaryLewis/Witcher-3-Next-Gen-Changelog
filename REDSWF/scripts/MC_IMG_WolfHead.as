package
{
   import red.game.witcher3.hud.modules.wolfHead.WolfMedallion;
   
   public dynamic class MC_IMG_WolfHead extends WolfMedallion
   {
       
      
      public function MC_IMG_WolfHead()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
   }
}
