package scaleform.clik.controls
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.utils.InputUtils;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.ConstrainMode;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ComponentEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IScrollBar;
   import scaleform.clik.ui.InputDetails;
   import scaleform.clik.utils.ConstrainedElement;
   import scaleform.clik.utils.Constraints;
   import scaleform.gfx.Extensions;
   
   public class TextArea extends TextInput
   {
      
      protected static const AXIS_INPUT_DELAY:Number = 300;
      
      protected static const AXIS_INPUT_REPEAT_DELAY:Number = 120;
       
      
      protected var _scrollPolicy:String = "auto";
      
      protected var _position:int = 1;
      
      protected var _maxScroll:Number = 1;
      
      protected var _resetScrollPosition:Boolean = false;
      
      protected var _scrollBarValue:Object;
      
      protected var _autoScrollBar:Boolean = false;
      
      protected var _thumbOffset:Object;
      
      protected var _minThumbSize:uint = 1;
      
      protected var _lastJoyUpdateTime:int = 0;
      
      protected var _lastJoyUpdateDir:String = "none";
      
      protected var _scrollBar:IScrollBar;
      
      public var container:Sprite;
      
      public function TextArea()
      {
         this._thumbOffset = {
            "top":0,
            "bottom":0
         };
         super();
      }
      
      override protected function preInitialize() : void
      {
         if(!constraintsDisabled)
         {
            constraints = new Constraints(this,ConstrainMode.COUNTER_SCALE);
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this.container == null)
         {
            this.container = new Sprite();
            addChild(this.container);
         }
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.updateScrollBar();
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(param1:int) : void
      {
         this._position = param1;
         textField.scrollV = this._position;
      }
      
      public function get scrollBar() : Object
      {
         return this._scrollBar;
      }
      
      public function set scrollBar(param1:Object) : void
      {
         this._scrollBarValue = param1;
         invalidate(InvalidationType.SCROLL_BAR);
      }
      
      public function get minThumbSize() : uint
      {
         return this._minThumbSize;
      }
      
      public function set minThumbSize(param1:uint) : void
      {
         this._minThumbSize = param1;
         if(!this._autoScrollBar)
         {
            return;
         }
         var _loc2_:ScrollIndicator = this._scrollBar as ScrollIndicator;
         _loc2_.minThumbSize = param1;
      }
      
      public function get thumbOffset() : Object
      {
         return this._thumbOffset;
      }
      
      public function set thumbOffset(param1:Object) : void
      {
         this._thumbOffset = param1;
         if(!this._autoScrollBar)
         {
            return;
         }
         var _loc2_:ScrollIndicator = this._scrollBar as ScrollIndicator;
         _loc2_.offsetTop = this._thumbOffset.top;
         _loc2_.offsetBottom = this._thumbOffset.bottom;
      }
      
      public function get availableWidth() : Number
      {
         return Math.round(_width) - (this._autoScrollBar && (this._scrollBar as MovieClip).visible ? Math.round(this._scrollBar.width) : 0);
      }
      
      public function get availableHeight() : Number
      {
         return Math.round(_height);
      }
      
      override public function toString() : String
      {
         return "[CLIK TextArea " + name + "]";
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:InputDetails = null;
         var _loc6_:Boolean = false;
         var _loc7_:InputAxisData = null;
         var _loc8_:Number = NaN;
         var _loc9_:InputDetails = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         if(_editable)
         {
            return;
         }
         _loc2_ = param1.details.navEquivalent;
         _loc3_ = getTimer();
         _loc4_ = _loc3_ - this._lastJoyUpdateTime;
         if(_loc3_ - this._lastJoyUpdateTime > AXIS_INPUT_DELAY * 2)
         {
            this._lastJoyUpdateDir = "none";
         }
         if((_loc5_ = param1.details).code == KeyCode.PAD_RIGHT_STICK_AXIS)
         {
            _loc6_ = false;
            _loc7_ = InputAxisData(_loc5_.value);
            _loc8_ = InputUtils.getAngleRadians(_loc7_.xvalue,_loc7_.yvalue);
            if((_loc9_ = CommonUtils.convertAxisToNavigationCode(_loc8_)).code == KeyCode.UP && (_loc4_ > AXIS_INPUT_DELAY || this._lastJoyUpdateDir == "uprepeat" && _loc4_ > AXIS_INPUT_REPEAT_DELAY))
            {
               if(this.position == 1)
               {
                  return;
               }
               this.position = Math.max(1,this.position - 1);
               param1.handled = true;
               _loc6_ = true;
               if(this._lastJoyUpdateDir == "up")
               {
                  this._lastJoyUpdateDir = "uprepeat";
               }
               else if(this._lastJoyUpdateDir != "uprepeat")
               {
                  this._lastJoyUpdateDir = "up";
               }
            }
            else if(_loc9_.code == KeyCode.DOWN && (_loc4_ > AXIS_INPUT_DELAY || this._lastJoyUpdateDir == "downrepeat" && _loc4_ > AXIS_INPUT_REPEAT_DELAY))
            {
               if(this.position == this._maxScroll)
               {
                  return;
               }
               this.position = Math.min(this._maxScroll,this.position + 1);
               param1.handled = true;
               _loc6_ = true;
               if(this._lastJoyUpdateDir == "down")
               {
                  this._lastJoyUpdateDir = "downrepeat";
               }
               else if(this._lastJoyUpdateDir != "downrepeat")
               {
                  this._lastJoyUpdateDir = "down";
               }
            }
            if(_loc6_)
            {
               this._lastJoyUpdateTime = _loc3_;
            }
         }
         switch(_loc2_)
         {
            case NavigationCode.UP:
               if(this.position == 1)
               {
                  return;
               }
               this.position = Math.max(1,this.position - 1);
               param1.handled = true;
               break;
            case NavigationCode.DOWN:
               if(this.position == this._maxScroll)
               {
                  return;
               }
               this.position = Math.min(this._maxScroll,this.position + 1);
               param1.handled = true;
               break;
            case NavigationCode.END:
               this.position = this._maxScroll;
               param1.handled = true;
               break;
            case NavigationCode.HOME:
               this.position = 1;
               param1.handled = true;
               break;
            case NavigationCode.PAGE_UP:
               _loc10_ = textField.bottomScrollV - textField.scrollV;
               this.position = Math.max(1,this.position - _loc10_);
               param1.handled = true;
               break;
            case NavigationCode.PAGE_DOWN:
               _loc11_ = textField.bottomScrollV - textField.scrollV;
               this.position = Math.min(this._maxScroll,this.position + _loc11_);
               param1.handled = true;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(textField != null)
         {
            textField.addEventListener(Event.SCROLL,this.onScroller,false,0,true);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:uint = 0;
         if(isInvalid(InvalidationType.SCROLL_BAR))
         {
            this.createScrollBar();
         }
         if(isInvalid(InvalidationType.STATE))
         {
            if(_newFrame)
            {
               gotoAndPlay(_newFrame);
               _newFrame = null;
            }
            updateAfterStateChange();
            this.updateTextField();
            dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
            invalidate(InvalidationType.SIZE);
         }
         else if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            removeChild(this.container);
            setActualSize(_width,_height);
            this.container.scaleX = 1 / scaleX;
            this.container.scaleY = 1 / scaleY;
            if(!constraintsDisabled)
            {
               constraints.update(this.availableWidth,_height);
               if(!Extensions.enabled)
               {
                  _loc1_ = textField.textWidth;
               }
            }
            addChild(this.container);
            if(this._autoScrollBar)
            {
               this.drawScrollBar();
            }
         }
      }
      
      protected function createScrollBar() : void
      {
         var _loc1_:IScrollBar = null;
         var _loc2_:Class = null;
         var _loc3_:Object = null;
         if(this._scrollBar != null)
         {
            this._scrollBar.removeEventListener(Event.SCROLL,this.handleScroll,false);
            this._scrollBar.removeEventListener(Event.CHANGE,this.handleScroll,false);
            this._scrollBar.focusTarget = null;
            if(this.container.contains(this._scrollBar as DisplayObject))
            {
               this.container.removeChild(this._scrollBar as DisplayObject);
            }
            this._scrollBar = null;
         }
         if(!this._scrollBarValue || this._scrollBarValue == "")
         {
            return;
         }
         this._autoScrollBar = false;
         if(this._scrollBarValue is String)
         {
            if(parent != null)
            {
               _loc1_ = parent.getChildByName(this._scrollBarValue.toString()) as IScrollBar;
            }
            if(_loc1_ == null)
            {
               _loc2_ = getDefinitionByName(this._scrollBarValue.toString()) as Class;
               if(_loc2_)
               {
                  _loc1_ = new _loc2_() as IScrollBar;
               }
               if(_loc1_)
               {
                  this._autoScrollBar = true;
                  _loc3_ = _loc1_ as Object;
                  if(Boolean(_loc3_) && Boolean(this._thumbOffset))
                  {
                     _loc3_.offsetTop = this._thumbOffset.top;
                     _loc3_.offsetBottom = this._thumbOffset.bottom;
                  }
                  _loc1_.addEventListener(MouseEvent.MOUSE_WHEEL,this.blockMouseWheel,false,0,true);
                  (_loc1_ as Object).minThumbSize = this._minThumbSize;
                  this.container.addChild(_loc1_ as DisplayObject);
               }
            }
         }
         else if(this._scrollBarValue is Class)
         {
            _loc1_ = new (this._scrollBarValue as Class)() as IScrollBar;
            _loc1_.addEventListener(MouseEvent.MOUSE_WHEEL,this.blockMouseWheel,false,0,true);
            if(_loc1_ != null)
            {
               this._autoScrollBar = true;
               (_loc1_ as Object).offsetTop = this._thumbOffset.top;
               (_loc1_ as Object).offsetBottom = this._thumbOffset.bottom;
               (_loc1_ as Object).minThumbSize = this._minThumbSize;
               this.container.addChild(_loc1_ as DisplayObject);
            }
         }
         else
         {
            _loc1_ = this._scrollBarValue as IScrollBar;
         }
         this._scrollBar = _loc1_;
         invalidateSize();
         if(this._scrollBar != null)
         {
            this._scrollBar.addEventListener(Event.SCROLL,this.handleScroll,false,0,true);
            this._scrollBar.addEventListener(Event.CHANGE,this.handleScroll,false,0,true);
            this._scrollBar.focusTarget = this;
            (this._scrollBar as Object).scrollTarget = textField;
            this._scrollBar.tabEnabled = false;
         }
      }
      
      protected function drawScrollBar() : void
      {
         if(!this._autoScrollBar)
         {
            return;
         }
         this._scrollBar.x = _width - this._scrollBar.width;
         this._scrollBar.height = this.availableHeight;
         this._scrollBar.validateNow();
      }
      
      protected function updateScrollBar() : void
      {
         this._maxScroll = textField.maxScrollV;
         var _loc1_:ScrollIndicator = this._scrollBar as ScrollIndicator;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:ConstrainedElement = constraints.getElement("textField");
         if(this._scrollPolicy == "on" || this._scrollPolicy == "auto" && textField.maxScrollV > 1)
         {
            if(this._autoScrollBar && !_loc1_.visible)
            {
               if(_loc2_ != null)
               {
                  constraints.update(_width,_height);
                  invalidate();
               }
               this._maxScroll = textField.maxScrollV;
            }
            _loc1_.visible = true;
         }
         if(this._scrollPolicy == "off" || this._scrollPolicy == "auto" && textField.maxScrollV == 1)
         {
            if(this._autoScrollBar && _loc1_.visible)
            {
               _loc1_.visible = false;
               if(_loc2_ != null)
               {
                  constraints.update(this.availableWidth,_height);
                  invalidate();
               }
            }
         }
         if(_loc1_.enabled != this.enabled)
         {
            _loc1_.enabled = this.enabled;
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         this.updateScrollBar();
      }
      
      override protected function updateTextField() : void
      {
         this._resetScrollPosition = true;
         super.updateTextField();
      }
      
      protected function handleScroll(param1:Event) : void
      {
         this.position = this._scrollBar.position;
      }
      
      protected function blockMouseWheel(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      override protected function handleTextChange(param1:Event) : void
      {
         if(this._maxScroll != textField.maxScrollV)
         {
            this.updateScrollBar();
         }
         super.handleTextChange(param1);
      }
      
      protected function onScroller(param1:Event) : void
      {
         if(this._resetScrollPosition)
         {
            textField.scrollV = this._position;
         }
         else
         {
            this._position = textField.scrollV;
         }
         this._resetScrollPosition = false;
      }
   }
}
