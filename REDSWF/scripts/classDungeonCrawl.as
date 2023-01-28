package
{
   import flash.display.MovieClip;
   
   public dynamic class classDungeonCrawl extends MovieClip
   {
       
      
      public function classDungeonCrawl()
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
