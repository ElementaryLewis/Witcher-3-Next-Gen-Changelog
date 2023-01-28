package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXSummonClonesArrive extends CardFX
   {
       
      
      public function CardFXSummonClonesArrive()
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
