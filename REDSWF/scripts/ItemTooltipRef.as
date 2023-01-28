package
{
   import red.game.witcher3.tooltips.TooltipInventory;
   
   public dynamic class ItemTooltipRef extends TooltipInventory
   {
       
      
      public function ItemTooltipRef()
      {
         super();
         this.__setProp_mcPropertyList_ItemTooltip_listProps_0();
         this.__setProp_mcSocketList_ItemTooltip_listSockets_0();
         this.__setProp_mcAttributeList_ItemTooltip_listStats_0();
      }
      
      internal function __setProp_mcPropertyList_ItemTooltip_listProps_0() : *
      {
         try
         {
            mcPropertyList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPropertyList.alignment = "right";
         mcPropertyList.enabled = true;
         mcPropertyList.enableInitCallback = false;
         mcPropertyList.isHorizontal = false;
         mcPropertyList.itemPadding = 0;
         mcPropertyList.itemRendererName = "PropertyRendererRef";
         mcPropertyList.visible = true;
         try
         {
            mcPropertyList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcSocketList_ItemTooltip_listSockets_0() : *
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
         mcSocketList.itemPadding = 0;
         mcSocketList.itemRendererName = "SocketRendererRef";
         mcSocketList.visible = true;
         try
         {
            mcSocketList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcAttributeList_ItemTooltip_listStats_0() : *
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
         mcAttributeList.itemPadding = 0;
         mcAttributeList.itemRendererName = "AttributeRendererRef";
         mcAttributeList.visible = true;
         try
         {
            mcAttributeList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
