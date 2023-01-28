package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.controls.BaseListItem;
   
   public class HubMapQuestTrackerItemRenderer extends BaseListItem
   {
       
      
      public var tfObjective:TextField;
      
      public var mcTrackIndicator:MovieClip;
      
      public var mcBackground:MovieClip;
      
      private var _scriptName:uint;
      
      private const RIGHT_MARGIN:int = 70;
      
      private const LEFT_MARGIN:int = 45;
      
      private const TRACK_INDICATOR_SPACING:int = 15;
      
      public function HubMapQuestTrackerItemRenderer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            this._scriptName = param1.objectiveScriptName;
            this.tfObjective.htmlText = param1.objectiveName;
            this.tfObjective.textColor = !!param1.highlighted ? 15777336 : 14671582;
            this.mcTrackIndicator.visible = param1.highlighted;
            this.mcBackground.width = this.RIGHT_MARGIN + this.tfObjective.textWidth + (!!param1.highlighted ? this.LEFT_MARGIN : 0);
            this.mcTrackIndicator.x = this.mcBackground.x - this.mcBackground.width + this.TRACK_INDICATOR_SPACING;
            this.tfObjective.width = this.tfObjective.textWidth;
            this.tfObjective.x = this.mcBackground.x - this.mcBackground.width + (!!param1.highlighted ? this.LEFT_MARGIN : 0) + this.TRACK_INDICATOR_SPACING;
         }
      }
      
      public function getScriptName() : uint
      {
         return this._scriptName;
      }
   }
}
