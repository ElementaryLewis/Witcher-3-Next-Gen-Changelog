package red.game.witcher3.popups
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.game.witcher3.constants.MessageButton;
   import red.game.witcher3.controls.W3TextArea;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.data.SysMessageData;
   import red.game.witcher3.events.InputFeedbackEvent;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.clik.core.UIComponent;
   
   public class SystemMessageModule extends UIComponent
   {
      
      private static const DEF_SCALE_MIN:Number = 0.3;
      
      private static const DEF_SCALE_MAX:Number = 1.3;
      
      private static const DEF_ANIM_DURATION:Number = 0.6;
      
      private static const DEF_BACKGROUND_WIDTH:Number = 155;
      
      private static const BUTTOND_PADDING:Number = 15;
      
      private static const HEIGHT_PADDING:Number = 10;
      
      private static const FINAL_HEIGHT_PADDING:Number = 40;
       
      
      public var tfTitle:TextField;
      
      public var tfMessage:W3TextArea;
      
      public var messageScrollbar:ScrollBar;
      
      public var mcInputFeedback:ModuleInputFeedback;
      
      public var mcBackground:MovieClip;
      
      public var mcInputBackground:MovieClip;
      
      public var mcProgressBar:StatusIndicator;
      
      public var tfProgress:TextField;
      
      protected var _progress:Number;
      
      protected var _isShown:Boolean = false;
      
      protected var _isHidden:Boolean = true;
      
      protected var _data:SysMessageData;
      
      internal var curHeight:Number;
      
      public function SystemMessageModule()
      {
         super();
         this.cleanup();
         this.mcInputFeedback.buttonAlign = "center";
         this.mcInputFeedback.directWsCall = false;
         this.mcInputFeedback.addEventListener(InputFeedbackEvent.USER_ACTION,this.handleUserAction,false,0,true);
         this.mcProgressBar.value = 0;
         this.mcProgressBar.minimum = 0;
         this.mcProgressBar.maximum = 1;
         this.mcProgressBar.visible = false;
         this.tfProgress.visible = false;
      }
      
      public function isShown() : Boolean
      {
         return this._isShown;
      }
      
      public function isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function get data() : SysMessageData
      {
         return this._data;
      }
      
      public function set data(param1:SysMessageData) : void
      {
         this._data = param1;
         this.cleanup();
         if(this._data)
         {
            this.populateData();
            this.populateButtons(this._data.buttonList);
         }
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function setProgress(param1:Number, param2:String) : void
      {
         this._progress = param1;
         if(this._progress < 0)
         {
            this.mcProgressBar.visible = false;
            this.tfProgress.visible = false;
         }
         else
         {
            if(!this.mcProgressBar.visible)
            {
               this.mcProgressBar.visible = true;
               this.tfProgress.visible = true;
            }
            this.mcProgressBar.value = param1 / 100;
            if(param2 == "_SHOW_PERC_")
            {
               this.tfProgress.text = String(Math.round(param1)) + "%";
            }
            else
            {
               this.tfProgress.text = param2;
            }
         }
      }
      
      public function show(param1:Boolean = false) : void
      {
         this._isHidden = false;
         this._isShown = true;
         visible = true;
         alpha = 0;
         scaleX = scaleY = param1 ? DEF_SCALE_MAX : DEF_SCALE_MIN;
         GTweener.removeTweens(this);
         GTweener.to(this,DEF_ANIM_DURATION,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },{
            "ease":Exponential.easeOut,
            "onComplete":this.handleShown
         });
      }
      
      public function hide(param1:Boolean = false) : void
      {
         this._isHidden = true;
         visible = true;
         var _loc2_:* = param1 ? DEF_SCALE_MIN : DEF_SCALE_MAX;
         GTweener.removeTweens(this);
         GTweener.to(this,DEF_ANIM_DURATION,{
            "alpha":0,
            "scaleX":_loc2_,
            "scaleY":_loc2_
         },{
            "ease":Exponential.easeOut,
            "onComplete":this.handleHidden
         });
      }
      
      protected function populateData() : void
      {
         this.tfTitle.htmlText = this._data.titleText;
         this.tfMessage.htmlText = this._data.messageText;
         this.tfMessage.validateNow();
         if(this.tfTitle.text == "")
         {
            this.tfMessage.y = 22.15;
            this.messageScrollbar.y = 22.15;
         }
         this.curHeight = this.tfMessage.y + this.tfMessage.textField.textHeight + HEIGHT_PADDING;
         this.tfMessage.focused = 1;
         if(Boolean(this.mcProgressBar) && this.mcProgressBar.visible)
         {
            this.mcProgressBar.y = this.curHeight;
            this.curHeight += HEIGHT_PADDING;
         }
         if(Boolean(this.tfProgress) && this.tfProgress.visible)
         {
            this.tfProgress.y = this.curHeight;
            this.curHeight += HEIGHT_PADDING;
         }
         this.mcBackground.height = this.curHeight + FINAL_HEIGHT_PADDING;
         this.mcInputBackground.y = this.mcBackground.height - this.mcInputBackground.height / 2;
         this.mcInputFeedback.y = this.mcInputBackground.y + this.mcInputBackground.height / 2;
      }
      
      protected function populateButtons(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:KeyBindingData = null;
         if(param1)
         {
            _loc2_ = [];
            _loc3_ = int(param1.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = int((_loc5_ = param1[_loc4_]).id);
               (_loc7_ = new KeyBindingData()).actionId = _loc6_;
               if(_loc5_.label)
               {
                  _loc7_.label = _loc5_.label;
               }
               else
               {
                  _loc7_.label = MessageButton.getLocalizedLabel(_loc6_);
               }
               _loc7_.keyboard_keyCode = MessageButton.getPcKeyCode(_loc6_);
               _loc7_.gamepad_navEquivalent = MessageButton.getGamepadNavCode(_loc6_);
               _loc2_.push(_loc7_);
               _loc4_++;
            }
            this.mcInputFeedback.handleSetupButtons(_loc2_);
            if(_loc3_ == 0)
            {
               this.mcInputBackground.visible = false;
            }
         }
         else
         {
            trace("GFX <ERROR>[SystemMessageModule] invalid buttonsList");
         }
      }
      
      protected function cleanup() : void
      {
         this.tfTitle.text = "";
         this.tfMessage.text = "";
         this.mcInputFeedback.cleanupButtons();
      }
      
      protected function handleShown(param1:GTween) : void
      {
         dispatchEvent(new Event(Event.ACTIVATE));
      }
      
      protected function handleHidden(param1:GTween) : void
      {
         this._isShown = false;
         visible = false;
         dispatchEvent(new Event(Event.DEACTIVATE));
      }
      
      protected function handleUserAction(param1:InputFeedbackEvent) : void
      {
         if(this._data)
         {
            param1.messageId = this._data.id;
         }
      }
   }
}
