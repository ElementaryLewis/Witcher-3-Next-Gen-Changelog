package
{
   import red.game.witcher3.menus.glossary.GlossaryTextureSubListModule;
   
   public dynamic class MC_MODULE_GlossaryTextureSubList extends GlossaryTextureSubListModule
   {
       
      
      public function MC_MODULE_GlossaryTextureSubList()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcLoader_MC_MODULE_GlossaryTextureSubList_mcLoader_0();
      }
      
      internal function __setProp_mcLoader_MC_MODULE_GlossaryTextureSubList_mcLoader_0() : *
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
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
