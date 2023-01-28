package red.game.witcher3.menus.mainmenu
{
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.data.KeyBindingData;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class StartupMoviesMenu extends CoreMenu
   {
       
      
      public var btnSkip:InputFeedbackButton;
      
      public var mcLogoLoader:W3UILoader;
      
      public var tfSubtitles:TextField;
      
      public function StartupMoviesMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         SHOW_ANIM_OFFSET = 0;
         SHOW_ANIM_DURATION = 2;
         this.__setProp_mcLogoLoader_Scene1_mcLogoLoader_0();
      }
      
      override protected function get menuName() : String
      {
         return "StartupMoviesMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         upToCloseEnabled = false;
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"startup.movies.buttons.setup",[this.handleSetupButtons]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.tfSubtitles.htmlText = "";
         this.btnSkip.clickable = false;
         this.btnSkip.visible = false;
         this.btnSkip.validateNow();
      }
      
      protected function handleSetupButtons(param1:Object, param2:int) : void
      {
         var _loc4_:KeyBindingData = null;
         var _loc3_:Array = param1 as Array;
         if(_loc4_ = _loc3_[0] as KeyBindingData)
         {
            this.btnSkip.clickable = false;
            this.btnSkip.visible = true;
            this.btnSkip.setDataFromStage(_loc4_.gamepad_navEquivalent,_loc4_.keyboard_keyCode,_loc4_.gamepad_keyCode);
            this.btnSkip.label = _loc4_.label;
         }
         else
         {
            this.btnSkip.visible = false;
         }
      }
      
      public function setSubtitles(param1:String) : void
      {
         this.tfSubtitles.htmlText = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:Boolean = false;
         if(param1.handled)
         {
            return;
         }
         if(this.btnSkip.visible)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
            if(_loc3_ && !param1.handled)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_B:
                     param1.handled = true;
                     return;
                  case NavigationCode.GAMEPAD_X:
                     param1.handled = true;
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnSkipMovie"));
               }
            }
            if(_loc3_ && !param1.handled)
            {
               switch(_loc2_.code)
               {
                  case KeyCode.SPACE:
                  case KeyCode.ESCAPE:
                     param1.handled = true;
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnSkipMovie"));
               }
            }
         }
         param1.handled = true;
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
      }
      
      public function setGameLogoLanguage(param1:Boolean, param2:String) : void
      {
         if(this.mcLogoLoader)
         {
            this.mcLogoLoader.visible = param1;
            if(param1)
            {
               if(param2 != "RU" || param2 != "CZ" || param2 != "PL")
               {
                  param2 = "EN";
               }
               this.mcLogoLoader.source = "img://icons/Logos/WitcherLogo_" + param2 + ".png";
            }
         }
      }
      
      internal function __setProp_mcLogoLoader_Scene1_mcLogoLoader_0() : *
      {
         try
         {
            this.mcLogoLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcLogoLoader.autoSize = false;
         this.mcLogoLoader.enableInitCallback = false;
         this.mcLogoLoader.maintainAspectRatio = false;
         this.mcLogoLoader.source = "";
         this.mcLogoLoader.visible = true;
         try
         {
            this.mcLogoLoader["componentInspectorSetting"] = false;
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
