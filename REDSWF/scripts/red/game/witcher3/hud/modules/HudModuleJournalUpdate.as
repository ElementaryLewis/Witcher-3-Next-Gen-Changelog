package red.game.witcher3.hud.modules
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.hud.modules.journalupdate.QuestBookInfo;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.Label;
   
   public class HudModuleJournalUpdate extends HudModuleBase
   {
       
      
      private const BOOK_INFO_ANIM_OFFSET:Number = 10;
      
      public var mcText:Label;
      
      public var mcTitle:Label;
      
      public var mcIconLoader:W3UILoader;
      
      public var mcInputFeedback:ModuleInputFeedback;
      
      public var displayTime:Number = 3000;
      
      public var lvlupanim:MovieClip;
      
      private var showTimer:Timer;
      
      private var _showInfoPanelTimer:Timer;
      
      private var _bookInfo:QuestBookInfo;
      
      private var _bookInfoData:Object;
      
      public function HudModuleJournalUpdate()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6,6,this.frame7);
         this.__setProp_mcIconLoader_Scene1_icon_0();
         this.__setProp_mcInputFeedback_Scene1_Layer2_0();
      }
      
      override public function get moduleName() : String
      {
         return "JournalUpdateModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         visible = false;
         this.mcIconLoader.visible = false;
         this.lvlupanim.visible = false;
         this.mcTitle.htmlText = "";
         this.mcText.htmlText = "";
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"hud.journalupdate.buttons.setup",[this.handleSetupButtons]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"hud.journalupdate.bookinfo",[this.showItemInfo]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function updateItemInfo() : void
      {
         if(!this._bookInfo)
         {
         }
      }
      
      public function hideItemInfo() : void
      {
         if(this._bookInfo)
         {
            this.ClearJournalUpdate();
            GTweener.removeTweens(this._bookInfo);
            removeChild(this._bookInfo);
            this._bookInfo = null;
            if(this._showInfoPanelTimer)
            {
               this._showInfoPanelTimer.stop();
               this._showInfoPanelTimer.removeEventListener(TimerEvent.TIMER,this.handleBookInfoTimer,false);
            }
         }
      }
      
      private function showItemInfo(param1:Object) : void
      {
         var _loc2_:Class = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Point = null;
         this.mcTitle.htmlText = "";
         this.mcText.htmlText = "";
         this.SetIcon("");
         this.mcInputFeedback.cleanupButtons();
         if(this._bookInfo)
         {
            GTweener.removeTweens(this._bookInfo);
            removeChild(this._bookInfo);
            this._bookInfo = null;
         }
         this._bookInfoData = param1;
         if(this._bookInfoData)
         {
            _loc2_ = getDefinitionByName("BookInfoPopupRef") as Class;
            this.SetShowTimer(param1.showTime,true);
            this._bookInfo = new _loc2_() as QuestBookInfo;
            this._bookInfo.alpha = 0;
            _loc3_ = CommonUtils.getScreenRect();
            _loc4_ = globalToLocal(new Point(_loc3_.width / 2,_loc3_.height));
            this._bookInfo.data = param1;
            this._bookInfo.y = 150;
            addChild(this._bookInfo);
            GTweener.removeTweens(this._bookInfo);
            GTweener.to(this._bookInfo,1,{"alpha":1},{"ease":Sine.easeOut});
            if(this._showInfoPanelTimer)
            {
               this._showInfoPanelTimer.stop();
               this._showInfoPanelTimer.removeEventListener(TimerEvent.TIMER,this.handleBookInfoTimer,false);
            }
            this._showInfoPanelTimer = new Timer(param1.showTime);
            this._showInfoPanelTimer.addEventListener(TimerEvent.TIMER,this.handleBookInfoTimer,false,0,true);
            this._showInfoPanelTimer.start();
         }
      }
      
      private function handleBookInfoTimer(param1:Event = null) : void
      {
         if(this._showInfoPanelTimer)
         {
            this._showInfoPanelTimer.stop();
            this._showInfoPanelTimer.removeEventListener(TimerEvent.TIMER,this.handleBookInfoTimer,false);
         }
         if(this._bookInfo)
         {
            GTweener.removeTweens(this._bookInfo);
            GTweener.to(this._bookInfo,1,{"alpha":0},{
               "ease":Sine.easeOut,
               "onComplete":this.handelBookInfoHidden
            });
         }
      }
      
      private function handelBookInfoHidden() : void
      {
         if(this._bookInfo)
         {
            GTweener.removeTweens(this._bookInfo);
            removeChild(this._bookInfo);
         }
      }
      
      public function ShowJournalUpdate(param1:String, param2:String, param3:Number) : void
      {
         if(isEnabled)
         {
            this.mcTitle.htmlText = CommonUtils.toUpperCaseSafe(param2);
            this.mcText.htmlText = CommonUtils.toUpperCaseSafe(param1);
            this.SetShowTimer(param3);
            this.mcText.validateNow();
            this.mcInputFeedback.y = this.mcText.y + this.mcText.textField.textHeight + this.mcInputFeedback.height / 2;
         }
      }
      
      public function SetIcon(param1:String) : void
      {
         if(param1 == "")
         {
            this.mcIconLoader.visible = false;
         }
         else
         {
            this.mcIconLoader.visible = true;
            this.mcIconLoader.source = "img://" + param1;
         }
      }
      
      public function SetJournalUpdateStatus(param1:int) : void
      {
         if(this.lvlupanim)
         {
            this.lvlupanim.visible = false;
         }
         if(param1 == 0)
         {
            return;
         }
         if(param1 == 6)
         {
            if(this.lvlupanim)
            {
               this.lvlupanim.visible = true;
               this.lvlupanim.gotoAndPlay(1);
            }
         }
         if(param1 == 7)
         {
            if(this.lvlupanim)
            {
               this.lvlupanim.visible = false;
            }
         }
         gotoAndStop(param1);
      }
      
      public function PauseShowTimer(param1:Boolean) : void
      {
         if(this._showInfoPanelTimer)
         {
            if(this._showInfoPanelTimer)
            {
               this._showInfoPanelTimer.stop();
            }
            else
            {
               this._showInfoPanelTimer.start();
            }
         }
         if(this.showTimer)
         {
            if(param1)
            {
               this.showTimer.stop();
            }
            else
            {
               this.showTimer.start();
            }
         }
      }
      
      public function SetShowTimer(param1:Number, param2:Boolean = false) : void
      {
         if(param1 == 0)
         {
            if(this.showTimer)
            {
               this.showTimer.stop();
            }
            return;
         }
         if(!this.showTimer)
         {
            this.displayTime = param1;
            this.showTimer = new Timer(param1,1);
            if(param2)
            {
               this.showTimer.addEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCountingNoCallback,false,0,true);
            }
            else
            {
               this.showTimer.addEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCounting,false,0,true);
            }
         }
         else if(param1 != this.displayTime)
         {
            this.displayTime = param1;
            this.showTimer.stop();
            this.showTimer.removeEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCounting);
            this.showTimer.removeEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCountingNoCallback);
            this.showTimer = null;
            this.showTimer = new Timer(param1,1);
            if(param2)
            {
               this.showTimer.addEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCountingNoCallback,false,0,true);
            }
            else
            {
               this.showTimer.addEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCounting,false,0,true);
            }
         }
         else
         {
            this.showTimer.reset();
         }
         this.showTimer.start();
      }
      
      public function ResetShowTimer() : void
      {
         if(this.showTimer)
         {
            this.showTimer.reset();
            this.showTimer.start();
         }
      }
      
      public function RemoveShowTimer() : void
      {
         if(this.showTimer)
         {
            this.showTimer.stop();
            this.showTimer.removeEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCounting);
            this.showTimer.removeEventListener(TimerEvent.TIMER,this.ShowTimerFinishedCountingNoCallback);
            this.showTimer = null;
         }
      }
      
      internal function ShowTimerFinishedCounting(param1:TimerEvent) : void
      {
         this.RemoveShowTimer();
         ShowElementFromState(false,false);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRemoveUpdate"));
      }
      
      internal function ShowTimerFinishedCountingNoCallback(param1:TimerEvent) : void
      {
         this.RemoveShowTimer();
         ShowElementFromState(false,false);
      }
      
      public function ClearJournalUpdate() : *
      {
         this.RemoveShowTimer();
         ShowElementFromState(false,false);
         this.mcTitle.htmlText = "";
         this.mcText.htmlText = "";
         this.SetIcon("");
         this.mcInputFeedback.cleanupButtons();
      }
      
      override public function SetState(param1:String) : *
      {
         super.SetState(param1);
         if(!isEnabled || param1 == "Hide")
         {
            this.ClearJournalUpdate();
            if(alpha != 0 && _ShowState)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnShowUpdateEnd"));
            }
            _ShowState = false;
         }
      }
      
      override protected function handleModuleHidden(param1:GTween) : void
      {
         super.handleModuleHidden(param1);
         if(alpha == 0 && _ShowState)
         {
            _ShowState = false;
            this.RemoveShowTimer();
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnShowUpdateEnd"));
         }
      }
      
      protected function handleSetupButtons(param1:Object, param2:int) : void
      {
         this.mcInputFeedback.handleSetupButtons(param1);
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      override public function onCutsceneStartedOrEnded(param1:Boolean) : *
      {
         if(param1)
         {
            if(!isInCutscene)
            {
               isInCutscene = true;
               x += 440;
            }
         }
         else if(isInCutscene)
         {
            isInCutscene = false;
            x -= 440;
         }
      }
      
      internal function __setProp_mcIconLoader_Scene1_icon_0() : *
      {
         try
         {
            this.mcIconLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcIconLoader.autoSize = true;
         this.mcIconLoader.enableInitCallback = false;
         this.mcIconLoader.maintainAspectRatio = true;
         this.mcIconLoader.source = "";
         this.mcIconLoader.visible = false;
         try
         {
            this.mcIconLoader["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcInputFeedback_Scene1_Layer2_0() : *
      {
         try
         {
            this.mcInputFeedback["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcInputFeedback.buttonAlign = "left";
         this.mcInputFeedback.enabled = true;
         this.mcInputFeedback.enableInitCallback = false;
         this.mcInputFeedback.visible = true;
         try
         {
            this.mcInputFeedback["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
   }
}
