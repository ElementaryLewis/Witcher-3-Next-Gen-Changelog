package hud_enemyfocus_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class MC_IMG_EnemyFocusFeedback_1 extends MovieClip
   {
       
      
      public var tfName:TextField;
      
      public var mcDodgeFeedback:MovieClip;
      
      public var mcCharacterIcon:MovieClip;
      
      public var mcDamageTextAnim:MovieClip;
      
      public var mcHealthBar:NPCStatusIndicator;
      
      public var mcMutation8Feedback:MovieClip;
      
      public var mcStaminaDelay:NPCStaminaDelayIndicator;
      
      public var mcStaminaBar:NPCStaminaIndicator;
      
      public var mcEnemyLevel:MovieClip;
      
      public var mcFocusLock:MovieClip;
      
      public function MC_IMG_EnemyFocusFeedback_1()
      {
         super();
         this.__setProp_mcStaminaBar_MC_IMG_EnemyFocusFeedback_mcNPCStamina_0();
         this.__setProp_mcHealthBar_MC_IMG_EnemyFocusFeedback_mcNPCHealth_0();
      }
      
      internal function __setProp_mcStaminaBar_MC_IMG_EnemyFocusFeedback_mcNPCStamina_0() : *
      {
         try
         {
            this.mcStaminaBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcStaminaBar.enabled = true;
         this.mcStaminaBar.enableInitCallback = false;
         this.mcStaminaBar.maximum = 100;
         this.mcStaminaBar.minimum = 0;
         this.mcStaminaBar.value = 56;
         this.mcStaminaBar.visible = true;
         try
         {
            this.mcStaminaBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcHealthBar_MC_IMG_EnemyFocusFeedback_mcNPCHealth_0() : *
      {
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcHealthBar.enabled = true;
         this.mcHealthBar.enableInitCallback = false;
         this.mcHealthBar.maximum = 100;
         this.mcHealthBar.minimum = 0;
         this.mcHealthBar.value = 56;
         this.mcHealthBar.visible = true;
         try
         {
            this.mcHealthBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
