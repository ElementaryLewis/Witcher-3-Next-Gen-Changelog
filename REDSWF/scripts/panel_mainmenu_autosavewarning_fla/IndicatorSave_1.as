package panel_mainmenu_autosavewarning_fla
{
   import flash.display.MovieClip;
   
   public dynamic class IndicatorSave_1 extends MovieClip
   {
       
      
      public function IndicatorSave_1()
      {
         super();
         addFrameScript(0,this.frame1,118,this.frame119,174,this.frame175);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame119() : *
      {
         gotoAndPlay("active");
      }
      
      internal function frame175() : *
      {
         gotoAndStop("inactive");
      }
   }
}
