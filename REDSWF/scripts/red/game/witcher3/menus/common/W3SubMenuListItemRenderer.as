package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3Slider;
   import red.game.witcher3.menus.mainmenu.IngameMenu;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   
   public class W3SubMenuListItemRenderer extends BaseListItem
   {
      
      protected static const TOGGLE_ON_STRING:String = "[[panel_mainmenu_option_value_on]]";
      
      protected static const TOGGLE_OFF_STRING:String = "[[panel_mainmenu_option_value_off]]";
       
      
      public var tfCurrentValue:TextField;
      
      public var tfMinValue:TextField;
      
      public var tfMaxValue:TextField;
      
      public var mcHitArea:MovieClip;
      
      public var mcSlider:W3Slider;
      
      private var _currentValue:String = "";
      
      private var _id:String = "";
      
      private var _type:int;
      
      public var mcSelectionHighlightPro:MovieClip;
      
      private var _startingXForCurrent:Number;
      
      protected var _initialValueSet:Boolean = false;
      
      public function W3SubMenuListItemRenderer()
      {
         super();
         preventAutosizing = true;
         mouseEnabled = true;
         this.mouseChildren = true;
         hitArea = this.mcHitArea;
         if(this.mcSlider)
         {
            this.mcSlider.enableSounds = true;
         }
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
      }
      
      override public function setData(param1:Object) : void
      {
         this._initialValueSet = false;
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
         this.CreateSubElementByType(param1.type);
         this.OnSliderValueChanged(null);
      }
      
      public function setSelectionVisible(param1:Boolean) : void
      {
         if(this.mcSlider)
         {
            this.mcSlider.focused = 0;
         }
      }
      
      internal function CreateSubElementByType(param1:uint) : *
      {
         if(this.mcSlider)
         {
            this.mcSlider.removeEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false);
            this.mcSlider.removeEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false);
            removeEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false);
            removeChild(this.mcSlider);
            this.mcSlider = null;
            this.tfMaxValue.htmlText = "";
            this.tfMinValue.htmlText = "";
         }
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
         }
      }
      
      internal function CreateSlider() : void
      {
         var _loc1_:Class = getDefinitionByName("SubMenuSlider") as Class;
         if(_loc1_ != null)
         {
            this.mcSlider = new _loc1_() as W3Slider;
            this.mcSlider.x = 117;
            this.mcSlider.y = 52;
            this.mcSlider.width = 540;
            if(data.subElements.length >= 3)
            {
               this.mcSlider.snapInterval = Number((data.subElements[1] - data.subElements[0]) / data.subElements[2]);
            }
            else
            {
               this.mcSlider.snapInterval = 1;
            }
            this.mcSlider.snapping = true;
            this.mcSlider.offsetLeft = 35;
            this.mcSlider.offsetRight = 35;
            if(data.subElements.length >= 2)
            {
               this.mcSlider.maximum = Number(data.subElements[1]);
            }
            else
            {
               this.mcSlider.maximum = 1;
            }
            if(data.subElements.length >= 1)
            {
               this.mcSlider.minimum = Number(data.subElements[0]);
            }
            else
            {
               this.mcSlider.minimum = 0;
            }
            this.mcSlider.value = Number(data.current);
            addChildAt(this.mcSlider,getChildIndex(textField));
            this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false,0,false);
            this.mcSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false,0,true);
            addEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false,0,false);
            this.mcSlider.validateNow();
            this.tfCurrentValue.x = this._startingXForCurrent;
            this.tfMaxValue.visible = true;
            this.tfMinValue.visible = true;
            this.tfMaxValue.htmlText = this.mcSlider.maximum.toString();
            this.tfMinValue.htmlText = this.mcSlider.minimum.toString();
         }
      }
      
      internal function OnSliderValueChanged(param1:SliderEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = this.mcSlider.value;
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
               this._currentValue = TOGGLE_OFF_STRING;
            }
            else
            {
               data.current = "true";
               this._currentValue = TOGGLE_ON_STRING;
            }
         }
         else if(data.type == IngameMenu.IGMActionType_List)
         {
            data.current = _loc2_.toString();
            this._currentValue = data.subElements[_loc2_];
         }
         this.updateCurrentValue();
         if(this._initialValueSet)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionValueChanged",[data.groupID,data.tag,data.current]));
         }
         else
         {
            this._initialValueSet = true;
         }
      }
      
      internal function CreateToggleSlider(param1:int) : void
      {
         var _loc2_:Class = null;
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            _loc2_ = getDefinitionByName("SubMenuSliderToggle") as Class;
         }
         else
         {
            _loc2_ = getDefinitionByName("SubMenuSlider") as Class;
         }
         if(_loc2_ != null)
         {
            this.mcSlider = new _loc2_() as W3Slider;
            if(this._type == IngameMenu.IGMActionType_Toggle)
            {
               this.mcSlider.x = 513;
               this.mcSlider.width = 140;
               this.mcSlider.y = 17;
            }
            else
            {
               this.mcSlider.x = 117;
               this.mcSlider.width = 540;
               this.mcSlider.y = 52;
            }
            this.mcSlider.snapInterval = 1;
            this.mcSlider.maximum = param1;
            this.mcSlider.minimum = 0;
            this.mcSlider.snapping = true;
            this.mcSlider.offsetLeft = 35;
            this.mcSlider.offsetRight = 35;
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
            addChildAt(this.mcSlider,getChildIndex(textField));
            this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false,0,false);
            this.mcSlider.addEventListener(MouseEvent.MOUSE_OUT,this.onSliderMouseOut,false,0,true);
            addEventListener(ButtonEvent.PRESS,this.OnCallConfirm,false,0,false);
            this.mcSlider.validateNow();
            this.tfCurrentValue.x = this._startingXForCurrent;
            if(this._type == IngameMenu.IGMActionType_Toggle)
            {
               this.tfMaxValue.visible = false;
               this.tfMinValue.visible = false;
            }
            else
            {
               this.tfMaxValue.visible = true;
               this.tfMinValue.visible = true;
               this.tfMaxValue.htmlText = data.subElements[data.subElements.length - 1];
               this.tfMinValue.htmlText = data.subElements[0];
            }
            this.updateCurrentValue();
         }
      }
      
      public function activate() : void
      {
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            this.mcSlider.value = this.mcSlider.value == 0 ? 1 : 0;
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
         if(this._type == IngameMenu.IGMActionType_Toggle)
         {
            this.tfCurrentValue.htmlText = "<p align=\"left\">" + this._currentValue + "</p>";
            this.tfCurrentValue.x = this.tfMaxValue.x;
         }
         else
         {
            this.tfCurrentValue.htmlText = "<p align=\"right\">" + this._currentValue + "</p>";
            this.tfCurrentValue.x = this._startingXForCurrent;
         }
      }
      
      override protected function updateAfterStateChange() : void
      {
      }
      
      override protected function handleClick(param1:uint = 0) : void
      {
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
            super.mouseChildren = true;
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(this.mcSlider)
         {
            this.mcSlider.handleInput(param1);
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
            return;
         }
         super.selected = param1;
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
   }
}
