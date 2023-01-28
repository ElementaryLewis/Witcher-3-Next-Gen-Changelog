package
{
   import flash.display.MovieClip;
   
   public dynamic class classSpoilsOfWarDisabled extends MovieClip
   {
       
      
      public function classSpoilsOfWarDisabled()
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
