package red.game.witcher3.menus.inventory_menu
{
   public class GridTabSections
   {
       
      
      public var sections:Array;
      
      public function GridTabSections()
      {
         super();
         this.sections = [];
      }
      
      public function push(param1:int, param2:ItemSectionData) : ItemSectionData
      {
         var _loc3_:Object = {
            "tabIdx":param1,
            "item":param2
         };
         this.sections.push(_loc3_);
         return param2;
      }
      
      public function getTabSections(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = int(this.sections.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.sections[_loc4_].tabIdx == param1)
            {
               _loc2_.push(this.sections[_loc4_].item);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         return "[GridTabSections] contains " + this.sections.length + " sections";
      }
   }
}
