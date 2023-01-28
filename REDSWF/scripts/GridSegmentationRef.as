package
{
   import flash.display.MovieClip;
   
   public dynamic class GridSegmentationRef extends MovieClip
   {
       
      
      public function GridSegmentationRef()
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
