package
{
   import red.game.witcher3.menus.worldmap.StaticMapPinDescribed;
   
   public dynamic class StaticMapPinBase extends StaticMapPinDescribed
   {
       
      
      public function StaticMapPinBase()
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
