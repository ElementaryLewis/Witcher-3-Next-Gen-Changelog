package
{
   import red.game.witcher3.menus.infopopup.InformationPopup;
   
   public dynamic class MC_MODULE_INFO_POPUP extends InformationPopup
   {
       
      
      public function MC_MODULE_INFO_POPUP()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
