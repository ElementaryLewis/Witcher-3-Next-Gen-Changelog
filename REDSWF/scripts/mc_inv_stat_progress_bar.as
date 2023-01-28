package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class mc_inv_stat_progress_bar extends StatusIndicator
   {
       
      
      public function mc_inv_stat_progress_bar()
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
