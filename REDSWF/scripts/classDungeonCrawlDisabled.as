package
{
   import flash.display.MovieClip;
   
   public dynamic class classDungeonCrawlDisabled extends MovieClip
   {
       
      
      public function classDungeonCrawlDisabled()
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
