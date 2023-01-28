package
{
   import red.game.witcher3.menus.mainmenu.PatchNotesPopup;
   
   public dynamic class PatchNotesPopupPC extends PatchNotesPopup
   {
       
      
      public function PatchNotesPopupPC()
      {
         super();
         addFrameScript(0,this.frame1,66,this.frame67);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame67() : *
      {
         stop();
      }
   }
}
