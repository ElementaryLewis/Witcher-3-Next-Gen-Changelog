package red.game.witcher3.popups
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Elastic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.CorePopup;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.MessageButton;
   import red.game.witcher3.constants.SysMessageType;
   import red.game.witcher3.controls.MouseCursor;
   import red.game.witcher3.data.SysMessageData;
   import red.game.witcher3.events.InputFeedbackEvent;
   import red.game.witcher3.managers.RuntimeAssetsManager;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class MessagePopupMenu extends CorePopup
   {
      
      private static const ANIM_DURATION:Number = 1.5;
       
      
      public var mcMessageModule:SystemMessageModule;
      
      public var mcBackground:Sprite;
      
      private var currentMessage:SysMessageData;
      
      private var _pendedMessageId:int = -1;
      
      private var _progressTimer:Timer;
      
      private var _overlayCanvas:MovieClip;
      
      private var _mouseCursor:MouseCursor;
      
      public function MessagePopupMenu()
      {
         super();
         _enableInputValidation = true;
         RuntimeAssetsManager.getInstanse().loadLibrary();
         this.mcBackground.visible = false;
         this.mcMessageModule.addEventListener(Event.ACTIVATE,this.handleMessageShown,false,0,true);
         this.mcMessageModule.addEventListener(Event.DEACTIVATE,this.handleMessageHidden,false,0,true);
         this.mcMessageModule.addEventListener(InputFeedbackEvent.USER_ACTION,this.handleUserAction,false,0,true);
         var _loc1_:ModuleInputFeedback = this.mcMessageModule.mcInputFeedback;
         if(_loc1_)
         {
            _loc1_.filterKeyCodeFunction = isKeyCodeValid;
            _loc1_.filterNavCodeFunction = isNavEquivalentValid;
         }
         if(!Extensions.isScaleform)
         {
            this.startDebugMode();
         }
         this.mcMessageModule.visible = false;
      }
      
      override protected function get popupName() : String
      {
         return "MessagePopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"message.show",[this.showMessage]));
         this.playStartupAnim();
         this.mcMessageModule.tfMessage.focused = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this._overlayCanvas = new MovieClip();
         this._overlayCanvas.mouseChildren = this._overlayCanvas.mouseEnabled = false;
         addChild(this._overlayCanvas);
         this._mouseCursor = new MouseCursor(this._overlayCanvas);
      }
      
      public function showProgressBar(param1:Number, param2:Number, param3:String) : void
      {
         this.mcMessageModule.setProgress(param1,param3);
         if(param1 == -1)
         {
            if(this._progressTimer)
            {
               this._progressTimer.stop();
               this._progressTimer.removeEventListener(TimerEvent.TIMER,this.progressUpdate);
               this._progressTimer = null;
            }
         }
         else if(!this._progressTimer)
         {
            this._progressTimer = new Timer(param2,0);
            this._progressTimer.addEventListener(TimerEvent.TIMER,this.progressUpdate);
            this._progressTimer.start();
         }
      }
      
      public function hideMessage(param1:int) : void
      {
         trace("GFX hideMessage [" + param1 + "] _pendedMessageId: ",this._pendedMessageId);
         this._pendedMessageId = -1;
         if(Boolean(this.mcMessageModule.data) && this.mcMessageModule.data.id == param1)
         {
            this.mcMessageModule.hide();
            if(this._progressTimer)
            {
               this._progressTimer.stop();
               this._progressTimer.removeEventListener(TimerEvent.TIMER,this.progressUpdate);
               this._progressTimer = null;
            }
         }
      }
      
      protected function showMessage(param1:SysMessageData) : void
      {
         trace("GFX showMessage [" + param1.messageText + "] _pendedMessageId ",this._pendedMessageId,"; isShown ",this.mcMessageModule.isShown());
         if(param1.id == this._pendedMessageId)
         {
            this._pendedMessageId = -1;
            this.setCurrentMessage(param1);
         }
      }
      
      public function prepareMessageShowing(param1:int) : void
      {
         trace("GFX prepareMessageShowing [" + param1 + "]");
         this._pendedMessageId = param1;
         if(this._pendedMessageId == -1)
         {
            this.mcMessageModule.hide();
         }
      }
      
      protected function setCurrentMessage(param1:SysMessageData) : void
      {
         this.mcMessageModule.data = param1;
         this.mcMessageModule.show();
         this._pendedMessageId = -1;
      }
      
      protected function playStartupAnim() : void
      {
         this.mcBackground.visible = true;
         this.mcBackground.alpha = 0;
         GTweener.to(this.mcBackground,ANIM_DURATION,{"alpha":1},{"ease":Elastic.easeOut});
      }
      
      private function handleMessageShown(param1:Event) : void
      {
      }
      
      private function handleMessageHidden(param1:Event = null) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnMessageHidden",[this.mcMessageModule.data.id]));
      }
      
      private function handleUserAction(param1:InputFeedbackEvent) : void
      {
         var _loc3_:InputDetails = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc2_:InputEvent = param1.inputEventRef;
         if(this.mcMessageModule.isHidden())
         {
            return;
         }
         if(_loc2_)
         {
            _loc3_ = _loc2_.details;
            if(_enableInputValidation && (!isNavEquivalentValid(_loc3_.navEquivalent) || !isKeyCodeValid(_loc3_.code)))
            {
               return;
            }
         }
         if(this.mcMessageModule.data.type != SysMessageType.NONE)
         {
            _loc4_ = param1.actionId;
            _loc5_ = MessageButton.isPositive(_loc4_);
            this.mcMessageModule.hide(!_loc5_);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUserAction",[param1.messageId,param1.actionId]));
         }
      }
      
      private function startDebugMode() : void
      {
         var _loc1_:Array = [];
         var _loc2_:SysMessageData = new SysMessageData();
         _loc2_.id = 0;
         _loc2_.titleText = "TEST MESSAGE";
         _loc2_.messageText = "Some message, <FONT color = \'#FF0000\'>just</FONT> for test.";
         _loc1_.push({"id":MessageButton.MB_OK});
         _loc1_.push({
            "id":MessageButton.MB_CANCEL,
            "label":"Custom cancel text"
         });
         _loc2_.buttonList = _loc1_;
         this.showMessage(_loc2_);
      }
      
      internal function progressUpdate(param1:TimerEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnProgressUpdateRequested"));
      }
   }
}
