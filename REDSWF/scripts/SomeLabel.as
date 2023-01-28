package
{
   import red.game.witcher3.controls.Label;
   
   public dynamic class SomeLabel extends Label
   {
       
      
      public function SomeLabel()
      {
         super();
         addFrameScript(8,this.frame9,18,this.frame19,28,this.frame29);
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame19() : *
      {
         stop();
      }
      
      internal function frame29() : *
      {
         stop();
      }
   }
}
