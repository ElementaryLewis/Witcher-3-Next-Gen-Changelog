package
{
   import red.game.witcher3.menus.character_menu.MutationRequirements;
   
   public dynamic class MutationTooltip_PanelRequirements extends MutationRequirements
   {
       
      
      public function MutationTooltip_PanelRequirements()
      {
         super();
         this.__setProp_mcRequitementsList_MutationTooltip_PanelRequirements_Layer5_0();
      }
      
      internal function __setProp_mcRequitementsList_MutationTooltip_PanelRequirements_Layer5_0() : *
      {
         try
         {
            mcRequitementsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRequitementsList.alignment = "left";
         mcRequitementsList.enabled = true;
         mcRequitementsList.enableInitCallback = false;
         mcRequitementsList.isHorizontal = false;
         mcRequitementsList.itemPadding = 0;
         mcRequitementsList.itemRendererName = "MutationRequirementItemRef";
         mcRequitementsList.visible = true;
         try
         {
            mcRequitementsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
