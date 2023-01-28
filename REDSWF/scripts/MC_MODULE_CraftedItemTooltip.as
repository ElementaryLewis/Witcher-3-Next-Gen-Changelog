package
{
   import red.game.witcher3.modules.ItemTooltipModule;
   
   public dynamic class MC_MODULE_CraftedItemTooltip extends ItemTooltipModule
   {
       
      
      public function MC_MODULE_CraftedItemTooltip()
      {
         super();
         this.__setProp_mcAttributesList_MC_MODULE_CraftedItemTooltip_attributes_0();
      }
      
      internal function __setProp_mcAttributesList_MC_MODULE_CraftedItemTooltip_attributes_0() : *
      {
         try
         {
            mcAttributesList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcAttributesList.alignment = "left";
         mcAttributesList.enabled = true;
         mcAttributesList.enableInitCallback = false;
         mcAttributesList.isHorizontal = false;
         mcAttributesList.itemPadding = 4;
         mcAttributesList.itemRendererName = "StatsItemRendererRef";
         mcAttributesList.visible = true;
         try
         {
            mcAttributesList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
