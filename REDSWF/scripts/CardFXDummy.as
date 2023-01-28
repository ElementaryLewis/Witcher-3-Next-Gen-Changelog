package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXDummy extends CardFX
   {
       
      
      public function CardFXDummy()
      {
         super();
         addFrameScript(49,this.frame50);
      }
      
      internal function frame50() : *
      {
         stop();
         fxEnded();
      }
   }
}
