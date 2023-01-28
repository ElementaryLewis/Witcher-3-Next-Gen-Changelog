package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXMorph extends CardFX
   {
       
      
      public function CardFXMorph()
      {
         super();
         addFrameScript(24,this.frame25,49,this.frame50);
      }
      
      internal function frame25() : *
      {
         midFXPoint();
      }
      
      internal function frame50() : *
      {
         stop();
         fxEnded();
      }
   }
}
