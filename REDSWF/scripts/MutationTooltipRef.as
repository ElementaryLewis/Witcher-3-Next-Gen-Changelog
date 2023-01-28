package
{
   import red.game.witcher3.menus.character_menu.MutationTooltip;
   
   public dynamic class MutationTooltipRef extends MutationTooltip
   {
       
      
      public function MutationTooltipRef()
      {
         super();
         this.__setProp_mcColorsList_MutationTooltip_colorslistanchor_0();
      }
      
      internal function __setProp_mcColorsList_MutationTooltip_colorslistanchor_0() : *
      {
         try
         {
            mcColorsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcColorsList.alignment = "left";
         mcColorsList.enabled = true;
         mcColorsList.enableInitCallback = false;
         mcColorsList.isHorizontal = true;
         mcColorsList.itemPadding = 25;
         mcColorsList.itemRendererName = "MutationTooltip_SkillColorItemRendererRef";
         mcColorsList.visible = true;
         try
         {
            mcColorsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
