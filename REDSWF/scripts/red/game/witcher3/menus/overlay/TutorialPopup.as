package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class TutorialPopup extends UIComponent
   {
      
      protected static const MIN_WIDTH:Number = 480;
      
      protected static const MAX_WIDTH:Number = 600;
      
      protected static const EDGE_PADDING:Number = 5;
      
      protected static const UI_EDGE_PADDING:Number = 40;
      
      protected static const GRADIENT_PADDING:Number = 115;
      
      protected static const TOP_BORDER_POS:Number = -7;
      
      protected static const BUTTONS_PADDING:Number = 15;
      
      protected static const BUTTONS_OFFSET:Number = 10;
      
      protected static const TOP_OFFSET_FOR_TITLE:Number = 90;
      
      protected static const SAFE_TEXTFIELD_OFFSET:Number = 5;
      
      protected static const BLOCK_PADDING:Number = 2;
      
      protected static const GLOSSARY_RIGHT_PADDING:Number = 60;
      
      protected static const GLOSSARY_PADDING:Number = 10;
      
      protected static const GLOSSARY_HEIGHT:Number = 70;
      
      protected static const BOTTOM_PADDING:Number = 10;
       
      
      public var btnAccept:InputFeedbackButton;
      
      public var btnGlossary:InputFeedbackButton;
      
      public var txtTitle:TextField;
      
      public var txtDescription:TextField;
      
      public var topDelemiter:Sprite;
      
      public var background:MovieClip;
      
      public var titleModule:TutorialPopupTitle;
      
      public var mcErrorFeedback:MovieClip;
      
      public var mcCorrectFeedback:MovieClip;
      
      public var contentMask:Sprite;
      
      public var borderLineTop:Sprite;
      
      public var borderLineBottom:Sprite;
      
      protected var _autosize:Boolean;
      
      protected var _data:Object;
      
      protected var _imageLoader:UILoader;
      
      private const HOLD_CANVAS_OFFSET:Number = 200;
      
      public function TutorialPopup()
      {
         super();
         visible = false;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         if(this._data)
         {
            this._autosize = this._data.autosize;
            visible = false;
            this.cleanup();
            this.populateData();
         }
         else
         {
            this.cleanup();
         }
      }
      
      public function playFeedbackAnimation(param1:Boolean) : void
      {
         if(param1)
         {
            this.mcCorrectFeedback.gotoAndPlay(2);
         }
         else
         {
            this.mcErrorFeedback.gotoAndPlay(2);
         }
      }
      
      public function getPositionShiftX() : Number
      {
         var _loc1_:Rectangle = CommonUtils.getScreenRect();
         var _loc2_:Point = this.localToGlobal(new Point(this.txtDescription.x,this.txtDescription.y));
         var _loc3_:Number = _loc1_.width * 0.05;
         if(_loc2_.x < _loc3_)
         {
            return _loc3_ - _loc2_.x;
         }
         if(_loc2_.x + this.txtDescription.textWidth > _loc1_.x + _loc1_.width - _loc3_)
         {
            return _loc1_.x + _loc1_.width - _loc3_ - (_loc2_.x + this.txtDescription.textWidth);
         }
         return 0;
      }
      
      protected function populateData() : void
      {
         var _loc2_:TextFormat = null;
         var _loc3_:String = null;
         var _loc1_:Boolean = false;
         if(this._data.imagePath)
         {
            this.loadImage(this._data.imagePath);
            _loc1_ = true;
         }
         if(this._data.messageTitle)
         {
            this.txtTitle.text = this._data.messageTitle;
            this.txtTitle.text = CommonUtils.toUpperCaseSafe(this.txtTitle.text);
            this.txtTitle.height = this.txtTitle.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.txtTitle.textColor = !!this._data.isUiTutorial ? 0 : 11374417;
            this.topDelemiter.visible = true;
            _loc2_ = new TextFormat();
            if(CoreComponent.isArabicAligmentMode)
            {
               _loc2_.font = "$NormalFont";
            }
            else
            {
               _loc2_.font = "$BoldFont";
            }
            this.txtTitle.setTextFormat(_loc2_);
         }
         if(this._data.messageText)
         {
            this.txtDescription.width = MIN_WIDTH;
            this.txtDescription.multiline = true;
            this.txtDescription.wordWrap = true;
            _loc3_ = CommonUtils.fixFontStyleTags(this._data.messageText);
            if(this._data.isUiTutorial)
            {
               this._data.messageText = "<font color = \'#0\'>" + _loc3_ + "</font>";
            }
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtDescription.htmlText = "<p align=\"right\">" + this._data.messageText + "</p>";
            }
            else
            {
               this.txtDescription.htmlText = this._data.messageText;
            }
            this.txtDescription.visible = true;
         }
         if(this._data.enableGlossaryLink)
         {
            this.btnGlossary.clickable = false;
            this.btnGlossary.overrideTextColor = !!this._data.isUiTutorial ? 0 : -1;
            this.btnGlossary.label = "[[panel_title_glossary]]";
            this.btnGlossary.setDataFromStage(NavigationCode.GAMEPAD_BACK,-1,KeyCode.PAD_PS4_OPTIONS,1000);
            this.btnGlossary.visible = true;
            this.btnGlossary.holdCallback = this.handleGlossaryLink;
            this.btnGlossary.validateNow();
         }
         else
         {
            this.btnGlossary.holdCallback = null;
         }
         if(this._data.enableAcceptButton)
         {
            this.btnAccept.clickable = false;
            this.btnAccept.overrideTextColor = !!this._data.isUiTutorial ? 0 : -1;
            this.btnAccept.label = "[[panel_continue]]";
            this.btnAccept.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.SPACE);
            this.btnAccept.visible = true;
            this.btnAccept.validateNow();
         }
         else
         {
            this.btnAccept.visible = false;
         }
         this.background.gotoAndStop(!!this._data.isUiTutorial ? "ui" : "game");
         if(!_loc1_)
         {
            this.alignContent();
         }
      }
      
      private function alignContent() : void
      {
         var _loc1_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:* = new Namespace("");
         _loc1_ = 0;
         var _loc2_:Number = 0;
         var _loc3_:Rectangle = CommonUtils.getScreenRect();
         if(this.topDelemiter.visible)
         {
            _loc1_ += TOP_OFFSET_FOR_TITLE + BLOCK_PADDING;
         }
         else
         {
            _loc1_ += BLOCK_PADDING * 4;
         }
         if(this.txtDescription.visible)
         {
            this.txtDescription.y = _loc1_;
            _loc8_ = Math.min(MAX_WIDTH,this.txtDescription.textWidth + CommonConstants.SAFE_TEXT_PADDING);
            this.txtDescription.width = _loc8_;
            this.txtDescription.height = this.txtDescription.textHeight + SAFE_TEXTFIELD_OFFSET;
            _loc1_ += this.txtDescription.height + BLOCK_PADDING;
            _loc2_ = this.txtDescription.width;
         }
         if(this.btnAccept.visible)
         {
            this.btnAccept.y = _loc1_ + GLOSSARY_PADDING + GLOSSARY_HEIGHT / 2;
         }
         if(this.btnGlossary.visible)
         {
            this.btnGlossary.y = _loc1_ + GLOSSARY_PADDING + GLOSSARY_HEIGHT / 2;
         }
         if(this.btnAccept.visible || this.btnGlossary.visible)
         {
            _loc1_ += GLOSSARY_HEIGHT + GLOSSARY_PADDING;
         }
         _loc1_ += BOTTOM_PADDING;
         this.background.height = _loc1_ + BLOCK_PADDING;
         if(this._data.isUiTutorial)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = _loc3_.width * 0.05 + BLOCK_PADDING;
         }
         if(this._data.isUiTutorial)
         {
            _loc2_ = Math.max(MIN_WIDTH,_loc2_) + UI_EDGE_PADDING;
            this.background.width = _loc2_;
         }
         else
         {
            _loc2_ = Math.max(MIN_WIDTH,_loc2_) + EDGE_PADDING;
            this.background.width = _loc2_ + GRADIENT_PADDING + _loc4_;
         }
         this.mcCorrectFeedback.x = this.mcErrorFeedback.x = this.background.x;
         this.mcCorrectFeedback.y = this.mcErrorFeedback.y = this.background.y;
         this.mcCorrectFeedback.width = this.mcErrorFeedback.width = this.background.width;
         this.mcCorrectFeedback.height = this.mcErrorFeedback.height = this.background.height;
         var _loc5_:Number = Math.round(_loc2_ / 2) + _loc4_;
         var _loc6_:Number = Math.round(_loc1_ / 2);
         this.txtDescription.x = _loc5_ - this.txtDescription.width / 2;
         this.topDelemiter.x = _loc5_;
         this.topDelemiter.y = this.txtTitle.y + this.txtTitle.height + BOTTOM_PADDING;
         this.txtTitle.x = _loc5_ - this.txtTitle.width / 2;
         if(this.btnAccept.visible && this.btnGlossary.visible)
         {
            this.btnGlossary.x = _loc5_ + BUTTONS_PADDING - BUTTONS_OFFSET;
            this.btnAccept.x = _loc5_ - this.btnAccept.getViewWidth() - BUTTONS_PADDING - BUTTONS_OFFSET;
         }
         else
         {
            this.btnGlossary.x = _loc5_ - this.btnGlossary.getViewWidth() / 2;
            this.btnAccept.x = _loc5_ - this.btnAccept.getViewWidth() / 2;
         }
         var _loc7_:* = 0;
         if(this._data.showAnimation)
         {
            this.contentMask.y = _loc6_;
            this.contentMask.width = this.background.width + _loc7_;
            this.contentMask.height = 1;
            this.borderLineTop.y = _loc6_ - 1;
            this.borderLineBottom.y = _loc6_ + 1;
            GTweener.removeTweens(this.contentMask);
            GTweener.removeTweens(this.borderLineTop);
            GTweener.removeTweens(this.borderLineBottom);
            _loc9_ = 0.4;
            GTweener.to(this.contentMask,_loc9_,{"height":this.background.height},{
               "ease":Sine.easeInOut,
               "onComplete":this.handleShown
            });
            GTweener.to(this.borderLineTop,_loc9_,{"y":0},{"ease":Sine.easeInOut});
            GTweener.to(this.borderLineBottom,_loc9_,{"y":this.background.height - 1},{"ease":Sine.easeInOut});
         }
         else
         {
            this.contentMask.y = _loc6_;
            this.contentMask.width = this.background.width + _loc7_;
            this.contentMask.height = this.background.height + 200;
            this.borderLineTop.y = 0;
            this.borderLineBottom.y = this.background.height - 1;
         }
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function handleShown(param1:GTween) : void
      {
         this.contentMask.height = this.background.height + this.HOLD_CANVAS_OFFSET;
      }
      
      private function cleanup() : void
      {
         this.txtDescription.visible = false;
         this.btnGlossary.visible = false;
         this.txtTitle.text = "";
         this.removeImageLoader();
      }
      
      private function loadImage(param1:String) : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            removeChild(this._imageLoader);
         }
         this._imageLoader = new UILoader();
         this._imageLoader.width = this.background.width;
         this._imageLoader.maintainAspectRatio = true;
         this._imageLoader.autoSize = false;
         this._imageLoader.source = "img://" + param1;
         this._imageLoader.addEventListener(Event.COMPLETE,this.handleImageLoaded,false,0,true);
         this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleImageLoadinfFailed,false,0,true);
         addChild(this._imageLoader);
      }
      
      private function removeImageLoader() : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleImageLoaded);
            this._imageLoader.unload();
            removeChild(this._imageLoader);
         }
      }
      
      private function handleImageLoadinfFailed(param1:IOErrorEvent) : void
      {
         removeChild(this._imageLoader);
         this.alignContent();
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         this.alignContent();
      }
      
      private function handleGlossaryLink() : void
      {
         if(this._data && visible && parent.visible)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnGotoGlossary"));
         }
      }
      
      public function proccedInput(param1:InputEvent, param2:Boolean = false) : void
      {
         var _loc3_:InputDetails = param1.details;
         var _loc4_:Boolean = this._data && this._data.enableAcceptButton && visible && parent.visible;
         var _loc5_:* = _loc3_.value == (param2 ? InputValue.KEY_DOWN : InputValue.KEY_UP);
         var _loc6_:Boolean = _loc3_.code == KeyCode.ESCAPE || _loc3_.navEquivalent == NavigationCode.GAMEPAD_A;
         if(_loc4_ && _loc5_ && _loc6_)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnCloseByUser"));
         }
      }
   }
}
