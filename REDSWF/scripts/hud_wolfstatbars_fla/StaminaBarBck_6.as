package hud_wolfstatbars_fla
{
   import flash.display.MovieClip;
   
   public dynamic class StaminaBarBck_6 extends MovieClip
   {
       
      
      public function StaminaBarBck_6()
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
