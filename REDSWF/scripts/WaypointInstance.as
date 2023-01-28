package
{
   import red.game.witcher3.hud.modules.minimap2.WaypointInstance;
   
   public dynamic class WaypointInstance extends red.game.witcher3.hud.modules.minimap2.WaypointInstance
   {
       
      
      public function WaypointInstance()
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
