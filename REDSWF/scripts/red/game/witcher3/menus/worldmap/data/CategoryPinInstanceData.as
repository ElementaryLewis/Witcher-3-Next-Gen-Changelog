package red.game.witcher3.menus.worldmap.data
{
   import flash.geom.Point;
   
   public class CategoryPinInstanceData
   {
       
      
      public var _id;
      
      public var _worldPosition;
      
      public var _distance;
      
      public function CategoryPinInstanceData(param1:uint, param2:Point, param3:Number)
      {
         super();
         this._id = param1;
         this._worldPosition = param2;
         this._distance = param3;
      }
   }
}
