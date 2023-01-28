package
{
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuItemEquipped;
   
   public dynamic class RadialMenuItemRef extends RadialMenuItemEquipped
   {
       
      
      public function RadialMenuItemRef()
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
