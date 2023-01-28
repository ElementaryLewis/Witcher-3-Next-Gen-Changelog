package
{
   import red.game.witcher3.menus.worldmap.UserPinPanel;
   
   public dynamic class UserPinPanelRef extends UserPinPanel
   {
       
      
      public function UserPinPanelRef()
      {
         super();
         this.__setProp_mcUserPinsList_MC_UserPinPanel_mcUserPinsList_0();
      }
      
      internal function __setProp_mcUserPinsList_MC_UserPinPanel_mcUserPinsList_0() : *
      {
         try
         {
            mcUserPinsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcUserPinsList.DownAction = 39;
         mcUserPinsList.enabled = true;
         mcUserPinsList.enableInitCallback = false;
         mcUserPinsList.focusable = true;
         mcUserPinsList.itemRendererName = "";
         mcUserPinsList.itemRendererInstanceName = "mcUserPin";
         mcUserPinsList.margin = -1;
         mcUserPinsList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcUserPinsList.PCDownAction = 83;
         mcUserPinsList.PCUpAction = 87;
         mcUserPinsList.rowHeight = 0;
         mcUserPinsList.scrollBar = "";
         mcUserPinsList.selectOnOver = false;
         mcUserPinsList.UpAction = 37;
         mcUserPinsList.visible = true;
         mcUserPinsList.wrapping = "normal";
         try
         {
            mcUserPinsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
