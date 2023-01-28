package
{
   import red.game.witcher3.menus.character_menu.CharacterTabbedListModule;
   
   public dynamic class CharacterTabbedListModuleRef extends CharacterTabbedListModule
   {
       
      
      public function CharacterTabbedListModuleRef()
      {
         super();
         this.__setProp_mcSkillSlotList_CharacterTabbedListModule_mcSkillSlotList_0();
         this.__setProp_mcMutagenSlotList_CharacterTabbedListModule_mcMutagenSlotList_0();
         this.__setProp_mcTabList_CharacterTabbedListModule_mcTabList_0();
      }
      
      internal function __setProp_mcSkillSlotList_CharacterTabbedListModule_mcSkillSlotList_0() : *
      {
         try
         {
            mcSkillSlotList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSkillSlotList.enabled = true;
         mcSkillSlotList.enableInitCallback = false;
         mcSkillSlotList.heightPadding = 93;
         mcSkillSlotList.slotRendererName = "SlotSkillGridRef";
         mcSkillSlotList.visible = true;
         mcSkillSlotList.widthPadding = 97;
         try
         {
            mcSkillSlotList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcMutagenSlotList_CharacterTabbedListModule_mcMutagenSlotList_0() : *
      {
         try
         {
            mcMutagenSlotList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcMutagenSlotList.columns = 7;
         mcMutagenSlotList.elementGridSquareOffset = 0;
         mcMutagenSlotList.enabled = true;
         mcMutagenSlotList.enableInitCallback = false;
         mcMutagenSlotList.gridSquareSize = 64;
         mcMutagenSlotList.rows = 6;
         mcMutagenSlotList.scrollBar = "mcScrollbar";
         mcMutagenSlotList.slotRendererName = "InventorySlotRef";
         mcMutagenSlotList.visible = true;
         try
         {
            mcMutagenSlotList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcTabList_CharacterTabbedListModule_mcTabList_0() : *
      {
         try
         {
            mcTabList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcTabList.DownAction = 149;
         mcTabList.enabled = true;
         mcTabList.enableInitCallback = false;
         mcTabList.focusable = true;
         mcTabList.itemRendererName = "";
         mcTabList.itemRendererInstanceName = "mcTabListItem";
         mcTabList.margin = 0;
         mcTabList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcTabList.PCDownAction = 83;
         mcTabList.PCUpAction = 87;
         mcTabList.rowHeight = 0;
         mcTabList.scrollBar = "";
         mcTabList.UpAction = 148;
         mcTabList.visible = true;
         mcTabList.wrapping = "wrap";
         try
         {
            mcTabList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
