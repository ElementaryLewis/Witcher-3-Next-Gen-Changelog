package hud_bossfocus_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MC_IMG_EnemyHealthBar_4 extends MovieClip
   {
       
      
      public function MC_IMG_EnemyHealthBar_4()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
