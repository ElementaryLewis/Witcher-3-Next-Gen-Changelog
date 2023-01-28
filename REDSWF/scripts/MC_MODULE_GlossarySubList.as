package
{
   import red.game.witcher3.menus.glossary.GlossarySubListModule;
   
   public dynamic class MC_MODULE_GlossarySubList extends GlossarySubListModule
   {
       
      
      public function MC_MODULE_GlossarySubList()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcLoader_MC_MODULE_GlossarySubList_mcLoader_0();
         this.__setProp_mcRewards_MC_MODULE_GlossarySubList_mcRewards_0();
      }
      
      internal function __setProp_mcLoader_MC_MODULE_GlossarySubList_mcLoader_0() : *
      {
         try
         {
            mcLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcLoader.autoSize = false;
         mcLoader.enableInitCallback = false;
         mcLoader.maintainAspectRatio = false;
         mcLoader.source = "";
         mcLoader.visible = true;
         try
         {
            mcLoader["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcRewards_MC_MODULE_GlossarySubList_mcRewards_0() : *
      {
         try
         {
            mcRewards["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRewards.columns = 6;
         mcRewards.enabled = true;
         mcRewards.enableInitCallback = false;
         mcRewards.visible = true;
         try
         {
            mcRewards["componentInspectorSetting"] = false;
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
