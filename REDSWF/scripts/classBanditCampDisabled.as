package
{
   import flash.display.MovieClip;
   
   public dynamic class classBanditCampDisabled extends MovieClip
   {
       
      
      public function classBanditCampDisabled()
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
