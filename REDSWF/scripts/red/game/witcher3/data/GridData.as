package red.game.witcher3.data
{
   import scaleform.clik.data.ListData;
   
   public class GridData extends ListData
   {
       
      
      public var iconPath:String;
      
      public var gridSize:int;
      
      public function GridData(param1:uint, param2:String = "Empty", param3:Boolean = false, param4:* = "", param5:* = 1)
      {
         super(param1,param2,param3);
         this.iconPath = param4;
         this.gridSize = param5;
      }
      
      override public function toString() : String
      {
         return "[W3 GridData " + index + ", " + label + ", " + selected + ", " + this.iconPath + ", " + this.gridSize + "]";
      }
   }
}
