package
{
   import red.game.witcher3.menus.preparation_menu.ModuleMonsterTrack;
   
   public dynamic class MC_MODULE_MonsterTrack extends ModuleMonsterTrack
   {
       
      
      public function MC_MODULE_MonsterTrack()
      {
         super();
         this.__setProp_mcRewards_MC_MODULE_MonsterTrack_mcRewards_0();
      }
      
      internal function __setProp_mcRewards_MC_MODULE_MonsterTrack_mcRewards_0() : *
      {
         try
         {
            mcRewards["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRewards.columns = 5;
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
   }
}
