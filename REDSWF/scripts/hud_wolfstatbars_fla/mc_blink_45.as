package hud_wolfstatbars_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_blink_45 extends MovieClip
   {
       
      
      public function mc_blink_45()
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
