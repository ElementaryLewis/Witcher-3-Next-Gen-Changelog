package
{
   import red.game.witcher3.menus.worldmap.HubMapQuestTracker;
   
   public dynamic class HubMapQuestTrackerRef extends HubMapQuestTracker
   {
       
      
      public function HubMapQuestTrackerRef()
      {
         super();
         this.__setProp_mcHubMapQuestTrackerList_MC_HubMapQuestTracker_mcHubMapQuestTrackerList_0();
      }
      
      internal function __setProp_mcHubMapQuestTrackerList_MC_HubMapQuestTracker_mcHubMapQuestTrackerList_0() : *
      {
         try
         {
            mcHubMapQuestTrackerList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHubMapQuestTrackerList.DownAction = 40;
         mcHubMapQuestTrackerList.enabled = true;
         mcHubMapQuestTrackerList.enableInitCallback = false;
         mcHubMapQuestTrackerList.focusable = true;
         mcHubMapQuestTrackerList.itemRendererName = "";
         mcHubMapQuestTrackerList.itemRendererInstanceName = "mcHubMapQuestTrackerItem";
         mcHubMapQuestTrackerList.margin = 0;
         mcHubMapQuestTrackerList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcHubMapQuestTrackerList.PCDownAction = 83;
         mcHubMapQuestTrackerList.PCUpAction = 87;
         mcHubMapQuestTrackerList.reverseMouseWheel = false;
         mcHubMapQuestTrackerList.rowHeight = 0;
         mcHubMapQuestTrackerList.scrollBar = "";
         mcHubMapQuestTrackerList.selectOnOver = false;
         mcHubMapQuestTrackerList.UpAction = 38;
         mcHubMapQuestTrackerList.visible = true;
         mcHubMapQuestTrackerList.wrapping = "normal";
         try
         {
            mcHubMapQuestTrackerList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
