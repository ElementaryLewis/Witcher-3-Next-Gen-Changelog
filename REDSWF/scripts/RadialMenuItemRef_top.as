package
{
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuItem;
   
   public dynamic class RadialMenuItemRef_top extends RadialMenuItem
   {
       
      
      public function RadialMenuItemRef_top()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
   }
}
