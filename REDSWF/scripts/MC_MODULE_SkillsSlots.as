package
{
   import red.game.witcher3.menus.character_menu.ModuleSkillsSockets;
   
   public dynamic class MC_MODULE_SkillsSlots extends ModuleSkillsSockets
   {
       
      
      public function MC_MODULE_SkillsSlots()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_socketsList_MC_MODULE_SkillsSlots_list_0();
      }
      
      internal function __setProp_socketsList_MC_MODULE_SkillsSlots_list_0() : *
      {
         try
         {
            socketsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         socketsList.enabled = true;
         socketsList.enableInitCallback = false;
         socketsList.internalRenderers = false;
         socketsList.slotRendererName = "";
         socketsList.visible = true;
         try
         {
            socketsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
