package red.game.witcher3.menus.glossary
{
   import flash.display.MovieClip;
   import flash.external.ExternalInterface;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3RenderToTextureHolder;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.managers.PanelModuleManager;
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GlossaryBestiaryMenu extends CoreMenu
   {
       
      
      public var mcPanelModuleManager:PanelModuleManager;
      
      public var mcMainListModule:DropdownListModuleBase;
      
      public var mcGlossarySubModule:GlossarySubListModule;
      
      public var mcTextAreaModule:TextAreaModuleCustomInput;
      
      public var mcMonsterTexture:W3RenderToTextureHolder;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      private var m_bUsingGamepad:Boolean = true;
      
      public function GlossaryBestiaryMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         this.mcMainListModule.menuName = this.menuName;
         this.mcMainListModule.selectModuleOnClick = true;
         this.__setProp_mcMainListModule_Scene1_mcMainListModule_0();
      }
      
      override protected function get menuName() : String
      {
         return "GlossaryBestiaryMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         addEventListener(GridEvent.ITEM_CHANGE,this.onGridItemChange,false,0,true);
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         _contextMgr.enableInputFeedbackShowing(true);
         registerRenderTarget("test_nopack",1024,1024);
         focused = 1;
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcGlossarySubModule.mcRewards.mcRewardGrid.initFindSelection = false;
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         this.mcGlossarySubModule.active = param1;
         this.mcTextAreaModule.active = param1;
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
      
      public function hideContent(param1:Boolean) : void
      {
         var _loc2_:GridEvent = null;
         this.mcGlossarySubModule.mcRewards.enabled = param1;
         this.mcGlossarySubModule.mcRewards.mcRewardGrid.enabled = param1;
         this.mcGlossarySubModule.active = param1;
         this.mcTextAreaModule.active = param1;
         if(!param1)
         {
            _loc2_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,-1,-1,-1,null,null);
            dispatchEvent(_loc2_);
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
         if(this.mcTextAreaModule)
         {
            this.mcTextAreaModule.SetText(param1);
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
      
      protected function onGridItemChange(param1:GridEvent) : void
      {
         var _loc3_:GridEvent = null;
         var _loc2_:ItemDataStub = param1.itemData as ItemDataStub;
         if(_loc2_)
         {
            if(_loc2_.id)
            {
               _loc3_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
            else
            {
               _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
            }
         }
         else
         {
            _loc3_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,0,-1,-1,null,_loc2_);
         }
         dispatchEvent(_loc3_);
      }
      
      public function IsUsingGamepad() : Boolean
      {
         this.m_bUsingGamepad = ExternalInterface.call("isUsingPad");
         return this.m_bUsingGamepad;
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
         this.mcMainListModule.DataBindingKey = "glossary.bestiary.list";
         this.mcMainListModule.DropDownItemRendererClass = "IconDropDownListItem";
         this.mcMainListModule.DropDownListClass = "DropDownList";
         this.mcMainListModule.enabled = true;
         this.mcMainListModule.enableInitCallback = false;
         this.mcMainListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcMainListModule.ItemRendererClass = "IconListItem";
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
