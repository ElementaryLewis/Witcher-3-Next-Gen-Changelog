package red.game.witcher3.menus.glossary
{
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.menus.common.ListModuleBase;
   import red.game.witcher3.menus.common.TextAreaModule;
   import red.game.witcher3.utils.motion.TweenEx;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GlossaryStorybookMenu extends CoreMenu
   {
      
      protected static const FADE_DURATION:Number = 1000;
       
      
      public var mcMainListModule:ListModuleBase;
      
      public var mcTextAreaModule:TextAreaModule;
      
      public var btnSkip:InputFeedbackButton;
      
      public var mcSkipIndicator:MovieClip;
      
      private var _fadeTimer:Timer;
      
      private var _skipButtonShown:Boolean;
      
      protected var targetTweens:Vector.<TweenEx>;
      
      public function GlossaryStorybookMenu()
      {
         this.targetTweens = new Vector.<TweenEx>();
         addFrameScript(0,this.frame1);
         super();
         this.mcMainListModule.menuName = this.menuName;
         this.mcMainListModule.itemInputFeedbackLabel = "panel_button_common_play";
         this.mcTextAreaModule.dataBindingKey = "glossary.description";
         this.__setProp_mcMainListModule_Scene1_mcMainListModule_0();
      }
      
      override protected function get menuName() : String
      {
         return "GlossaryStorybookMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._fadeTimer = new Timer(3300);
         this._fadeTimer.addEventListener(TimerEvent.TIMER,this.OnFadeTimer,false,0,true);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         stage.invalidate();
         validateNow();
         focused = 1;
         this.btnSkip = this.mcSkipIndicator.btnSkip;
         this.btnSkip.clickable = false;
         this.btnSkip.label = "[[panel_button_dialogue_skip]]";
         this.mcSkipIndicator.alpha = 0;
         this.btnSkip.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.ESCAPE);
         this.btnSkip.validateNow();
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         this.mcTextAreaModule.visible = param1;
         this.mcTextAreaModule.enabled = param1;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc4_:UIComponent = null;
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(this.mcMainListModule.GetMovieIsPlaying())
         {
            if(!param1.handled && _loc3_)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_B:
                  case NavigationCode.GAMEPAD_X:
                     if(this.mcSkipIndicator.alpha > 0.1)
                     {
                        this.SkipConfirmHide();
                        closeMenu();
                        return;
                     }
                     break;
               }
               this.SkipConfirmShow();
            }
            if(_loc3_ && !param1.handled)
            {
               switch(_loc2_.code)
               {
                  case KeyCode.SPACE:
                  case KeyCode.ESCAPE:
                     if(this.mcSkipIndicator.alpha > 0.1)
                     {
                        this.SkipConfirmHide();
                        closeMenu();
                        return;
                     }
                     break;
               }
               this.SkipConfirmShow();
            }
         }
         else
         {
            for each(_loc4_ in actualModules)
            {
               if(param1.handled)
               {
                  param1.stopImmediatePropagation();
                  return;
               }
               _loc4_.handleInput(param1);
            }
         }
      }
      
      public function setTitle(param1:String) : void
      {
         if(this.mcTextAreaModule)
         {
            this.mcTextAreaModule.SetTitle(param1);
         }
      }
      
      public function setText(param1:String) : void
      {
         if(this.mcTextAreaModule)
         {
            this.mcTextAreaModule.SetText(param1);
         }
      }
      
      public function showModules(param1:Boolean) : void
      {
         var _loc2_:Number = 0;
         if(param1)
         {
            _loc2_ = 1;
            visible = true;
            y = 0;
            alpha = 1;
            this.mcMainListModule.SetMovieIsPlaying(false);
            this.SkipConfirmHide();
         }
         if(this.mcTextAreaModule)
         {
            this.mcTextAreaModule.alpha = _loc2_ + 0.001;
         }
         if(this.mcMainListModule)
         {
            this.mcMainListModule.alpha = _loc2_;
         }
      }
      
      public function SkipConfirmShow() : void
      {
         this._skipButtonShown = true;
         this._fadeTimer.stop();
         this.effectFade(this.mcSkipIndicator,1,300);
         this._fadeTimer.reset();
         this._fadeTimer.start();
      }
      
      public function SkipConfirmHide() : void
      {
         this._skipButtonShown = false;
         this._fadeTimer.stop();
         this.effectFade(this.mcSkipIndicator,0,300);
      }
      
      private function OnFadeTimer(param1:TimerEvent) : void
      {
         this.SkipConfirmHide();
      }
      
      protected function effectFade(param1:Object, param2:Number, param3:int = 1000) : void
      {
         var _loc4_:TweenEx = null;
         this.pauseTweenOn(param1);
         _loc4_ = TweenEx.to(param3,param1,{"alpha":param2},{
            "paused":false,
            "ease":Strong.easeOut,
            "onComplete":this.handleTweenComplete
         });
         this.targetTweens.push(_loc4_);
      }
      
      protected function handleTweenComplete(param1:TweenEx) : void
      {
         this.pauseTweenOn(param1.target);
      }
      
      protected function pauseTweenOn(param1:Object) : *
      {
         var _loc2_:int = int(this.targetTweens.length - 1);
         while(_loc2_ > -1)
         {
            if(param1 == this.targetTweens[_loc2_].target)
            {
               this.targetTweens[_loc2_].paused = true;
               this.targetTweens.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
      
      protected function Update() : void
      {
      }
      
      internal function __setProp_mcMainListModule_Scene1_mcMainListModule_0() : *
      {
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcMainListModule.DataBindingKey = "glossary.storybook.list";
         this.mcMainListModule.enabled = true;
         this.mcMainListModule.enableInitCallback = false;
         this.mcMainListModule.itemInputFeedbackLabel = "panel_button_common_play";
         this.mcMainListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcMainListModule.ItemRendererClass = "IconListItem";
         this.mcMainListModule.listHeight = 600;
         this.mcMainListModule.listWidth = 200;
         this.mcMainListModule.visible = true;
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = false;
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
