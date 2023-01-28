package red.game.witcher3.menus.death_screen
{
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.GwintInputFeedback;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputFeedbackManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.clik.ui.InputDetails;
   
   public class DeathScreenMenu extends CoreMenu
   {
       
      
      public var mcDeathScreenGraphics:MovieClip;
      
      public var mcFakeBlackScreen:MovieClip;
      
      public var mcList:W3ScrollingList;
      
      public var mcListItem1:BaseListItem;
      
      public var mcListItem2:BaseListItem;
      
      public var mcListItem3:BaseListItem;
      
      public var mcListItem4:BaseListItem;
      
      private var _focusHandler:FocusHandler;
      
      private var _inputEnabled:Boolean = true;
      
      public function DeathScreenMenu()
      {
         addFrameScript(0,this.frame1);
         super();
         _enableMouse = false;
         InputFeedbackManager.useOverlayPopup = true;
         InputFeedbackManager.eventDispatcher = this;
         this.mcList.selectOnOver = true;
         this.__setProp_mcList_Scene1_mcList_0();
      }
      
      override protected function get menuName() : String
      {
         return "DeathScreenMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"hud.deathscreen.list",[this.handleDataSet]));
         this.mcList.addEventListener(ListEvent.ITEM_CLICK,this.SendPressEvent);
         this.mcList.focusable = false;
         this.showInputFeedback(true);
         visible = true;
         alpha = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      override protected function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         if(param1.handled || !this._inputEnabled)
         {
            return;
         }
         this.mcList.handleInput(param1);
         if(!param1.handled)
         {
            _loc2_ = param1.details;
            if(_loc2_.value == InputValue.KEY_UP && (_loc2_.navEquivalent == NavigationCode.ENTER || _loc2_.code == KeyCode.E || _loc2_.code == KeyCode.NUMPAD_ENTER))
            {
               this.SendPressEvent();
               param1.handled = true;
            }
         }
      }
      
      override protected function showAnimation() : void
      {
         handleShowAnimComplete(null);
      }
      
      public function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         this.mcList.dataProvider = new DataProvider(_loc3_);
         this.mcList.validateNow();
         this.mcList.focused = 1;
         if(this.mcList.selectedIndex == -1)
         {
            this.mcList.selectedIndex = 0;
         }
         var _loc4_:Number = 20;
         this.mcListItem1.validateNow();
         this.mcListItem2.validateNow();
         this.mcListItem3.validateNow();
         this.mcListItem4.validateNow();
         this.mcListItem2.y = this.mcListItem1.y + this.mcListItem1.textField.textHeight + _loc4_;
         this.mcListItem3.y = this.mcListItem2.y + this.mcListItem2.textField.textHeight + _loc4_;
         this.mcListItem4.y = this.mcListItem1.y - this.mcListItem1.textField.textHeight - _loc4_;
      }
      
      public function SendPressEvent(param1:ListEvent = null) : void
      {
         var _loc2_:BaseListItem = null;
         _loc2_ = this.mcList.getRendererAt(this.mcList.selectedIndex) as BaseListItem;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPress",[_loc2_.data.tag]));
      }
      
      public function setShowBlackscreen(param1:Boolean) : *
      {
         if(this.mcFakeBlackScreen)
         {
            this.mcFakeBlackScreen.visible = param1;
         }
      }
      
      public function showInputFeedback(param1:Boolean) : *
      {
         InputFeedbackManager.cleanupButtons(this);
         this._inputEnabled = param1;
         if(param1)
         {
            InputFeedbackManager.appendButtonById(GwintInputFeedback.apply,NavigationCode.GAMEPAD_A,KeyCode.ENTER,"panel_button_common_select");
            InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate,NavigationCode.GAMEPAD_L3,-1,"panel_button_common_navigation");
         }
      }
      
      internal function __setProp_mcList_Scene1_mcList_0() : *
      {
         try
         {
            this.mcList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcList.DownAction = 40;
         this.mcList.enabled = true;
         this.mcList.enableInitCallback = false;
         this.mcList.focusable = true;
         this.mcList.itemRendererName = "";
         this.mcList.itemRendererInstanceName = "mcListItem";
         this.mcList.margin = 0;
         this.mcList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         this.mcList.rowHeight = 0;
         this.mcList.scrollBar = "";
         this.mcList.UpAction = 38;
         this.mcList.visible = true;
         this.mcList.wrapping = "wrap";
         try
         {
            this.mcList["componentInspectorSetting"] = false;
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
