package red.game.witcher3.menus.meditation_menu
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.core.utils.InputUtils;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class MeditationClock extends UIComponent
   {
      
      protected static const MAGNITUDE_DEAD_ZONE:Number = 0.75;
      
      protected static const MAGNITUDE_DEC_DEAD_ZONE:Number = 0.1;
      
      protected static const MAGNITUDE_TIME_DELTA:Number = 0.5;
      
      protected static const MAGNITUDE_CHARGE = 15;
      
      protected static const PC_BUTTON_PADDING = 12;
      
      protected static const MAX_WAIT_HOURS:uint = 24;
      
      protected static const NUM_ANIM_FRAMES:uint = 72;
      
      protected static const NUM_FRAMES_PER_HOUR:uint = 3;
      
      protected static const CLOCK_CENTER:Number = 326;
       
      
      public var lbSelectedHours:TextField;
      
      public var txtDuration:TextField;
      
      public var selectedTimeIndicator:ClockIndicator;
      
      public var dayQuarterIndicator:DayQuarterIndicator;
      
      public var arrowTarget:MovieClip;
      
      public var arrowCurrent:MovieClip;
      
      public var centerOfClock:MovieClip;
      
      public var edgeOfClock:MovieClip;
      
      public var mcActivateButton:InputFeedbackButton;
      
      public var mcActivateButtonPc:InputFeedbackButton;
      
      public var mcBackground:MovieClip;
      
      private var _globalCenter:Point;
      
      private var _mouseDownOnClock:Boolean;
      
      private var _lastClickLocation:Point;
      
      private var _lastClickTime:Number;
      
      private var _timeFormat24HR:Boolean;
      
      protected var _selectedTime:uint;
      
      protected var _currentTime:uint;
      
      protected var _currentTimeMin:uint;
      
      protected var _currentlyRenderedTime:int;
      
      private var _animationTimer:Timer;
      
      private var _isMeditating:Boolean;
      
      private var _stopMeditationReq:Boolean;
      
      private var bMeditationBlocked:Boolean = false;
      
      private var prevMagnitude:Number = 0;
      
      private var bufMagnitude:Number = 0;
      
      protected var durationText:String = "";
      
      public var mcFrameMed:MovieClip;
      
      public var mcFinishMeditationGlow:MovieClip;
      
      private var _maxRadius:Number;
      
      private var _labelActivateButton:String;
      
      private var _labelMeditateUntil:String;
      
      public var timeChangeCallback:Function;
      
      public function MeditationClock()
      {
         super();
         this._mouseDownOnClock = false;
         this._selectedTime = 1000;
         this._currentTime = 1000;
         this._currentTimeMin = 1000;
         this._isMeditating = false;
         this._stopMeditationReq = false;
         this._currentlyRenderedTime = 0;
         this._lastClickLocation = new Point(0,0);
         this._lastClickTime = 0;
         this.edgeOfClock.stage;
         this._globalCenter = this.centerOfClock.localToGlobal(new Point(0,0));
         var _loc1_:Point = this.edgeOfClock.localToGlobal(new Point(0,0));
         this._maxRadius = Math.sqrt(Math.pow(_loc1_.x - this._globalCenter.x,2) + Math.pow(_loc1_.y - this._globalCenter.y,2));
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         stage.doubleClickEnabled = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.hours",[this.setCurrentHours]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.minutes",[this.setCurrentMin]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.hours.update",[this.updateCurrentHours]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"meditation.clock.blocked",[this.blockClock]));
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         stage.addEventListener(MouseEvent.CLICK,this.handleClick,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         this.txtDuration.mouseEnabled = false;
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         this.mcActivateButton.setDataFromStage(NavigationCode.GAMEPAD_A,-1);
         this._labelActivateButton = "[[panel_name_skillcategory_meditation]]";
         this._labelMeditateUntil = "[[panel_meditationclock_med_hours]]";
         this.mcActivateButtonPc.clickable = true;
         this.mcActivateButtonPc.label = this._labelActivateButton;
         this.mcActivateButtonPc.addEventListener(ButtonEvent.PRESS,this.handleActionButtonPress,false,0,true);
         this.mcActivateButtonPc.setDataFromStage("",KeyCode.E);
         this.mcActivateButtonPc.validateNow();
         if(!this._isMeditating)
         {
            this.txtDuration.text = this.durationText;
            this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
         }
         this.mcActivateButton.clickable = false;
      }
      
      public function setLabels(param1:String, param2:String) : void
      {
         this._labelActivateButton = param1;
         this._labelMeditateUntil = param2;
         this.mcActivateButtonPc.label = this._labelActivateButton;
         this.mcActivateButtonPc.updateDataFromStage();
         this.mcActivateButtonPc.validateNow();
         this.mcActivateButtonPc.x = CLOCK_CENTER - this.mcActivateButtonPc.getViewWidth() / 2;
         this.updateTimeMeditateText();
      }
      
      public function get isMeditating() : Boolean
      {
         return this._isMeditating;
      }
      
      public function set isMeditating(param1:Boolean) : void
      {
         this._isMeditating = param1;
      }
      
      public function get selectedTime() : uint
      {
         return this._selectedTime;
      }
      
      public function set selectedTime(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._selectedTime == param1)
         {
            return;
         }
         this._selectedTime = param1;
         if(!this._isMeditating)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_clock_tick"]));
         }
         this.updateTimeMeditateText();
         this.durationText = this.txtDuration.text;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_meditation_select_time"]));
         if(this._selectedTime == this._currentTime)
         {
            this.arrowTarget.rotation = this.timeConvertedForFlashRotation(this._selectedTime) / 24 * 360;
            this.selectedTimeIndicator.progress = 0;
            this.selectedTimeIndicator.visible = false;
         }
         else
         {
            this.arrowTarget.rotation = this.timeConvertedForFlashRotation(this._selectedTime) / 24 * 360;
            this.selectedTimeIndicator.visible = true;
            _loc2_ = this._selectedTime < this._currentTime ? uint(24 + this._selectedTime - this._currentTime) : uint(this._selectedTime - this._currentTime);
            this.selectedTimeIndicator.progress = 1 + Math.ceil(_loc2_ / 24 * NUM_ANIM_FRAMES);
         }
         if(this.timeChangeCallback != null)
         {
            this.timeChangeCallback(this._currentTime);
         }
      }
      
      protected function updateTimeMeditateText() : *
      {
         var _loc1_:* = "";
         var _loc2_:uint = this._selectedTime;
         if(!this._timeFormat24HR)
         {
            if(_loc2_ >= 12)
            {
               if(_loc2_ > 12)
               {
                  _loc2_ -= 12;
               }
               if(_loc2_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc2_ + ":00 PM";
            }
            else
            {
               if(_loc2_ == 0)
               {
                  _loc2_ = 12;
               }
               if(_loc2_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc2_ + ":00 AM";
            }
         }
         else
         {
            if(_loc2_ < 10)
            {
               _loc1_ += "0";
            }
            _loc1_ += this._selectedTime.toString() + ":00";
         }
         this.txtDuration.text = this._labelMeditateUntil;
         this.txtDuration.appendText(" " + _loc1_);
         this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
      }
      
      public function get currentTime() : uint
      {
         return this._currentTime;
      }
      
      public function set currentTime(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(this._currentTime == param1)
         {
            return;
         }
         this._currentTime = param1;
         if(!this._isMeditating)
         {
            this.dayQuarterIndicator.currentTime = this._currentTime;
            this.arrowCurrent.rotation = this.timeConvertedForFlashRotation(this._currentTime) / 24 * 360;
            this.selectedTimeIndicator.rotation = this.timeConvertedForFlashRotation(this._currentTime) / 24 * 360;
            if(this._currentTime != this._selectedTime)
            {
               _loc2_ = this._selectedTime < this._currentTime ? uint(24 + this._selectedTime - this._currentTime) : uint(this._selectedTime - this._currentTime);
               this.selectedTimeIndicator.progress = 1 + Math.ceil(_loc2_ / 24 * NUM_ANIM_FRAMES);
            }
         }
         this.updateCurrentTimeString();
      }
      
      public function get currentTimeMin() : uint
      {
         return this._currentTimeMin;
      }
      
      public function set currentTimeMin(param1:uint) : void
      {
         this._currentTimeMin = param1;
         this.updateCurrentTimeString();
      }
      
      public function updateCurrentTimeString() : void
      {
         this.lbSelectedHours.htmlText = "[[panel_meditationclock_current_time]]";
         this.lbSelectedHours.htmlText = CommonUtils.toUpperCaseSafe(this.lbSelectedHours.htmlText);
         var _loc1_:* = "";
         var _loc2_:uint = this._currentTime;
         var _loc3_:uint = this._currentTimeMin;
         if(!this._timeFormat24HR)
         {
            if(_loc2_ >= 12)
            {
               if(_loc2_ > 12)
               {
                  _loc2_ -= 12;
               }
               _loc1_ += " PM";
            }
            else
            {
               if(_loc2_ == 0)
               {
                  _loc2_ = 12;
               }
               _loc1_ += " AM";
            }
         }
         var _loc4_:* = " ";
         if(_loc2_ < 10)
         {
            _loc4_ += "0";
         }
         _loc4_ += _loc2_ + ":";
         if(_loc3_ < 10)
         {
            _loc4_ += "0";
         }
         _loc4_ += _loc3_ + _loc1_;
         this.lbSelectedHours.htmlText += _loc4_;
         this.lbSelectedHours.htmlText = CommonUtils.toUpperCaseSafe(this.lbSelectedHours.htmlText);
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         if(this._isMeditating)
         {
            this.txtDuration.htmlText = param1.isGamepad ? "[[panel_common_cancel]]" : "";
            this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
         }
         this.mcActivateButtonPc.x = CLOCK_CENTER - this.mcActivateButtonPc.getViewWidth() / 2;
      }
      
      private function timeConvertedForFlashRotation(param1:uint) : uint
      {
         var _loc2_:uint = uint(param1 + 12);
         if(_loc2_ > 23)
         {
            _loc2_ -= 24;
         }
         return _loc2_;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:InputAxisData = null;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         if(this._isMeditating && _loc2_.value == InputValue.KEY_UP)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_B:
               case NavigationCode.ESCAPE:
                  this.stopMeditation();
                  param1.handled = true;
            }
            return;
         }
         if(!this._isMeditating)
         {
            CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
            if(_loc2_.code == KeyCode.E)
            {
               _loc2_.navEquivalent = NavigationCode.ENTER;
            }
            if(_loc2_.code == KeyCode.PAD_LEFT_STICK_AXIS)
            {
               _loc3_ = InputAxisData(_loc2_.value);
               if((_loc4_ = InputUtils.getMagnitude(_loc3_.xvalue,_loc3_.yvalue)) < MAGNITUDE_DEAD_ZONE)
               {
                  this.prevMagnitude = _loc4_;
                  return;
               }
               if(this.prevMagnitude > _loc4_ && Math.abs(this.prevMagnitude - _loc4_) > 0.0005)
               {
                  this.prevMagnitude = _loc4_;
                  return;
               }
               this.prevMagnitude = _loc4_;
               this.setSelectedTimeBasedOffPosition(_loc3_.xvalue,_loc3_.yvalue);
               param1.handled = true;
            }
            else if(_loc2_.value == InputValue.KEY_UP && _loc2_.fromJoystick == false)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_A:
                  case NavigationCode.ENTER:
                     if(!this.bMeditationBlocked)
                     {
                        this.applySelectedTime();
                        param1.handled = true;
                     }
                     else
                     {
                        dispatchEvent(new GameEvent(GameEvent.CALL,"OnMeditateBlocked"));
                     }
                     break;
                  case NavigationCode.UP:
                  case NavigationCode.RIGHT:
                     if(!this._mouseDownOnClock && !this._isMeditating)
                     {
                        if((_loc5_ = uint(this.selectedTime + 1)) > 23)
                        {
                           _loc5_ = 0;
                        }
                        this.selectedTime = _loc5_;
                        param1.handled = true;
                     }
                     break;
                  case NavigationCode.DOWN:
                  case NavigationCode.LEFT:
                     if(!this._mouseDownOnClock && !this._isMeditating)
                     {
                        this.selectedTime = this.selectedTime == 0 ? 23 : this.selectedTime - 1;
                        param1.handled = true;
                     }
               }
            }
         }
      }
      
      protected function handleMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         if(this._isMeditating || this.bMeditationBlocked)
         {
            return;
         }
         if(param1.delta > 0)
         {
            _loc2_ = uint(this.selectedTime + 1);
            if(_loc2_ > 23)
            {
               _loc2_ = 0;
            }
            this.selectedTime = _loc2_;
         }
         else
         {
            this.selectedTime = this.selectedTime == 0 ? 23 : this.selectedTime - 1;
         }
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         if(this._isMeditating || this.bMeditationBlocked)
         {
            return;
         }
         var _loc2_:Number = param1.stageX - this._globalCenter.x;
         var _loc3_:Number = this._globalCenter.y - param1.stageY;
         var _loc4_:Number;
         if((_loc4_ = Math.sqrt(Math.pow(_loc2_,2) + Math.pow(_loc3_,2))) <= this._maxRadius)
         {
            this._mouseDownOnClock = true;
            this.setSelectedTimeBasedOffPosition(_loc2_,_loc3_);
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._isMeditating || this.bMeditationBlocked)
         {
            this._mouseDownOnClock = false;
            return;
         }
         if(this._mouseDownOnClock)
         {
            _loc2_ = param1.stageX - this._globalCenter.x;
            _loc3_ = this._globalCenter.y - param1.stageY;
            this.setSelectedTimeBasedOffPosition(_loc2_,_loc3_);
         }
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this._mouseDownOnClock = false;
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this._isMeditating)
            {
               return;
            }
            _loc3_ = Math.sqrt(Math.pow(param1.stageX - this._lastClickLocation.x,2) + Math.pow(param1.stageY - this._lastClickLocation.y,2));
            _loc4_ = getTimer() - this._lastClickTime;
            this._lastClickLocation.x = param1.stageX;
            this._lastClickLocation.y = param1.stageY;
            this._lastClickTime = getTimer();
            _loc5_ = param1.stageX - this._globalCenter.x;
            _loc6_ = this._globalCenter.y - param1.stageY;
            if((_loc7_ = Math.sqrt(Math.pow(_loc5_,2) + Math.pow(_loc6_,2))) <= this._maxRadius)
            {
               this.setSelectedTimeBasedOffPosition(_loc5_,_loc6_);
               if(_loc4_ > 500 || _loc3_ > 30)
               {
                  return;
               }
               if(this.bMeditationBlocked)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnMeditateBlocked"));
                  return;
               }
               if(this.selectedTime != this.currentTime)
               {
                  this.applySelectedTime();
               }
            }
         }
         else if(_loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            if(this._isMeditating)
            {
               this.stopMeditation();
            }
         }
      }
      
      protected function setSelectedTimeBasedOffPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = InputUtils.getAngleRadians(param1,param2);
         if(_loc3_ > 2 * Math.PI)
         {
            _loc3_ -= 2 * Math.PI;
         }
         _loc3_ += 3 * Math.PI / 2;
         if(_loc3_ > Math.PI * 2)
         {
            _loc3_ -= Math.PI * 2;
         }
         var _loc4_:int = int(_loc3_ * 12 / Math.PI + 0.5);
         if((_loc4_ = 12 - _loc4_) < 0)
         {
            _loc4_ += 24;
         }
         this.selectedTime = _loc4_;
      }
      
      protected function setCurrentHours(param1:int) : void
      {
         this._currentlyRenderedTime = param1 * NUM_FRAMES_PER_HOUR;
         this.currentTime = param1;
         this.selectedTime = param1;
      }
      
      protected function setCurrentMin(param1:int) : void
      {
         this.currentTimeMin = param1;
      }
      
      protected function updateCurrentHours(param1:int) : void
      {
         this.currentTime = param1;
         if(this._isMeditating)
         {
            if(param1 == this.selectedTime && this._currentlyRenderedTime % NUM_FRAMES_PER_HOUR == 0 && this._currentlyRenderedTime / NUM_FRAMES_PER_HOUR == this.selectedTime)
            {
               this.stopMeditation();
            }
         }
      }
      
      protected function blockClock(param1:Boolean) : void
      {
         if(!param1 && this._isMeditating)
         {
            this._stopMeditationReq = true;
         }
      }
      
      protected function applySelectedTime() : void
      {
         if(this.selectedTime != this.currentTime && !this._isMeditating)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMeditate",[Number(this.selectedTime)]));
            this._isMeditating = true;
            this._stopMeditationReq = false;
            this._animationTimer = new Timer(20,1);
            this._animationTimer.addEventListener(TimerEvent.TIMER,this.animationTimerTrigger);
            this._animationTimer.start();
            this.mcActivateButton.setDataFromStage(NavigationCode.GAMEPAD_B,-1);
            this.mcActivateButtonPc.label = "[[panel_common_cancel]]";
            this.mcActivateButtonPc.setDataFromStage("",KeyCode.ESCAPE);
            this.mcActivateButtonPc.validateNow();
            this.mcActivateButtonPc.x = CLOCK_CENTER - this.mcActivateButtonPc.getViewWidth() / 2;
            if(InputManager.getInstance().isGamepad())
            {
               this.txtDuration.htmlText = "[[panel_common_cancel]]";
               this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
            }
         }
      }
      
      protected function stopMeditation() : void
      {
         if(this._isMeditating)
         {
            this.mcActivateButton.setDataFromStage(NavigationCode.GAMEPAD_A,-1);
            this.mcActivateButtonPc.label = this._labelActivateButton;
            this.mcActivateButtonPc.setDataFromStage("",KeyCode.E);
            this.mcActivateButtonPc.validateNow();
            this.mcActivateButtonPc.x = CLOCK_CENTER - this.mcActivateButtonPc.getViewWidth() / 2;
            this.txtDuration.htmlText = this.durationText;
            this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnStopMeditate"));
            this._stopMeditationReq = true;
            if(this.mcFinishMeditationGlow)
            {
               this.mcFinishMeditationGlow.gotoAndPlay("start");
            }
         }
      }
      
      protected function handleActionButtonPress(param1:ButtonEvent) : void
      {
         if(this._isMeditating)
         {
            this.stopMeditation();
         }
         else if(!this.bMeditationBlocked)
         {
            this.applySelectedTime();
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMeditateBlocked"));
         }
      }
      
      internal function animationTimerTrigger(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:* = 0;
         if(!this._isMeditating)
         {
            this._animationTimer.stop();
            return;
         }
         var _loc2_:uint = this.currentTime;
         var _loc4_:int;
         if((_loc4_ = Math.floor(this._currentlyRenderedTime / NUM_FRAMES_PER_HOUR)) > 23)
         {
            _loc4_ -= 24;
         }
         if(this._currentlyRenderedTime % NUM_FRAMES_PER_HOUR != 0 || _loc4_ != _loc2_)
         {
            this._currentlyRenderedTime += 1;
            if(this._currentlyRenderedTime > NUM_ANIM_FRAMES)
            {
               this._currentlyRenderedTime -= NUM_ANIM_FRAMES;
            }
            this.dayQuarterIndicator.currentTime = _loc4_;
            if((_loc5_ = this._currentlyRenderedTime + 12 * NUM_FRAMES_PER_HOUR) >= NUM_ANIM_FRAMES)
            {
               _loc5_ -= NUM_ANIM_FRAMES;
            }
            _loc5_ = _loc5_ / NUM_ANIM_FRAMES * 360;
            this.arrowCurrent.rotation = _loc5_;
            this.selectedTimeIndicator.rotation = _loc5_;
            _loc6_ = (_loc6_ = this.selectedTime * NUM_FRAMES_PER_HOUR < this._currentlyRenderedTime ? int((24 + this.selectedTime) * NUM_FRAMES_PER_HOUR - this._currentlyRenderedTime) : this.selectedTime * NUM_FRAMES_PER_HOUR - this._currentlyRenderedTime) + 1;
            this.selectedTimeIndicator.progress = _loc6_;
            this._animationTimer.reset();
            this._animationTimer.start();
         }
         else if(_loc4_ == this._selectedTime || this._stopMeditationReq == true)
         {
            this._stopMeditationReq = false;
            this._animationTimer.stop();
            this.stopMeditation();
            this._isMeditating = false;
            this.mcActivateButton.setDataFromStage(NavigationCode.GAMEPAD_A,-1);
            this.mcActivateButtonPc.label = this._labelActivateButton;
            this.mcActivateButtonPc.setDataFromStage("",KeyCode.E);
            this.mcActivateButtonPc.validateNow();
            this.mcActivateButtonPc.x = CLOCK_CENTER - this.mcActivateButtonPc.getViewWidth() / 2;
            this.txtDuration.text = this.durationText;
            this.txtDuration.htmlText = CommonUtils.toUpperCaseSafe(this.txtDuration.htmlText);
         }
         else
         {
            this._animationTimer.reset();
            this._animationTimer.start();
         }
      }
      
      public function SetBlockMeditation(param1:Boolean) : *
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:ColorMatrixFilter = null;
         this.bMeditationBlocked = param1;
         if(this.bMeditationBlocked && Boolean(this.mcActivateButton))
         {
            _loc2_ = new Array();
            _loc3_ = 0.4;
            _loc2_ = _loc2_.concat([_loc3_,0,0,0,0]);
            _loc2_ = _loc2_.concat([0,_loc3_,0,0,0]);
            _loc2_ = _loc2_.concat([0,0,_loc3_,0,0]);
            _loc2_ = _loc2_.concat([0,0,0,1,0]);
            _loc4_ = new ColorMatrixFilter(_loc2_);
            this.mcActivateButton.filters = [_loc4_];
         }
      }
      
      public function Set24HRFormat(param1:Boolean) : *
      {
         this._timeFormat24HR = param1;
      }
   }
}
