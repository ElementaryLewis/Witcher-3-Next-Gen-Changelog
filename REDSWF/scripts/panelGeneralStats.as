package
{
   import red.game.witcher3.menus.inventory_menu.PlayerGeneralStatsPanel;
   
   public dynamic class panelGeneralStats extends PlayerGeneralStatsPanel
   {
       
      
      public function panelGeneralStats()
      {
         super();
         this.__setProp_mcStatsList_panelGeneralStats_list_0();
      }
      
      internal function __setProp_mcStatsList_panelGeneralStats_list_0() : *
      {
         try
         {
            mcStatsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcStatsList.DownAction = 40;
         mcStatsList.enabled = true;
         mcStatsList.enableInitCallback = false;
         mcStatsList.focusable = true;
         mcStatsList.itemRendererName = "FullStatsItemRef";
         mcStatsList.itemRendererInstanceName = "";
         mcStatsList.margin = 0;
         mcStatsList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcStatsList.PCDownAction = 83;
         mcStatsList.PCUpAction = 87;
         mcStatsList.rowHeight = 0;
         mcStatsList.scrollBar = "";
         mcStatsList.selectOnOver = false;
         mcStatsList.UpAction = 38;
         mcStatsList.visible = true;
         mcStatsList.wrapping = "normal";
         try
         {
            mcStatsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
