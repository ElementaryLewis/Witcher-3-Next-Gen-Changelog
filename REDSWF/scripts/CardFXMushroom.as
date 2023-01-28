package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXMushroom extends CardFX
   {
       
      
      public function CardFXMushroom()
      {
         super();
         addFrameScript(0,this.frame1,49,this.frame50);
      }
      
      internal function frame1() : *
      {
         midFXPoint();
      }
      
      internal function frame50() : *
      {
         stop();
         fxEnded();
      }
   }
}
