package red.game.witcher3.popups
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import red.core.CorePopup;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.overlay.TutorialPopup;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class TutorialPopupMenu extends CorePopup
   {
      
      protected static const OVER_ANIM_OFFSET_X:Number = -50;
      
      protected static const OVER_ANIM_DURATION:Number = 0.5;
      
      protected static const ANIM_INIT_SCALE:Number = 0.8;
      
      protected static const ANIM_DURATION:Number = 0.6;
      
      protected static const ANIM_OFFSET_Y:Number = 30;
      
      protected static const ANIM_OFFSET_ROT_X:Number = 0;
      
      protected static const ANIM_OFFSET_ROT_Y:Number = 0;
      
      protected static const DEFAULT_CENTER_Y:Number = 50;
      
      protected static const DEFAULT_X:Number = 0;
      
      protected static const DEFAULT_Y:Number = 211;
      
      protected static const DEFAULT_DELAY:Number = 6000;
      
      protected static const AREA_ANIM_DURATION:Number = 1;
      
      protected static const AREA_ANIM_INIT_SCALE:Number = 4;
      
      protected static const CONTENT_REF:String = "TutorialPopupRef";
      
      protected static const AREA_REF:String = "AreaBorderRef";
       
      
      protected var _minDuration:Number = -1;
      
      protected var _data:Object;
      
      protected var _timer:Timer;
      
      protected var _areaCanvas:Sprite;
      
      protected var _popupContainer:Sprite;
      
      private var _resetInput:Boolean = false;
      
      public var popupInstance:TutorialPopup;
      
      public var tutorialOverlay:TutorialOverlay;
      
      internal const AREA_SCALE_ACCURACY:int = 100;
      
      public function TutorialPopupMenu()
      {
         _enableInputValidation = true;
         this._areaCanvas = new Sprite();
         addChild(this._areaCanvas);
         super();
         this.popupInstance.visible = false;
         this.popupInstance.addEventListener(Event.RESIZE,this.handlePopupResized,false,0,true);
         this.tutorialOverlay.visible = false;
         this._popupContainer = new Sprite();
         this._popupContainer.addChild(this.popupInstance);
         addChild(this._popupContainer);
      }
      
      override protected function get popupName() : String
      {
         return "TutorialPopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"tutorial.hint.data",[this.createMessage]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"tutorial.area.highlight",[this.highlightAreas]));
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         _inputMgr.enableHoldEmulation = false;
         _inputMgr.enableInputDeviceCheck = false;
         _inputMgr.addInputBlocker(true,"TUTORIAL_ROOT");
         if(!Extensions.isScaleform)
         {
            this.startDebugMode();
         }
      }
      
      override public function resetInput() : void
      {
         super.resetInput();
         this._resetInput = true;
      }
      
      public function playFeedbackAnimation(param1:Boolean) : void
      {
         if(this.popupInstance)
         {
            this.popupInstance.playFeedbackAnimation(param1);
         }
      }
      
      public function removeMessage() : void
      {
         this.hideMessage();
      }
      
      protected function createMessage(param1:Object) : void
      {
         var _loc3_:Number = NaN;
         this._data = param1;
         if(Boolean(this._data.fullscreen) || Boolean(this._data.enableAcceptButton))
         {
            _inputMgr.addInputBlocker(false,"TUTORIAL_INSTANCE");
         }
         var _loc2_:Rectangle = CommonUtils.getScreenRect();
         if(this._data.fullscreen)
         {
            this.popupInstance.visible = false;
            this.tutorialOverlay.data = this._data;
            this.tutorialOverlay.visible = true;
            if(this._data.showAnimation)
            {
               GTweener.removeTweens(this.tutorialOverlay);
               this.tutorialOverlay.alpha = 0;
               this.tutorialOverlay.x = OVER_ANIM_OFFSET_X + _loc2_.x;
               GTweener.to(this.tutorialOverlay,OVER_ANIM_DURATION,{
                  "x":_loc2_.x,
                  "alpha":1
               },{"ease":Exponential.easeOut});
            }
         }
         else
         {
            this.tutorialOverlay.visible = false;
            this.popupInstance.data = this._data;
            if(this._timer)
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimer,false);
            }
            _loc3_ = Number(this._data.duration);
            if(_loc3_ != -1)
            {
               if(isNaN(_loc3_) || _loc3_ == 0)
               {
                  _loc3_ = DEFAULT_DELAY;
               }
               this._timer = new Timer(_loc3_,1);
               this._timer.addEventListener(TimerEvent.TIMER,this.handleTimer,false,0,true);
               this._timer.start();
            }
         }
      }
      
      protected function handlePopupResized(param1:Event) : void
      {
         this.setupPosition(this._data.posX,this._data.posY);
      }
      
      protected function highlightAreas(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Sprite = null;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            _loc5_ = this.createArea();
            _loc8_ = CommonUtils.getScreenRect();
            _loc9_ = new Rectangle(0,0,1920,1080);
            _loc10_ = _loc4_.x * _loc9_.width;
            _loc11_ = _loc4_.y * _loc9_.height;
            _loc12_ = _loc4_.width * _loc9_.width;
            _loc13_ = _loc4_.height * _loc9_.height;
            _loc10_ = Math.round(_loc10_ * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc11_ = Math.round(_loc11_ * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc12_ = Math.round(_loc12_ * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc13_ = Math.round(_loc13_ * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc5_.width = _loc12_;
            _loc5_.height = _loc13_;
            _loc5_.x = _loc10_ + _loc12_ / 2;
            _loc5_.y = _loc11_ + _loc13_ / 2;
            _loc6_ = Math.round(_loc5_.scaleX * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc7_ = Math.round(_loc5_.scaleY * this.AREA_SCALE_ACCURACY) / this.AREA_SCALE_ACCURACY;
            _loc5_.alpha = 0;
            _loc5_.scaleX = _loc6_ * AREA_ANIM_INIT_SCALE;
            _loc5_.scaleY = _loc7_ * AREA_ANIM_INIT_SCALE;
            GTweener.to(_loc5_,AREA_ANIM_DURATION,{
               "scaleX":_loc6_,
               "scaleY":_loc7_,
               "alpha":1
            },{"ease":Exponential.easeOut});
            _loc2_++;
         }
      }
      
      protected function createArea() : Sprite
      {
         var _loc1_:Class = getDefinitionByName(AREA_REF) as Class;
         var _loc2_:Sprite = new _loc1_();
         this._areaCanvas.addChild(_loc2_);
         return _loc2_;
      }
      
      protected function setupPosition(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:Rectangle = CommonUtils.getScreenRect();
         var _loc4_:Rectangle = new Rectangle(0,0,1920,1080);
         this.popupInstance.visible = true;
         if((isNaN(param1) || param1 <= 0) && (isNaN(param2) || param2 <= 0))
         {
            _loc5_ = _loc3_.x;
            _loc6_ = DEFAULT_Y;
         }
         else
         {
            _loc5_ = _loc4_.width * param1;
            _loc6_ = _loc4_.height * param2;
         }
         _loc5_ += this.popupInstance.actualWidth / 2;
         _loc6_ += this.popupInstance.actualHeight / 2;
         this.popupInstance.x = -this.popupInstance.actualWidth / 2;
         this.popupInstance.y = -this.popupInstance.actualHeight / 2;
         this._popupContainer.x = _loc5_;
         this._popupContainer.y = _loc6_;
         this._popupContainer.alpha = 0;
         _loc5_ += this.popupInstance.getPositionShiftX();
         GTweener.removeTweens(this._popupContainer);
         GTweener.to(this._popupContainer,ANIM_DURATION,{
            "x":_loc5_,
            "y":_loc6_,
            "rotationY":0,
            "rotationX":0,
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },{"ease":Exponential.easeOut});
      }
      
      protected function handleTimer(param1:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimer,false);
         this._timer.stop();
         this._timer = null;
         this.hideMessage();
      }
      
      protected function hideMessage() : void
      {
         _inputMgr.removeInputBlocker("TUTORIAL_INSTANCE");
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnHideTimer"));
      }
      
      protected function startDebugMode() : void
      {
         var _loc1_:Object = {};
         _loc1_.messageText = "Please note that this happens only once the tutorial switches from using keyboard/mouse to using the controller.";
         _loc1_.messageTitle = "Test title";
         _loc1_.enableGlossaryLink = true;
         _loc1_.fullscreen = false;
         _loc1_.autosize = true;
         _loc1_.showAnimation = true;
         _loc1_.isUiTutorial = true;
         this.createMessage(_loc1_);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         var _loc2_:InputDetails = param1.details;
         if(this._resetInput)
         {
            pressedButtonsByKeys = {};
            pressedButtonsByNavEquivalent = {};
            this._resetInput = false;
            return;
         }
         if(_enableInputValidation && !(isNavEquivalentValid(_loc2_.navEquivalent) || isKeyCodeValid(_loc2_.code)))
         {
            return;
         }
         if(Boolean(this.popupInstance) && this.popupInstance.visible)
         {
            this.popupInstance.proccedInput(param1);
         }
         if(Boolean(this.tutorialOverlay) && this.tutorialOverlay.visible)
         {
            this.tutorialOverlay.proccedInput(param1);
         }
      }
   }
}
