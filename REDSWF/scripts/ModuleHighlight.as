package
{
   import red.game.witcher3.controls.ModuleHighlighting;
   
   public dynamic class ModuleHighlight extends ModuleHighlighting
   {
       
      
      public function ModuleHighlight()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,10,this.frame11);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         stop();
      }
   }
}
