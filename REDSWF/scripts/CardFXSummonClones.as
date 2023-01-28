package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXSummonClones extends CardFX
   {
       
      
      public function CardFXSummonClones()
      {
         super();
         addFrameScript(39,this.frame40);
      }
      
      internal function frame40() : *
      {
         stop();
         fxEnded();
      }
   }
}
