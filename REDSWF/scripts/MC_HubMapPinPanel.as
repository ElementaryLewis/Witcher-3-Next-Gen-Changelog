package
{
   import red.game.witcher3.menus.worldmap.HubMapPinPanel;
   
   public dynamic class MC_HubMapPinPanel extends HubMapPinPanel
   {
       
      
      public function MC_HubMapPinPanel()
      {
         super();
         this.__setProp_mcHubMapPinCategoryList_MC_HubMapPinPanel_mcHubMapPinCategoryList_0();
      }
      
      internal function __setProp_mcHubMapPinCategoryList_MC_HubMapPinPanel_mcHubMapPinCategoryList_0() : *
      {
         try
         {
            mcHubMapPinCategoryList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcHubMapPinCategoryList.DownAction = 142;
         mcHubMapPinCategoryList.enabled = true;
         mcHubMapPinCategoryList.enableInitCallback = false;
         mcHubMapPinCategoryList.focusable = true;
         mcHubMapPinCategoryList.itemRendererName = "";
         mcHubMapPinCategoryList.itemRendererInstanceName = "";
         mcHubMapPinCategoryList.margin = 0;
         mcHubMapPinCategoryList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcHubMapPinCategoryList.PCDownAction = 87;
         mcHubMapPinCategoryList.PCUpAction = 83;
         mcHubMapPinCategoryList.reverseMouseWheel = true;
         mcHubMapPinCategoryList.rowHeight = 0;
         mcHubMapPinCategoryList.scrollBar = "";
         mcHubMapPinCategoryList.selectOnOver = false;
         mcHubMapPinCategoryList.UpAction = 143;
         mcHubMapPinCategoryList.visible = true;
         mcHubMapPinCategoryList.wrapping = "normal";
         try
         {
            mcHubMapPinCategoryList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
