package
{
   import red.game.witcher3.hud.modules.iteminfo.HudItemInfo;
   
   public dynamic class ExtendedItemInfo extends HudItemInfo
   {
       
      
      public function ExtendedItemInfo()
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
