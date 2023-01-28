package
{
   import red.game.witcher3.menus.gwint.GwintDeckRenderer;
   
   public dynamic class DeckRenderer extends GwintDeckRenderer
   {
       
      
      public function DeckRenderer()
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
