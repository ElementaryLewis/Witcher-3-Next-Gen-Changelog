package red.core.overlay
{
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.gfx.Extensions;
   
   public class LoadingScreen extends MovieClip
   {
       
      
      private const SKIP_ACTIVE_POS:Number = 1670;
      
      private const SKIP_INACTIVE_POS:Number = 1740;
      
      public var mcProgressBar:StatusIndicator;
      
      public var mcImage:MovieClip;
      
      public var mcBlackscreen:MovieClip;
      
      public var mcSubtitles:MovieClip;
      
      public var btnSkipIndicator:InputFeedbackButton;
      
      private var lastFrameTimeInMS:int = 0;
      
      private var blackscreenAlphaAccel:Number = 0;
      
      private var tipList:Array;
      
      private var _tipTimer:Timer;
      
      private var _lastSkipBtnVisibilitySet:Boolean = false;
      
      public function LoadingScreen()
      {
         super();
         this.initializeTipList();
         var _loc1_:String = "";
         if(Extensions.enabled)
         {
            _loc1_ = ExternalInterface.call("initString") as String;
         }
         InputManager.getInstance().init(this);
         InputManager.getInstance().setControllerType(true);
         this.mcProgressBar.visible = false;
         this.mcProgressBar.minimum = 0;
         this.mcProgressBar.maximum = 1;
         this.mcProgressBar.validateNow();
         this.mcSubtitles.tfSubtitles.text = "";
         if(!stage)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            this.registerLoadingScreen();
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this.registerLoadingScreen();
      }
      
      protected function registerLoadingScreen() : void
      {
         if(Extensions.enabled)
         {
            ExternalInterface.call("registerLoadingScreen",this);
         }
      }
      
      public function showProgressBar(param1:Boolean) : void
      {
         this.mcProgressBar.visible = param1;
      }
      
      public function setProgressValue(param1:Number) : void
      {
         this.mcProgressBar.value = param1;
      }
      
      public function setPlatform(param1:uint) : void
      {
         InputManager.getInstance().setPlatformType(param1);
         if(param1 == PlatformType.PLATFORM_PC)
         {
            this.initializeTipListForPC();
         }
         if(this.btnSkipIndicator)
         {
            this.btnSkipIndicator.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.SPACE);
            this.btnSkipIndicator.label = "[[panel_button_dialogue_skip]]";
            this.btnSkipIndicator.clickable = false;
            this.btnSkipIndicator.alpha = 0;
            this.btnSkipIndicator.visible = false;
         }
      }
      
      public function setExpansionsAvailable(param1:Boolean, param2:Boolean) : *
      {
         if(param2)
         {
            this.initializeTipListForEP2();
         }
      }
      
      public function setVideoSubtitles(param1:String) : void
      {
         this.mcSubtitles.tfSubtitles.text = param1;
      }
      
      public function setTipText(param1:String) : void
      {
         this.mcSubtitles.tfSubtitles.text = param1;
      }
      
      public function setPCInput(param1:Boolean) : void
      {
         InputManager.getInstance().setControllerType(!param1);
      }
      
      public function showVideoSkip() : void
      {
         if(!this._lastSkipBtnVisibilitySet && Boolean(this.btnSkipIndicator))
         {
            this._lastSkipBtnVisibilitySet = true;
            GTweener.removeTweens(this.btnSkipIndicator);
            this.btnSkipIndicator.visible = true;
            GTweener.to(this.btnSkipIndicator,1,{
               "alpha":1,
               "x":this.SKIP_ACTIVE_POS
            });
         }
      }
      
      public function hideVideoSkip() : void
      {
         if(this._lastSkipBtnVisibilitySet && Boolean(this.btnSkipIndicator))
         {
            this._lastSkipBtnVisibilitySet = false;
            GTweener.removeTweens(this.btnSkipIndicator);
            GTweener.to(this.btnSkipIndicator,1,{
               "alpha":0,
               "x":this.SKIP_INACTIVE_POS
            });
         }
      }
      
      public function showImage() : void
      {
         this.mcImage.visible = true;
         this.setTipsEnabled(true);
      }
      
      public function hideImage() : void
      {
         this.mcImage.visible = false;
         this.setTipsEnabled(false);
      }
      
      protected function setTipsEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this._tipTimer)
            {
               this._tipTimer = new Timer(10000);
               this._tipTimer.addEventListener(TimerEvent.TIMER,this.onTipTimer,false,0,true);
               this.showNextTip();
               this._tipTimer.start();
            }
         }
         else if(this._tipTimer)
         {
            this._tipTimer = null;
         }
      }
      
      private function onTipTimer(param1:TimerEvent) : void
      {
         this.showNextTip();
         this._tipTimer.reset();
         this._tipTimer.start();
      }
      
      private function showNextTip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.tipList.length > 0)
         {
            _loc1_ = Math.min(this.tipList.length - 1,Math.floor(Math.random() * this.tipList.length));
            _loc2_ = String(this.tipList[_loc1_]);
            this.setTipText("[[" + _loc2_ + "]]");
            this.tipList.splice(_loc1_,1);
         }
      }
      
      public function fadeIn(param1:Number) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
         if(param1 <= 0)
         {
            this.mcBlackscreen.visible = false;
         }
         else
         {
            this.mcBlackscreen.alpha = 1;
            this.mcBlackscreen.visible = true;
            this.blackscreenAlphaAccel = -1 / param1;
            this.lastFrameTimeInMS = getTimer();
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
      }
      
      public function fadeOut(param1:Number) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
         if(param1 <= 0)
         {
            this.mcBlackscreen.visible = true;
            this.onFadeOutCompleted();
         }
         else
         {
            this.mcBlackscreen.alpha = 0;
            this.mcBlackscreen.visible = true;
            this.blackscreenAlphaAccel = 1 / param1;
            this.lastFrameTimeInMS = getTimer();
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:Number = (_loc2_ - this.lastFrameTimeInMS) / 1000;
         this.mcBlackscreen.alpha += _loc3_ * this.blackscreenAlphaAccel;
         if(this.blackscreenAlphaAccel < 0 && this.mcBlackscreen.alpha <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
            this.mcBlackscreen.visible = false;
         }
         else if(this.blackscreenAlphaAccel > 0 && this.mcBlackscreen.alpha >= 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
            this.onFadeOutCompleted();
         }
         this.lastFrameTimeInMS = _loc2_;
      }
      
      private function onFadeOutCompleted() : void
      {
         if(Extensions.enabled)
         {
            ExternalInterface.call("fadeOutCompleted",this);
         }
      }
      
      private function initializeTipList() : void
      {
         this.tipList = new Array();
         this.tipList.push("loading_screen_hint_1");
         this.tipList.push("loading_screen_hint_2");
         this.tipList.push("loading_screen_hint_100");
         this.tipList.push("loading_screen_hint_4");
         this.tipList.push("loading_screen_hint_5");
         this.tipList.push("loading_screen_hint_6");
         this.tipList.push("loading_screen_hint_7");
         this.tipList.push("loading_screen_hint_101");
         this.tipList.push("loading_screen_hint_8");
         this.tipList.push("loading_screen_hint_9");
         this.tipList.push("loading_screen_hint_11");
         this.tipList.push("loading_screen_hint_13");
         this.tipList.push("loading_screen_hint_14");
         this.tipList.push("loading_screen_hint_15");
         this.tipList.push("loading_screen_hint_16");
         this.tipList.push("loading_screen_hint_17");
         this.tipList.push("loading_screen_hint_18");
         this.tipList.push("loading_screen_hint_19");
         this.tipList.push("loading_screen_hint_20");
         this.tipList.push("loading_screen_hint_21");
         this.tipList.push("loading_screen_hint_24");
         this.tipList.push("loading_screen_hint_25");
         this.tipList.push("loading_screen_hint_26");
         this.tipList.push("loading_screen_hint_27");
         this.tipList.push("loading_screen_hint_28");
         this.tipList.push("loading_screen_hint_29");
         this.tipList.push("loading_screen_hint_30");
         this.tipList.push("loading_screen_hint_31");
         this.tipList.push("loading_screen_hint_32");
         this.tipList.push("loading_screen_hint_33");
         this.tipList.push("loading_screen_hint_103");
         this.tipList.push("loading_screen_hint_34");
         this.tipList.push("loading_screen_hint_35");
         this.tipList.push("loading_screen_hint_36");
         this.tipList.push("loading_screen_hint_38");
         this.tipList.push("loading_screen_hint_39");
         this.tipList.push("loading_screen_hint_40");
         this.tipList.push("loading_screen_hint_42");
         this.tipList.push("loading_screen_hint_43");
         this.tipList.push("loading_screen_hint_44");
         this.tipList.push("loading_screen_hint_102");
         this.tipList.push("loading_screen_hint_45");
         this.tipList.push("loading_screen_hint_46");
         this.tipList.push("loading_screen_hint_47");
         this.tipList.push("loading_screen_hint_48");
         this.tipList.push("loading_screen_hint_49");
         this.tipList.push("loading_screen_hint_51");
         this.tipList.push("loading_screen_hint_52");
         this.tipList.push("loading_screen_hint_53");
         this.tipList.push("loading_screen_hint_54");
         this.tipList.push("loading_screen_hint_55");
         this.tipList.push("loading_screen_hint_56");
         this.tipList.push("loading_screen_hint_57");
         this.tipList.push("loading_screen_hint_58");
         this.tipList.push("loading_screen_hint_59");
         this.tipList.push("loading_screen_hint_60");
         this.tipList.push("loading_screen_hint_62");
         this.tipList.push("loading_screen_hint_63");
         this.tipList.push("loading_screen_hint_105");
         this.tipList.push("loading_screen_hint_106");
         this.tipList.push("loading_screen_hint_107");
         this.tipList.push("loading_screen_hint_108");
         this.tipList.push("loading_screen_hint_109");
         this.tipList.push("loading_screen_hint_110");
         this.tipList.push("loading_screen_hint_111");
         this.tipList.push("loading_screen_hint_112");
         this.tipList.push("loading_screen_hint_113");
         this.tipList.push("loading_screen_hint_114");
         this.tipList.push("loading_screen_hint_115");
         this.tipList.push("loading_screen_hint_117");
         this.tipList.push("loading_screen_hint_118");
         this.tipList.push("loading_screen_hint_119");
         this.tipList.push("loading_screen_hint_120");
         this.tipList.push("loading_screen_hint_121");
         this.tipList.push("loading_screen_hint_122");
         this.tipList.push("loading_screen_hint_123");
         this.tipList.push("loading_screen_hint_124");
         this.tipList.push("loading_screen_hint_125");
         this.tipList.push("loading_screen_hint_65");
         this.tipList.push("loading_screen_hint_66");
         this.tipList.push("loading_screen_hint_67");
         this.tipList.push("loading_screen_hint_68");
         this.tipList.push("loading_screen_hint_69");
         this.tipList.push("loading_screen_hint_70");
         this.tipList.push("loading_screen_hint_71");
         this.tipList.push("loading_screen_hint_72");
         this.tipList.push("loading_screen_hint_73");
         this.tipList.push("loading_screen_hint_74");
         this.tipList.push("loading_screen_hint_75");
         this.tipList.push("loading_screen_hint_76");
         this.tipList.push("loading_screen_hint_77");
         this.tipList.push("loading_screen_hint_78");
         this.tipList.push("loading_screen_hint_79");
         this.tipList.push("loading_screen_hint_80");
         this.tipList.push("loading_screen_hint_81");
         this.tipList.push("loading_screen_hint_82");
         this.tipList.push("loading_screen_hint_83");
         this.tipList.push("loading_screen_hint_84");
         this.tipList.push("loading_screen_hint_85");
         this.tipList.push("loading_screen_hint_86");
         this.tipList.push("loading_screen_hint_87");
         this.tipList.push("loading_screen_hint_88");
         this.tipList.push("loading_screen_hint_89");
         this.tipList.push("loading_screen_hint_90");
         this.tipList.push("loading_screen_hint_91");
         this.tipList.push("loading_screen_hint_92");
         this.tipList.push("loading_screen_hint_93");
         this.tipList.push("loading_screen_hint_94");
         this.tipList.push("loading_screen_hint_95");
         this.tipList.push("loading_screen_hint_00003");
         this.tipList.push("loading_screen_hint_00004");
         this.tipList.push("loading_screen_hint_130");
         this.tipList.push("loading_screen_hint_131");
         this.tipList.push("loading_screen_hint_134");
         this.tipList.push("loading_screen_hint_135");
         this.tipList.push("loading_screen_hint_136");
         this.tipList.push("loading_screen_hint_137");
         this.tipList.push("loading_screen_hint_138");
      }
      
      private function initializeTipListForPC() : void
      {
         if(this.tipList)
         {
            this.tipList.push("loading_screen_hint_00001");
         }
      }
      
      private function initializeTipListForEP2() : void
      {
         if(this.tipList)
         {
            this.tipList.push("loading_screen_hint_ep2_001");
            this.tipList.push("loading_screen_hint_ep2_002");
            this.tipList.push("loading_screen_hint_ep2_003");
            this.tipList.push("loading_screen_hint_ep2_004");
            this.tipList.push("loading_screen_hint_ep2_005");
            this.tipList.push("loading_screen_hint_ep2_007");
            this.tipList.push("loading_screen_hint_ep2_008");
         }
      }
   }
}
