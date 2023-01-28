package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   
   public dynamic class ItemSectionData
   {
       
      
      public var id:uint;
      
      public var label:String;
      
      public var start:uint;
      
      public var end:uint;
      
      public var border:MovieClip;
      
      public function ItemSectionData(param1:uint, param2:uint, param3:uint, param4:String, param5:MovieClip = null)
      {
         super();
         this.id = param1;
         this.start = param2;
         this.end = param3;
         this.label = param4;
         this.border = param5;
      }
      
      public function toString() : String
      {
         return "[ItemSectionData GROUP <" + this.id + "> :\"" + this.label + "\" ( " + this.start + " : " + this.end + " ) ]";
      }
   }
}
