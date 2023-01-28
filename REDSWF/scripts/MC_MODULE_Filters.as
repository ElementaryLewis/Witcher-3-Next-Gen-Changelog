package
{
   import red.game.witcher3.menus.common.DropdownEnchantmentsFilterMode;
   
   public dynamic class MC_MODULE_Filters extends DropdownEnchantmentsFilterMode
   {
       
      
      public function MC_MODULE_Filters()
      {
         super();
         this.__setProp_mcItemRenderer1_MC_MODULE_Filters_mcItemRenderers_0();
         this.__setProp_mcItemRenderer2_MC_MODULE_Filters_mcItemRenderers_0();
         this.__setProp_mcItemRenderer3_MC_MODULE_Filters_mcItemRenderers_0();
         this.__setProp_mcItemRenderer4_MC_MODULE_Filters_mcItemRenderers_0();
         this.__setProp_mcItemRenderer5_MC_MODULE_Filters_mcItemRenderers_0();
         this.__setProp_mcList_MC_MODULE_Filters_mcList_0();
      }
      
      internal function __setProp_mcItemRenderer1_MC_MODULE_Filters_mcItemRenderers_0() : *
      {
         try
         {
            mcItemRenderer1["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcItemRenderer1.autoRepeat = false;
         mcItemRenderer1.autoSize = "none";
         mcItemRenderer1.data = "";
         mcItemRenderer1.dataKey = "";
         mcItemRenderer1.enabled = true;
         mcItemRenderer1.enableInitCallback = false;
         mcItemRenderer1.groupID = "unique";
         mcItemRenderer1.label = "";
         mcItemRenderer1.selected = false;
         mcItemRenderer1.toggle = false;
         mcItemRenderer1.visible = true;
         try
         {
            mcItemRenderer1["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcItemRenderer2_MC_MODULE_Filters_mcItemRenderers_0() : *
      {
         try
         {
            mcItemRenderer2["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcItemRenderer2.autoRepeat = false;
         mcItemRenderer2.autoSize = "none";
         mcItemRenderer2.data = "";
         mcItemRenderer2.dataKey = "";
         mcItemRenderer2.enabled = true;
         mcItemRenderer2.enableInitCallback = false;
         mcItemRenderer2.groupID = "unique";
         mcItemRenderer2.label = "";
         mcItemRenderer2.selected = false;
         mcItemRenderer2.toggle = false;
         mcItemRenderer2.visible = true;
         try
         {
            mcItemRenderer2["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcItemRenderer3_MC_MODULE_Filters_mcItemRenderers_0() : *
      {
         try
         {
            mcItemRenderer3["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcItemRenderer3.autoRepeat = false;
         mcItemRenderer3.autoSize = "none";
         mcItemRenderer3.data = "";
         mcItemRenderer3.dataKey = "";
         mcItemRenderer3.enabled = true;
         mcItemRenderer3.enableInitCallback = false;
         mcItemRenderer3.groupID = "unique";
         mcItemRenderer3.label = "";
         mcItemRenderer3.selected = false;
         mcItemRenderer3.toggle = false;
         mcItemRenderer3.visible = true;
         try
         {
            mcItemRenderer3["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcItemRenderer4_MC_MODULE_Filters_mcItemRenderers_0() : *
      {
         try
         {
            mcItemRenderer4["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcItemRenderer4.autoRepeat = false;
         mcItemRenderer4.autoSize = "none";
         mcItemRenderer4.data = "";
         mcItemRenderer4.dataKey = "";
         mcItemRenderer4.enabled = true;
         mcItemRenderer4.enableInitCallback = false;
         mcItemRenderer4.groupID = "unique";
         mcItemRenderer4.label = "";
         mcItemRenderer4.selected = false;
         mcItemRenderer4.toggle = false;
         mcItemRenderer4.visible = true;
         try
         {
            mcItemRenderer4["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcItemRenderer5_MC_MODULE_Filters_mcItemRenderers_0() : *
      {
         try
         {
            mcItemRenderer5["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcItemRenderer5.autoRepeat = false;
         mcItemRenderer5.autoSize = "none";
         mcItemRenderer5.data = "";
         mcItemRenderer5.dataKey = "";
         mcItemRenderer5.enabled = true;
         mcItemRenderer5.enableInitCallback = false;
         mcItemRenderer5.groupID = "unique";
         mcItemRenderer5.label = "";
         mcItemRenderer5.selected = false;
         mcItemRenderer5.toggle = false;
         mcItemRenderer5.visible = true;
         try
         {
            mcItemRenderer5["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcList_MC_MODULE_Filters_mcList_0() : *
      {
         try
         {
            mcList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcList.DownAction = 40;
         mcList.enabled = true;
         mcList.enableInitCallback = false;
         mcList.focusable = false;
         mcList.itemRendererName = "";
         mcList.itemRendererInstanceName = "mcItemRenderer";
         mcList.margin = 0;
         mcList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         mcList.PCDownAction = 83;
         mcList.PCUpAction = 87;
         mcList.rowHeight = 0;
         mcList.scrollBar = "";
         mcList.selectOnOver = false;
         mcList.UpAction = 38;
         mcList.visible = true;
         mcList.wrapping = "normal";
         try
         {
            mcList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
