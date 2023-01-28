package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3OptionStepper;
   import red.game.witcher3.controls.W3OptionsSeparator;
   import red.game.witcher3.controls.W3Slider;
   import red.game.witcher3.menus.mainmenu.IngameMenu;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.IndexEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class W3SubMenuListItemRenderer extends BaseListItem
   {
      
      private static const gamepadButtonDownload:String = NavigationCode.GAMEPAD_X;
      
      private static const keyboardButtonDownload:uint = KeyCode.ENTER;
      
      protected static const TOGGLE_ON_STRING:String = "[[panel_mainmenu_option_value_on]]";
      
      protected static const TOGGLE_OFF_STRING:String = "[[panel_mainmenu_option_value_off]]";
      
      private static const ACTION_DOWNLOAD:uint = 66;
       
      
      public var tfCurrentValue:TextField;
      
      public var tfMinValue:TextField;
      
      public var tfMaxValue:TextField;
      
      public var downloadBtn:DownloadButton;
      
      public var hintBtn:InputFeedbackButton;
      
      public var mcHitArea:MovieClip;
      
      public var mcSlider:W3Slider;
      
      public var mcStepper:W3OptionStepper;
      
      public var mcSeparator:W3OptionsSeparator;
      
      public var mcBackground:MovieClip;
      
      public var mcDropDownBG:MovieClip;
      
      public var mcDeveloperHighlightBG:MovieClip;
      
      private var _currentValue:String = "";
      
      private var _currentTextColor:Number;
      
      private var _id:String = "";
      
      private var _type:int;
      
      public var mcSelectionHighlightPro:MovieClip;
      
      private var _startingXForCurrent:Number;
      
      protected var _supressEvents:Boolean = false;
      
      protected var _ingameMenu:IngameMenu;
      
      protected var _tfCurrentValueStartUpX:int;
      
      protected var _startUpX:int;
      
      protected var _selectionStartUpX:int;
      
      protected var _selectionStartUpWidth:int;
      
      protected var _textFieldStartUpX:int;
      
      protected var _mcDropDownBGStartUpX:int;
      
      public function W3SubMenuListItemRenderer()
      {
         preventAutosizing = true;
         mouseEnabled = true;
         this.mouseChildren = true;
         super();
         hitArea = this.mcHitArea;
         if(this.mcSlider)
         {
            this.mcSlider.enableSounds = true;
         }
         this.tfMinValue.visible = false;
         this.tfMaxValue.visible = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.tfCurrentValue)
         {
            this._startingXForCurrent = this.tfCurrentValue.x;
         }
         if(this.mcSelectionHighlightPro)
         {
            this.mcSelectionHighlightPro.mouseEnabled = false;
         }
         this._ingameMenu = parent.parent as IngameMenu;
         this._startUpX = this.x;
         this._selectionStartUpX = this.mcSelectionHighlightPro.x;
         this._selectionStartUpWidth = this.mcSelectionHighlightPro.width;
         this._tfCurrentValueStartUpX = this.tfCurrentValue.x;
         this._textFieldStartUpX = textField.x;
         this._mcDropDownBGStartUpX = this.mcDropDownBG.x;
      }
      
      override public function setData(param1:Object) : void
      {
         this._supressEvents = true;
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         label = param1.label;
         this._currentValue = param1.current as String;
         if(!this._currentValue)
         {
            this._currentValue = param1.current.toString();
         }
         this.createSubElementByType(param1.type);
         this.initializeStreamableUi(param1);
         if(param1.isDropdownContent)
         {
            this.mcDropDownBG.visible = true;
            this.mcBackground.visible = false;
            this.x = this._startUpX + 50;
            this.mcSelectionHighlightPro.width = 900;
            this.mcSelectionHighlightPro.x = 205;
            this.tfCurrentValue.x = this._tfCurrentValueStartUpX - 200;
         }
         else
         {
            this.mcDropDownBG.visible = false;
            this.mcBackground.visible = this._type != IngameMenu.IGMActionType_Separator && this._type != IngameMenu.IGMActionType_SubtleSeparator;
            this.x = this._startUpX;
            this.tfCurrentValue.x = this._tfCurrentValueStartUpX;
            this.mcSelectionHighlightPro.width = this._selectionStartUpWidth;
            this.mcSelectionHighlightPro.x = this._selectionStartUpX;
         }
         if(param1.disabled)
         {
            this.alpha = 0.35;
            this.selectable = false;
         }
         else
         {
            this.alpha = 1;
            this.selectable = true;
         }
         if(param1.indent)
         {
            textField.x = this._textFieldStartUpX + 32;
            this.mcBackground.x = this.mcDropDownBG.x = this._mcDropDownBGStartUpX + 32;
         }
         else
         {
            textField.x = this._textFieldStartUpX - (CoreComponent.isArabicAligmentMode ? 20 : 0);
            this.mcBackground.x = this.mcDropDownBG.x = this._mcDropDownBGStartUpX;
         }
         this.mcDeveloperHighlightBG.visible = param1.isDeveloper;
         this.invalidate();
         this.validateNow();
         this.OnSliderValueChanged(null);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionSelectionChanged",[param1.tag,selected]));
         this._supressEvents = false;
      }
      
      public function setSelectionVisible(param1:Boolean) : void
      {
         if(this.mcSlider)
         {
            this.mcSlider.focused = 0;
         }
      }
      
      private function initializeStreamableUi(param1:Object) : *
      {
         if(!param1.streamable)
         {
            return;
         }
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"streamable.status",[this.onStreamableStatusUpdated]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"option.changedId",[this.onSelectedOptionIdChanged]));
      }
      
      private function onDownloadBtnPressed(param1:ButtonEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnDownloadContentRequested",[data.groupID,data.tag,data.current]));
      }
      
      private function onStreamableStatusUpdated(param1:Object) : void
      {
         if(data.tag != param1.optionTag)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.data.streamableStatus.length)
         {
            if(this.data.streamableStatus[_loc2_].optionValueString == param1.optionValueString)
            {
               this.data.streamableStatus[_loc2_].optionStatus = param1.optionStatus;
               if(this.mcSlider.value == _loc2_)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionValueChanged",[data.groupID,data.tag,data.current]));
               }
            }
            _loc2_++;
         }
         this.updateCurrentValue();
      }
      
      private function onSelectedOptionIdChanged(param1:Object) : void
      {
         if(data.tag != param1.optionTag && !this.mcSlider)
         {
            return;
         }
         this.mcSlider.value = param1.optionSelectedId;
      }
      
      internal function createSubElementByType(param1:uint) : *
      {
         if(this.mcSlider != null)
         {
            this.mcSlider.removeEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false);
            this.mcSlider.removeEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false);
            removeEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false);
            removeChild(this.mcSlider);
            this.mcSlider.gEvent = null;
            this.mcSlider = null;
         }
         if(this.mcStepper)
         {
            this.mcStepper.visible = false;
         }
         if(this.mcSeparator)
         {
            this.mcSeparator.visible = false;
         }
         textField.visible = true;
         this.tfCurrentValue.visible = true;
         this.selectable = true;
         this.mcBackground.visible = true;
         this._type = param1;
         this.mouseChildren = false;
         switch(param1)
         {
            case IngameMenu.IGMActionType_Slider:
               this.CreateSlider();
               break;
            case IngameMenu.IGMActionType_Toggle:
               this.CreateToggleSlider(1);
               break;
            case IngameMenu.IGMActionType_List:
               this.CreateToggleSlider(data.subElements.length - 1);
               break;
            case IngameMenu.IGMActionType_ListWithCondition:
               this.CreateToggleSlider(data.subElements.length - 1);
               break;
            case IngameMenu.IGMActionType_Stepper:
               this.tfCurrentValue.visible = false;
               this.initializeOptionStepper(false);
               break;
            case IngameMenu.IGMActionType_ToggleStepper:
               this.tfCurrentValue.visible = false;
               this.initializeOptionStepper(true);
               break;
            case IngameMenu.IGMActionType_Separator:
               textField.visible = false;
               this.tfCurrentValue.visible = false;
               this.selectable = false;
               this.mcBackground.visible = false;
               this.initialzeSeparator();
               break;
            case IngameMenu.IGMActionType_SubtleSeparator:
               textField.visible = false;
               this.tfCurrentValue.visible = false;
               this.selectable = false;
               this.mcBackground.visible = false;
               this.initialzeSubtleSeparator();
         }
      }
      
      internal function initializeOptionStepper(param1:Boolean) : *
      {
         var _loc2_:Class = null;
         if(this.mcStepper == null)
         {
            _loc2_ = getDefinitionByName("SubMenuOptionStepper") as Class;
            this.mcStepper = new _loc2_() as W3OptionStepper;
            addChildAt(this.mcStepper,getChildIndex(textField));
         }
         this.mcStepper.removeEventListener(IndexEvent.INDEX_CHANGE,this.onStepperValueChanged);
         this.mcStepper.x = !!data.isDropdownContent ? 350 : 650;
         this.mcStepper.y = 35;
         this.mcStepper.hideIndicator = data.hideIndicator;
         if(param1)
         {
            this.mcStepper.dataProvider = new DataProvider(["Off","On"]);
            this.mcStepper.selectedIndex = data.current == "true" ? 1 : 0;
         }
         else
         {
            this.mcStepper.dataProvider = new DataProvider(data.subElements);
            this.mcStepper.selectedIndex = parseInt(data.current);
         }
         this.mcStepper.visible = true;
         this.mcStepper.invalidate();
         this.mcStepper.validateNow();
         this.mcStepper.addEventListener(IndexEvent.INDEX_CHANGE,this.onStepperValueChanged);
      }
      
      internal function initialzeSeparator() : *
      {
         var _loc1_:Class = null;
         if(this.mcSeparator == null)
         {
            _loc1_ = getDefinitionByName("OptionsSeparator") as Class;
            this.mcSeparator = new _loc1_() as W3OptionsSeparator;
            addChildAt(this.mcSeparator,getChildIndex(textField));
         }
         this.mcSeparator.label.text = data.label;
         this.mcSeparator.x = -150;
         this.mcSeparator.y = 34;
         this.mcSeparator.width = this.width;
         this.mcSeparator.height = this.height;
         this.mcSeparator.visible = true;
         this.mcSeparator.alpha = 1;
         this.invalidate();
         this.validateNow();
      }
      
      internal function initialzeSubtleSeparator() : *
      {
         var _loc1_:Class = null;
         if(this.mcSeparator == null)
         {
            _loc1_ = getDefinitionByName("OptionsSeparator") as Class;
            this.mcSeparator = new _loc1_() as W3OptionsSeparator;
            addChildAt(this.mcSeparator,getChildIndex(textField));
         }
         this.mcSeparator.label.text = "";
         this.mcSeparator.x = -150 + 300;
         this.mcSeparator.y = 34;
         this.mcSeparator.width = this.width - 600;
         this.mcSeparator.height = this.height;
         this.mcSeparator.visible = true;
         this.mcSeparator.alpha = 0.05;
         this.invalidate();
         this.validateNow();
      }
      
      internal function CreateSlider() : void
      {
         var _loc1_:Class = null;
         if(this.mcSlider == null)
         {
            _loc1_ = getDefinitionByName("SubMenuSlider") as Class;
            this.mcSlider = new _loc1_() as W3Slider;
         }
         this.mcSlider.removeEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false);
         this.mcSlider.removeEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false);
         removeEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false);
         this.mcSlider.x = !!data.isDropdownContent ? 520 : 720;
         this.mcSlider.y = 35;
         this.mcSlider.setActualSize(!!data.isDropdownContent ? 200 : 296,this.mcSlider.height);
         this.mcSlider.snapInterval = data.subElements.length >= 3 ? Number((data.subElements[1] - data.subElements[0]) / data.subElements[2]) : 1;
         this.mcSlider.snapping = true;
         this.mcSlider.offsetLeft = 30;
         this.mcSlider.offsetRight = 35;
         this.mcSlider.maximum = data.subElements.length >= 2 ? Number(data.subElements[1]) : 1;
         this.mcSlider.minimum = data.subElements.length >= 1 ? Number(data.subElements[0]) : 0;
         this.mcSlider.previousValue = -1;
         this.mcSlider.lockedValue = this.mcSlider.maximum + 1;
         this.mcSlider.value = Number(data.current);
         this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false,0,false);
         this.mcSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false,0,true);
         addEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false,0,false);
         addChildAt(this.mcSlider,getChildIndex(textField));
         this.mcSlider.invalidate();
         this.mcSlider.validateNow();
      }
      
      internal function OnSliderValueChanged(param1:SliderEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mcSlider)
         {
            _loc2_ = this.mcSlider.value;
         }
         if(data.type == IngameMenu.IGMActionType_Slider)
         {
            data.current = _loc2_.toString();
            _loc3_ = int(Math.ceil(100 * this.mcSlider.value)) / 100;
            this._currentValue = _loc3_.toString();
            if(_loc3_ != int(_loc3_))
            {
               if(this._currentValue.length < 4)
               {
                  this._currentValue += "0";
               }
               else if(this._currentValue.length > 4)
               {
                  this._currentValue.slice(0,4);
               }
            }
            else if(this._currentValue.length > 4)
            {
               this._currentValue = this._currentValue.slice(0,4);
            }
         }
         else if(data.type == IngameMenu.IGMActionType_Toggle)
         {
            if(_loc2_ == 0)
            {
               data.current = "false";
               this._currentValue = data.hasOwnProperty("offString") ? String(data.offString) : TOGGLE_OFF_STRING;
               this._currentTextColor = 8421504;
            }
            else
            {
               data.current = "true";
               this._currentValue = data.hasOwnProperty("onString") ? String(data.onString) : TOGGLE_ON_STRING;
               this._currentTextColor = 16777215;
            }
         }
         else if(data.type == IngameMenu.IGMActionType_List || data.type == IngameMenu.IGMActionType_ListWithCondition)
         {
            data.current = _loc2_.toString();
            this._currentValue = data.subElements[_loc2_];
         }
         this.updateCurrentValue();
         if(Boolean(this._ingameMenu) && Boolean(this._ingameMenu.mcOptionListModule))
         {
            this._ingameMenu.mcOptionListModule.updateDescriptionText(data);
         }
         if(!this._supressEvents)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionValueChanged",[data.groupID,data.tag,data.current]));
         }
      }
      
      private function onStepperValueChanged(param1:IndexEvent) : void
      {
         if(this._type == IngameMenu.IGMActionType_ToggleStepper)
         {
            data.current = param1.index == 0 ? "false" : "true";
         }
         else
         {
            data.current = param1.index.toString();
         }
         if(Boolean(this._ingameMenu) && Boolean(this._ingameMenu.mcOptionListModule))
         {
            this._ingameMenu.mcOptionListModule.updateDescriptionText(data);
         }
         if(!this._supressEvents)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionValueChanged",[data.groupID,data.tag,data.current]));
         }
      }
      
      internal function CreateToggleSlider(param1:int) : void
      {
         var _loc2_:Class = null;
         if(this.mcSlider == null)
         {
            _loc2_ = this._type == IngameMenu.IGMActionType_Toggle ? getDefinitionByName("SubMenuSliderToggle") as Class : getDefinitionByName("SubMenuSlider") as Class;
            this.mcSlider = new _loc2_() as W3Slider;
         }
         this.mcSlider.removeEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false);
         this.mcSlider.removeEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false);
         removeEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false);
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            this.mcSlider.x = !!data.isDropdownContent ? 520 : 720;
            this.mcSlider.y = 35;
            this.mcSlider.setActualSize(!!data.isDropdownContent ? 100 : 140,this.mcSlider.actualHeight);
            this.mcSlider.offsetLeft = 35;
            this.mcSlider.offsetRight = 45;
         }
         else
         {
            this.mcSlider.x = !!data.isDropdownContent ? 520 : 720;
            this.mcSlider.y = 35;
            this.mcSlider.setActualSize(!!data.isDropdownContent ? 200 : 296,this.mcSlider.actualHeight);
            this.mcSlider.offsetLeft = 32;
            this.mcSlider.offsetRight = 35;
         }
         this.mcSlider.snapInterval = 1;
         this.mcSlider.maximum = param1;
         this.mcSlider.minimum = 0;
         this.mcSlider.snapping = true;
         if(data.current == "true")
         {
            this.mcSlider.value = 1;
         }
         else if(data.current == "false")
         {
            this.mcSlider.value = 0;
         }
         else
         {
            this.mcSlider.value = Number(data.current);
         }
         this.updateCurrentValue();
         if(this._type == IngameMenu.IGMActionType_ListWithCondition)
         {
            this.mcSlider.skipValue = Number(data.skip);
            this.mcSlider.lockedValue = Number(data.lock);
            this.mcSlider.gEvent = new GameEvent(GameEvent.CALL,"OnCancelOptionValueChange",[data.groupID,data.tag]);
         }
         this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false,0,false);
         this.mcSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false,0,true);
         addEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false,0,false);
         addChildAt(this.mcSlider,getChildIndex(textField));
         this.mcSlider.invalidate();
         this.mcSlider.validateNow();
      }
      
      public function activate() : void
      {
         if(Boolean(data) && Boolean(data.disabled))
         {
            return;
         }
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            this.mcSlider.value = this.mcSlider.value == 0 ? 1 : 0;
         }
         else if(this._type == IngameMenu.IGMActionType_Button)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnButtonClicked",[data.tag]));
         }
      }
      
      internal function OnCallConfirm(param1:ButtonEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfirm"));
      }
      
      protected function onSliderMouseOut(param1:MouseEvent) : void
      {
         this.mcSlider.focused = 0;
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         this.updateCurrentValue();
         if(this.mcSelectionHighlightPro)
         {
            this.mcSelectionHighlightPro.mouseEnabled = false;
         }
      }
      
      protected function updateCurrentValue() : void
      {
         var _loc1_:* = undefined;
         if(this.data && !this.data.streamable && Boolean(this._ingameMenu))
         {
            this._ingameMenu.mcInputFeedbackModule.removeButton(ACTION_DOWNLOAD,true);
         }
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            this.tfCurrentValue.htmlText = this._currentValue;
            this.tfCurrentValue.textColor = this._currentTextColor;
         }
         else if(Boolean(this.data) && Boolean(this.data.streamable))
         {
            _loc1_ = Boolean(this.data.streamableStatus[this.mcSlider.value].optionStatus);
            this.tfCurrentValue.htmlText = !!_loc1_ ? "" : "[[options_language_not_installed]]";
            this.tfCurrentValue.htmlText = !!_loc1_ ? this._currentValue : this._currentValue + " (" + this.tfCurrentValue.htmlText + ")";
            if(this.downloadBtn)
            {
               this.downloadBtn.visible = !_loc1_;
            }
            if(this.hintBtn)
            {
               this.hintBtn.visible = !_loc1_;
            }
            if(this._ingameMenu)
            {
               if(!_loc1_ && !this._ingameMenu.mcInputFeedbackModule.showBackground)
               {
                  this._ingameMenu.mcInputFeedbackModule.appendButton(ACTION_DOWNLOAD,gamepadButtonDownload,keyboardButtonDownload,"[[options_language_request_download]]",true);
               }
               else
               {
                  this._ingameMenu.mcInputFeedbackModule.removeButton(ACTION_DOWNLOAD,true);
               }
            }
         }
         else
         {
            this.tfCurrentValue.htmlText = this._currentValue;
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
      }
      
      override protected function handleClick(param1:uint = 0) : void
      {
         if(Boolean(data) && Boolean(data.disabled))
         {
            return;
         }
         this.activate();
      }
      
      override public function set mouseChildren(param1:Boolean) : void
      {
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            super.mouseChildren = false;
         }
         else
         {
            super.mouseChildren = !(data && data.disabled);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.navEquivalent == gamepadButtonDownload || _loc2_.code == keyboardButtonDownload;
         if(_loc2_.value == InputValue.KEY_DOWN && _loc3_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnDownloadContentRequested",[data.groupID,data.tag,data.current]));
            param1.handled = true;
         }
         if(Boolean(this.mcSlider) && this.mcSlider.visible)
         {
            this.mcSlider.handleInput(param1);
         }
         if(Boolean(this.mcStepper) && this.mcStepper.visible)
         {
            this.mcStepper.handleInput(param1);
         }
         if(!param1.handled)
         {
            super.handleInput(param1);
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         if(super.selected == param1)
         {
            if(Boolean(data) && data.hasOwnProperty("tag"))
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionSelectionChanged",[data.tag,param1]));
            }
            return;
         }
         super.selected = param1;
         if(!param1 && (this._type == IngameMenu.IGMActionType_List || this._type == IngameMenu.IGMActionType_ListWithCondition))
         {
            focused = 0;
            this._ingameMenu.focused = 1;
         }
         if(this.mcSelectionHighlightPro)
         {
            if(param1)
            {
               this.mcSelectionHighlightPro.alpha = 1;
            }
            else
            {
               this.mcSelectionHighlightPro.alpha = 0;
            }
         }
         if(Boolean(data) && data.hasOwnProperty("tag"))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionSelectionChanged",[data.tag,param1]));
         }
      }
      
      public function showTooltip() : void
      {
      }
      
      public function hideTooltip() : void
      {
      }
      
      protected function pendedTooltipShow(param1:Event) : void
      {
      }
      
      protected function pendedTooltipHide(param1:Event) : void
      {
      }
      
      protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
      }
      
      protected function fireTooltipHideEvent(param1:Boolean = false) : void
      {
      }
      
      public function getGlobalRect() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle(x,y,width,height);
         var _loc2_:Point = localToGlobal(new Point(_loc1_.x,_loc1_.y));
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return _loc1_;
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
            if(autoSize != TextFieldAutoSize.NONE)
            {
               invalidateSize();
            }
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            if(!preventAutosizing)
            {
               alignForAutoSize();
               setActualSize(_width,_height);
            }
            if(!constraintsDisabled)
            {
               constraints.update(_width,_height);
            }
         }
      }
   }
}
