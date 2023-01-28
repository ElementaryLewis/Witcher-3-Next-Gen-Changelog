package red.game.witcher3.hud.modules
{
   import red.core.events.GameEvent;
   
   public class HudModuleConsole extends HudModuleBase
   {
       
      
      public var messagesQueue:mcConsoleMessagesQueue;
      
      public function HudModuleConsole()
      {
         super();
         this.__setProp_messagesQueue_Scene1_Layer1_0();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         alpha = 0;
      }
      
      override public function get moduleName() : String
      {
         return "ConsoleModule";
      }
      
      public function showMessage(param1:String) : void
      {
         if(visible)
         {
            this.messagesQueue.pushMessage(param1);
         }
      }
      
      public function cleanup() : void
      {
      }
      
      public function debugMessage() : void
      {
         var _loc1_:String = "Customized <img src = \'icons/inventory/raspberryjuice_64x64.dds\' /> to fit any desired style or theme!";
         this.messagesQueue.pushMessage("Some <font color = \'#FF5555\'>message</font> " + Math.round(Math.random() * 1000) + _loc1_);
      }
      
      internal function __setProp_messagesQueue_Scene1_Layer1_0() : *
      {
         try
         {
            this.messagesQueue["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.messagesQueue.direction = "up";
         this.messagesQueue.enabled = true;
         this.messagesQueue.enableInitCallback = false;
         this.messagesQueue.padding = 1;
         this.messagesQueue.msgVisibilityDuration = 750;
         this.messagesQueue.visible = true;
         try
         {
            this.messagesQueue["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
