package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class MutationItem_progressbar extends StatusIndicator
   {
       
      
      public function MutationItem_progressbar()
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
