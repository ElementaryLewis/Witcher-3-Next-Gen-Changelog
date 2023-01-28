package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.AspectRatio;
   import red.game.witcher3.managers.PanelModuleManager;
   
   public class HudModuleAnchors extends HudModuleBase
   {
       
      
      public var mcModuleManager:PanelModuleManager;
      
      public var mcAnchorWolfHead:MovieClip;
      
      public var mcAnchorHorseStaminaBar:MovieClip;
      
      public var mcAnchorHorsePanicBar:MovieClip;
      
      public var mcAnchorItemInfo:MovieClip;
      
      public var mcAnchorLootPopup:MovieClip;
      
      public var mcAnchorMiniMap:MovieClip;
      
      public var mcAnchorOxygenBar:MovieClip;
      
      public var mcAnchorQuest:MovieClip;
      
      public var mcAnchorBuffs:MovieClip;
      
      public var mcAnchorConsole:MovieClip;
      
      public var mcAnchorBoatHealth:MovieClip;
      
      public var mcAnchorBossFocus:MovieClip;
      
      public var mcAnchorMessage:MovieClip;
      
      public var mcAnchorWatermark:MovieClip;
      
      public var mcAnchorTimelapse:MovieClip;
      
      public var mcAnchorJournalUpdate:MovieClip;
      
      public var mcAnchorAreaInfo:MovieClip;
      
      public var mcAnchorCrosshair:MovieClip;
      
      public var mcAnchorCompanion:MovieClip;
      
      public var mcAnchorDamagedItems:MovieClip;
      
      public var mcAnchorControlsFeedback:MovieClip;
      
      protected var _currentAspectRatio:int;
      
      public function HudModuleAnchors()
      {
         super();
      }
      
      override public function get moduleName() : String
      {
         return "AnchorsModule";
      }
      
      override protected function configUI() : void
      {
         visible = false;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function UpdateAnchorsAspectRatio(param1:int, param2:int) : void
      {
         this._currentAspectRatio = AspectRatio.getCurrentAspectRatio(param1,param2);
         switch(this._currentAspectRatio)
         {
            case AspectRatio.ASPECT_RATIO_DEFAULT:
            case AspectRatio.ASPECT_RATIO_4_3:
            case AspectRatio.ASPECT_RATIO_21_9:
               gotoAndStop(this._currentAspectRatio);
               break;
            case AspectRatio.ASPECT_RATIO_UNDEFINED:
         }
      }
      
      public function isAspectRatio21_9() : Boolean
      {
         return this._currentAspectRatio == AspectRatio.ASPECT_RATIO_21_9;
      }
      
      public function UpdateAnchorsPositions() : void
      {
         this.mcModuleManager.UpdateAnchorsPositions();
      }
   }
}
