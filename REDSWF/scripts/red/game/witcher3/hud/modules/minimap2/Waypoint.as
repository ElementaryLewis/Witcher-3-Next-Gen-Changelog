package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   
   public class Waypoint
   {
       
      
      public var pinClip:MovieClip;
      
      private var isVisible:Boolean = false;
      
      public function Waypoint()
      {
         super();
      }
      
      public function ForceShow(param1:Boolean) : *
      {
         this.pinClip.visible = param1;
         this.isVisible = param1;
      }
      
      public function Show(param1:Boolean) : *
      {
         if(this.isVisible != param1)
         {
            this.pinClip.visible = param1;
            this.isVisible = param1;
         }
      }
      
      public function SetScale(param1:Number) : *
      {
         if(this.pinClip.mcWaypoint)
         {
            this.pinClip.mcWaypoint.scaleX = param1;
            this.pinClip.mcWaypoint.scaleY = param1;
         }
      }
      
      public function SetPosition(param1:Number, param2:Number) : *
      {
         this.pinClip.x = param1;
         this.pinClip.y = param2;
      }
   }
}
