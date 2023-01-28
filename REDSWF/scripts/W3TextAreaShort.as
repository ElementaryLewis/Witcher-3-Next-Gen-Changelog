package
{
   import red.game.witcher3.controls.W3TextArea;
   
   public dynamic class W3TextAreaShort extends W3TextArea
   {
       
      
      public function W3TextAreaShort()
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
