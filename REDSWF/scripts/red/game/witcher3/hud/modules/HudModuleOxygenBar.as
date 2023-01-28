package red.game.witcher3.hud.modules
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.StatusIndicator;
   
   public class HudModuleOxygenBar extends HudModuleBase
   {
      
      private static const BAR_LERP_SPEED:Number = 1000;
      
      private static const FADE_IN_DURATION:Number = 1000;
       
      
      public var mcOxygeneBar:StatusIndicator;
      
      public var textField:TextField;
      
      public function HudModuleOxygenBar()
      {
         addFrameScript(0,this.frame1);
         super();
         isAlwaysDynamic = true;
         this.__setProp_mcOxygeneBar_Scene1_Graphic_OxygenBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "OxygenBarModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         alpha = 0;
         this.textField.htmlText = "[[panel_hud_breath]]";
         this.textField.htmlText = CommonUtils.toUpperCaseSafe(this.textField.htmlText);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setOxygene(param1:Number) : void
      {
         this.mcOxygeneBar.value = param1 * 100;
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function reset() : void
      {
         this.mcOxygeneBar.value = 100;
      }
      
      internal function __setProp_mcOxygeneBar_Scene1_Graphic_OxygenBar_0() : *
      {
         try
         {
            this.mcOxygeneBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcOxygeneBar.enabled = true;
         this.mcOxygeneBar.enableInitCallback = false;
         this.mcOxygeneBar.maximum = 100;
         this.mcOxygeneBar.minimum = 0;
         this.mcOxygeneBar.value = 100;
         this.mcOxygeneBar.visible = true;
         try
         {
            this.mcOxygeneBar["componentInspectorSetting"] = false;
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
