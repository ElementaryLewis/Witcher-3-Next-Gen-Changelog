package red.game.witcher3.menus.worldmap
{
   import flash.display.Sprite;
   import red.game.witcher3.data.StaticMapPinData;
   import scaleform.clik.core.UIComponent;
   
   public class HubMapPinContainer extends UIComponent
   {
       
      
      public var _defCanvas:Sprite;
      
      public var _areaCanvas:Sprite;
      
      public var _travelCanvas:Sprite;
      
      public var _questCanvas:Sprite;
      
      public var _boardsCanvas:Sprite;
      
      public var _selectedCanvas:Sprite;
      
      public function HubMapPinContainer()
      {
         super();
         this._defCanvas = new Sprite();
         this._areaCanvas = new Sprite();
         this._travelCanvas = new Sprite();
         this._questCanvas = new Sprite();
         this._boardsCanvas = new Sprite();
         this._selectedCanvas = new Sprite();
         addChild(this._areaCanvas);
         addChild(this._defCanvas);
         addChild(this._boardsCanvas);
         addChild(this._questCanvas);
         addChild(this._travelCanvas);
         addChild(this._selectedCanvas);
      }
      
      public function getPinCanvas(param1:StaticMapPinData) : Sprite
      {
         var _loc2_:Sprite = this._defCanvas;
         if(!param1)
         {
            return _loc2_;
         }
         if(param1.radius > 0)
         {
            _loc2_ = this._areaCanvas;
         }
         else
         {
            switch(param1.type)
            {
               case "RoadSign":
               case "Harbor":
                  _loc2_ = this._travelCanvas;
                  break;
               case "StoryQuest":
               case "ChapterQuest":
               case "SideQuest":
               case "MonsterQuest":
               case "TreasureQuest":
                  _loc2_ = this._questCanvas;
                  break;
               case "NoticeBoard":
                  _loc2_ = this._boardsCanvas;
                  break;
               default:
                  _loc2_ = this._defCanvas;
            }
         }
         return _loc2_;
      }
   }
}
