package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXHorn extends CardFX
   {
       
      
      public function CardFXHorn()
      {
         super();
         addFrameScript(44,this.frame45);
      }
      
      internal function frame45() : *
      {
         stop();
         fxEnded();
      }
   }
}
