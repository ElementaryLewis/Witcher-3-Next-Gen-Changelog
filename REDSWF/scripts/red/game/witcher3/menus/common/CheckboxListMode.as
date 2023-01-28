package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class CheckboxListMode extends UIComponent
   {
       
      
      public var mcTitle:TextField;
      
      public var mcBackground:MovieClip;
      
      public var mcList:W3ScrollingList;
      
      public var mcItemRenderer1:CheckboxListItem;
      
      public var mcItemRenderer2:CheckboxListItem;
      
      public var mcItemRenderer3:CheckboxListItem;
      
      public var mcItemRenderer4:CheckboxListItem;
      
      public var mcItemRenderer5:CheckboxListItem;
      
      public var mcItemRenderer6:CheckboxListItem;
      
      public var mcItemRenderer7:CheckboxListItem;
      
      public var mcItemRenderer8:CheckboxListItem;
      
      public var mcItemRenderer9:CheckboxListItem;
      
      public var mcItemRenderer10:CheckboxListItem;
      
      public var mcCloseButton:InputFeedbackButton;
      
      public var disallowCloseOnNoCheck:Boolean = false;
      
      public var exclusiveCheckList:Boolean = false;
      
      public var hideCB:Function;
      
      public var closeCB:Function;
      
      public var allowUnchecking:Boolean = true;
      
      private var valuesOnShow:Array;
      
      public var extraCloseMode:Boolean = false;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      protected var _lastMouseOveredItem:int = -1;
      
      public function CheckboxListMode()
      {
         this.valuesOnShow = new Array();
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         this.mcCloseButton.clickable = true;
         this.mcCloseButton.label = "[[panel_button_common_close]]";
         this.mcCloseButton.addEventListener(ButtonEvent.PRESS,this.handleClosePressed,false,0,true);
         this.mcCloseButton.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
         this.mcCloseButton.validateNow();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,10,true);
         if(this.mcBackground)
         {
            this.mcBackground.addEventListener(MouseEvent.CLICK,this.handleBackgroundClick,false,0,true);
         }
      }
      
      public function get lastMoveWasMouse() : Boolean
      {
         return this._lastMoveWasMouse;
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         if(!this._lastMoveWasMouse)
         {
            if(this.mcList.selectedIndex == -1)
            {
               this.mcList.selectedIndex = 0;
            }
         }
         else
         {
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      public function show() : void
      {
         var _loc1_:CheckboxListItem = null;
         var _loc2_:int = 0;
         this.registerMouseEventsForItem(this.mcItemRenderer1);
         this.registerMouseEventsForItem(this.mcItemRenderer2);
         this.registerMouseEventsForItem(this.mcItemRenderer3);
         this.registerMouseEventsForItem(this.mcItemRenderer4);
         this.registerMouseEventsForItem(this.mcItemRenderer5);
         this.registerMouseEventsForItem(this.mcItemRenderer6);
         this.registerMouseEventsForItem(this.mcItemRenderer7);
         this.registerMouseEventsForItem(this.mcItemRenderer8);
         this.registerMouseEventsForItem(this.mcItemRenderer9);
         this.registerMouseEventsForItem(this.mcItemRenderer10);
         visible = true;
         if(this.mcList.selectedIndex == -1)
         {
            this.mcList.selectedIndex = 0;
         }
         this.valuesOnShow.length = 0;
         _loc2_ = 0;
         while(_loc2_ < this.mcList.numRenderers)
         {
            _loc1_ = this.mcList.getRendererAt(_loc2_) as CheckboxListItem;
            if(_loc1_ && _loc1_.visible && _loc1_.data != null)
            {
               this.valuesOnShow.push(_loc1_.isChecked);
            }
            _loc2_++;
         }
      }
      
      protected function registerMouseEventsForItem(param1:CheckboxListItem) : void
      {
         if(param1)
         {
            param1.addEventListener(MouseEvent.CLICK,this.onItemClicked,false,1,true);
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,1,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,1,true);
         }
      }
      
      protected function unregisterMouseEventsForItem(param1:CheckboxListItem) : void
      {
         if(param1)
         {
            param1.removeEventListener(MouseEvent.CLICK,this.onItemClicked);
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
         }
      }
      
      protected function onItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:CheckboxListItem = null;
         if(this.mcList.selectedIndex != -1)
         {
            _loc2_ = this.mcList.getSelectedRenderer() as CheckboxListItem;
            if(_loc2_)
            {
               this.toggleValue(_loc2_);
            }
         }
      }
      
      protected function onItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:CheckboxListItem = param1.currentTarget as CheckboxListItem;
         this._lastMouseOveredItem = this.mcList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      protected function onItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = -1;
         }
      }
      
      public function setData(param1:Array) : void
      {
         this.mcList.dataProvider = new DataProvider(param1);
         this.mcList.validateNow();
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:CheckboxListItem = null;
         if(!visible)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc2_.navEquivalent != NavigationCode.GAMEPAD_A)
         {
            this.mcList.handleInput(param1);
         }
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_UP && !param1.handled;
         if(_loc3_)
         {
            if(_loc2_.code == KeyCode.ESCAPE || _loc2_.navEquivalent == NavigationCode.GAMEPAD_B)
            {
               this.close();
               param1.handled = true;
               param1.stopImmediatePropagation();
               return;
            }
            if(this.extraCloseMode && (_loc2_.code == KeyCode.F || _loc2_.navEquivalent == NavigationCode.GAMEPAD_R3))
            {
               this.close();
               param1.handled = true;
               param1.stopImmediatePropagation();
            }
            else if(_loc2_.code == KeyCode.E || _loc2_.navEquivalent == NavigationCode.GAMEPAD_A)
            {
               if(_loc4_ = this.mcList.getSelectedRenderer() as CheckboxListItem)
               {
                  this.toggleValue(_loc4_);
               }
            }
         }
         param1.handled = true;
         param1.stopImmediatePropagation();
         super.handleInput(param1);
      }
      
      private function handleBackgroundClick(param1:MouseEvent) : void
      {
         this.close();
      }
      
      protected function toggleValue(param1:CheckboxListItem) : void
      {
         var _loc2_:CheckboxListItem = null;
         var _loc3_:int = 0;
         if(Boolean(param1) && (!param1.isChecked || this.allowUnchecking))
         {
            param1.isChecked = !param1.isChecked;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_switch"]));
            if(this.exclusiveCheckList)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mcList.numRenderers)
               {
                  _loc2_ = this.mcList.getRendererAt(_loc3_) as CheckboxListItem;
                  if(Boolean(_loc2_) && _loc2_ != param1)
                  {
                     _loc2_.isChecked = false;
                  }
                  _loc3_++;
               }
               if(this.canApplyValue())
               {
                  this.applyValue();
               }
            }
         }
      }
      
      protected function handleClosePressed(param1:ButtonEvent) : void
      {
         this.close();
      }
      
      public function isBoxChecked(param1:String) : Boolean
      {
         var _loc2_:CheckboxListItem = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.mcList.numRenderers)
         {
            _loc2_ = this.mcList.getRendererAt(_loc3_) as CheckboxListItem;
            if(_loc2_.dataKey == param1)
            {
               return _loc2_.isChecked;
            }
            _loc3_++;
         }
         throw new Error("GFX - tried to check if checkbox with key: \"" + param1 + "\" was checked but failed to find it");
      }
      
      public function setBoxChecked(param1:String, param2:Boolean) : void
      {
         var _loc3_:CheckboxListItem = null;
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.mcList.numRenderers)
         {
            _loc3_ = this.mcList.getRendererAt(_loc4_) as CheckboxListItem;
            if(_loc3_.dataKey == param1)
            {
               _loc3_.isChecked = param2;
               return;
            }
            _loc4_++;
         }
         throw new Error("GFX - tried to set checkbox with key: \"" + param1 + "\" to isChecked value: \"" + param2 + "\" but failed to find it");
      }
      
      public function close() : void
      {
         if(this.canApplyValue())
         {
            this.hide();
            this.applyValue();
         }
      }
      
      private function canApplyValue() : Boolean
      {
         var _loc1_:CheckboxListItem = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.disallowCloseOnNoCheck)
         {
            _loc3_ = false;
            _loc2_ = 0;
            while(_loc2_ < this.mcList.numRenderers)
            {
               _loc1_ = this.mcList.getRendererAt(_loc2_) as CheckboxListItem;
               if(Boolean(_loc1_) && _loc1_.isChecked)
               {
                  _loc3_ = true;
                  break;
               }
               _loc2_++;
            }
            if(!_loc3_)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEmptyCheckListCloseFailed"));
               return false;
            }
         }
         return true;
      }
      
      private function applyValue() : void
      {
         var _loc1_:CheckboxListItem = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         if(this.closeCB != null)
         {
            _loc3_ = false;
            _loc2_ = 0;
            while(_loc2_ < this.mcList.numRenderers)
            {
               _loc1_ = this.mcList.getRendererAt(_loc2_) as CheckboxListItem;
               if(_loc1_ && _loc1_.visible && _loc1_.data != null)
               {
                  if(_loc1_.isChecked != this.valuesOnShow[_loc2_])
                  {
                     _loc3_ = true;
                     break;
                  }
               }
               _loc2_++;
            }
            this.closeCB(_loc3_);
            this.hide();
         }
      }
      
      private function hide() : void
      {
         this.unregisterMouseEventsForItem(this.mcItemRenderer1);
         this.unregisterMouseEventsForItem(this.mcItemRenderer2);
         this.unregisterMouseEventsForItem(this.mcItemRenderer3);
         this.unregisterMouseEventsForItem(this.mcItemRenderer4);
         this.unregisterMouseEventsForItem(this.mcItemRenderer5);
         this.unregisterMouseEventsForItem(this.mcItemRenderer6);
         this.unregisterMouseEventsForItem(this.mcItemRenderer7);
         this.unregisterMouseEventsForItem(this.mcItemRenderer8);
         this.unregisterMouseEventsForItem(this.mcItemRenderer9);
         this.unregisterMouseEventsForItem(this.mcItemRenderer10);
         visible = false;
         if(this.hideCB != null)
         {
            this.hideCB();
         }
      }
   }
}
