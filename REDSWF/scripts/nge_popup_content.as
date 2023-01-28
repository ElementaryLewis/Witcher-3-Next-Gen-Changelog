package
{
   import red.game.witcher3.menus.mainmenu.PatchNotesPopup;
   
   public dynamic class nge_popup_content extends PatchNotesPopup
   {
       
      
      public function nge_popup_content()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
