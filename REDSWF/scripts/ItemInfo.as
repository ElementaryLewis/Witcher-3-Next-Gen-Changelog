package
{
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuSelectedInfo;
   
   public dynamic class ItemInfo extends RadialMenuSelectedInfo
   {
       
      
      public function ItemInfo()
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
