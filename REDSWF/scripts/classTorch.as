package
{
   import flash.display.MovieClip;
   
   public dynamic class classTorch extends MovieClip
   {
       
      
      public function classTorch()
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
