package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventorySlotType;
   
   public class HudModuleDamagedItems extends HudModuleBase
   {
       
      
      public var mcSilver:MovieClip;
      
      public var mcSteel:MovieClip;
      
      public var mcArmor:MovieClip;
      
      public var mcBoots:MovieClip;
      
      public var mcTrousers:MovieClip;
      
      public var mcGloves:MovieClip;
      
      public function HudModuleDamagedItems()
      {
         super();
      }
      
      override public function get moduleName() : String
      {
         return "DamagedItemsModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setItemDamaged(param1:int, param2:Boolean) : *
      {
         switch(param1)
         {
            case InventorySlotType.SilverSword:
               this.mcSilver.gotoAndStop(param2 + 1);
               break;
            case InventorySlotType.SteelSword:
               this.mcSteel.gotoAndStop(param2 + 1);
               break;
            case InventorySlotType.Armor:
               this.mcArmor.gotoAndStop(param2 + 1);
               break;
            case InventorySlotType.Boots:
               this.mcBoots.gotoAndStop(param2 + 1);
               break;
            case InventorySlotType.Pants:
               this.mcTrousers.gotoAndStop(param2 + 1);
               break;
            case InventorySlotType.Gloves:
               this.mcGloves.gotoAndStop(param2 + 1);
         }
      }
   }
}
