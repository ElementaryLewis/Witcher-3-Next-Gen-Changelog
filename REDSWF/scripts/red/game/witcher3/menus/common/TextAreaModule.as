package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.CoreMenuModule;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.managers.InputFeedbackManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class TextAreaModule extends CoreMenuModule
   {
      
      public static const TEXT_HEIGHT_PADDING:int = 0.5;
      
      public static const TEXT_HEADER_PADDING_BOTTOM:int = 18;
       
      
      public var tfTitle:TextField;
      
      public var tfDifficulty:TextField;
      
      public var tfLocation:TextField;
      
      public var headerColor:MovieClip;
      
      public var crests:MovieClip;
      
      public var skullIcon:MovieClip;
      
      public var mcTextArea:W3TextArea;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcSeparator:Sprite;
      
      public var mcFrameDescr:MovieClip;
      
      protected var _inputSymbolScroll:int = -1;
      
      protected var _moduleDisplayName:String = "";
      
      protected var _lastTitle:String = "";
      
      protected var _lastText:String = "";
      
      public function TextAreaModule()
      {
         super();
         if(this.skullIcon)
         {
            this.skullIcon.visible = false;
         }
         if(this.crests)
         {
            this.crests.visible = false;
         }
         if(this.headerColor)
         {
            this.headerColor.visible = false;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = false;
         _inputHandlers.push(this.mcTextArea);
         this.SetTitle(this._lastTitle);
         this.SetText(this._lastText);
      }
      
      override public function hasSelectableItems() : Boolean
      {
         if(this.mcScrollbar.visible && this.mcScrollbar.enabled)
         {
            return true;
         }
         return false;
      }
      
      public function SetTitle(param1:String) : void
      {
         this._lastTitle = param1;
         if(this.tfTitle)
         {
            this._moduleDisplayName = param1;
            if(CoreComponent.isArabicAligmentMode)
            {
               param1 = "<p align=\"right\">" + param1 + "</p>";
            }
            this.tfTitle.htmlText = param1;
            this.tfTitle.htmlText = CommonUtils.toUpperCaseSafe(this.tfTitle.htmlText);
         }
         handleDataChanged();
         this.updateTextPositions();
      }
      
      public function setDifficulty(param1:String) : void
      {
         var _loc2_:* = null;
         if(param1 == "")
         {
            this.tfDifficulty.visible = false;
         }
         else
         {
            this.tfDifficulty.visible = true;
            _loc2_ = CommonUtils.toUpperCaseSafe(param1);
            if(CoreComponent.isArabicAligmentMode)
            {
               _loc2_ = "<p align=\"right\">" + _loc2_ + "</p>";
            }
            this.tfDifficulty.htmlText = _loc2_;
         }
         this.updateTextPositions();
      }
      
      public function ShowSkullIcon(param1:Boolean) : void
      {
         if(this.skullIcon)
         {
            this.skullIcon.visible = param1;
         }
      }
      
      public function setLocation(param1:String) : void
      {
         var _loc2_:* = CommonUtils.toUpperCaseSafe(param1);
         if(CoreComponent.isArabicAligmentMode)
         {
            _loc2_ = "<p align=\"right\">" + _loc2_ + "</p>";
         }
         this.tfLocation.htmlText = _loc2_;
         this.updateTextPositions();
      }
      
      public function setCrest(param1:String) : void
      {
         if(this.crests)
         {
            this.crests.gotoAndStop(param1);
            this.crests.visible = true;
         }
      }
      
      public function updateTextPositions() : *
      {
         if(this.tfLocation && this.tfDifficulty && this.headerColor && this.crests && Boolean(this.skullIcon))
         {
            if(this.tfDifficulty.visible == true)
            {
               this.tfLocation.y = this.tfTitle.y + this.tfTitle.textHeight + TEXT_HEIGHT_PADDING;
               this.tfDifficulty.y = this.tfLocation.y + this.tfLocation.textHeight + TEXT_HEIGHT_PADDING;
               this.headerColor.height = this.tfTitle.textHeight + this.tfLocation.textHeight + this.tfDifficulty.textHeight + TEXT_HEADER_PADDING_BOTTOM;
               this.crests.y = this.headerColor.y + this.headerColor.height / 2 - this.crests.height / 2;
               this.skullIcon.y = this.tfDifficulty.y + this.tfDifficulty.textHeight / 2 - this.skullIcon.height / 2;
            }
            else
            {
               this.tfLocation.y = this.tfTitle.y + this.tfTitle.textHeight + TEXT_HEIGHT_PADDING;
               this.headerColor.height = this.tfTitle.textHeight + this.tfLocation.textHeight + TEXT_HEADER_PADDING_BOTTOM;
               this.crests.y = this.headerColor.y + this.headerColor.height / 2 - this.crests.height / 2;
               this.skullIcon.visible = false;
            }
         }
      }
      
      public function setHeaderColor(param1:Number) : void
      {
         if(this.headerColor)
         {
            this.headerColor.visible = true;
            this.headerColor.gotoAndStop(1);
            switch(param1)
            {
               case 0:
                  this.headerColor.gotoAndStop("main");
                  break;
               case 1:
                  this.headerColor.gotoAndStop("main");
                  break;
               case 2:
                  this.headerColor.gotoAndStop("secondary");
                  break;
               case 3:
                  this.headerColor.gotoAndStop("contract");
                  break;
               case 4:
                  this.headerColor.gotoAndStop("treasurehunt");
            }
         }
      }
      
      public function SetText(param1:String) : void
      {
         this._lastText = param1;
         if(CoreComponent.isArabicAligmentMode)
         {
            param1 = "<p align=\"right\">" + param1 + "</p>";
         }
         this.mcTextArea.htmlText = param1;
         if(this.mcFrameDescr)
         {
            if(param1 == "")
            {
               this.mcFrameDescr.visible = false;
            }
            else
            {
               this.mcFrameDescr.visible = true;
            }
         }
         handleDataChanged();
         validateNow();
         this.updateInputFeedback();
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         if(_focused)
         {
            this.SetAsActiveContainer(true);
         }
         else
         {
            this.SetAsActiveContainer(false);
         }
         this.updateInputFeedback();
      }
      
      public function SetAsActiveContainer(param1:Boolean) : *
      {
         if(this.tfTitle)
         {
            this.tfTitle.htmlText = this._moduleDisplayName;
            this.tfTitle.htmlText = CommonUtils.toUpperCaseSafe(this.tfTitle.htmlText);
            this.tfTitle.height = this.tfTitle.textHeight;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:UIComponent = null;
         if(param1.handled || !focused)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         for each(_loc4_ in _inputHandlers)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            _loc4_.handleInput(param1);
         }
         if(_loc3_)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.DOWN:
               case NavigationCode.UP:
                  param1.handled = true;
                  return;
            }
         }
      }
      
      protected function scrollFocusCheck() : Boolean
      {
         return focused == 1;
      }
      
      protected function updateInputFeedback() : void
      {
         var _loc1_:Boolean = false;
         if(this.scrollFocusCheck())
         {
            _loc1_ = this.mcScrollbar.visible;
         }
         else
         {
            _loc1_ = false;
         }
         if(_loc1_ && this._inputSymbolScroll == -1)
         {
            this._inputSymbolScroll = InputFeedbackManager.appendButton(this,NavigationCode.GAMEPAD_RSTICK_SCROLL,-1,"input_feedback_scroll_text");
         }
         else if(!_loc1_ && this._inputSymbolScroll != -1)
         {
            InputFeedbackManager.removeButton(this,this._inputSymbolScroll);
            this._inputSymbolScroll = -1;
         }
         InputFeedbackManager.updateButtons(this);
      }
   }
}
