package
{
   import flash.display.MovieClip;
   
   public dynamic class classHairdresser extends MovieClip
   {
       
      
      public function classHairdresser()
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
