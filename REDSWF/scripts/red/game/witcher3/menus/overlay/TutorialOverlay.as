package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.Sprite;
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
   
   public class TutorialOverlay extends UIComponent
   {
      
      protected static const OVER_ANIM_OFFSET_X:Number = -50;
      
      protected static const OVER_ANIM_DURATION:Number = 0.5;
      
      protected static const BLOCK_PADDING:Number = 10;
      
      protected static const EDGE_PADDING:Number = 10;
      
      protected static const BUTTONS_TOP_PADDING:Number = 50;
      
      protected static const BUTTONS_PADDING:Number = 10;
      
      protected static const GRADIENT_PADDING:Number = 130;
       
      
      public var txtTitle:TextField;
      
      public var txtDescription:TextField;
      
      public var btnAccept:InputFeedbackButton;
      
      public var btnGlossary:InputFeedbackButton;
      
      public var topDelemiter:Sprite;
      
      public var mcBackground:Sprite;
      
      protected var _data:Object;
      
      protected var _imageLoader:UILoader;
      
      protected var _container:Sprite;
      
      public function TutorialOverlay()
      {
         super();
         this._container = new Sprite();
         addChild(this._container);
         this._container.addChild(this.txtTitle);
         this._container.addChild(this.topDelemiter);
         this._container.addChild(this.txtDescription);
         this._container.addChild(this.btnAccept);
         this._container.addChild(this.btnGlossary);
         this.btnAccept.label = "[[panel_continue]]";
         this.btnAccept.clickable = false;
         this.btnAccept.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.SPACE);
         this.btnGlossary.label = "[[panel_title_glossary]]";
         this.btnGlossary.clickable = false;
         this.btnGlossary.setDataFromStage(NavigationCode.GAMEPAD_BACK,-1,-1,1000);
         this.cleanup();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         this.cleanup();
         this._data = param1;
         if(this._data.enableGlossaryLink)
         {
            this.btnGlossary.visible = true;
            this.btnGlossary.holdCallback = this.handleGlossaryLink;
         }
         else
         {
            this.btnGlossary.visible = false;
            this.btnGlossary.holdCallback = null;
         }
         if(this.btnAccept.visible && this.btnGlossary.visible)
         {
            _loc2_ = this.btnAccept.getViewWidth() + this.btnGlossary.getViewWidth() + BUTTONS_PADDING;
         }
         else
         {
            _loc2_ = this.btnGlossary.getViewWidth();
         }
         var _loc3_:Rectangle = CommonUtils.getScreenRect();
         var _loc4_:Number = _loc3_.width * 0.05;
         var _loc5_:Number = Math.max(this.txtDescription.width / 2,_loc2_ / 2);
         var _loc6_:Number;
         var _loc7_:Number = (_loc6_ = _loc4_ + EDGE_PADDING + _loc5_) + _loc5_ + GRADIENT_PADDING;
         this.mcBackground.width = _loc7_;
         this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this._data.messageTitle);
         this.txtTitle.width = this.txtTitle.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         this.txtDescription.htmlText = CommonUtils.fixFontStyleTags(this._data.messageText);
         this.txtDescription.height = this.txtDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.topDelemiter.x = _loc6_;
         this.txtTitle.x = _loc6_ - this.txtTitle.textWidth / 2;
         var _loc8_:TextFormat = new TextFormat();
         if(CoreComponent.isArabicAligmentMode)
         {
            this.txtDescription.htmlText = "<p align=\"right\">" + this._data.messageText + "</p>";
            this.txtDescription.x = _loc6_ - this.txtDescription.textWidth / 2 - (this.txtDescription.width - this.txtDescription.textWidth);
            _loc8_.font = "$NormalFont";
         }
         else
         {
            this.txtDescription.x = _loc6_ - this.txtDescription.textWidth / 2;
            _loc8_.font = "$BoldFont";
         }
         this.txtTitle.setTextFormat(_loc8_);
         if(!this._data.imagePath)
         {
         }
         this.btnAccept.y = this.btnGlossary.y = this.txtDescription.y + this.txtDescription.height + BUTTONS_TOP_PADDING;
         if(this.btnGlossary.visible)
         {
            this.btnAccept.x = _loc6_ - _loc2_ / 2;
            this.btnGlossary.x = this.btnAccept.x + this.btnAccept.getViewWidth() + BUTTONS_PADDING;
         }
         else
         {
            this.btnAccept.x = _loc6_ - this.btnAccept.getViewWidth() / 2;
         }
         this._container.y = _loc3_.y + (_loc3_.height - this._container.height) / 2;
      }
      
      private function cleanup() : void
      {
         this.txtTitle.htmlText = "";
         this.txtDescription.htmlText = "";
         this.btnGlossary.visible = false;
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            removeChild(this._imageLoader);
         }
      }
      
      private function loadImage(param1:String) : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            removeChild(this._imageLoader);
         }
         this._imageLoader = new UILoader();
         this._imageLoader.maintainAspectRatio = true;
         this._imageLoader.autoSize = true;
         this._imageLoader.source = "img://" + param1;
         this._imageLoader.x = this.txtDescription.x;
         this._imageLoader.y = this.txtDescription.y + this.txtDescription.height;
         addChild(this._imageLoader);
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
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc3_:InputDetails = param1.details;
         var _loc4_:Boolean = Boolean(this._data) && visible && parent.visible;
         var _loc5_:* = _loc3_.value == (param2 ? InputValue.KEY_DOWN : InputValue.KEY_UP);
         var _loc6_:Boolean = _loc3_.navEquivalent == NavigationCode.GAMEPAD_A || _loc3_.navEquivalent == NavigationCode.GAMEPAD_B;
         if(_loc4_ && _loc5_ && _loc6_)
         {
            _loc7_ = {
               "ease":Exponential.easeOut,
               "onComplete":this.handleOverlayHidden
            };
            _loc8_ = {
               "x":OVER_ANIM_OFFSET_X,
               "alpha":0
            };
            GTweener.removeTweens(this);
            GTweener.to(this,OVER_ANIM_DURATION,_loc8_,_loc7_);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnStartHiding"));
         }
      }
      
      protected function handleOverlayHidden(param1:GTween) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnHideTimer"));
      }
   }
}
