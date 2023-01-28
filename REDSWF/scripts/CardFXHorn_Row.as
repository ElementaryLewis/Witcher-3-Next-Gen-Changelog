package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXHorn_Row extends CardFX
   {
       
      
      public function CardFXHorn_Row()
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
