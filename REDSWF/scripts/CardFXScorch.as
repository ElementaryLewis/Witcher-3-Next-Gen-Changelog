package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXScorch extends CardFX
   {
       
      
      public function CardFXScorch()
      {
         super();
         addFrameScript(42,this.frame43);
      }
      
      internal function frame43() : *
      {
         stop();
         fxEnded();
      }
   }
}
