package
{
   import red.game.witcher3.tooltips.TooltipDescription;
   
   public dynamic class ItemDescriptionTooltipRef extends TooltipDescription
   {
       
      
      public function ItemDescriptionTooltipRef()
      {
         super();
         this.__setProp_listStats_ItemDescriptionTooltip_statsList_0();
         this.__setProp_propsList_ItemDescriptionTooltip_propsList_0();
      }
      
      internal function __setProp_listStats_ItemDescriptionTooltip_statsList_0() : *
      {
         try
         {
            listStats["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         listStats.enabled = true;
         listStats.enableInitCallback = false;
         listStats.itemPadding = 0;
         listStats.itemRendererName = "AttributeRendererRef";
         listStats.visible = true;
         try
         {
            listStats["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_propsList_ItemDescriptionTooltip_propsList_0() : *
      {
         try
         {
            propsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         propsList.enabled = true;
         propsList.enableInitCallback = false;
         propsList.isHorizontal = true;
         propsList.itemPadding = 0;
         propsList.itemRendererName = "PropertyRendererRef";
         propsList.visible = true;
         try
         {
            propsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
