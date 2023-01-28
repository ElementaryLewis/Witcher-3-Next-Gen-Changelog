package red.game.witcher3.constants
{
   import red.game.witcher3.menus.common.ItemDataStub;
   
   public class DebugDataProvider
   {
       
      
      public function DebugDataProvider()
      {
         super();
      }
      
      public static function GetGridDebugData() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:ItemDataStub = null;
         _loc1_ = [];
         _loc2_ = new ItemDataStub();
         _loc2_.actionType = InventoryActionType.EQUIP;
         _loc2_.equipped = 0;
         _loc2_.gridPosition = 0;
         _loc2_.gridSize = 2;
         _loc2_.iconPath = "../../icons/inventory/armor-01.png";
         _loc2_.id = 1;
         _loc2_.isNew = true;
         _loc2_.price = 100;
         _loc2_.needRepair = true;
         _loc2_.quantity = 10;
         _loc2_.slotType = InventorySlotType.Armor;
         _loc1_.push(_loc2_);
         var _loc3_:ItemDataStub = new ItemDataStub();
         _loc3_.actionType = InventoryActionType.EQUIP;
         _loc3_.equipped = 0;
         _loc3_.gridPosition = 1;
         _loc3_.gridSize = 2;
         _loc3_.iconPath = "../../icons/inventory/sword-01-B.png";
         _loc3_.id = 1;
         _loc3_.isNew = true;
         _loc3_.price = 100;
         _loc3_.needRepair = true;
         _loc3_.quantity = 10;
         _loc3_.slotType = InventorySlotType.SilverSword;
         _loc1_.push(_loc3_);
         return _loc1_;
      }
      
      public static function GetPaperdollData() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:ItemDataStub = new ItemDataStub();
         _loc2_.actionType = InventoryActionType.EQUIP;
         _loc2_.equipped = 0;
         _loc2_.gridPosition = 1;
         _loc2_.gridSize = 2;
         _loc2_.iconPath = "../../icons/inventory/armor-01.png";
         _loc2_.id = 1;
         _loc2_.isNew = true;
         _loc2_.price = 100;
         _loc2_.needRepair = true;
         _loc2_.quantity = 10;
         _loc2_.slotType = InventorySlotType.Armor;
         _loc1_.push(_loc2_);
         var _loc3_:ItemDataStub = new ItemDataStub();
         _loc3_.actionType = InventoryActionType.EQUIP;
         _loc3_.equipped = 0;
         _loc3_.gridPosition = 1;
         _loc3_.gridSize = 2;
         _loc3_.iconPath = "../../icons/inventory/sword-01-B.png";
         _loc3_.id = 1;
         _loc3_.isNew = true;
         _loc3_.price = 100;
         _loc3_.needRepair = true;
         _loc3_.quantity = 10;
         _loc3_.slotType = InventorySlotType.SilverSword;
         _loc1_.push(_loc3_);
         var _loc4_:ItemDataStub;
         (_loc4_ = new ItemDataStub()).actionType = InventoryActionType.EQUIP;
         _loc4_.equipped = 0;
         _loc4_.gridPosition = 1;
         _loc4_.gridSize = 1;
         _loc4_.iconPath = "../../icons/inventory/ico_apple.png";
         _loc4_.id = 2;
         _loc4_.isNew = true;
         _loc4_.price = 100;
         _loc4_.needRepair = true;
         _loc4_.quantity = 10;
         _loc4_.slotType = InventorySlotType.Potion2;
         _loc1_.push(_loc4_);
         return _loc1_;
      }
   }
}
