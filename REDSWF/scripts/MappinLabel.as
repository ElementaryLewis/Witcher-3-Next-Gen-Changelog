package
{
   import scaleform.clik.controls.Label;
   
   public dynamic class MappinLabel extends Label
   {
       
      
      public function MappinLabel()
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
