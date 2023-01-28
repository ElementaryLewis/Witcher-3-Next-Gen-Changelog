package red.game.witcher3.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import red.core.CoreComponent;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.ScrollIndicator;
   import scaleform.clik.controls.TextArea;
   import scaleform.clik.utils.ConstrainedElement;
   
   public class W3TextArea extends TextArea
   {
       
      
      protected var _scrollSpeed:Number;
      
      protected var _baseTextColor:uint;
      
      protected var _uppercase:Boolean;
      
      protected var _alignArabicText:Boolean;
      
      protected var txtInitPosition:Number;
      
      protected var _textColorChange:uint;
      
      public function W3TextArea()
      {
         super();
         this.txtInitPosition = textField.x;
      }
      
      public function get uppercase() : Boolean
      {
         return this._uppercase;
      }
      
      public function set uppercase(param1:Boolean) : void
      {
         this._uppercase = param1;
      }
      
      public function get alignArabicText() : Boolean
      {
         return this._alignArabicText;
      }
      
      public function set alignArabicText(param1:Boolean) : void
      {
         this._alignArabicText = param1;
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         super.text = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelScroll,false,0,true);
         this._baseTextColor = textField.textColor;
         this._textColorChange = this._baseTextColor;
      }
      
      override public function set position(param1:int) : void
      {
         super.position = param1;
         scrollBar.position = param1;
         if(_maxScroll > 1)
         {
            if(position != param1)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_scroll_description"]));
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_scroll_description_failed"]));
            }
         }
      }
      
      public function get scrollSpeed() : Number
      {
         return this._scrollSpeed;
      }
      
      public function set scrollSpeed(param1:Number) : void
      {
         this._scrollSpeed = param1;
      }
      
      public function changeScrollBarPolicy(param1:String) : void
      {
         _scrollPolicy = param1;
         this.updateScrollBar();
      }
      
      override protected function updateText() : void
      {
         var _loc1_:TextFormat = null;
         super.updateText();
         if(this._baseTextColor != this._textColorChange || textField.textColor != this._baseTextColor)
         {
            textField.textColor = this._textColorChange;
         }
         if(this._uppercase)
         {
            textField.htmlText = CommonUtils.toUpperCaseSafe(textField.htmlText);
         }
         if(this._alignArabicText && CoreComponent.isArabicAligmentMode)
         {
            _loc1_ = textField.getTextFormat();
            _loc1_.align = TextFormatAlign.RIGHT;
            textField.setTextFormat(_loc1_);
            textField.x = this.txtInitPosition - (textField.width - textField.textWidth);
         }
         else
         {
            textField.x = this.txtInitPosition;
         }
      }
      
      override protected function updateScrollBar() : void
      {
         _maxScroll = textField.maxScrollV;
         var _loc1_:ScrollIndicator = _scrollBar as ScrollIndicator;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:ConstrainedElement = constraints.getElement("textField");
         if(_scrollPolicy == "on" || _scrollPolicy == "auto" && textField.maxScrollV > 1)
         {
            if(_autoScrollBar && !_loc1_.visible)
            {
               if(_loc2_ != null)
               {
                  constraints.update(_width,_height);
                  invalidate();
               }
               _maxScroll = textField.maxScrollV;
            }
            _loc1_.visible = true;
         }
         if(_scrollPolicy == "off" || _scrollPolicy == "auto" && textField.maxScrollV < 2)
         {
            if(_loc1_.visible)
            {
               _loc1_.visible = false;
            }
            if(_autoScrollBar)
            {
               if(_loc2_ != null)
               {
                  constraints.update(availableWidth,_height);
                  invalidate();
               }
            }
         }
         if(_loc1_.enabled != enabled)
         {
            _loc1_.enabled = enabled;
         }
      }
      
      public function CanBeFocused() : Boolean
      {
         return textField.maxScrollV > 1;
      }
      
      public function setTextColor(param1:uint) : void
      {
         this._textColorChange = param1;
         textField.textColor = this._textColorChange;
      }
      
      public function resetTextColor() : void
      {
         this._textColorChange = this._baseTextColor;
         textField.textColor = this._textColorChange;
      }
      
      override protected function blockMouseWheel(param1:MouseEvent) : void
      {
      }
      
      protected function onMouseWheelScroll(param1:MouseEvent) : void
      {
         this.position = textField.scrollV;
      }
      
      override protected function onScroller(param1:Event) : void
      {
         super.onScroller(param1);
         this.updateScrollBar();
      }
   }
}
