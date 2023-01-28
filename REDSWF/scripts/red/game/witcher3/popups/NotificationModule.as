package red.game.witcher3.popups
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class NotificationModule extends UIComponent
   {
      
      private static const TEXT_WIDTH_MAX:Number = 400;
      
      private static const TEXT_WIDTH_MIN:Number = 200;
      
      private static const TEXT_WIDTH_PADDING:Number = 40;
      
      private static const TEXT_HEIGHT_PADDING:Number = 20;
      
      private static const DEF_DURATION:Number = 4000;
      
      private static const ANIMATION_DURATION:Number = 0.3;
       
      
      public var tfMessage:TextField;
      
      public var mcBackground:Sprite;
      
      protected var _timer:Timer;
      
      protected var _message:String;
      
      protected var _duration:Number;
      
      protected var _shown:Boolean;
      
      public function NotificationModule()
      {
         super();
         this._shown = false;
         visible = false;
      }
      
      public function show(param1:String, param2:Number = 0) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this._message = param1;
         this._duration = param2;
         if(this._message)
         {
            _loc3_ = CommonUtils.getScreenRect();
            _loc4_ = _loc3_.width * 0.05;
            _loc5_ = _loc3_.height * 0.95;
            this.populateData();
            y = _loc5_ - (this.mcBackground.y + this.mcBackground.height);
            if(!this._shown)
            {
               visible = true;
               x = 0;
               alpha = 0;
               GTweener.removeTweens(this);
               GTweener.to(this,ANIMATION_DURATION,{
                  "x":_loc4_,
                  "alpha":1
               },{
                  "ease":Exponential.easeOut,
                  "onComplete":this.handleShown
               });
            }
            this._shown = true;
            this.initTimer();
         }
         else
         {
            dispatchEvent(new Event(Event.DEACTIVATE));
         }
      }
      
      public function hide() : void
      {
         this.playHideTween();
      }
      
      public function isShown() : Boolean
      {
         return this._shown;
      }
      
      protected function playHideTween() : void
      {
         if(this._shown)
         {
            GTweener.removeTweens(this);
            GTweener.to(this,ANIMATION_DURATION,{
               "x":0,
               "alpha":0
            },{
               "ease":Exponential.easeOut,
               "onComplete":this.handleHidden
            });
         }
      }
      
      protected function initTimer() : void
      {
         this._duration = !!this._duration ? this._duration : DEF_DURATION;
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimer,false);
            this._timer.stop();
            this._timer = null;
         }
         this._timer = new Timer(this._duration);
         this._timer.addEventListener(TimerEvent.TIMER,this.handleTimer,false,0,true);
         this._timer.start();
      }
      
      protected function populateData() : void
      {
         this.tfMessage.width = TEXT_WIDTH_MAX;
         this.tfMessage.htmlText = this._message;
         var _loc1_:Number = Math.max(Math.min(this.tfMessage.textWidth,TEXT_WIDTH_MAX),TEXT_WIDTH_MIN);
         this.tfMessage.width = _loc1_ + CommonConstants.SAFE_TEXT_PADDING;
         this.tfMessage.height = this.tfMessage.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.mcBackground.height = this.tfMessage.height + TEXT_HEIGHT_PADDING;
         this.mcBackground.width = this.tfMessage.width + TEXT_WIDTH_PADDING;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfMessage.htmlText = "<p align=\"right\">" + this._message + "</p>";
         }
      }
      
      protected function handleTimer(param1:TimerEvent) : void
      {
         this.playHideTween();
      }
      
      protected function handleHidden(param1:GTween) : void
      {
         this._shown = false;
         visible = false;
         dispatchEvent(new Event(Event.DEACTIVATE));
      }
      
      protected function handleShown(param1:GTween) : void
      {
      }
   }
}
