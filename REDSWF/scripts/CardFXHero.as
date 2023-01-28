package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXHero extends CardFX
   {
       
      
      public function CardFXHero()
      {
         super();
         addFrameScript(59,this.frame60);
      }
      
      internal function frame60() : *
      {
         stop();
         fxEnded();
      }
   }
}
