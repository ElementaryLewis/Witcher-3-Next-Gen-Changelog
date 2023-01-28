package red.game.witcher3.popups
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import red.core.CorePopup;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.MouseCursorComponent;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.gfx.Extensions;
   
   public class OverlayPopupMenu extends CorePopup
   {
       
      
      public var notificationModule:NotificationModule;
      
      public var mouseCursor:MouseCursorComponent;
      
      public var mcIndicatorLoad:MovieClip;
      
      public var mcIndicatorSave:MovieClip;
      
      public var mcInpuFeedback:ModuleInputFeedback;
      
      protected var _mouseShown:Boolean;
      
      protected var _enableInputMgr:Boolean;
      
      protected var _notificationQueue:Vector.<Object>;
      
      protected var _safeRectCanvas:Sprite;
      
      private var _logoLoader:UILoader;
      
      private var _debugTimer:Timer;
      
      public function OverlayPopupMenu()
      {
         super();
         _enableHoldEmulation = false;
         _enableInputDeviceCheck = false;
         InputDelegate.getInstance().disableInputEvents(true);
         this._notificationQueue = new Vector.<Object>();
         this.notificationModule.addEventListener(Event.DEACTIVATE,this.handleNotificationHidden,false,0,true);
         this.mouseCursor = new MouseCursorComponent(this);
         this.mouseCursor.visible = false;
         this.mcInpuFeedback.clickable = false;
      }
      
      override protected function get popupName() : String
      {
         return "OverlayPopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         if(!Extensions.isScaleform)
         {
            this.startDebugMode();
         }
      }
      
      public function showSafeRect(param1:Boolean) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Graphics = null;
         if(this._safeRectCanvas)
         {
            removeChild(this._safeRectCanvas);
            this._safeRectCanvas = null;
         }
         if(param1)
         {
            this._safeRectCanvas = new Sprite();
            addChild(this._safeRectCanvas);
            _loc2_ = CommonUtils.getScreenRect();
            _loc3_ = _loc2_.width * 0.05;
            _loc4_ = _loc2_.height * 0.05;
            (_loc5_ = this._safeRectCanvas.graphics).lineStyle(1,16711680);
            _loc5_.moveTo(_loc2_.x + _loc3_,this._safeRectCanvas.y + _loc4_);
            _loc5_.lineTo(_loc2_.x + _loc2_.width - _loc3_,_loc2_.y + _loc4_);
            _loc5_.lineTo(_loc2_.x + _loc2_.width - _loc3_,_loc2_.y + _loc2_.height - _loc4_);
            _loc5_.lineTo(_loc2_.x + _loc3_,_loc2_.y + _loc2_.height - _loc4_);
            _loc5_.lineTo(_loc2_.x + _loc3_,_loc2_.y + _loc4_);
            _loc5_.lineStyle(0.5,16711680,0.6);
            _loc5_.moveTo(_loc2_.x + _loc3_,_loc2_.height / 2);
            _loc5_.lineTo(_loc2_.x + _loc2_.width - _loc3_,_loc2_.height / 2);
            _loc5_.moveTo(_loc2_.width / 2,_loc2_.y + _loc4_);
            _loc5_.lineTo(_loc2_.width / 2,_loc2_.y + _loc2_.height - _loc4_);
         }
      }
      
      public function updateInputFeedback() : void
      {
         this.mcInpuFeedback.refreshButtonList();
         this.updateMouseEventListeners();
      }
      
      public function appendBinding(param1:int, param2:String, param3:int, param4:String, param5:int = -1) : void
      {
         this.mcInpuFeedback.appendButton(param1,param2,param3,param4,true,param5);
      }
      
      public function removeBinding(param1:int, param2:int = -1) : void
      {
         this.mcInpuFeedback.removeButton(param1,true,param2);
      }
      
      public function removeAllContextBinding(param1:int) : void
      {
         this.mcInpuFeedback.removeAllContextButtons(param1);
      }
      
      public function showMouseCursor(param1:Boolean) : void
      {
         this._mouseShown = param1;
         this.mouseCursor.visible = this._mouseShown;
         this.updateMouseEventListeners();
      }
      
      public function showNotification(param1:String, param2:Number = 0, param3:Boolean = false) : void
      {
         if(this.notificationModule.isShown())
         {
            if(param3)
            {
               this._notificationQueue.push({
                  "messageText":param1,
                  "duration":param2
               });
            }
            else
            {
               this._notificationQueue.length = 0;
               this._notificationQueue.push({
                  "messageText":param1,
                  "duration":param2
               });
               this.notificationModule.hide();
            }
         }
         else
         {
            this.notificationModule.show(param1,param2);
         }
      }
      
      public function hideNotification() : void
      {
         if(this.notificationModule.isShown())
         {
            this.notificationModule.hide();
         }
      }
      
      public function clearNotificationsQueue() : void
      {
         if(this.notificationModule.isShown())
         {
            this.notificationModule.hide();
         }
         this._notificationQueue.length = 0;
      }
      
      public function showLoadIdicator() : void
      {
         this.mcIndicatorLoad.gotoAndPlay("activate");
      }
      
      public function hideLoadIdicator(param1:Boolean = false) : void
      {
         this.mcIndicatorLoad.gotoAndPlay(param1 ? "inactive" : "finish");
      }
      
      public function showSaveIdicator() : void
      {
         this.mcIndicatorSave.gotoAndPlay("activate");
      }
      
      public function hideSaveIdicator(param1:Boolean = false) : void
      {
         this.mcIndicatorSave.gotoAndPlay(param1 ? "inactive" : "finish");
      }
      
      public function setMouseCursorType(param1:int) : void
      {
         if(this.mouseCursor)
         {
            this.mouseCursor.cursorType = param1;
         }
      }
      
      public function showEP2Logo(param1:Boolean, param2:Number, param3:int, param4:int, param5:String = null) : *
      {
         if(param1)
         {
            if(this.addEP2Logo(param5,param2,param3,param4))
            {
               if(param2 > 0)
               {
                  GTweener.to(this._logoLoader,param2,{"alpha":1},{"ease":Sine.easeOut});
               }
            }
         }
         else if(param2 <= 0)
         {
            this.removeEP2Logo();
         }
         else
         {
            GTweener.to(this._logoLoader,param2,{"alpha":0},{
               "ease":Sine.easeOut,
               "onComplete":this.handleLogoHidden
            });
         }
      }
      
      protected function handleLogoHidden(param1:GTween) : *
      {
         this.removeEP2Logo();
      }
      
      private function addEP2Logo(param1:String, param2:Number, param3:int, param4:int) : Boolean
      {
         this.removeEP2Logo();
         if(!param1 || param1.length == 0)
         {
            return false;
         }
         this._logoLoader = new UILoader();
         if(param2 > 0)
         {
            this._logoLoader.alpha = 0;
         }
         this._logoLoader.x = param3;
         this._logoLoader.y = param4;
         this._logoLoader.source = param1;
         addChild(this._logoLoader);
         return true;
      }
      
      private function removeEP2Logo() : *
      {
         if(this._logoLoader)
         {
            removeChild(this._logoLoader);
            this._logoLoader = null;
         }
      }
      
      protected function handleNotificationHidden(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(this._notificationQueue.length)
         {
            _loc2_ = this._notificationQueue.shift();
            this.notificationModule.show(_loc2_.messageText,_loc2_.duration);
         }
      }
      
      protected function updateMouseEventListeners() : void
      {
         InputDelegate.getInstance().disableInputEvents(this._enableInputMgr || this._mouseShown);
      }
      
      protected function startDebugMode() : void
      {
         this.showMouseCursor(true);
         Mouse.hide();
         this.showNotification("Gamepad detected.<br/>Control sheme changed",2000);
         this.showLoadIdicator();
         this._debugTimer = new Timer(2000,1);
         this._debugTimer.addEventListener(TimerEvent.TIMER,this.handleDebugTimer,false,0,true);
         this._debugTimer.start();
         this.showSafeRect(true);
      }
      
      private function handleDebugTimer(param1:TimerEvent) : void
      {
         this._debugTimer.stop();
         this._debugTimer = null;
         this.hideLoadIdicator();
      }
   }
}
