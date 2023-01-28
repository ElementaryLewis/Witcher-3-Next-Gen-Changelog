package
{
   import red.game.witcher3.menus.inventory.InventorySlotOverlay;
   
   public dynamic class PaperdollBigSlot_OverlaysRef extends InventorySlotOverlay
   {
       
      
      public function PaperdollBigSlot_OverlaysRef()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
   }
}
