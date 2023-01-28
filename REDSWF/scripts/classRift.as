package
{
   import flash.display.MovieClip;
   
   public dynamic class classRift extends MovieClip
   {
       
      
      public function classRift()
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
