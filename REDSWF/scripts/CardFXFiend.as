package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXFiend extends CardFX
   {
       
      
      public function CardFXFiend()
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
