package
{
   import red.game.witcher3.hud.modules.lootpopup.HudLootItemModule;
   
   public dynamic class MC_IMG_LootWindow extends HudLootItemModule
   {
       
      
      public function MC_IMG_LootWindow()
      {
         super();
         this.__setProp_mcScrollBar_MC_IMG_LootWindow_Graphic_Scrollbar_0();
         this.__setProp_mcLootItemsList_MC_IMG_LootWindow_Component_SrollingList_0();
      }
      
      internal function __setProp_mcScrollBar_MC_IMG_LootWindow_Graphic_Scrollbar_0() : *
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
         mcScrollBar.minThumbSize = 0;
         mcScrollBar.offsetBottom = 0;
         mcScrollBar.offsetTop = 0;
         mcScrollBar.scrollTarget = "";
         mcScrollBar.trackMode = "scrollPage";
         mcScrollBar.visible = true;
         try
         {
            mcScrollBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcLootItemsList_MC_IMG_LootWindow_Component_SrollingList_0() : *
      {
         try
         {
            mcLootItemsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcLootItemsList.DownAction = 40;
         mcLootItemsList.enabled = true;
         mcLootItemsList.enableInitCallback = false;
         mcLootItemsList.focusable = true;
         mcLootItemsList.itemRendererName = "";
         mcLootItemsList.itemRendererInstanceName = "mcLootItemsListItem";
         mcLootItemsList.margin = 0;
         mcLootItemsList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcLootItemsList.rowHeight = 0;
         mcLootItemsList.scrollBar = "mcScrollBar";
         mcLootItemsList.UpAction = 38;
         mcLootItemsList.visible = true;
         mcLootItemsList.wrapping = "wrap";
         try
         {
            mcLootItemsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
