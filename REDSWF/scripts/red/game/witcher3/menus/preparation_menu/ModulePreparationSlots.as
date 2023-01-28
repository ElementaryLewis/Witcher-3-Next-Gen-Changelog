package red.game.witcher3.menus.preparation_menu
{
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotPaperdoll;
   import red.game.witcher3.slots.SlotsListPaperdoll;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class ModulePreparationSlots extends CoreMenuModule
   {
       
      
      public var mcPrepSlot1:SlotPaperdoll;
      
      public var mcPrepSlot2:SlotPaperdoll;
      
      public var mcPrepSlot3:SlotPaperdoll;
      
      public var mcPrepSlot4:SlotPaperdoll;
      
      public var mcPrepSlot5:SlotPaperdoll;
      
      public var mcPrepSlot6:SlotPaperdoll;
      
      public var mcPrepSlot7:SlotPaperdoll;
      
      public var mcPrepSlot8:SlotPaperdoll;
      
      public var mcPrepSlot9:SlotPaperdoll;
      
      public var mcPrepSlot10:SlotPaperdoll;
      
      public var mcSlotsList:SlotsListPaperdoll;
      
      public var txtTitlePotionsBombs:TextField;
      
      public var txtTitleSwordsOils:TextField;
      
      public var txtTitleMutagenPotions:TextField;
      
      public var txtPotions:TextField;
      
      public var txtBombs:TextField;
      
      public var txtSilverSword:TextField;
      
      public var txtSteelSword:TextField;
      
      private var _inputSymbolIDA:int = -1;
      
      public function ModulePreparationSlots()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"preparations.slots.list",[this.handleDataSet]));
         this.txtTitlePotionsBombs.htmlText = "[[panel_preparation_potionsandbombs_slots_description]]";
         this.txtTitlePotionsBombs.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitlePotionsBombs.htmlText);
         this.txtTitleSwordsOils.htmlText = "[[panel_preparation_oils_grid_name]]";
         this.txtTitleSwordsOils.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitleSwordsOils.htmlText);
         this.txtTitleMutagenPotions.htmlText = "[[panel_preparation_mutagens_sublist_name]]";
         this.txtTitleMutagenPotions.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitleMutagenPotions.htmlText);
         this.txtPotions.htmlText = "[[panel_inventory_paperdoll_slotname_potions]]";
         this.txtPotions.htmlText = CommonUtils.toUpperCaseSafe(this.txtPotions.htmlText);
         this.txtBombs.htmlText = "[[panel_inventory_paperdoll_slotname_petards]]";
         this.txtBombs.htmlText = CommonUtils.toUpperCaseSafe(this.txtBombs.htmlText);
         this.txtSilverSword.htmlText = "[[panel_inventory_paperdoll_slotname_silver]]";
         this.txtSilverSword.htmlText = CommonUtils.toUpperCaseSafe(this.txtSilverSword.htmlText);
         this.txtSteelSword.htmlText = "[[panel_inventory_paperdoll_slotname_steel]]";
         this.txtSteelSword.htmlText = CommonUtils.toUpperCaseSafe(this.txtSteelSword.htmlText);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.mcSlotsList.addEventListener(ListEvent.INDEX_CHANGE,this.onSlotsListIndexChanged,false,0,true);
         this.mcSlotsList.focusable = false;
      }
      
      override public function set focused(value:Number) : void
      {
         super.focused = value;
         this.UpdateSlotInputFeedback();
         this.updateActivateSelectionEnabled();
      }
      
      protected function updateActivateSelectionEnabled() : void
      {
         this.mcSlotsList.activeSelectionVisible = focused != 0;
         this.mcSlotsList.updateActiveSelectionVisible();
      }
      
      private function onSlotsListIndexChanged(event:ListEvent) : void
      {
         this.UpdateSlotInputFeedback();
      }
      
      private function UpdateSlotInputFeedback() : void
      {
         var curPaperdoll:SlotPaperdoll = null;
         if(this._inputSymbolIDA != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolIDA);
            this._inputSymbolIDA = -1;
         }
         if(focused)
         {
            curPaperdoll = this.mcSlotsList.getSelectedRenderer() as SlotPaperdoll;
            if(curPaperdoll && !curPaperdoll.isEmpty() && curPaperdoll.slotTypeID != 3)
            {
               this._inputSymbolIDA = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_A,-1,"panel_button_inventory_unequip");
            }
         }
         InputFeedbackManager.updateButtons(this);
      }
      
      private function handleDataSet(gameData:Object, index:int) : void
      {
         var i:int = 0;
         var currentSlot:SlotInventoryGrid = null;
         var dataArray:Array = gameData as Array;
         if(!dataArray)
         {
            throw new Error("GFX - This is one shitty error where the data passed from witcher script wasn\'t even an array !??!");
         }
         this.mcSlotsList.data = dataArray;
         validateNow();
         for(i = 0; i < this.mcSlotsList.getRenderersLength(); i++)
         {
            currentSlot = this.mcSlotsList.getRendererAt(i) as SlotInventoryGrid;
            if(currentSlot)
            {
               currentSlot.useContextMgr = false;
               if(currentSlot.data)
               {
                  currentSlot.data.actionType = 0;
               }
            }
         }
         this.updateActivateSelectionEnabled();
      }
      
      public function canEquipSteelOil() : Boolean
      {
         return !this.mcPrepSlot6.isLocked;
      }
      
      public function canEquipSilverOil() : Boolean
      {
         return !this.mcPrepSlot5.isLocked;
      }
      
      public function MakeUnselectableUnlessCorrectSlot(targetSlot:SlotInventoryGrid) : void
      {
         var i:int = 0;
         var curSlot:SlotPaperdoll = null;
         for(i = 0; i < this.mcSlotsList.getRenderersLength(); i++)
         {
            curSlot = this.mcSlotsList.getRendererAt(i) as SlotPaperdoll;
            if(Boolean(curSlot) && targetSlot.data)
            {
               if(curSlot.slotTypeID != targetSlot.data.prepItemType || curSlot.isLocked)
               {
                  curSlot.selectable = false;
               }
               else if(curSlot.slotTypeID == 3)
               {
                  if(curSlot.equipID == InventorySlotType.SilverSword && !targetSlot.data.silverOil)
                  {
                     curSlot.selectable = false;
                  }
                  else if(curSlot.equipID == InventorySlotType.SteelSword && !targetSlot.data.steelOil)
                  {
                     curSlot.selectable = false;
                  }
               }
            }
         }
      }
      
      public function MakeAllSelectable() : void
      {
         var i:int = 0;
         var curSlot:SlotBase = null;
         for(i = 0; i < this.mcSlotsList.getRenderersLength(); i++)
         {
            curSlot = this.mcSlotsList.getRendererAt(i) as SlotBase;
            if(curSlot)
            {
               curSlot.selectable = true;
            }
         }
      }
      
      override public function handleInput(event:InputEvent) : void
      {
         var currentSlot:SlotInventoryGrid = null;
         var activateEvent:SlotActionEvent = null;
         if(!focused || event.handled)
         {
            return;
         }
         this.mcSlotsList.handleInputPreset(event);
         if(Boolean(this.mcSlotsList) && !event.handled)
         {
            currentSlot = this.mcSlotsList.getSelectedRenderer() as SlotInventoryGrid;
            if(currentSlot)
            {
               if(event.details.value == InputValue.KEY_UP && event.details.code == KeyCode.PAD_A_CROSS)
               {
                  activateEvent = new SlotActionEvent(SlotActionEvent.EVENT_ACTIVATE,true);
                  activateEvent.actionType = 0;
                  activateEvent.targetSlot = currentSlot;
                  dispatchEvent(activateEvent);
               }
            }
         }
      }
   }
}
