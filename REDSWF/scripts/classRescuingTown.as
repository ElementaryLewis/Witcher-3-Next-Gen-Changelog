package
{
   import flash.display.MovieClip;
   
   public dynamic class classRescuingTown extends MovieClip
   {
       
      
      public function classRescuingTown()
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
