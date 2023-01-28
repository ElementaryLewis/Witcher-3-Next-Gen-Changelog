package
{
   import red.game.witcher3.menus.perks_menu.ModuleSkillList;
   
   public dynamic class GridModuleRef extends ModuleSkillList
   {
       
      
      public function GridModuleRef()
      {
         super();
         this.__setProp_mcPlayerGrid_GridModule_mcPlayerGrid_0();
      }
      
      internal function __setProp_mcPlayerGrid_GridModule_mcPlayerGrid_0() : *
      {
         try
         {
            mcPlayerGrid["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcPlayerGrid.enabled = true;
         mcPlayerGrid.enableInitCallback = false;
         mcPlayerGrid.slotRendererName = "SlotSkillGridRef";
         mcPlayerGrid.visible = true;
         try
         {
            mcPlayerGrid["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
