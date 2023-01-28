package
{
   import red.game.witcher3.menus.inventory_menu.ModuleContainer;
   
   public dynamic class ContainerGrid extends ModuleContainer
   {
       
      
      public function ContainerGrid()
      {
         super();
         this.__setProp_mcPlayerGrid_ContainerGrid_mcPlayerGrid_0();
      }
      
      internal function __setProp_mcPlayerGrid_ContainerGrid_mcPlayerGrid_0() : *
      {
         try
         {
            mcPlayerGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPlayerGrid.columns = 8;
         mcPlayerGrid.elementGridSquareOffset = 0;
         mcPlayerGrid.enabled = true;
         mcPlayerGrid.enableInitCallback = false;
         mcPlayerGrid.gridSquareSize = 64;
         mcPlayerGrid.rows = 10;
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
   }
}
