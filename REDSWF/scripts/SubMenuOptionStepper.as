package
{
   import red.game.witcher3.controls.W3OptionStepper;
   
   public dynamic class SubMenuOptionStepper extends W3OptionStepper
   {
       
      
      public function SubMenuOptionStepper()
      {
         super();
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30);
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
   }
}
