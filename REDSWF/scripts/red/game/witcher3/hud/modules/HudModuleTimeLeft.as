package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   import scaleform.clik.controls.StatusIndicator;
   
   public class HudModuleTimeLeft extends HudModuleBase
   {
       
      
      public var mcDialogueBar:StatusIndicator;
      
      public function HudModuleTimeLeft()
      {
         super();
         this.__setProp_mcDialogueBar_Scene1_Layer1_0();
      }
      
      override public function get moduleName() : String
      {
         return "TimeLeftModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function setTimeOutPercent(param1:Number) : *
      {
         this.mcDialogueBar.value = param1;
      }
      
      internal function __setProp_mcDialogueBar_Scene1_Layer1_0() : *
      {
         try
         {
            this.mcDialogueBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcDialogueBar.enabled = true;
         this.mcDialogueBar.enableInitCallback = false;
         this.mcDialogueBar.maximum = 100;
         this.mcDialogueBar.minimum = 0;
         this.mcDialogueBar.value = 0;
         this.mcDialogueBar.visible = true;
         try
         {
            this.mcDialogueBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
