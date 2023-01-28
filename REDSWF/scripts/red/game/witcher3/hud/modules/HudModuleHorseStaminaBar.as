package red.game.witcher3.hud.modules
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   
   public class HudModuleHorseStaminaBar extends HudModuleBase
   {
      
      private static const BAR_LERP_SPEED:Number = 1000;
      
      private static const FADE_IN_DURATION:Number = 1000;
       
      
      public var mcStaminaBar:StatusIndicator;
      
      public var textField:TextField;
      
      public function HudModuleHorseStaminaBar()
      {
         addFrameScript(0,this.frame1);
         super();
         isAlwaysDynamic = true;
         this.__setProp_mcStaminaBar_Scene1_Graphic_StaminaBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "HorseStaminaBarModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         alpha = 0;
         this.textField.htmlText = "[[panel_hud_horse_stamina]]";
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(this.textField.htmlText);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setStamina(param1:Number) : void
      {
         this.mcStaminaBar.value = param1 * 100;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function reset() : void
      {
         this.mcStaminaBar.value = 100;
      }
      
      public function ShowStaminaIndicator(param1:Number, param2:Number) : void
      {
      }
      
      internal function __setProp_mcStaminaBar_Scene1_Graphic_StaminaBar_0() : *
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
         this.mcStaminaBar.value = 0;
         this.mcStaminaBar.visible = true;
         try
         {
            this.mcStaminaBar["componentInspectorSetting"] = false;
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
