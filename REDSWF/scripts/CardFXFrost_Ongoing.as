package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXFrost_Ongoing extends CardFX
   {
       
      
      public function CardFXFrost_Ongoing()
      {
         super();
         addFrameScript(0,this.frame1,55,this.frame56,65,this.frame66);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame56() : *
      {
         gotoAndPlay("loop");
      }
      
      internal function frame66() : *
      {
         gotoAndStop("idle");
      }
   }
}
