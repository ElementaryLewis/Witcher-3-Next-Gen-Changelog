package red.game.witcher3.controls
{
   import flash.events.Event;
   import flash.net.URLRequest;
   import red.game.witcher3.constants.InventorySlotType;
   import scaleform.clik.controls.UILoader;
   
   public class W3UILoaderSlot extends UILoader
   {
      
      protected static const DEFAULT_ICON:String = "icons/inventory/raspberryjuice_64x64.dds";
       
      
      protected var tryLoadDefault:Boolean;
      
      protected var _slotType:int;
      
      public function W3UILoaderSlot()
      {
         super();
      }
      
      public function get slotType() : int
      {
         return this._slotType;
      }
      
      public function set slotType(param1:int) : void
      {
         this._slotType = param1;
      }
      
      public function setOriginSource(param1:String) : void
      {
         super.source = param1;
      }
      
      override public function set source(param1:String) : void
      {
         if(Boolean(param1) && param1 != "")
         {
            super.source = "img://" + param1;
         }
         else
         {
            super.source = "img://" + this.getDefaultImage();
         }
      }
      
      override protected function handleLoadIOError(param1:Event) : void
      {
         if(!this.tryLoadDefault)
         {
            loader.load(new URLRequest(DEFAULT_ICON));
            this.tryLoadDefault = true;
         }
         else
         {
            super.handleLoadIOError(param1);
         }
      }
      
      override protected function handleLoadComplete(param1:Event) : void
      {
         super.handleLoadComplete(param1);
         this.tryLoadDefault = false;
      }
      
      protected function getDefaultImage() : String
      {
         switch(this._slotType)
         {
            case InventorySlotType.SteelSword:
               return "icons/inventory/sword-01-A.png";
            case InventorySlotType.SilverSword:
               return "icons/inventory/sword-02-A.png";
            case InventorySlotType.Armor:
               return "icons/inventory/armor-00.png";
            case InventorySlotType.Trophy:
               return "icons/inventory/hardenedleather-00.png";
            case InventorySlotType.Gloves:
               return "icons/inventory/gauntlet-00.png";
            case InventorySlotType.Pants:
               return "icons/inventory/trousers-00.png";
            case InventorySlotType.Boots:
               return "icons/inventory/boots-00.png";
            case InventorySlotType.Trophy:
               return "icons/inventory/trophy-00.png";
            case InventorySlotType.Potion2:
            case InventorySlotType.Potion1:
               return "icons/inventory/trophy-00.png";
            default:
               return "";
         }
      }
   }
}
