package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3QuantitySlider;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class QuantityPopup extends BasePopup
   {
       
      
      public var txtTitle:TextField;
      
      public var tfPriceValue:TextField;
      
      public var mcSlider:W3QuantitySlider;
      
      public var mcPriceIcon:MovieClip;
      
      public var mcBettingMoneyIcon:MovieClip;
      
      protected var _itemPrice:Number;
      
      protected var _currentQuantity:int;
      
      protected var _showPrice:Boolean;
      
      private const INVALID_VALUE:Number = 16711680;
      
      private const VALID_VALUE:Number = 11635295;
      
      private const MONEY_ICON_PADDING:Number = 25;
      
      public function QuantityPopup()
      {
         super();
         mcInpuFeedback.buttonAlign = "center";
         this.tfPriceValue.text = "0";
         this.mcSlider.visible = false;
         this.mcSlider.snapping = true;
         this.mcSlider.liveDragging = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.handlSliderChanged,false,0,true);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
         this._showPrice = _data.ShowPrice;
         if(this._showPrice)
         {
            this._itemPrice = _data.ItempPrice;
            this.mcPriceIcon.visible = true;
            this.tfPriceValue.visible = true;
         }
         else
         {
            this.mcPriceIcon.visible = false;
            this.tfPriceValue.visible = false;
         }
         this.alignControls();
         this.txtTitle.htmlText = _data.TextTitle;
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
         this.mcSlider.minimum = _data.minValue;
         this.mcSlider.maximum = _data.maxValue;
         this.mcSlider.value = _data.currentValue;
         this.mcSlider.visible = true;
         if(this._showPrice)
         {
            this.tfPriceValue.text = String(this.mcSlider.value * this._itemPrice);
         }
         if(this.mcBettingMoneyIcon)
         {
            this.mcBettingMoneyIcon.visible = _data.displayMoneyIcon;
         }
         this.alignMoneyIcon();
      }
      
      protected function alignControls() : void
      {
         var _loc1_:* = 140;
         var _loc2_:* = 104;
         var _loc3_:* = 153;
         var _loc4_:* = 117;
         if(this._showPrice)
         {
            this.mcSlider.y = _loc1_;
            if(this.mcBettingMoneyIcon)
            {
               this.mcBettingMoneyIcon.y = _loc2_;
            }
         }
         else
         {
            this.mcSlider.y = _loc3_;
            if(this.mcBettingMoneyIcon)
            {
               this.mcBettingMoneyIcon.y = _loc4_;
            }
         }
      }
      
      protected function handlSliderChanged(param1:SliderEvent) : void
      {
         if(this._currentQuantity != param1.value)
         {
            this._currentQuantity = param1.value;
            this.tfPriceValue.text = String(this._currentQuantity * this._itemPrice);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetQuantity",[this._currentQuantity]));
            removeEventListener(Event.ENTER_FRAME,this.handleValidatePosition);
            addEventListener(Event.ENTER_FRAME,this.handleValidatePosition,false,0,true);
         }
      }
      
      private function handleValidatePosition() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleValidatePosition);
         this.checkValidBet();
         this.alignMoneyIcon();
      }
      
      private function alignMoneyIcon() : void
      {
         var _loc1_:TextField = null;
         if(this.mcBettingMoneyIcon)
         {
            if(this.mcBettingMoneyIcon.visible)
            {
               _loc1_ = this.mcSlider.txtValue;
               this.mcBettingMoneyIcon.x = _loc1_.x + (_loc1_.width - _loc1_.textWidth) / 2 + _loc1_.textWidth + this.MONEY_ICON_PADDING + this.mcSlider.x;
            }
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:Boolean = false;
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_)
         {
            _loc4_ = false;
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.LEFT:
               case NavigationCode.DOWN:
                  --this.mcSlider.value;
                  param1.handled = true;
                  _loc4_ = true;
                  return;
               case NavigationCode.RIGHT:
               case NavigationCode.UP:
                  ++this.mcSlider.value;
                  param1.handled = true;
                  _loc4_ = true;
                  return;
               case NavigationCode.HOME:
                  this.mcSlider.value = this.mcSlider.minimum;
                  param1.handled = true;
                  _loc4_ = true;
                  return;
               case NavigationCode.END:
                  this.mcSlider.value = this.mcSlider.maximum;
                  param1.handled = true;
                  _loc4_ = true;
                  return;
               default:
                  if(!param1.handled)
                  {
                     switch(_loc2_.code)
                     {
                        case KeyCode.NUMPAD_ADD:
                           ++this.mcSlider.value;
                           _loc4_ = true;
                           break;
                        case KeyCode.NUMPAD_SUBTRACT:
                           --this.mcSlider.value;
                           _loc4_ = true;
                     }
                  }
                  if(_loc4_)
                  {
                  }
            }
         }
      }
      
      private function checkValidBet() : void
      {
         if(this.mcBettingMoneyIcon)
         {
            if(this.mcBettingMoneyIcon.visible)
            {
               if(this.mcSlider.value > _data.playerMoney)
               {
                  this.mcSlider.txtValue.textColor = this.INVALID_VALUE;
               }
               else
               {
                  this.mcSlider.txtValue.textColor = this.VALID_VALUE;
               }
            }
         }
      }
   }
}
