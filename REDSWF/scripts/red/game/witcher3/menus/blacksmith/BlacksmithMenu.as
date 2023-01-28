package red.game.witcher3.menus.blacksmith
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.utils.CommonUtils;
   import red.game.witcher3.utils.FiniteStateMachine;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class BlacksmithMenu extends CoreMenu
   {
       
      
      private const MENU_TAB_SOCKETS:String = "Sockets";
      
      private const MENU_TAB_REPAIR:String = "Repair";
      
      private const MENU_TAB_DISASSEMBLE:String = "Disassemble";
      
      private const MENU_TAB_ADD_SOCKETS:String = "AddSockets";
      
      private const STATE_SELECTION:String = "Selection";
      
      private const STATE_CONFIRMATION:String = "Confirmation";
      
      private const STATE_WAITING:String = "Waiting";
      
      private const ACTION_ACTIVATE_ID:int = 1000;
      
      private const ACTION_COMPARE_ID:int = 1001;
      
      private const ACTION_REPAIR_ALL:int = 1002;
      
      public var mcPlayerGridModule:ModuleBlacksmithGrid;
      
      public var tooltipAnchor:DisplayObject;
      
      public var panelSockets:ItemSocketsInfo;
      
      public var panelRepair:ItemRepairInfo;
      
      public var panelDisassemble:ItemDisassembleInfo;
      
      public var panelAddSocket:ItemAddSocketInfo;
      
      public var mcBkBlacksmith:MovieClip;
      
      public var mcBkSockets:MovieClip;
      
      private var _currentInfoPanel:BlacksmithItemPanel;
      
      public var moduleMerchantInfo:ModuleMerchantInfo;
      
      public var warningDisassemble:MovieClip;
      
      public var emptyListIcon:MovieClip;
      
      public var txtEmptyList:TextField;
      
      private var _selectdTargetItem:SlotBase;
      
      private var _targetItem:SlotBase;
      
      private var _stateMachine:FiniteStateMachine;
      
      private var _actionDisabledWarning:MovieClip;
      
      private var _activateInputFeedbackLabel:String;
      
      private var _isActionDisabled:Boolean;
      
      private var _xActionLabel:String;
      
      private var _btn_switch_sections:int = -1;
      
      protected var _action_confirmed:Boolean;
      
      public function BlacksmithMenu()
      {
         super();
         this.panelAddSocket.visible = false;
         this.panelSockets.visible = false;
         this.panelRepair.visible = false;
         this.warningDisassemble.visible = false;
         this.emptyListIcon.visible = false;
         this.txtEmptyList.visible = false;
         InputFeedbackManager.eventDispatcher = this;
         InputFeedbackManager.useOverlayPopup = false;
         this.mcBkBlacksmith.visible = true;
         this.mcBkSockets.visible = false;
         (this.warningDisassemble["container"]["textField"] as TextField).text = "[[panel_blacksmith_items_cant_disassemble]]";
      }
      
      public function setXActionLabel(param1:String) : void
      {
         this._xActionLabel = param1;
         var _loc2_:SlotBase = this.mcPlayerGridModule.mcPlayerGrid.getSelectedRenderer() as SlotBase;
         if(param1 == "")
         {
            InputFeedbackManager.removeButtonById(this.ACTION_REPAIR_ALL);
            this.panelRepair.btnRepairAll.visible = false;
         }
         else
         {
            if(_loc2_)
            {
               this.displayItemInfo(_loc2_);
            }
            this.panelRepair.btnRepairAll.visible = true;
         }
      }
      
      override protected function get menuName() : String
      {
         return "BlacksmithMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"blacksmith.item.update",[this.updateItem]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"blacksmith.item.list.update",[this.updateItemsList]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"blacksmith.merchant.info",[this.setMerchantInfo]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"blacksmith.grid.section",[this.setSectionsList]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         _contextMgr.defaultAnchor = this.tooltipAnchor;
         _contextMgr.addGridEventsTooltipHolder(stage);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,10,true);
         this.mcPlayerGridModule.mcPlayerGrid.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleItemActivate,false,0,true);
         this.mcPlayerGridModule.mcPlayerGrid.addEventListener(ListEvent.INDEX_CHANGE,this.handleItemSelected,false,0,true);
         this.mcPlayerGridModule.addEventListener(Event.ACTIVATE,this.handlePlayerGridActivated,false,0,true);
         this.mcPlayerGridModule.addEventListener(Event.DEACTIVATE,this.handlePlayerGridDeactivate,false,0,true);
         this.mcPlayerGridModule.active = true;
         this.mcPlayerGridModule.focused = 0;
         this.mcPlayerGridModule.mcPlayerGrid.ignoreGridPosition = true;
         this._stateMachine = new FiniteStateMachine();
         this._stateMachine.AddState(this.STATE_SELECTION,this.state_begin_selection,this.state_update_selection,null);
         this._stateMachine.AddState(this.STATE_CONFIRMATION,this.state_begin_confirmation,this.state_update_confirmation,null);
         this._stateMachine.AddState(this.STATE_WAITING,this.state_begin_waiting,this.state_update_waiting,null);
         if(this._btn_switch_sections == -1)
         {
            this._btn_switch_sections = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_R3,-1,"panel_button_common_jump_sections");
         }
      }
      
      public function updateItemsList(param1:Array) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1)
         {
            this.mcPlayerGridModule.mcPlayerGrid.updateItemData(_loc2_);
         }
         this.mcPlayerGridModule.checkItemsCount();
      }
      
      public function updateItem(param1:Object) : void
      {
         this.mcPlayerGridModule.mcPlayerGrid.updateItemData(param1);
         this.mcPlayerGridModule.checkItemsCount();
      }
      
      public function removeItem(param1:int, param2:Boolean = false) : void
      {
         this._stateMachine.ChangeState(this.STATE_SELECTION);
         this._stateMachine.ForceUpdateState();
         this.mcPlayerGridModule.mcPlayerGrid.removeItem(param1,param2);
         this.mcPlayerGridModule.checkItemsCount();
      }
      
      public function setPlayerMoney(param1:int) : void
      {
         this.panelSockets.playerMoney = param1;
         this.panelRepair.playerMoney = param1;
         this.panelDisassemble.playerMoney = param1;
         this.panelAddSocket.playerMoney = param1;
      }
      
      private function setSectionsList(param1:Array) : void
      {
         this.mcPlayerGridModule.mcPlayerGrid.setItemSections(param1);
         this.mcPlayerGridModule.displaySection(param1);
      }
      
      private function setMerchantInfo(param1:Object) : void
      {
         this.moduleMerchantInfo.data = param1;
      }
      
      private function handlePlayerGridActivated(param1:Event) : void
      {
         var _loc2_:SlotBase = this.mcPlayerGridModule.mcPlayerGrid.getSelectedRenderer() as SlotBase;
         this.emptyListIcon.visible = false;
         this._isActionDisabled = false;
         this.txtEmptyList.visible = false;
         this.mcPlayerGridModule.visible = true;
         if(this._currentInfoPanel)
         {
            this._currentInfoPanel.visible = true;
         }
         if(_loc2_)
         {
            this.displayItemInfo(_loc2_);
         }
         else
         {
            this._currentInfoPanel.cleanup();
         }
      }
      
      private function handlePlayerGridDeactivate(param1:Event) : void
      {
         this.emptyListIcon.visible = true;
         this._isActionDisabled = true;
         this.txtEmptyList.visible = true;
         this.mcPlayerGridModule.visible = false;
         if(this._currentInfoPanel)
         {
            this._currentInfoPanel.visible = false;
         }
         if(this._actionDisabledWarning)
         {
            this._actionDisabledWarning.visible = false;
         }
         InputFeedbackManager.removeButtonById(this.ACTION_COMPARE_ID);
         InputFeedbackManager.removeButtonById(this.ACTION_ACTIVATE_ID);
         InputFeedbackManager.updateButtons(this);
         var _loc2_:GridEvent = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,-1,-1,-1,null,null);
         dispatchEvent(_loc2_);
      }
      
      private function handleItemActivate(param1:SlotActionEvent) : void
      {
         if(this._stateMachine.currentState == this.STATE_SELECTION)
         {
            this._targetItem = param1.targetSlot as SlotBase;
            if(this._targetItem && this._targetItem.data && Boolean(this._targetItem.data.disableAction))
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayDeniedSound"));
               this._targetItem = null;
            }
         }
      }
      
      private function handleItemSelected(param1:ListEvent) : void
      {
         var _loc2_:SlotBase = null;
         this._selectdTargetItem = null;
         if(this._stateMachine.currentState == this.STATE_SELECTION)
         {
            _loc2_ = param1.itemRenderer as SlotBase;
            this.displayItemInfo(_loc2_);
         }
      }
      
      private function activateSelectedItem() : void
      {
         var _loc1_:SlotBase = null;
         if(this._stateMachine.currentState == this.STATE_SELECTION)
         {
            _loc1_ = this.mcPlayerGridModule.mcPlayerGrid.getSelectedRenderer() as SlotBase;
            if(_loc1_ && _loc1_.data && !_loc1_.data.disableAction)
            {
               this._targetItem = _loc1_;
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlayDeniedSound"));
            }
         }
      }
      
      private function displayItemInfo(param1:SlotBase) : void
      {
         var _loc2_:Object = null;
         if(!this._currentInfoPanel)
         {
            return;
         }
         if(param1)
         {
            _loc2_ = param1.data;
            this._currentInfoPanel.data = _loc2_;
            this._isActionDisabled = _loc2_.disableAction;
            this._selectdTargetItem = param1;
            if(!this._isActionDisabled)
            {
               if(this._activateInputFeedbackLabel)
               {
                  InputFeedbackManager.appendButtonById(this.ACTION_ACTIVATE_ID,NavigationCode.GAMEPAD_A,KeyCode.E,this._activateInputFeedbackLabel);
               }
               if(this._actionDisabledWarning)
               {
                  this._actionDisabledWarning.visible = false;
               }
            }
            else
            {
               InputFeedbackManager.removeButtonById(this.ACTION_ACTIVATE_ID);
               if(this._actionDisabledWarning)
               {
                  this._actionDisabledWarning.visible = true;
               }
            }
            if(this._xActionLabel != "")
            {
               InputFeedbackManager.appendButtonById(this.ACTION_REPAIR_ALL,NavigationCode.GAMEPAD_X,KeyCode.SPACE,this._xActionLabel);
            }
            InputFeedbackManager.updateButtons(this);
         }
      }
      
      public function confirmAction(param1:Boolean) : void
      {
         if(param1)
         {
            this._action_confirmed = true;
         }
         else
         {
            this._stateMachine.ChangeState(this.STATE_SELECTION);
         }
      }
      
      public function inventoryRemoveItem(param1:int) : void
      {
         this.mcPlayerGridModule.inventoryRemoveItem(param1);
      }
      
      private function updateButtonsLabels() : *
      {
         this.panelAddSocket.setButtonData("[[panel_blacksmith_add_socket]]",NavigationCode.GAMEPAD_A,KeyCode.E);
         this.panelRepair.setButtonData("[[panel_button_common_repair]]",NavigationCode.GAMEPAD_A,KeyCode.E);
         this.panelDisassemble.setButtonData("[[panel_title_blacksmith_disassamble]]",NavigationCode.GAMEPAD_A,KeyCode.E);
         this.panelSockets.setButtonData("[[panel_title_blacksmith_sockets]]",NavigationCode.GAMEPAD_A,KeyCode.E);
      }
      
      override public function setMenuState(param1:String) : void
      {
         super.setMenuState(param1);
         if(this._actionDisabledWarning)
         {
            this._actionDisabledWarning.visible = false;
         }
         if(this._selectdTargetItem)
         {
            this._selectdTargetItem = null;
            this._stateMachine.ChangeState(this.STATE_SELECTION);
            this._stateMachine.ForceUpdateState();
         }
         if(this._currentInfoPanel)
         {
            this._currentInfoPanel.stopProcess();
         }
         this.panelAddSocket.visible = false;
         this.panelSockets.visible = false;
         this.panelRepair.visible = false;
         this.panelDisassemble.visible = false;
         this.mcBkBlacksmith.visible = true;
         this.mcBkSockets.visible = false;
         switch(param1)
         {
            case this.MENU_TAB_ADD_SOCKETS:
               this.txtEmptyList.text = "[[panel_menu_empty_list_add_sockets]]";
               this.txtEmptyList.text = CommonUtils.toUpperCaseSafe(this.txtEmptyList.text);
               this._xActionLabel = "";
               this._activateInputFeedbackLabel = "";
               this._currentInfoPanel = this.panelAddSocket;
               this.panelAddSocket.buttonCallback = this.activateSelectedItem;
               this._actionDisabledWarning = null;
               this.mcBkBlacksmith.visible = false;
               this.mcBkSockets.visible = true;
               break;
            case this.MENU_TAB_SOCKETS:
               this.txtEmptyList.text = "[[panel_menu_empty_list_remove_upgrades]]";
               this.txtEmptyList.text = CommonUtils.toUpperCaseSafe(this.txtEmptyList.text);
               this._xActionLabel = "";
               this._activateInputFeedbackLabel = "";
               this._currentInfoPanel = this.panelSockets;
               this._actionDisabledWarning = null;
               this.panelSockets.buttonCallback = this.activateSelectedItem;
               break;
            case this.MENU_TAB_REPAIR:
               this.txtEmptyList.text = "[[panel_menu_empty_list_repair]]";
               this.txtEmptyList.text = CommonUtils.toUpperCaseSafe(this.txtEmptyList.text);
               this._xActionLabel = "";
               this._activateInputFeedbackLabel = "";
               this._currentInfoPanel = this.panelRepair;
               this._actionDisabledWarning = null;
               this.panelRepair.buttonCallback = this.activateSelectedItem;
               break;
            case this.MENU_TAB_DISASSEMBLE:
               this.txtEmptyList.text = "[[panel_menu_empty_list_disassemble]]";
               this.txtEmptyList.text = CommonUtils.toUpperCaseSafe(this.txtEmptyList.text);
               this._xActionLabel = "";
               this._activateInputFeedbackLabel = "";
               this._currentInfoPanel = this.panelDisassemble;
               this._actionDisabledWarning = this.warningDisassemble;
               this.panelDisassemble.buttonCallback = this.activateSelectedItem;
         }
         this.updateButtonsLabels();
         this._isActionDisabled = false;
         var _loc2_:GridEvent = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,-1,-1,-1,null,null);
         dispatchEvent(_loc2_);
      }
      
      protected function state_begin_selection() : void
      {
         this._targetItem = null;
      }
      
      protected function state_update_selection() : void
      {
         if(this._targetItem)
         {
            this._stateMachine.ChangeState(this.STATE_CONFIRMATION);
         }
      }
      
      protected function state_begin_confirmation() : void
      {
         if(Boolean(this._targetItem) && !this._isActionDisabled)
         {
            this._action_confirmed = false;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnRequestConfirmation",[this._targetItem.data.id,this._targetItem.data.actionPrice]));
         }
         else
         {
            this._stateMachine.ChangeState(this.STATE_SELECTION);
         }
      }
      
      protected function state_update_confirmation() : void
      {
         if(this._action_confirmed)
         {
            this._stateMachine.ChangeState(this.STATE_WAITING);
         }
      }
      
      protected function state_begin_waiting() : void
      {
         this._currentInfoPanel.showProcessAnimation();
      }
      
      protected function state_update_waiting() : void
      {
         var _loc1_:Boolean = this._currentInfoPanel.isInProgress();
         if(!_loc1_ && Boolean(this._targetItem))
         {
            switch(_currentMenuState)
            {
               case this.MENU_TAB_SOCKETS:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveImprovements",[this._targetItem.data.id,this._targetItem.data.actionPrice]));
                  break;
               case this.MENU_TAB_REPAIR:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnRepairItem",[this._targetItem.data.id,this._targetItem.data.actionPrice]));
                  break;
               case this.MENU_TAB_DISASSEMBLE:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnDisassembleItem",[this._targetItem.data.id,this._targetItem.data.actionPrice]));
                  break;
               case this.MENU_TAB_ADD_SOCKETS:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnAddSocket",[this._targetItem.data.id,this._targetItem.data.actionPrice]));
            }
            this._stateMachine.ChangeState(this.STATE_SELECTION);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         var _loc4_:*;
         if(_loc4_ = _loc2_.value == InputValue.KEY_UP)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_X:
                  if(this._xActionLabel != "")
                  {
                     _inputMgr.reset();
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnRepairAllItems"));
                     param1.handled = true;
                  }
                  break;
               case NavigationCode.GAMEPAD_L2:
            }
            if(!param1.handled && _loc2_.code == KeyCode.SPACE)
            {
               if(this._xActionLabel != "")
               {
                  _inputMgr.reset();
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnRepairAllItems"));
                  param1.handled = true;
               }
            }
         }
      }
   }
}
