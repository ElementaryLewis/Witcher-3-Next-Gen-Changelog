package red.game.witcher3.hud.modules
{
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.hud.modules.dialog.Option;
   import red.game.witcher3.hud.modules.dialog.OptionContainer;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.MouseEventEx;
   
   public class HudModuleDialog extends HudModuleBase
   {
      
      private static const BLOCK_PADDING:Number = 44;
      
      private static const SKIP_HEIGHT:Number = 45;
       
      
      public var mcSkipIndicator:SkipIndicator;
      
      public var tfSubtitles:TextField;
      
      public var tfPreviousSubtitles:TextField;
      
      public var mcSubtitlesContainer:MovieClip;
      
      public var mcOptionContainer:OptionContainer;
      
      public var mcDialogueBar:StatusIndicator;
      
      public var mcAngerBar:StatusIndicator;
      
      private var _fadeTimer:Timer;
      
      public var canBeSkipped:Boolean = true;
      
      private var _skipButtonShown:Boolean;
      
      private var _focusHandler:FocusHandler;
      
      public function HudModuleDialog()
      {
         addFrameScript(0,this.frame1);
         super();
         this._fadeTimer = new Timer(3300);
         this._fadeTimer.addEventListener(TimerEvent.TIMER,this.OnFadeTimer,false,0,true);
         this.__setProp_mcAngerBar_Scene1_mcAngerBar_0();
         this.__setProp_mcDialogueBar_Scene1_mcDialogueBar_0();
      }
      
      override public function get moduleName() : String
      {
         return "DialogModule";
      }
      
      override public function ShowElementFromState(param1:Boolean, param2:Boolean = false) : void
      {
         super.ShowElementFromState(param1,param2);
         if(_shown)
         {
            _inputMgr.addInputBlocker(false,"HUD_DIALOG");
         }
         else
         {
            _inputMgr.removeInputBlocker("HUD_DIALOG");
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         FocusHandler.init(stage,this);
         this._focusHandler = FocusHandler.getInstance();
         tabEnabled = tabChildren = false;
         mouseEnabled = false;
         visible = false;
         alpha = 0;
         this.mcOptionContainer.visible = false;
         this.mcOptionContainer.alpha = 1;
         this.tfSubtitles = this.mcSubtitlesContainer.tfSubtitles;
         this.tfPreviousSubtitles = this.mcSubtitlesContainer.tfPreviousSubtitles;
         this.tfSubtitles.autoSize = TextFieldAutoSize.CENTER;
         this.tfSubtitles.multiline = true;
         this.tfSubtitles.wordWrap = true;
         this.tfPreviousSubtitles.autoSize = TextFieldAutoSize.CENTER;
         this.tfPreviousSubtitles.multiline = true;
         this.tfPreviousSubtitles.wordWrap = true;
         this.tfSubtitles.text = "";
         this.tfPreviousSubtitles.text = "";
         this.mcDialogueBar["tfBarLabel"].htmlText = "[[panel_hud_dialogue_bar_label_timeleft]]";
         this.mcAngerBar["tfBarLabel"].htmlText = "[[panel_hud_dialogue_bar_label_anger]]";
         this.mcAngerBar.visible = false;
         this.mcDialogueBar.visible = false;
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         registerDataBinding("hud.dialog.choices",this.onChoicesSet);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         stage.addEventListener(MouseEvent.CLICK,this.handleStageClick,false,0,true);
         _inputHandlers.push(this.mcOptionContainer);
         this.mcSkipIndicator.setupData();
         this.updateSlipPosition();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.updateSlipPosition,false,0,true);
      }
      
      private function updateSlipPosition(param1:Event = null) : void
      {
         this.mcSkipIndicator.x = Math.round((1920 - this.mcSkipIndicator.btnSkip.getViewWidth()) / 2);
      }
      
      public function setAlternativeDialogOptionView(param1:Boolean) : void
      {
         Option.ALTERNATIVE_ARROW_SKIN = param1;
      }
      
      public function setCanBeSkipped(param1:Boolean) : void
      {
         this.canBeSkipped = param1;
         if(param1 == false && this.mcSkipIndicator.alpha > 0.1)
         {
            this.SkipConfirmHide();
         }
      }
      
      public function SentenceSet(param1:String) : void
      {
         this.tfSubtitles.htmlText = param1;
         this.mcOptionContainer.DataReset();
         this.alignControls();
      }
      
      public function SentenceHide() : void
      {
         this.tfSubtitles.htmlText = "";
         this.alignControls();
      }
      
      public function PreviousSentenceSet(param1:String) : void
      {
         this.tfPreviousSubtitles.htmlText = param1;
         this.alignControls();
      }
      
      public function PreviousSentenceHide() : void
      {
         this.tfPreviousSubtitles.htmlText = "";
         this.alignControls();
      }
      
      private function onChoicesSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(param2 <= 0)
         {
            if(_loc3_)
            {
               this.ChoicesSet(_loc3_);
               this._focusHandler.setFocus(this,0);
            }
         }
      }
      
      public function ChoicesSet(param1:Array) : void
      {
         if(param1.length > 0)
         {
            this.mcOptionContainer.alpha = 1;
            this.mcOptionContainer.visible = true;
         }
         else
         {
            this.mcOptionContainer.alpha = 0;
            this.mcOptionContainer.visible = false;
         }
         this.mcOptionContainer.ChoicesSet(param1);
         this.SkipConfirmHide();
      }
      
      public function ChoiceSelectionSet(param1:int) : void
      {
         this.mcOptionContainer.ChoiceSelectionSet(param1);
      }
      
      public function ChoiceTimeoutSet(param1:Number) : void
      {
         this.mcDialogueBar.value = param1;
         this.mcDialogueBar.visible = true;
      }
      
      public function ChoiceTimeoutHide() : void
      {
         this.mcDialogueBar.visible = false;
      }
      
      public function SkipConfirmShow() : void
      {
         if(this.canBeSkipped)
         {
            this._skipButtonShown = true;
            this._fadeTimer.stop();
            this.effectFade(this.mcSkipIndicator,1,300);
            this._fadeTimer.reset();
            this._fadeTimer.start();
         }
      }
      
      public function SkipConfirmHide() : void
      {
         this._skipButtonShown = false;
         this._fadeTimer.stop();
         this.effectFade(this.mcSkipIndicator,0,300);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:UIComponent = null;
         if(param1.handled || alpha == 0)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:int = 0;
         this._focusHandler.setFocus(this,0);
         for each(_loc4_ in _inputHandlers)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            _loc4_.handleInput(param1);
         }
         if(param1.handled)
         {
            param1.stopImmediatePropagation();
            return;
         }
         if(_loc2_.value == InputValue.KEY_DOWN && this.canBeSkipped)
         {
            switch(_loc2_.code)
            {
               case KeyCode.SPACE:
               case KeyCode.PAD_X_SQUARE:
                  if(this.mcSkipIndicator.alpha > 0.1)
                  {
                     param1.handled = true;
                     this.SkipConfirmHide();
                     _loc3_ = 1;
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogSkipped",[_loc3_]));
                     break;
                  }
               default:
                  if((_loc2_.code < KeyCode.F1 || _loc2_.code > KeyCode.F24) && _loc2_.code != KeyCode.PRINTSCREEN && this.mcOptionContainer.GetOptionsListLength() == 0)
                  {
                     this.SkipConfirmShow();
                  }
            }
         }
      }
      
      private function handleStageClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            if(!this.canBeSkipped)
            {
               return;
            }
            if(this.mcSkipIndicator.alpha > 0.1)
            {
               this.SkipConfirmHide();
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnDialogSkipped",[1]));
            }
            else if(this.mcOptionContainer.GetOptionsListLength() == 0)
            {
               this.SkipConfirmShow();
            }
         }
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this._focusHandler.setFocus(this,0);
         this.mcOptionContainer.focused = 1;
      }
      
      public function setBarValue(param1:Number) : void
      {
         this.mcAngerBar.value = param1;
         if(param1 == 0)
         {
            this.mcAngerBar.visible = false;
         }
         else
         {
            this.mcAngerBar.visible = true;
         }
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      override protected function effectFade(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         pauseTweenOn(param1);
         desiredAlpha = param2;
         _loc4_ = TweenEx.to(param3,param1,{"alpha":param2},{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":handleTweenComplete
         });
         targetTweens.push(_loc4_);
      }
      
      override protected function SetScaleAnimation(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         pauseTweenOn(param1);
         desiredScale = param2;
         _loc4_ = TweenEx.to(param3,param1,{
            "scaleX":param2,
            "scaleY":param2
         },{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":handleTweenComplete
         });
         targetTweens.push(_loc4_);
      }
      
      private function alignControls() : void
      {
         var _loc1_:Number = 1080 * 0.95;
         this.tfPreviousSubtitles.height = this.tfPreviousSubtitles.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.tfSubtitles.height = this.tfSubtitles.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(this.mcSkipIndicator.visible)
         {
            this.mcSkipIndicator.y = _loc1_ - BLOCK_PADDING;
            this.mcSubtitlesContainer.y = this.mcSkipIndicator.y - SKIP_HEIGHT - BLOCK_PADDING;
         }
         else
         {
            this.mcSubtitlesContainer.y = _loc1_ - SKIP_HEIGHT - BLOCK_PADDING;
         }
      }
      
      private function OnFadeTimer(param1:TimerEvent) : void
      {
         this.SkipConfirmHide();
      }
      
      internal function __setProp_mcAngerBar_Scene1_mcAngerBar_0() : *
      {
         try
         {
            this.mcAngerBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcAngerBar.enabled = true;
         this.mcAngerBar.enableInitCallback = false;
         this.mcAngerBar.maximum = 100;
         this.mcAngerBar.minimum = 0;
         this.mcAngerBar.value = 0;
         this.mcAngerBar.visible = true;
         try
         {
            this.mcAngerBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcDialogueBar_Scene1_mcDialogueBar_0() : *
      {
         try
         {
            this.mcDialogueBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcDialogueBar.enabled = true;
         this.mcDialogueBar.enableInitCallback = false;
         this.mcDialogueBar.maximum = 100;
         this.mcDialogueBar.minimum = 0;
         this.mcDialogueBar.value = 0;
         this.mcDialogueBar.visible = true;
         try
         {
            this.mcDialogueBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
