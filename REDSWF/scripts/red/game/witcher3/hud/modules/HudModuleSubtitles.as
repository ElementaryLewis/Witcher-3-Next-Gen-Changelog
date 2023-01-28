package red.game.witcher3.hud.modules
{
   import fl.transitions.easing.Strong;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.motion.TweenEx;
   
   public class HudModuleSubtitles extends HudModuleBase
   {
      
      private static const BLOCK_PADDING:Number = 160;
       
      
      public var tfSubtitles:TextField;
      
      private var _currentId:int = 0;
      
      private var _defaultWidth;
      
      private var _defaultX;
      
      public function HudModuleSubtitles()
      {
         addFrameScript(0,this.frame1);
         super();
         this.tfSubtitles.htmlText = "";
         this.tfSubtitles.autoSize = TextFieldAutoSize.CENTER;
         this.tfSubtitles.multiline = true;
         this.tfSubtitles.wordWrap = true;
         this._defaultWidth = this.tfSubtitles.width;
         this._defaultX = this.tfSubtitles.x;
      }
      
      override public function get moduleName() : String
      {
         return "SubtitlesModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         alpha = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function addSubtitle(param1:int, param2:String, param3:String) : *
      {
         this.tfSubtitles.htmlText = "<b><font color=\'#FFFFFF\'>" + param2 + "</font>" + param3;
         this.tfSubtitles.height = this.tfSubtitles.textHeight + CommonConstants.SAFE_TEXT_PADDING + 12;
         var _loc4_:Number = 1080 * 0.95;
         this.tfSubtitles.y = _loc4_ - this.tfSubtitles.height - BLOCK_PADDING;
         this._currentId = param1;
         ShowElement(true);
      }
      
      public function removeSubtitle(param1:int) : void
      {
         if(param1 == this._currentId)
         {
            this.tfSubtitles.htmlText = "";
            this._currentId = 0;
         }
         ShowElement(false);
      }
      
      public function updateWidth(param1:Number) : void
      {
         param1 = 1 - (1 - param1) * 2;
         this.tfSubtitles.width = this._defaultWidth * param1;
         this.tfSubtitles.x = this._defaultX + (this._defaultWidth - this.tfSubtitles.width) * 0.5;
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
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
