package
{
   import red.game.witcher3.menus.meditation_menu.MeditationClock;
   
   public dynamic class MeditationClock extends red.game.witcher3.menus.meditation_menu.MeditationClock
   {
       
      
      public var __id0_:ConsoleButtonHighlight;
      
      public function MeditationClock()
      {
         super();
         this.__setProp___id0__MeditationClock_mcConsoleBtnHighlight_0();
      }
      
      internal function __setProp___id0__MeditationClock_mcConsoleBtnHighlight_0() : *
      {
         try
         {
            this.__id0_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id0_.autoRepeat = false;
         this.__id0_.autoSize = "none";
         this.__id0_.data = "";
         this.__id0_.enabled = true;
         this.__id0_.enableInitCallback = false;
         this.__id0_.focusable = true;
         this.__id0_.label = "";
         this.__id0_.selected = false;
         this.__id0_.showOnGamepad = true;
         this.__id0_.showOnMouseKeyboard = false;
         this.__id0_.toggle = false;
         this.__id0_.visible = true;
         try
         {
            this.__id0_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
