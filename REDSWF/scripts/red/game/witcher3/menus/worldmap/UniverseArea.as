package red.game.witcher3.menus.worldmap
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class UniverseArea extends UIComponent
   {
      
      protected static const INVALID_ACTIVE_KEY:String = "invalid.active.key";
       
      
      public var mcPlayerIndicator:MovieClip;
      
      public var mcQuestIndicator:MovieClip;
      
      public var mcIcon:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var mcBorder:MovieClip;
      
      public var tfLabel:TextField;
      
      public var mcCenterPosition:MovieClip;
      
      public var recLevel:Number;
      
      protected var m_worldName:String;
      
      protected var m_realWorldName:String;
      
      protected var _hasQuest:Boolean;
      
      protected var _isCurrentArea:Boolean;
      
      protected var _isActive:Boolean = false;
      
      protected var _activeDataKey:String;
      
      public function UniverseArea()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.isActive = false;
         if(this._activeDataKey != UniverseArea.INVALID_ACTIVE_KEY)
         {
            dispatchEvent(new GameEvent(GameEvent.REGISTER,this._activeDataKey,[this.setIsActive]));
         }
         this.mcIcon.gotoAndStop("inactive");
      }
      
      public function get hasQuest() : Boolean
      {
         return this._hasQuest;
      }
      
      public function set hasQuest(param1:Boolean) : void
      {
         this._hasQuest = param1;
         if(this.mcQuestIndicator)
         {
            this.mcQuestIndicator.visible = param1;
         }
      }
      
      public function get isCurrentArea() : Boolean
      {
         return this._isCurrentArea;
      }
      
      public function set isCurrentArea(param1:Boolean) : void
      {
         this._isCurrentArea = param1;
         if(this.mcPlayerIndicator)
         {
            this.mcPlayerIndicator.visible = param1;
         }
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         this._isActive = param1;
      }
      
      public function get activeDataKey() : String
      {
         return this._activeDataKey;
      }
      
      public function set activeDataKey(param1:String) : void
      {
         this._activeDataKey = param1;
      }
      
      public function SetWorldName(param1:String, param2:String = "") : *
      {
         this.m_worldName = param1;
         this.m_realWorldName = param2;
         if(this.tfLabel)
         {
            this.tfLabel.text = "[[map_location_" + this.m_worldName + "]]";
            this.tfLabel.text = CommonUtils.toUpperCaseSafe(this.tfLabel.text);
            if(this.mcBackground)
            {
               this.mcBackground.height = 2.2 * (this.tfLabel.y - this.mcBackground.y) + this.tfLabel.textHeight;
            }
         }
      }
      
      public function GetWorldName(param1:Boolean = false) : String
      {
         if(param1 && this.m_realWorldName != "")
         {
            return this.m_realWorldName;
         }
         return this.m_worldName;
      }
      
      protected function setIsActive(param1:Boolean) : void
      {
         this.isActive = param1;
      }
      
      public function GetCenterPosition() : Point
      {
         if(this.mcCenterPosition)
         {
            return localToGlobal(new Point(this.mcCenterPosition.x,this.mcCenterPosition.y));
         }
         return localToGlobal(new Point(0,0));
      }
   }
}
