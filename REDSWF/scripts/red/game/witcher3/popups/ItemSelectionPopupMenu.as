package red.game.witcher3.popups
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CorePopup;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.MouseCursor;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.events.InputFeedbackEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.menus.blacksmith.ModuleBlacksmithGrid;
   import red.game.witcher3.menus.common.ItemDataStub;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.managers.InputDelegate;
   
   public class ItemSelectionPopupMenu extends CorePopup
   {
      
      internal static const ACTION_SELECT_ITEM:uint = 0;
      
      internal static const ACTION_CLOSE:uint = 1;
       
      
      public var mcPlayerGridModule:ModuleBlacksmithGrid;
      
      public var mcInputFeedback:ModuleInputFeedback;
      
      public var txtItemName:TextField;
      
      private var _overlayCanvas:MovieClip;
      
      private var _mouseCursor:MouseCursor;
      
      public function ItemSelectionPopupMenu()
      {
         super();
         _enableInputValidation = true;
      }
      
      override protected function get popupName() : String
      {
         return "ItemSelectionPopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         registerDataBinding("ItemList",this.handleItemListData);
         this.mcPlayerGridModule.mcPlayerGrid.filterKeyCodeFunction = isKeyCodeValid;
         this.mcPlayerGridModule.mcPlayerGrid.filterNavCodeFunction = isNavEquivalentValid;
         this.mcInputFeedback.filterKeyCodeFunction = isKeyCodeValid;
         this.mcInputFeedback.filterNavCodeFunction = isNavEquivalentValid;
         this.mcInputFeedback.buttonAlign = "center";
         this.mcInputFeedback.directWsCall = false;
         this.mcInputFeedback.addEventListener(InputFeedbackEvent.USER_ACTION,this.handleUserAction,false,0,true);
         this.setupInputFeedback();
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,handleInput,false,0,true);
         this.mcPlayerGridModule.mcPlayerGrid.addEventListener(ListEvent.INDEX_CHANGE,this.handleItemSelected,false,0,true);
         this.mcPlayerGridModule.mcPlayerGrid.addEventListener(SlotActionEvent.EVENT_ACTIVATE,this.handleItemActivate,false,0,true);
         this.mcPlayerGridModule.active = true;
         this.mcPlayerGridModule.focused = 1;
         this.mcPlayerGridModule.mcPlayerGrid.ignoreGridPosition = true;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this._overlayCanvas = new MovieClip();
         this._overlayCanvas.mouseChildren = this._overlayCanvas.mouseEnabled = false;
         addChild(this._overlayCanvas);
         this._mouseCursor = new MouseCursor(this._overlayCanvas);
      }
      
      private function setupInputFeedback() : void
      {
         var _loc1_:Array = [];
         var _loc2_:KeyBindingData = new KeyBindingData();
         var _loc3_:KeyBindingData = new KeyBindingData();
         _loc2_.actionId = ACTION_SELECT_ITEM;
         _loc2_.label = "[[panel_button_inventory_select]]";
         _loc2_.keyboard_keyCode = KeyCode.E;
         _loc2_.gamepad_navEquivalent = NavigationCode.GAMEPAD_A;
         _loc1_.push(_loc2_);
         _loc3_.actionId = ACTION_CLOSE;
         _loc3_.label = "[[panel_button_common_close]]";
         _loc3_.keyboard_keyCode = KeyCode.ESCAPE;
         _loc3_.gamepad_navEquivalent = NavigationCode.GAMEPAD_B;
         _loc1_.push(_loc3_);
         this.mcInputFeedback.handleSetupButtons(_loc1_);
      }
      
      private function handleUserAction(param1:InputFeedbackEvent) : void
      {
         var _loc3_:SlotBase = null;
         var _loc2_:InputEvent = param1.inputEventRef;
         if(_loc2_)
         {
            if(_loc2_.details.value != InputValue.KEY_UP || !param1.isMouseEvent)
            {
               return;
            }
         }
         switch(param1.actionId)
         {
            case ACTION_SELECT_ITEM:
               _loc3_ = this.mcPlayerGridModule.mcPlayerGrid.getSelectedRenderer() as SlotBase;
               if(_loc3_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnCallSelectItem",[uint(_loc3_.data.id)]));
               }
               break;
            case ACTION_CLOSE:
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseSelectionPopup"));
         }
      }
      
      private function handleItemListData(param1:Array) : void
      {
      }
      
      private function handleItemSelected(param1:ListEvent) : void
      {
         var _loc3_:ItemDataStub = null;
         var _loc2_:SlotBase = param1.itemRenderer as SlotBase;
         if(Boolean(_loc2_) && _loc2_.data)
         {
            _loc3_ = _loc2_.data as ItemDataStub;
            this.txtItemName.text = CommonUtils.toUpperCaseSafe(_loc3_.itemName);
         }
      }
      
      private function handleItemActivate(param1:SlotActionEvent) : void
      {
         var _loc2_:SlotBase = param1.targetSlot as SlotBase;
         if(Boolean(_loc2_) && _loc2_.data)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCallSelectItem",[uint(_loc2_.data.id)]));
         }
      }
   }
}
