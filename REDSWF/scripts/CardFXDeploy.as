package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXDeploy extends CardFX
   {
       
      
      public function CardFXDeploy()
      {
         super();
         addFrameScript(18,this.frame19);
      }
      
      internal function frame19() : *
      {
         stop();
         fxEnded();
      }
   }
}
