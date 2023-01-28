package panel_preparation_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_PreloaderAnim_3 extends MovieClip
   {
       
      
      public function mc_PreloaderAnim_3()
      {
         super();
         addFrameScript(19,this.frame20);
      }
      
      internal function frame20() : *
      {
         gotoAndPlay("StartAnim");
      }
   }
}
