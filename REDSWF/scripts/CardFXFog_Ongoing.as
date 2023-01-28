package
{
   import red.game.witcher3.menus.gwint.CardFX;
   
   public dynamic class CardFXFog_Ongoing extends CardFX
   {
       
      
      public function CardFXFog_Ongoing()
      {
         super();
         addFrameScript(0,this.frame1,54,this.frame55,64,this.frame65);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame55() : *
      {
         gotoAndPlay("loop");
      }
      
      internal function frame65() : *
      {
         gotoAndStop("idle");
      }
   }
}
