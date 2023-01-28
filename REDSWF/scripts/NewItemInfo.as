package
{
   import red.game.witcher3.menus.common_menu.NewItemInfo;
   
   public dynamic class NewItemInfo extends red.game.witcher3.menus.common_menu.NewItemInfo
   {
       
      
      public function NewItemInfo()
      {
         super();
         this.__setProp_mcLoader_NewItemInfo_Layer1_0();
      }
      
      internal function __setProp_mcLoader_NewItemInfo_Layer1_0() : *
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
   }
}
