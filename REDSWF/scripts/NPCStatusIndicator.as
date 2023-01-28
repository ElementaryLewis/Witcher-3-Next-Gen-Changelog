package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class NPCStatusIndicator extends StatusIndicator
   {
       
      
      public function NPCStatusIndicator()
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
