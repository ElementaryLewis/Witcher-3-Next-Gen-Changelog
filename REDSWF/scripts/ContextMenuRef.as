package
{
   import red.game.witcher3.menus.overlay.ContextMenuPopup;
   
   public dynamic class ContextMenuRef extends ContextMenuPopup
   {
       
      
      public function ContextMenuRef()
      {
         super();
         this.__setProp_actionList_ContextMenu_actionsList_0();
      }
      
      internal function __setProp_actionList_ContextMenu_actionsList_0() : *
      {
         try
         {
            actionList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         actionList.DownAction = 40;
         actionList.enabled = true;
         actionList.enableInitCallback = false;
         actionList.focusable = true;
         actionList.itemRendererName = "ContextMenu_ItemRendererRef";
         actionList.itemRendererInstanceName = "";
         actionList.margin = 0;
         actionList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         actionList.rowHeight = 0;
         actionList.scrollBar = "";
         actionList.UpAction = 38;
         actionList.visible = true;
         actionList.wrapping = "normal";
         try
         {
            actionList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
