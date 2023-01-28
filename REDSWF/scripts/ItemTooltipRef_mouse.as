package
{
   import red.game.witcher3.tooltips.TooltipInventory;
   
   public dynamic class ItemTooltipRef_mouse extends TooltipInventory
   {
       
      
      public function ItemTooltipRef_mouse()
      {
         super();
         this.__setProp_mcPropertyList_ItemTooltip_mouse_listProps_0();
         this.__setProp_mcSocketList_ItemTooltip_mouse_listSockets_0();
         this.__setProp_mcAttributeList_ItemTooltip_mouse_listStats_0();
         this.__setProp_mcSetAttributeList_ItemTooltip_mouse_listSetStats_0();
      }
      
      internal function __setProp_mcPropertyList_ItemTooltip_mouse_listProps_0() : *
      {
         try
         {
            mcPropertyList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPropertyList.alignment = "left";
         mcPropertyList.enabled = true;
         mcPropertyList.enableInitCallback = false;
         mcPropertyList.isHorizontal = true;
         mcPropertyList.itemPadding = 17;
         mcPropertyList.itemRendererName = "PropertyRendererRef_mouse";
         mcPropertyList.visible = true;
         try
         {
            mcPropertyList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcSocketList_ItemTooltip_mouse_listSockets_0() : *
      {
         try
         {
            mcSocketList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSocketList.enabled = true;
         mcSocketList.enableInitCallback = false;
         mcSocketList.isHorizontal = false;
         mcSocketList.itemPadding = -3;
         mcSocketList.itemRendererName = "SocketRendererRef_mouse";
         mcSocketList.visible = true;
         try
         {
            mcSocketList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcAttributeList_ItemTooltip_mouse_listStats_0() : *
      {
         try
         {
            mcAttributeList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcAttributeList.enabled = true;
         mcAttributeList.enableInitCallback = false;
         mcAttributeList.itemPadding = -7;
         mcAttributeList.itemRendererName = "AttributeRendererRef_mouse";
         mcAttributeList.visible = true;
         try
         {
            mcAttributeList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcSetAttributeList_ItemTooltip_mouse_listSetStats_0() : *
      {
         try
         {
            mcSetAttributeList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSetAttributeList.enabled = true;
         mcSetAttributeList.enableInitCallback = false;
         mcSetAttributeList.itemPadding = 8;
         mcSetAttributeList.itemRendererName = "SetAttributeRendererRef";
         mcSetAttributeList.visible = true;
         try
         {
            mcSetAttributeList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
