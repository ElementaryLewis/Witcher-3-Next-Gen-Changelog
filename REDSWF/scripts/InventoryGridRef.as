package
{
   import red.game.witcher3.menus.inventory_menu.InventoryTabbedListModule;
   
   public dynamic class InventoryGridRef extends InventoryTabbedListModule
   {
       
      
      public function InventoryGridRef()
      {
         super();
         this.__setProp_mcTabList_InventoryGrid_InventoryTabs_list_0();
         this.__setProp_mcPlayerGrid_InventoryGrid_mcPlayerGrid_0();
         this.__setProp_mcScrollbar_InventoryGrid_ScrollBar_0();
      }
      
      internal function __setProp_mcTabList_InventoryGrid_InventoryTabs_list_0() : *
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
         mcTabList.focusable = false;
         mcTabList.itemRendererName = "";
         mcTabList.itemRendererInstanceName = "mcTabListItem";
         mcTabList.margin = 0;
         mcTabList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcTabList.PCDownAction = 102;
         mcTabList.PCUpAction = 100;
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
      
      internal function __setProp_mcPlayerGrid_InventoryGrid_mcPlayerGrid_0() : *
      {
         try
         {
            mcPlayerGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPlayerGrid.columns = 9;
         mcPlayerGrid.elementGridSquareOffset = 0;
         mcPlayerGrid.enabled = true;
         mcPlayerGrid.enableInitCallback = false;
         mcPlayerGrid.gridSquareSize = 64;
         mcPlayerGrid.rows = 10;
         mcPlayerGrid.scrollBar = "mcScrollbar";
         mcPlayerGrid.slotRendererName = "InventorySlotRef";
         mcPlayerGrid.visible = true;
         try
         {
            mcPlayerGrid["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcScrollbar_InventoryGrid_ScrollBar_0() : *
      {
         try
         {
            mcScrollbar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcScrollbar.enabled = true;
         mcScrollbar.enableInitCallback = false;
         mcScrollbar.minThumbSize = 10;
         mcScrollbar.offsetBottom = 0;
         mcScrollbar.offsetTop = 0;
         mcScrollbar.scrollTarget = "";
         mcScrollbar.trackMode = "scrollPage";
         mcScrollbar.visible = false;
         try
         {
            mcScrollbar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
