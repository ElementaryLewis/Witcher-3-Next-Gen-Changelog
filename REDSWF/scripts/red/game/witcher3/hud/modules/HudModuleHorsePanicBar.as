package red.game.witcher3.hud.modules
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   
   public class HudModuleHorsePanicBar extends HudModuleBase
   {
      
      private static const BAR_LERP_SPEED:Number = 1000;
      
      private static const FADE_IN_DURATION:Number = 1000;
       
      
      public var mcPanicBar:StatusIndicator;
      
      public var textField:TextField;
      
      public function HudModuleHorsePanicBar()
      {
         addFrameScript(0,this.frame1);
         super();
         isAlwaysDynamic = true;
         this.__setProp_mcPanicBar_Scene1_mcStaminaBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "HorsePanicBarModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = true;
         alpha = 0;
         this.textField.htmlText = "[[panel_hud_horse_panic]]";
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(this.textField.htmlText);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setPanic(param1:Number) : void
      {
         this.mcPanicBar.value = param1 * 100;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function reset() : void
      {
         this.mcPanicBar.value = 0;
      }
      
      internal function __setProp_mcPanicBar_Scene1_mcStaminaBar_0() : *
      {
         try
         {
            this.mcPanicBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcPanicBar.enabled = true;
         this.mcPanicBar.enableInitCallback = false;
         this.mcPanicBar.maximum = 100;
         this.mcPanicBar.minimum = 0;
         this.mcPanicBar.value = 0;
         this.mcPanicBar.visible = true;
         try
         {
            this.mcPanicBar["componentInspectorSetting"] = false;
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
