package
{
   import red.game.witcher3.menus.gwint.CardSlot;
   
   public dynamic class CardSlotRef extends CardSlot
   {
       
      
      public function CardSlotRef()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14,14,this.frame15,28,this.frame29);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         stop();
      }
      
      internal function frame15() : *
      {
         stop();
      }
      
      internal function frame29() : *
      {
         stop();
      }
   }
}
