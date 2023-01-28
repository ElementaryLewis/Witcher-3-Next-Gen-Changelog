package red.game.witcher3.menus.preparation_menu
{
   import red.core.events.GameEvent;
   import red.game.witcher3.modules.CollapsableTabbedListModule;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotsListGrid;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   
   public class PreparationTabbedModule extends CollapsableTabbedListModule
   {
      
      public static const TabIndex_Bombs:int = 0;
      
      public static const TabIndex_Potion:int = 1;
      
      public static const TabIndex_Oils:int = 2;
      
      public static const TabIndex_Mutagens:int = 3;
       
      
      public var mcSlotsListGrid:SlotsListGrid;
      
      public var canEquipSteelOil:Boolean = true;
      
      public var canEquipSilverOil:Boolean = true;
      
      public function PreparationTabbedModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         setTabData(new DataProvider([{
            "icon":"Bombs",
            "locKey":"[[panel_inventory_paperdoll_slotname_petards]]"
         },{
            "icon":"Potion",
            "locKey":"[[panel_inventory_paperdoll_slotname_potions]]"
         },{
            "icon":"Oils",
            "locKey":"[[panel_inventory_paperdoll_slotname_oils]]"
         },{
            "icon":"Mutagens",
            "locKey":"[[panel_inventory_paperdoll_slotname_mutagen]]"
         }]));
         addToListContainer(this.mcSlotsListGrid);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"preparation.slot.silversword.locked",[this.updateCanEquipSilverOil]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"preparation.slot.steelsword.locked",[this.updateCanEquipSteelOil]));
         if(this.mcSlotsListGrid)
         {
            this.mcSlotsListGrid.focusable = false;
            _inputHandlers.push(this.mcSlotsListGrid);
            this.mcSlotsListGrid.visible = false;
            this.mcSlotsListGrid.handleScrollBar = true;
            this.mcSlotsListGrid.ignoreGridPosition = true;
         }
      }
      
      override protected function updateSubData(index:int) : void
      {
         var currentSlot:SlotInventoryGrid = null;
         super.updateSubData(index);
         for(var i:int = 0; i < this.mcSlotsListGrid.getRenderersCount(); i++)
         {
            currentSlot = this.mcSlotsListGrid.getRendererAt(i) as SlotInventoryGrid;
            if(currentSlot)
            {
               currentSlot.useContextMgr = false;
            }
         }
      }
      
      override protected function setAllowSelectionHighlight(allowed:Boolean) : void
      {
         var currentSlotItem:SlotBase = null;
         var i:int = 0;
         super.setAllowSelectionHighlight(allowed);
         if(this.mcSlotsListGrid)
         {
            this.mcSlotsListGrid.validateNow();
            for(i = 0; i < this.mcSlotsListGrid.getRenderersLength(); i++)
            {
               currentSlotItem = this.mcSlotsListGrid.getRendererAt(i) as SlotBase;
               if(currentSlotItem)
               {
                  currentSlotItem.activeSelectionEnabled = allowed;
               }
            }
         }
      }
      
      override public function getDataShowerForTab(index:int) : UIComponent
      {
         return this.mcSlotsListGrid;
      }
      
      protected function updateCanEquipSilverOil(value:Boolean) : void
      {
         this.canEquipSilverOil = !value;
      }
      
      protected function updateCanEquipSteelOil(value:Boolean) : void
      {
         this.canEquipSteelOil = !value;
      }
      
      public function canEquip(sourceSlot:SlotInventoryGrid) : Boolean
      {
         if((sourceSlot.data.steelOil == false || this.canEquipSteelOil) && (sourceSlot.data.silverOil == false || this.canEquipSilverOil))
         {
            return true;
         }
         return false;
      }
   }
}
