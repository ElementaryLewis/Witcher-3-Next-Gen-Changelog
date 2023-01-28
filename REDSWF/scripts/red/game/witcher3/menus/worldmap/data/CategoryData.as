package red.game.witcher3.menus.worldmap.data
{
   public class CategoryData
   {
       
      
      public var _name:String;
      
      public var _priority:int;
      
      public var _pins:Array;
      
      public var _showUserPins:Boolean;
      
      public var _showFastTravelPins:Boolean;
      
      public var _showQuestPins:Boolean;
      
      public function CategoryData(param1:String, param2:int, param3:Boolean, param4:Boolean, param5:Boolean)
      {
         this._pins = new Array();
         super();
         this._name = param1;
         this._priority = param2;
         this._showUserPins = param3;
         this._showFastTravelPins = param4;
         this._showQuestPins = param5;
      }
   }
}
