package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   
   public class HudModuleBoatHealth extends HudModuleBase
   {
       
      
      public var mcBoat:MovieClip;
      
      public function HudModuleBoatHealth()
      {
         super();
      }
      
      override public function get moduleName() : String
      {
         return "BoatHealthModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setVolumeHealth(param1:int, param2:Number) : *
      {
         switch(param1)
         {
            case 0:
               this.mcBoat.mcBackLeft.gotoAndStop(param2 + 1);
               break;
            case 1:
               this.mcBoat.mcMiddleLeft.gotoAndStop(param2 + 1);
               break;
            case 2:
               this.mcBoat.mcFrontLeft.gotoAndStop(param2 + 1);
               break;
            case 3:
               this.mcBoat.mcBackRight.gotoAndStop(param2 + 1);
               break;
            case 4:
               this.mcBoat.mcMiddleRight.gotoAndStop(param2 + 1);
               break;
            case 5:
               this.mcBoat.mcFrontRight.gotoAndStop(param2 + 1);
         }
      }
   }
}
