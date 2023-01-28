package
{
   import red.game.witcher3.menus.common_menu.MenuHub;
   
   public dynamic class mcMenuHub extends MenuHub
   {
       
      
      public function mcMenuHub()
      {
         super();
         this.__setProp_mcBotTabList_mcMenuHub_mcBotTabList_0();
         this.__setProp_mcTopTabList_mcMenuHub_mcTopTabList_0();
         this.__setProp_txtTabNewDesc_mcMenuHub_txtTabNewDesc_0();
         this.__setProp_txtTopMainDesc_mcMenuHub_txtTopMainDesc_0();
         this.__setProp_txtBottomDesc_mcMenuHub_txtTopMainDesc_0();
         this.__setProp_txtNextTabName_mcMenuHub_txtNextTabName_0();
         this.__setProp_txtPrevTabName_mcMenuHub_txtPrevTabName_0();
         this.__setProp_mcRightPCButton_mcMenuHub_mcRightPCButton_0();
         this.__setProp_mcLeftPCButton_mcMenuHub_mcLeftPCButton_0();
      }
      
      internal function __setProp_mcBotTabList_mcMenuHub_mcBotTabList_0() : *
      {
         try
         {
            mcBotTabList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcBotTabList.DownAction = 39;
         mcBotTabList.enabled = true;
         mcBotTabList.enableInitCallback = false;
         mcBotTabList.focusable = false;
         mcBotTabList.itemRendererName = "";
         mcBotTabList.itemRendererInstanceName = "mcBotTabListItem";
         mcBotTabList.margin = 0;
         mcBotTabList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcBotTabList.PCDownAction = 68;
         mcBotTabList.PCUpAction = 65;
         mcBotTabList.rowHeight = 0;
         mcBotTabList.scrollBar = "";
         mcBotTabList.UpAction = 37;
         mcBotTabList.visible = true;
         mcBotTabList.wrapping = "wrap";
         try
         {
            mcBotTabList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcTopTabList_mcMenuHub_mcTopTabList_0() : *
      {
         try
         {
            mcTopTabList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcTopTabList.DownAction = 39;
         mcTopTabList.enabled = true;
         mcTopTabList.enableInitCallback = false;
         mcTopTabList.focusable = false;
         mcTopTabList.itemRendererName = "";
         mcTopTabList.itemRendererInstanceName = "mcTopTabListItem";
         mcTopTabList.margin = 0;
         mcTopTabList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcTopTabList.PCDownAction = 68;
         mcTopTabList.PCUpAction = 65;
         mcTopTabList.rowHeight = 0;
         mcTopTabList.scrollBar = "";
         mcTopTabList.UpAction = 37;
         mcTopTabList.visible = true;
         mcTopTabList.wrapping = "wrap";
         try
         {
            mcTopTabList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtTabNewDesc_mcMenuHub_txtTabNewDesc_0() : *
      {
         try
         {
            txtTabNewDesc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtTabNewDesc.actAsButton = false;
         txtTabNewDesc.defaultText = "";
         txtTabNewDesc.displayAsPassword = false;
         txtTabNewDesc.editable = false;
         txtTabNewDesc.enabled = true;
         txtTabNewDesc.enableInitCallback = false;
         txtTabNewDesc.focusable = false;
         txtTabNewDesc.maxChars = 0;
         txtTabNewDesc.minThumbSize = 1;
         txtTabNewDesc.scrollBar = "";
         txtTabNewDesc.scrollSpeed = 40;
         txtTabNewDesc.text = "";
         txtTabNewDesc.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtTabNewDesc.visible = true;
         try
         {
            txtTabNewDesc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtTopMainDesc_mcMenuHub_txtTopMainDesc_0() : *
      {
         try
         {
            txtTopMainDesc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtTopMainDesc.actAsButton = false;
         txtTopMainDesc.defaultText = "";
         txtTopMainDesc.displayAsPassword = false;
         txtTopMainDesc.editable = false;
         txtTopMainDesc.enabled = true;
         txtTopMainDesc.enableInitCallback = false;
         txtTopMainDesc.focusable = false;
         txtTopMainDesc.maxChars = 0;
         txtTopMainDesc.minThumbSize = 1;
         txtTopMainDesc.scrollBar = "";
         txtTopMainDesc.scrollSpeed = 40;
         txtTopMainDesc.text = "";
         txtTopMainDesc.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtTopMainDesc.visible = true;
         try
         {
            txtTopMainDesc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtBottomDesc_mcMenuHub_txtTopMainDesc_0() : *
      {
         try
         {
            txtBottomDesc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtBottomDesc.actAsButton = false;
         txtBottomDesc.defaultText = "";
         txtBottomDesc.displayAsPassword = false;
         txtBottomDesc.editable = false;
         txtBottomDesc.enabled = true;
         txtBottomDesc.enableInitCallback = false;
         txtBottomDesc.focusable = false;
         txtBottomDesc.maxChars = 0;
         txtBottomDesc.minThumbSize = 1;
         txtBottomDesc.scrollBar = "";
         txtBottomDesc.scrollSpeed = 40;
         txtBottomDesc.text = "";
         txtBottomDesc.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtBottomDesc.visible = true;
         try
         {
            txtBottomDesc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtNextTabName_mcMenuHub_txtNextTabName_0() : *
      {
         try
         {
            txtNextTabName["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtNextTabName.actAsButton = false;
         txtNextTabName.defaultText = "";
         txtNextTabName.displayAsPassword = false;
         txtNextTabName.editable = false;
         txtNextTabName.enabled = true;
         txtNextTabName.enableInitCallback = false;
         txtNextTabName.focusable = false;
         txtNextTabName.maxChars = 0;
         txtNextTabName.minThumbSize = 1;
         txtNextTabName.scrollBar = "";
         txtNextTabName.scrollSpeed = 40;
         txtNextTabName.text = "";
         txtNextTabName.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtNextTabName.visible = true;
         try
         {
            txtNextTabName["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtPrevTabName_mcMenuHub_txtPrevTabName_0() : *
      {
         try
         {
            txtPrevTabName["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtPrevTabName.actAsButton = false;
         txtPrevTabName.defaultText = "";
         txtPrevTabName.displayAsPassword = false;
         txtPrevTabName.editable = false;
         txtPrevTabName.enabled = true;
         txtPrevTabName.enableInitCallback = false;
         txtPrevTabName.focusable = false;
         txtPrevTabName.maxChars = 0;
         txtPrevTabName.minThumbSize = 1;
         txtPrevTabName.scrollBar = "";
         txtPrevTabName.scrollSpeed = 40;
         txtPrevTabName.text = "";
         txtPrevTabName.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtPrevTabName.visible = true;
         try
         {
            txtPrevTabName["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcRightPCButton_mcMenuHub_mcRightPCButton_0() : *
      {
         try
         {
            mcRightPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRightPCButton.autoRepeat = false;
         mcRightPCButton.autoSize = "none";
         mcRightPCButton.data = "";
         mcRightPCButton.enabled = true;
         mcRightPCButton.enableInitCallback = false;
         mcRightPCButton.focusable = false;
         mcRightPCButton.label = "";
         mcRightPCButton.selected = false;
         mcRightPCButton.showOnGamepad = false;
         mcRightPCButton.showOnMouseKeyboard = true;
         mcRightPCButton.toggle = false;
         mcRightPCButton.visible = true;
         try
         {
            mcRightPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcLeftPCButton_mcMenuHub_mcLeftPCButton_0() : *
      {
         try
         {
            mcLeftPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcLeftPCButton.autoRepeat = false;
         mcLeftPCButton.autoSize = "none";
         mcLeftPCButton.data = "";
         mcLeftPCButton.enabled = true;
         mcLeftPCButton.enableInitCallback = false;
         mcLeftPCButton.focusable = false;
         mcLeftPCButton.label = "";
         mcLeftPCButton.selected = false;
         mcLeftPCButton.showOnGamepad = false;
         mcLeftPCButton.showOnMouseKeyboard = true;
         mcLeftPCButton.toggle = false;
         mcLeftPCButton.visible = true;
         try
         {
            mcLeftPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
