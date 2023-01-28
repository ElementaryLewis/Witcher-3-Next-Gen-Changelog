package
{
   import red.game.witcher3.menus.worldmap.MapCrosshair;
   
   public dynamic class mcCrosshair extends MapCrosshair
   {
       
      
      public function mcCrosshair()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,11,this.frame12);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         stop();
      }
   }
}
