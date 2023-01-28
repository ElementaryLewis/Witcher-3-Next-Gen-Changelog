package menuBase_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MC_VEC_NavigationTab_2 extends MovieClip
   {
       
      
      public function MC_VEC_NavigationTab_2()
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
