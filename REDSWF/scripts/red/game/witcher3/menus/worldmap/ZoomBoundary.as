package red.game.witcher3.menus.worldmap
{
   public class ZoomBoundary
   {
       
      
      public var _min:Number;
      
      public var _max:Number;
      
      public function ZoomBoundary(param1:Number, param2:Number)
      {
         super();
         this._min = param1;
         this._max = param2;
      }
      
      public function IsValid() : Boolean
      {
         return this._min > 0 && this._max > 0 && this._min < this._max;
      }
      
      public function IsInside(param1:Number) : Boolean
      {
         return param1 >= this._min && param1 <= this._max;
      }
   }
}
