package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXRain extends CardFX
   {
       
      
      public function CardFXRain()
      {
         super();
         addFrameScript(39,this.frame40);
      }
      
      internal function frame40() : *
      {
         stop();
         fxEnded();
      }
   }
}
