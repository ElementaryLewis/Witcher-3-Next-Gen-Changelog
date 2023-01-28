package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class GEM_28 extends MovieClip
   {
       
      
      public var breakfx:MovieClip;
      
      public function GEM_28()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,18,this.frame19);
      }
      
      internal function frame1() : *
      {
         this.breakfx.gotoAndStop("stop");
         stop();
      }
      
      internal function frame2() : *
      {
         this.breakfx.gotoAndPlay("play");
      }
      
      internal function frame19() : *
      {
         stop();
      }
   }
}
