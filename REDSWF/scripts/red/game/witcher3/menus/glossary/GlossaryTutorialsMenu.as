package red.game.witcher3.menus.glossary
{
   import flash.events.Event;
   import red.core.CoreComponent;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GlossaryTutorialsMenu extends CoreMenu
   {
       
      
      public var mcMainListModule:DropdownListModuleBase;
      
      public var mcGlossarySubModule:GlossaryTextureSubListModule;
      
      public var mcTextAreaModule:TextAreaModuleCustomInput;
      
      public function GlossaryTutorialsMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         this.mcMainListModule.menuName = this.menuName;
         this.mcGlossarySubModule.dataBindingKey = "glossary.tutorials";
         this.__setProp_mcMainListModule_Scene1_mcMainListModule_0();
      }
      
      override protected function get menuName() : String
      {
         return "GlossaryTutorialsMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerUpdate,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         focused = 1;
      }
      
      private function handleControllerUpdate(param1:Event) : void
      {
         this.mcMainListModule.mcDropDownList.clearRenderers();
         this.mcMainListModule.validateNow();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnUpdateTutorials"));
         this.mcMainListModule.removeEventListener(Event.CHANGE,this.handleDataChanged);
         this.mcMainListModule.addEventListener(Event.CHANGE,this.handleDataChanged,false,0,true);
      }
      
      private function handleDataChanged(param1:Event) : void
      {
         this.mcMainListModule.removeEventListener(Event.CHANGE,this.handleDataChanged);
         this.mcMainListModule.mcDropDownList.selectedIndex = 0;
         this.mcMainListModule.mcDropDownList.validateNow();
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         this.mcGlossarySubModule.visible = param1;
         this.mcGlossarySubModule.enabled = param1;
         this.mcTextAreaModule.visible = param1;
         this.mcTextAreaModule.enabled = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         var _loc3_:InputDetails = null;
         var _loc4_:* = false;
         if(param1.handled)
         {
            return;
         }
         for each(_loc2_ in actualModules)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            _loc2_.handleInput(param1);
         }
         _loc3_ = param1.details;
         if(_loc4_ = _loc3_.value == InputValue.KEY_UP)
         {
            switch(_loc3_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
                  hideAnimation();
            }
         }
      }
      
      public function setTitle(param1:String) : void
      {
         if(this.mcTextAreaModule)
         {
            this.mcTextAreaModule.SetTitle(param1);
         }
      }
      
      public function setText(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.mcTextAreaModule)
         {
            param1 = CommonUtils.fixFontStyleTags(param1);
            if(CoreComponent.isArabicAligmentMode && param1.charAt(1) == ".")
            {
               _loc2_ = param1;
               this.mcTextAreaModule.SetText("." + param1.charAt(1) + param1.slice(2));
            }
            else
            {
               this.mcTextAreaModule.SetText(param1);
            }
            this.mcTextAreaModule.mcSeparator.visible = param1 != "";
         }
      }
      
      public function setImage(param1:String) : void
      {
         if(this.mcGlossarySubModule)
         {
            this.mcGlossarySubModule.handleSetImage(param1);
         }
      }
      
      protected function Update() : void
      {
      }
      
      internal function __setProp_mcMainListModule_Scene1_mcMainListModule_0() : *
      {
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcMainListModule.DataBindingKey = "glossary.tutorials.list";
         this.mcMainListModule.DropDownItemRendererClass = "IconDropDownListItem";
         this.mcMainListModule.DropDownListClass = "DropDownList";
         this.mcMainListModule.enabled = true;
         this.mcMainListModule.enableInitCallback = false;
         this.mcMainListModule.itemInputFeedbackLabel = "";
         this.mcMainListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcMainListModule.ItemRendererClass = "NoIconListItem";
         this.mcMainListModule.visible = true;
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = false;
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
