package hud_bossfocus_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class MC_BOSS_Indicator_1 extends MovieClip
   {
       
      
      public var tfBossName:TextField;
      
      public var mcBossHealth:BossStatusIndicator;
      
      public function MC_BOSS_Indicator_1()
      {
         super();
         this.__setProp_mcBossHealth_MC_BOSS_Indicator_Layer1_0();
      }
      
      internal function __setProp_mcBossHealth_MC_BOSS_Indicator_Layer1_0() : *
      {
         try
         {
            this.mcBossHealth["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcBossHealth.enabled = true;
         this.mcBossHealth.enableInitCallback = false;
         this.mcBossHealth.maximum = 100;
         this.mcBossHealth.minimum = 0;
         this.mcBossHealth.value = 56;
         this.mcBossHealth.visible = true;
         try
         {
            this.mcBossHealth["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
