package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXMoraleBoost extends CardFX
   {
       
      
      public function CardFXMoraleBoost()
      {
         super();
         addFrameScript(29,this.frame30);
      }
      
      internal function frame30() : *
      {
         stop();
         fxEnded();
      }
   }
}
