package
{
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   
   public dynamic class HealthStatusIndicator extends W3StatIndicator
   {
       
      
      public function HealthStatusIndicator()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_mcBackgroundHealth_HealthStatusIndicator_Graphic_BackgroundHealth_0();
      }
      
      internal function __setProp_mcBackgroundHealth_HealthStatusIndicator_Graphic_BackgroundHealth_0() : *
      {
         try
         {
            mcBackgroundHealth["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcBackgroundHealth.enabled = true;
         mcBackgroundHealth.enableInitCallback = false;
         mcBackgroundHealth.maximum = 100;
         mcBackgroundHealth.minimum = 0;
         mcBackgroundHealth.tweenDuration = 400;
         mcBackgroundHealth.value = 80;
         mcBackgroundHealth.visible = true;
         try
         {
            mcBackgroundHealth["componentInspectorSetting"] = false;
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
