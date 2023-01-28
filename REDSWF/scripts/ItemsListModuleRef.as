package
{
   import red.game.witcher3.menus.blacksmith.EnchantingItemsListModule;
   
   public dynamic class ItemsListModuleRef extends EnchantingItemsListModule
   {
       
      
      public function ItemsListModuleRef()
      {
         super();
         this.__setProp_mcScrollingList_ItemsListModule_scrolling_list_0();
      }
      
      internal function __setProp_mcScrollingList_ItemsListModule_scrolling_list_0() : *
      {
         try
         {
            mcScrollingList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcScrollingList.DownAction = 40;
         mcScrollingList.enabled = true;
         mcScrollingList.enableInitCallback = false;
         mcScrollingList.focusable = true;
         mcScrollingList.itemRendererName = "InventoryItemRendererRef";
         mcScrollingList.itemRendererInstanceName = "";
         mcScrollingList.margin = 0;
         mcScrollingList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcScrollingList.PCDownAction = 83;
         mcScrollingList.PCUpAction = 87;
         mcScrollingList.rowHeight = 0;
         mcScrollingList.scrollBar = "mcScrollbar";
         mcScrollingList.UpAction = 38;
         mcScrollingList.visible = true;
         mcScrollingList.wrapping = "normal";
         try
         {
            mcScrollingList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
