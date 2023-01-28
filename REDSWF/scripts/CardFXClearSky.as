package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXClearSky extends CardFX
   {
       
      
      public function CardFXClearSky()
      {
         super();
         addFrameScript(71,this.frame72);
      }
      
      internal function frame72() : *
      {
         stop();
         fxEnded();
      }
   }
}
