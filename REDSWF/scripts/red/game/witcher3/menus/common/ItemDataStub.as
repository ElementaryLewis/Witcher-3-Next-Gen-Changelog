package red.game.witcher3.menus.common
{
   public dynamic class ItemDataStub
   {
       
      
      public var id:uint;
      
      public var groupId:int;
      
      public var iconPath:String;
      
      public var quantity:int;
      
      public var gridPosition:int;
      
      public var gridSize:int = 1;
      
      public var isNew:Boolean;
      
      public var disableAction:Boolean;
      
      public var slotType:int;
      
      public var actionType:int;
      
      public var equipped:int;
      
      public var price:int;
      
      public var quality:int;
      
      public var needRepair:Boolean = false;
      
      public var durability:Number = 1;
      
      public var isReaded:Boolean = false;
      
      public var isEquipped:Boolean;
      
      public var weight:Number;
      
      public var socketsCount:int = 0;
      
      public var socketsUsedCount:int = 0;
      
      public var socketsMaxCount:int = 0;
      
      public var invisible:Boolean;
      
      public var category:String;
      
      public var isSilverOil:Boolean;
      
      public var isSteelOil:Boolean;
      
      public var isArmorUpgrade:Boolean;
      
      public var isWeaponUpgrade:Boolean;
      
      public var isArmorRepairKit:Boolean;
      
      public var isWeaponRepairKit:Boolean;
      
      public var isItemDye:Boolean;
      
      public var canDrop:Boolean;
      
      public var enchanted:Boolean;
      
      public var enchantmentId:uint;
      
      public var sortGroup:int = -1;
      
      public var sectionId:int = -1;
      
      public var cantEquip:Boolean;
      
      public var itemName:String;
      
      public var description:String;
      
      public var isNotEnoughSockets:int;
      
      public var cantUnequip:Boolean;
      
      public var charges:String;
      
      public var showExtendedTooltip:Boolean;
      
      public var tabIndex:int = -1;
      
      public var highlighted:Boolean = false;
      
      public var itemColor:String = "";
      
      public var isDyePreview:Boolean = false;
      
      public var userData;
      
      public function ItemDataStub()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[W3 ItemDataStub: id<" + this.id + "> iconPath: " + this.iconPath + " cantEquip: " + this.cantEquip + "; quantity " + this.quantity + " gridPosition " + this.gridPosition + " gridSize " + this.gridSize + " slotType " + this.slotType + " actionType " + this.actionType + " equipped " + this.equipped + " price " + this.price + " quality " + this.quality + " needRepair " + this.needRepair + " isReaded " + this.isReaded + "]";
      }
   }
}
