package
{
   import red.game.witcher3.menus.blacksmith.ModuleBlacksmithGrid;
   
   public dynamic class RepairGrid extends ModuleBlacksmithGrid
   {
       
      
      public function RepairGrid()
      {
         super();
         this.__setProp_mcPlayerGrid_RepairGrid_mcPlayerGrid_0();
         this.__setProp_mcScrollBar_RepairGrid_ScrollBar_0();
      }
      
      internal function __setProp_mcPlayerGrid_RepairGrid_mcPlayerGrid_0() : *
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
         mcPlayerGrid.rows = 9;
         mcPlayerGrid.scrollBar = "mcScrollBar";
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
      
      internal function __setProp_mcScrollBar_RepairGrid_ScrollBar_0() : *
      {
         try
         {
            mcScrollBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcScrollBar.enabled = true;
         mcScrollBar.enableInitCallback = false;
         mcScrollBar.minThumbSize = 10;
         mcScrollBar.offsetBottom = 0;
         mcScrollBar.offsetTop = 0;
         mcScrollBar.scrollTarget = "";
         mcScrollBar.trackMode = "scrollPage";
         mcScrollBar.visible = false;
         try
         {
            mcScrollBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
