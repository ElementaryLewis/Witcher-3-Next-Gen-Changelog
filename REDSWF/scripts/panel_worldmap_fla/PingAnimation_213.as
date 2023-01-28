package panel_worldmap_fla
{
   import flash.display.MovieClip;
   
   public dynamic class PingAnimation_213 extends MovieClip
   {
       
      
      public var mcNewFeedback:MovieClip;
      
      public function PingAnimation_213()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
