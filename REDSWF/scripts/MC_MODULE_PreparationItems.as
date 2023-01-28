package
{
   import red.game.witcher3.menus.preparation_menu.PreparationTabbedModule;
   
   public dynamic class MC_MODULE_PreparationItems extends PreparationTabbedModule
   {
       
      
      public function MC_MODULE_PreparationItems()
      {
         super();
         this.__setProp_mcSlotsListGrid_MC_MODULE_PreparationItems_mcSlotsListGrid_0();
         this.__setProp_mcTabList_MC_MODULE_PreparationItems_mcTabList_0();
      }
      
      internal function __setProp_mcSlotsListGrid_MC_MODULE_PreparationItems_mcSlotsListGrid_0() : *
      {
         try
         {
            mcSlotsListGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSlotsListGrid.columns = 6;
         mcSlotsListGrid.elementGridSquareOffset = 0;
         mcSlotsListGrid.enabled = true;
         mcSlotsListGrid.enableInitCallback = false;
         mcSlotsListGrid.gridSquareSize = 64;
         mcSlotsListGrid.rows = 6;
         mcSlotsListGrid.scrollBar = "mcScrollbar";
         mcSlotsListGrid.slotRendererName = "InventorySlotRef";
         mcSlotsListGrid.visible = true;
         try
         {
            mcSlotsListGrid["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcTabList_MC_MODULE_PreparationItems_mcTabList_0() : *
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
