package red.game.witcher3.menus.worldmap.data
{
   public class CategoryPinData
   {
       
      
      public var _name:String;
      
      public var _translation:String;
      
      public var _priority:int;
      
      public var _index:int;
      
      public var _instances:Array;
      
      public function CategoryPinData(param1:String, param2:String, param3:int)
      {
         this._instances = new Array();
         super();
         this._name = param1;
         this._translation = param2;
         this._priority = param3;
      }
   }
}
