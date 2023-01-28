package red.game.witcher3.menus.inventory_menu
{
   import red.core.events.GameEvent;
   import red.game.witcher3.slots.SlotPaperdoll;
   
   public class ModuleHorsePaperdoll extends ModulePaperdollBase
   {
       
      
      public var mcHorseSlot1:SlotPaperdoll;
      
      public var mcHorseSlot2:SlotPaperdoll;
      
      public var mcHorseSlot3:SlotPaperdoll;
      
      public var mcHorseSlot4:SlotPaperdoll;
      
      public function ModuleHorsePaperdoll()
      {
         super();
         dataBindingKey = "inventory.grid.paperdoll.horse";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.grid.paperdoll.horse",[this.handlePaperdollDataSet]));
      }
      
      override protected function handlePaperdollDataSet(param1:Object, param2:int) : void
      {
         mcPaperdoll.data = param1 as Array;
         mcPaperdoll.validateNow();
      }
      
      override public function toString() : String
      {
         return "[W3 ModuleHorsePaperdoll]";
      }
   }
}
