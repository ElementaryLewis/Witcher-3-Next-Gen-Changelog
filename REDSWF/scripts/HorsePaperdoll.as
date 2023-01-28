package
{
   import red.game.witcher3.menus.inventory_menu.ModuleHorsePaperdoll;
   
   public dynamic class HorsePaperdoll extends ModuleHorsePaperdoll
   {
       
      
      public function HorsePaperdoll()
      {
         super();
         this.__setProp_mcPaperdoll_HorsePaperdoll_paperdoll_list_0();
         this.__setProp_mcHorseSlot1_HorsePaperdoll_slots_0();
         this.__setProp_mcHorseSlot2_HorsePaperdoll_slots_0();
         this.__setProp_mcHorseSlot3_HorsePaperdoll_slots_0();
         this.__setProp_mcHorseSlot4_HorsePaperdoll_slots_0();
      }
      
      internal function __setProp_mcPaperdoll_HorsePaperdoll_paperdoll_list_0() : *
      {
         try
         {
            mcPaperdoll["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPaperdoll.enabled = true;
         mcPaperdoll.enableInitCallback = false;
         mcPaperdoll.slotsInstanceName = "mcHorseSlot";
         mcPaperdoll.visible = true;
         try
         {
            mcPaperdoll["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHorseSlot1_HorsePaperdoll_slots_0() : *
      {
         try
         {
            mcHorseSlot1["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHorseSlot1.enabled = true;
         mcHorseSlot1.enableInitCallback = false;
         mcHorseSlot1.equipID = 28;
         mcHorseSlot1.gridSize = 1;
         mcHorseSlot1.navigationDown = -1;
         mcHorseSlot1.navigationLeft = -1;
         mcHorseSlot1.navigationRight = 1;
         mcHorseSlot1.navigationUp = -1;
         mcHorseSlot1.slotTag = "horseBag";
         mcHorseSlot1.slotTypeID = 0;
         mcHorseSlot1.visible = true;
         try
         {
            mcHorseSlot1["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHorseSlot2_HorsePaperdoll_slots_0() : *
      {
         try
         {
            mcHorseSlot2["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHorseSlot2.enabled = true;
         mcHorseSlot2.enableInitCallback = false;
         mcHorseSlot2.equipID = 26;
         mcHorseSlot2.gridSize = 1;
         mcHorseSlot2.navigationDown = -1;
         mcHorseSlot2.navigationLeft = 0;
         mcHorseSlot2.navigationRight = 2;
         mcHorseSlot2.navigationUp = -1;
         mcHorseSlot2.slotTag = "horseBlinders";
         mcHorseSlot2.slotTypeID = 0;
         mcHorseSlot2.visible = true;
         try
         {
            mcHorseSlot2["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHorseSlot3_HorsePaperdoll_slots_0() : *
      {
         try
         {
            mcHorseSlot3["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHorseSlot3.enabled = true;
         mcHorseSlot3.enableInitCallback = false;
         mcHorseSlot3.equipID = 27;
         mcHorseSlot3.gridSize = 2;
         mcHorseSlot3.navigationDown = -1;
         mcHorseSlot3.navigationLeft = 1;
         mcHorseSlot3.navigationRight = 3;
         mcHorseSlot3.navigationUp = -1;
         mcHorseSlot3.slotTag = "horseSaddle";
         mcHorseSlot3.slotTypeID = 0;
         mcHorseSlot3.visible = true;
         try
         {
            mcHorseSlot3["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHorseSlot4_HorsePaperdoll_slots_0() : *
      {
         try
         {
            mcHorseSlot4["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHorseSlot4.enabled = true;
         mcHorseSlot4.enableInitCallback = false;
         mcHorseSlot4.equipID = 29;
         mcHorseSlot4.gridSize = 1;
         mcHorseSlot4.navigationDown = -1;
         mcHorseSlot4.navigationLeft = 2;
         mcHorseSlot4.navigationRight = -1;
         mcHorseSlot4.navigationUp = -1;
         mcHorseSlot4.slotTag = "horseTrophy";
         mcHorseSlot4.slotTypeID = 0;
         mcHorseSlot4.visible = true;
         try
         {
            mcHorseSlot4["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
