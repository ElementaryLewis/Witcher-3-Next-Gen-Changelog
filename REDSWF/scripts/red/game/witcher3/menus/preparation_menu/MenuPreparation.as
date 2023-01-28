package red.game.witcher3.menus.preparation_menu
{
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3RenderToTextureHolder;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.menus.character_menu.CharacterModeBackground;
   import red.game.witcher3.slots.SlotInventoryGrid;
   import red.game.witcher3.slots.SlotPaperdoll;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MenuPreparation extends CoreMenu
   {
       
      
      public var mcGridModule:PreparationTabbedModule;
      
      public var moduleSlots:ModulePreparationSlots;
      
      public var moduleMonster:ModuleMonsterTrack;
      
      public var mcSelectionMode:CharacterModeBackground;
      
      public var toxicityBar:ToxicityBar;
      
      public var tooltipAnchor:MovieClip;
      
      public var background:MovieClip;
      
      public var mcRenderToTextureHolder:W3RenderToTextureHolder;
      
      protected var _cachedSlotData:Object;
      
      public function MenuPreparation()
      {
         super();
         if(this.mcSelectionMode)
         {
            this.mcSelectionMode.deactivate();
         }
         this.__setProp_mcGridModule_Scene1_mcGridModule_0();
      }
      
      override protected function get menuName() : String
      {
         return "PreparationMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         _contextMgr.defaultAnchor = this.tooltipAnchor;
         _contextMgr.addGridEventsTooltipHolder(stage);
         this.mcGridModule.mcSlotsListGrid.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleItemAction,false,0,true);
         this.moduleSlots.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleSlotAction,false,0,true);
         if(this.mcSelectionMode)
         {
            this.mcSelectionMode.deactivate();
            this.mcSelectionMode.setCaption("[[panel_preparation_equip_dialog_title]]");
         }
         registerRenderTarget("test_nopack",1024,1024);
      }
      
      protected function startSelectionMode(targetSlot:SlotInventoryGrid) : void
      {
         this.mcSelectionMode.activate(targetSlot);
         this.moduleSlots.mcSlotsList.ignoreSelectable = false;
         this.moduleSlots.MakeUnselectableUnlessCorrectSlot(targetSlot);
         this.moduleSlots.mcSlotsList.ReselectIndexIfInvalid(this.moduleSlots.mcSlotsList.selectedIndex);
         this.mcGridModule.enabled = false;
         this.moduleMonster.enabled = false;
         currentModuleIdx = 0;
         this._cachedSlotData = targetSlot.data;
      }
      
      protected function endSelectionMode() : void
      {
         this.mcSelectionMode.deactivate();
         this.moduleSlots.MakeAllSelectable();
         this.mcGridModule.enabled = true;
         this.moduleMonster.enabled = true;
         currentModuleIdx = 0;
         this._cachedSlotData = null;
      }
      
      override protected function handleInputNavigate(event:InputEvent) : void
      {
         var details:InputDetails = event.details;
         var inputEnabled:Boolean = details.value == InputValue.KEY_UP && !event.handled && this.mcSelectionMode.isActive();
         if(inputEnabled)
         {
            switch(details.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
                  this.endSelectionMode();
                  event.handled = true;
                  event.stopImmediatePropagation();
                  return;
            }
         }
         super.handleInputNavigate(event);
      }
      
      protected function handleItemAction(event:SlotActionEvent) : void
      {
         var targetSlot:SlotInventoryGrid = event.targetSlot as SlotInventoryGrid;
         if(targetSlot.data == null)
         {
            return;
         }
         if(!this.mcGridModule.canEquip(targetSlot))
         {
            return;
         }
         this.startSelectionMode(targetSlot);
      }
      
      protected function handleSlotAction(event:SlotActionEvent) : void
      {
         var currentPaperdoll:SlotPaperdoll = event.targetSlot as SlotPaperdoll;
         if(!currentPaperdoll)
         {
            throw new Error("GFX - MenuPreperation trying to handle slot action on unknown slot data");
         }
         if(this._cachedSlotData != null)
         {
            this.callEquipItem(this._cachedSlotData,currentPaperdoll.equipID);
         }
         else if(!currentPaperdoll.isEmpty())
         {
            this.mcGridModule.onSetTabCalled(Math.max(0,currentPaperdoll.data.prepItemType - 1));
            this.callUnequipItem(currentPaperdoll.equipID);
         }
         else
         {
            this.mcGridModule.onSetTabCalled(Math.max(0,currentPaperdoll.data.prepItemType - 1));
            currentModuleIdx = 0;
         }
      }
      
      protected function callEquipItem(object:Object, equipID:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipItemPrep",[object.id,equipID]));
         if(this.mcSelectionMode.visible)
         {
            this.endSelectionMode();
         }
      }
      
      protected function callUnequipItem(equipID:int) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipItemPrep",[equipID]));
      }
      
      internal function __setProp_mcGridModule_Scene1_mcGridModule_0() : *
      {
         try
         {
            this.mcGridModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcGridModule.enabled = true;
         this.mcGridModule.enableInitCallback = false;
         this.mcGridModule.setSelectedTabDataProvider = "OnTabSelectRequested";
         this.mcGridModule.subDataProvider = "preparations.items.tab.data";
         this.mcGridModule.tabDataEventName = "OnTabDataRequested";
         this.mcGridModule.visible = true;
         try
         {
            this.mcGridModule["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
