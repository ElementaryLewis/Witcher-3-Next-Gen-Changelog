package red.game.witcher3.hud.modules.buffs
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.hud.LightweightUILoader;
   import scaleform.clik.controls.ListItemRenderer;
   
   public class HudBuff extends ListItemRenderer
   {
      
      protected static const STACK_PADDING:Number = 4;
       
      
      public var mcBuffDuration:HudBuffDurationBar;
      
      public var tfTimer:TextField;
      
      public var tfTitle:TextField;
      
      public var mcBuffUpdate:MovieClip;
      
      public var negativeBackground:MovieClip;
      
      public var positiveBackground:MovieClip;
      
      public var mcPermaBuffCircle:MovieClip;
      
      public var mcBuffStackIndicator:MovieClip;
      
      private var minimalView:Boolean;
      
      private var _iconLoader:LightweightUILoader;
      
      private var _IconName:String = "";
      
      private var _percent:Number = NaN;
      
      private var _lowerBuffPosition:Point;
      
      private var _format:int;
      
      private var expireTween:GTween;
      
      public function HudBuff()
      {
         super();
      }
      
      public function setMinimalView(param1:Boolean) : *
      {
         this.minimalView = param1;
         this.tfTimer.visible = !this.minimalView;
         this.tfTitle.visible = !this.minimalView;
      }
      
      public function reset() : void
      {
         this.mcBuffDuration.reset();
      }
      
      public function getFormat() : int
      {
         return this._format;
      }
      
      public function getLowerBuffPosition() : Point
      {
         return this._lowerBuffPosition;
      }
      
      public function updatePercent(param1:Number) : void
      {
         if(param1 != this.mcBuffDuration.percent)
         {
            this.mcBuffDuration.percent = param1;
            this.mcBuffDuration.validateNow();
         }
      }
      
      public function updateCounter(param1:Number, param2:Number) : *
      {
         if(this.mcBuffStackIndicator)
         {
            if(this.mcBuffStackIndicator.visible == false)
            {
               this.mcBuffStackIndicator.visible = true;
               this.tfTimer.text = "";
            }
            this.mcBuffStackIndicator.tfBuffStack.text = param1 + (this._format == 2 ? "%" : "");
            this.mcBuffStackIndicator.mcStackBackground.x = this.mcBuffStackIndicator.tfBuffStack.x + this.mcBuffStackIndicator.tfBuffStack.width - this.mcBuffStackIndicator.tfBuffStack.textWidth / 2 - STACK_PADDING / 2;
            this.mcBuffStackIndicator.mcStackBackground.width = this.mcBuffStackIndicator.tfBuffStack.textWidth + STACK_PADDING;
         }
      }
      
      public function updateTimer(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!data)
         {
            return;
         }
         if(param1 <= 5 && !this.expireTween)
         {
            this.displayExpireFeedback();
         }
         else if(param1 > 5 && Boolean(this.expireTween))
         {
            this.expireTween = null;
            alpha = 1;
            GTweener.removeTweens(this);
         }
         if(!(this._format == 1 || this._format == 2) && this.mcBuffStackIndicator.visible)
         {
            this.mcBuffStackIndicator.visible = false;
         }
         if(this.minimalView)
         {
            return;
         }
         if(data.initialDuration < 1)
         {
            this.tfTimer.text = "";
            return;
         }
         if(param2 < param1)
         {
            this.tfTimer.text = "";
            return;
         }
         _loc4_ = int(param1 / 60);
         _loc5_ = param1 % 60;
         this.tfTimer.text = "" + this.formatLeadingZero(_loc4_) + ":" + this.formatLeadingZero(_loc5_);
         this.tfTimer.y = this.tfTitle.y + this.tfTitle.textHeight + 5;
      }
      
      public function updateTimerAndCounter(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!data)
         {
            return;
         }
         if(param1 <= 5 && !this.expireTween)
         {
            this.displayExpireFeedback();
         }
         else if(param1 > 5 && Boolean(this.expireTween))
         {
            this.expireTween = null;
            alpha = 1;
            GTweener.removeTweens(this);
         }
         if(this.mcBuffStackIndicator)
         {
            if(this.mcBuffStackIndicator.visible == false)
            {
               this.mcBuffStackIndicator.visible = true;
               this.tfTimer.text = "";
            }
            this.mcBuffStackIndicator.tfBuffStack.text = param3 + (this._format == 2 || this._format == 4 ? "%" : "");
            this.mcBuffStackIndicator.mcStackBackground.x = this.mcBuffStackIndicator.tfBuffStack.x + this.mcBuffStackIndicator.tfBuffStack.width - this.mcBuffStackIndicator.tfBuffStack.textWidth / 2 - STACK_PADDING / 2;
            this.mcBuffStackIndicator.mcStackBackground.width = this.mcBuffStackIndicator.tfBuffStack.textWidth + STACK_PADDING;
         }
         if(this.minimalView)
         {
            return;
         }
         if(data.initialDuration < 1)
         {
            this.tfTimer.text = "";
            return;
         }
         if(param2 < param1)
         {
            this.tfTimer.text = "";
            return;
         }
         _loc5_ = int(param1 / 60);
         _loc6_ = param1 % 60;
         this.tfTimer.text = "" + this.formatLeadingZero(_loc5_) + ":" + this.formatLeadingZero(_loc6_);
         this.tfTimer.y = this.tfTitle.y + this.tfTitle.textHeight + 5;
      }
      
      public function updateEmpty() : *
      {
         if(this.mcBuffStackIndicator)
         {
            if(this.mcBuffStackIndicator.visible)
            {
               this.mcBuffStackIndicator.visible = false;
            }
            this.tfTimer.text = "";
            this.mcBuffStackIndicator.tfBuffStack.text = "";
         }
      }
      
      public function displayExpireFeedback() : *
      {
         this.expireTween = GTweener.to(this,0.5,{"alpha":0.4},{
            "repeatCount":0,
            "reflect":true
         });
      }
      
      private function formatLeadingZero(param1:int) : String
      {
         return param1 < 10 ? "0" + param1.toString() : param1.toString();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
         this.mcBuffStackIndicator.visible = false;
         this.negativeBackground.visible = false;
         this.positiveBackground.visible = false;
         this.setMinimalView(true);
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         this._format = param1.format;
         if(!(this._format == 1 || this._format == 2) && this.mcBuffStackIndicator.visible)
         {
            this.mcBuffStackIndicator.visible = false;
         }
         if(param1.isVisible == true)
         {
            this.visible = true;
            this.expireTween = null;
            alpha = 1;
            GTweener.removeTweens(this);
            if(param1.iconName != "")
            {
               this._IconName = param1.iconName;
            }
            else
            {
               this._IconName = "";
            }
            if(param1.title)
            {
               this.tfTitle.htmlText = param1.title;
               this.tfTimer.y = this.tfTitle.y + this.tfTitle.textHeight + 5;
               this._lowerBuffPosition = localToGlobal(new Point(0,this.tfTimer.y + this.tfTimer.textHeight + 30));
            }
            if(Boolean(param1.duration) && Boolean(param1.initialDuration))
            {
               if(param1.duration != -1)
               {
                  this._percent = param1.duration / param1.initialDuration;
               }
               else
               {
                  this._percent = 0;
               }
            }
            this.mcBuffDuration.setPositive(param1.isPositive);
            this.setBuffBackground(param1.isPositive);
            this.update();
         }
         else
         {
            this.expireTween = null;
            GTweener.removeTweens(this);
            this.mcBuffStackIndicator.visible = false;
            this.visible = false;
         }
      }
      
      public function update() : *
      {
         this.updateIcon();
         this.updatePercent(this._percent);
      }
      
      private function setBuffBackground(param1:int) : void
      {
         if(param1 == 0)
         {
            this.positiveBackground.visible = false;
            this.negativeBackground.visible = true;
         }
         else
         {
            this.positiveBackground.visible = true;
            this.negativeBackground.visible = false;
         }
      }
      
      private function updateIcon() : void
      {
         var _loc1_:* = undefined;
         if(this._iconLoader && this._iconLoader.source && this._iconLoader.source.length && this._iconLoader.source == this._IconName)
         {
            return;
         }
         if(Boolean(this._IconName) && this._IconName != "")
         {
            if(this._iconLoader)
            {
               this._iconLoader.unload();
               removeChild(this._iconLoader);
            }
            _loc1_ = getDefinitionByName("IconLoaderRef");
            this._iconLoader = new _loc1_();
            this._iconLoader.source = "img://" + this._IconName;
            this._iconLoader.x = -19;
            this._iconLoader.y = -19;
            addChild(this._iconLoader);
            addChild(this.mcBuffStackIndicator);
         }
      }
      
      public function set IconName(param1:String) : void
      {
         if(this._IconName != param1)
         {
            this._IconName = param1;
            this.updateIcon();
         }
      }
   }
}
