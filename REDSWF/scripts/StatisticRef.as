package
{
   import red.game.witcher3.menus.common.PlayerStatsModule;
   
   public dynamic class StatisticRef extends PlayerStatsModule
   {
       
      
      public function StatisticRef()
      {
         super();
         this.__setProp_mcStatsList_Statistic_mcStatList_0();
      }
      
      internal function __setProp_mcStatsList_Statistic_mcStatList_0() : *
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
         mcStatsList.itemRendererName = "";
         mcStatsList.itemRendererInstanceName = "mcStatsListItem";
         mcStatsList.margin = 0;
         mcStatsList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcStatsList.PCDownAction = 83;
         mcStatsList.PCUpAction = 87;
         mcStatsList.rowHeight = 20;
         mcStatsList.scrollBar = "";
         mcStatsList.UpAction = 38;
         mcStatsList.visible = true;
         mcStatsList.wrapping = "wrap";
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
