package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXRain_Ongoing extends CardFX
   {
       
      
      public function CardFXRain_Ongoing()
      {
         super();
         addFrameScript(0,this.frame1,58,this.frame59,68,this.frame69);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame59() : *
      {
         gotoAndPlay("loop");
      }
      
      internal function frame69() : *
      {
         gotoAndStop("idle");
      }
   }
}
