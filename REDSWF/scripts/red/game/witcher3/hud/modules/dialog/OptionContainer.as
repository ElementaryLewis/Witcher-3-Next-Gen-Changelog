package red.game.witcher3.hud.modules.dialog
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import com.gskinner.motion.easing.Quadratic;
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class OptionContainer extends UIComponent
   {
      
      private static const DEFAULT_X:Number = -234;
      
      private static const ANIMATION_DURATION:Number = 2500;
      
      private static const MAXIMAL_Y:Number = 120;
      
      private static const DIALOG_STEP_Y:Number = 40;
      
      private static const DIALOG_STEP_Y_EXTRA:Number = 35;
      
      private static const MAXIMAL_DIALOG_CHOICES:Number = 7;
       
      
      public var mcOptionList:OptionList;
      
      public var mcOption1:Option;
      
      public var mcOption2:Option;
      
      public var mcOption3:Option;
      
      public var mcOption4:Option;
      
      public var mcOption5:Option;
      
      public var mcOption6:Option;
      
      public var mcOption7:Option;
      
      public var mcUpArrow:MovieClip;
      
      public var mcDownArrow:MovieClip;
      
      protected var OPACITY_MAX:Number = 0.8;
      
      private var previousSelectedIndex:int = -1;
      
      private var closeAnimation:Boolean;
      
      public function OptionContainer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         tabEnabled = tabChildren = false;
         this.mcOptionList.tabEnabled = this.mcOptionList.tabChildren = false;
         this.mcOptionList.bSkipFocusCheck = true;
         visible = true;
         alpha = 0;
         this.mcOptionList.addEventListener(ListEvent.INDEX_CHANGE,this.onOptionChange,false,0,true);
         this.mcOptionList.addEventListener(ListEvent.ITEM_CLICK,this.onOptionClick);
         stage.addEventListener(W3ScrollingList.REPOSITION,this.SetOptionItemsY,false,0,true);
         this.mcOptionList.selectOnOver = true;
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
      }
      
      private function handleControllerChanged(param1:Event) : void
      {
         this.mcOptionList.invalidateData();
         this.mcOptionList.validateNow();
      }
      
      public function DataReset() : void
      {
         this.mcOptionList.selectedIndex = -1;
         if(this.mcOptionList.dataProvider.length > 0)
         {
            this.mcOptionList.dataProvider = new DataProvider();
         }
         this.mcOptionList.validateNow();
      }
      
      public function ChoicesSet(param1:Array) : void
      {
         this.closeAnimation = false;
         this.mcOptionList.selectedIndex = -1;
         this.mcOptionList.dataProvider = new DataProvider(param1);
         this.mcOptionList.validateNow();
         this.previousSelectedIndex = 0;
         this.mcOptionList.clearLastDir();
         var _loc2_:int = this.FindFirstAvailableDialogIndex(0);
         if(_loc2_ != -1)
         {
            this.ChoiceSelectionSet(_loc2_);
         }
         else if(this.mcOptionList.dataProvider.length > 0)
         {
            this.ChoiceSelectionSet(0);
         }
      }
      
      public function ChoiceSelectionSet(param1:int) : void
      {
         if(param1 >= 0 && param1 < this.mcOptionList.dataProvider.length)
         {
            this.mcOptionList.focused = 1;
            this.mcOptionList.selectedIndex = param1;
            this.mcOptionList.validateNow();
         }
         else
         {
            this.mcOptionList.selectedIndex = -1;
            this.mcOptionList.validateNow();
         }
      }
      
      private function FindFirstAvailableDialogIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc6_:Object = null;
         var _loc3_:int = this.mcOptionList.getLastDir();
         var _loc4_:int = int(this.mcOptionList.dataProvider.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_ >= 0)
            {
               _loc2_ = (_loc5_ + param1 + _loc4_) % _loc4_;
            }
            else
            {
               _loc2_ = (_loc4_ - _loc5_ - 1 + param1 + _loc4_) % _loc4_;
            }
            if(_loc6_ = this.mcOptionList.dataProvider[_loc2_])
            {
               if(!_loc6_.locked)
               {
                  return _loc2_;
               }
            }
            _loc5_++;
         }
         return -1;
      }
      
      private function UpdateArrows(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.mcUpArrow.alpha = 0;
            this.mcDownArrow.alpha = 0;
         }
         else
         {
            if(this.mcOptionList.scrollPosition > 0)
            {
               this.mcUpArrow.alpha = this.OPACITY_MAX;
            }
            else
            {
               this.mcUpArrow.alpha = 0;
            }
            this.mcDownArrow.alpha = 0;
            if(this.mcOptionList.dataProvider && this.mcOptionList.dataProvider.length > MAXIMAL_DIALOG_CHOICES && this.mcOptionList.scrollPosition < this.mcOptionList.dataProvider.length - MAXIMAL_DIALOG_CHOICES)
            {
               this.mcDownArrow.alpha = this.OPACITY_MAX;
            }
         }
      }
      
      private function SetOptionItemsY(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Option = null;
         var _loc6_:int = 0;
         var _loc4_:Number = MAXIMAL_Y;
         if(this.closeAnimation)
         {
            return;
         }
         this.mcOptionList.mouseChildren = false;
         this.mcOptionList.mouseEnabled = false;
         if(this.mcOptionList == null)
         {
            return;
         }
         if(this.mcOptionList.dataProvider == null)
         {
            return;
         }
         var _loc5_:Number = 0;
         _loc2_ = Math.min(this.mcOptionList.dataProvider.length - 1,MAXIMAL_DIALOG_CHOICES - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = this.mcOptionList.getRendererAt(_loc2_) as Option;
            _loc3_.visible = true;
            _loc3_.alpha = 1;
            _loc3_.scaleX = _loc3_.scaleY = 1;
            _loc3_.x = DEFAULT_X;
            GTweener.removeTweens(_loc3_);
            if(_loc3_.mcSelectionBck != null)
            {
               _loc3_.mcSelectionBck.mcImg.height = 35;
            }
            if(_loc3_.mcShadow != null)
            {
               _loc3_.mcShadow.height = 35;
            }
            if(_loc3_.tfLine.numLines > 1)
            {
               _loc6_ = _loc3_.tfLine.numLines - 1;
               _loc4_ -= DIALOG_STEP_Y_EXTRA * _loc6_;
               if(_loc3_.mcSelectionBck != null)
               {
                  _loc3_.mcSelectionBck.mcImg.height += 24 * _loc6_;
               }
               if(_loc3_.mcShadow != null)
               {
                  _loc3_.mcShadow.height += 24 * _loc6_;
               }
            }
            if(_loc3_ == null)
            {
               return;
            }
            _loc3_.y = _loc4_;
            _loc4_ -= DIALOG_STEP_Y;
            if(_loc5_ == 0)
            {
               _loc5_ = _loc3_.height;
            }
            _loc2_--;
         }
         if(this.mcUpArrow == null)
         {
            return;
         }
         if(this.mcDownArrow == null)
         {
            return;
         }
         if(_loc3_ == null)
         {
            return;
         }
         this.mcUpArrow.y = _loc4_ + this.mcUpArrow.height;
         this.mcDownArrow.y = MAXIMAL_Y + _loc5_ - this.mcDownArrow.height;
         this.UpdateArrows();
         this.mcOptionList.mouseChildren = false;
         this.mcOptionList.mouseEnabled = false;
      }
      
      private function onOptionChange(param1:ListEvent) : void
      {
         var _loc2_:Option = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = this.mcOptionList.selectedIndex;
         _loc4_ = this.mcOptionList.selectedIndex - this.mcOptionList.scrollPosition;
         _loc2_ = this.mcOptionList.getRendererAt(_loc4_) as Option;
         if(!_loc2_)
         {
            return;
         }
         if(_loc3_ < 0 || _loc3_ >= this.mcOptionList.dataProvider.length)
         {
            return;
         }
         var _loc5_:Object;
         if(_loc5_ = this.mcOptionList.dataProvider[_loc3_])
         {
            if(_loc5_.locked)
            {
               if((_loc6_ = this.FindFirstAvailableDialogIndex(_loc3_)) != -1)
               {
                  this.ChoiceSelectionSet(_loc6_);
                  this.UpdateArrows();
                  return;
               }
            }
         }
         this.UpdateArrows();
         if(this.closeAnimation)
         {
            return;
         }
         if(_loc3_ > -1 && this.previousSelectedIndex != _loc3_)
         {
            _loc2_ = this.mcOptionList.getRendererAt(_loc4_) as Option;
            if(_loc2_)
            {
               setChildIndex(_loc2_,0);
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogOptionSelected",[_loc3_]));
            }
         }
         this.previousSelectedIndex = _loc3_;
      }
      
      private function onOptionClick(param1:ListEvent) : void
      {
         var _loc2_:Option = this.mcOptionList.getRendererAt(this.mcOptionList.selectedIndex - this.mcOptionList.scrollPosition) as Option;
         if(Boolean(_loc2_) && (param1 == null || param1.itemRenderer == _loc2_))
         {
            this.activateOption(this.mcOptionList.selectedIndex);
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = 1;
         this.mcOptionList.focused = 1;
         var _loc2_:Option = this.mcOptionList.getRendererAt(this.mcOptionList.selectedIndex) as Option;
         if(_loc2_)
         {
            _loc2_.focused = 1;
         }
      }
      
      public function SetMaxOpacity(param1:Number) : *
      {
         this.OPACITY_MAX = param1;
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      public function GetOptionsListLength() : int
      {
         return this.mcOptionList.dataProvider.length;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Option = null;
         if(param1.handled || this.closeAnimation)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.value == InputValue.KEY_UP)
         {
            switch(_loc2_.code)
            {
               case KeyCode.E:
               case KeyCode.NUMPAD_ENTER:
               case KeyCode.PAD_A_CROSS:
                  if(this.GetOptionsListLength() != 0)
                  {
                     param1.handled = true;
                     this.onOptionClick(null);
                  }
                  return;
               default:
                  if(!param1.handled && _loc2_.code >= KeyCode.NUMBER_1 && _loc2_.code <= KeyCode.NUMBER_9)
                  {
                     _loc3_ = _loc2_.code - KeyCode.NUMBER_0 - 1;
                     _loc4_ = _loc3_ - this.mcOptionList.scrollPosition;
                     if((_loc5_ = this.mcOptionList.getRendererAt(_loc4_) as Option) && !_loc5_.isLocked && _loc5_.visible && _loc5_.alpha != 0 && _loc5_.tfLine.text != "")
                     {
                        this.mcOptionList.selectedIndex = _loc3_;
                        this.mcOptionList.validateNow();
                        this.activateOption(_loc3_);
                        param1.stopImmediatePropagation();
                        param1.handled = true;
                        return;
                     }
                  }
            }
         }
         this.mcOptionList.handleInput(param1);
      }
      
      private function activateOption(param1:int) : void
      {
         var _loc4_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:Option = null;
         var _loc8_:Option = null;
         var _loc2_:Vector.<IListItemRenderer> = this.mcOptionList.getRenderers();
         var _loc3_:Boolean = false;
         var _loc5_:Option;
         if((Boolean(_loc5_ = this.mcOptionList.getRendererAt(param1 - this.mcOptionList.scrollPosition) as Option)) && _loc5_.isLocked)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogOptionAccepted",[int(param1)]));
            return;
         }
         this.UpdateArrows(true);
         if(this.mcOptionList.dataProvider.length > 1)
         {
            _loc6_ = Math.min(this.mcOptionList.dataProvider.length - 1,MAXIMAL_DIALOG_CHOICES - 1);
            while(_loc6_ > -1)
            {
               _loc7_ = this.mcOptionList.getRendererAt(_loc6_) as Option;
               (_loc4_ = {}).data = {"idx":param1};
               if(Boolean(_loc7_) && _loc7_.index != param1)
               {
                  if(!_loc3_)
                  {
                     _loc4_.onComplete = this.fadeSelectedOption;
                     _loc3_ = true;
                  }
                  _loc4_.ease = Exponential.easeOut;
                  GTweener.to(_loc7_,0.4,{"alpha":0},_loc4_);
               }
               _loc6_--;
            }
         }
         if(_loc3_)
         {
            this.closeAnimation = true;
         }
         else if(_loc8_ = this.mcOptionList.getSelectedRenderer() as Option)
         {
            (_loc4_ = {}).data = {"idx":param1};
            _loc4_.ease = Quadratic.easeIn;
            _loc4_.onComplete = this.callActivateOption;
            GTweener.removeTweens(_loc8_);
            GTweener.to(_loc8_,0.3,{"alpha":0},_loc4_);
            this.closeAnimation = true;
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogOptionAccepted",[int(param1)]));
         }
      }
      
      private function fadeSelectedOption(param1:GTween) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Option = this.mcOptionList.getSelectedRenderer() as Option;
         if(_loc2_)
         {
            _loc3_ = {};
            _loc3_.data = param1.data;
            _loc3_.ease = Quadratic.easeIn;
            _loc3_.onComplete = this.callActivateOption;
            GTweener.to(_loc2_,0.3,{"alpha":0},_loc3_);
         }
         else
         {
            this.closeAnimation = false;
         }
      }
      
      private function callActivateOption(param1:GTween) : void
      {
         this.closeAnimation = false;
         if(param1.data && !isNaN(param1.data.idx))
         {
            if(this.mcOptionList.dataProvider.length > 0)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogOptionAccepted",[int(param1.data.idx)]));
            }
         }
      }
   }
}
