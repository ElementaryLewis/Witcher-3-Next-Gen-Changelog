package
{
   import flash.display.MovieClip;
   
   public dynamic class classMonsterHunt extends MovieClip
   {
       
      
      public function classMonsterHunt()
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
