package red.game.witcher3.menus.overlay
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.hud.modules.wolfHead.W3StatIndicator;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.motion.Tween;
   
   public class QuantityMonsterBarganingPopup extends QuantityPopup
   {
       
      
      public var tfBaseValue:TextField;
      
      public var tfBaseValueDescription:TextField;
      
      public var tfPlus:TextField;
      
      public var tfBonusValue:TextField;
      
      public var tfBonusValueDescription:TextField;
      
      public var tfEqual:TextField;
      
      public var tfFinalValue:TextField;
      
      public var tfFinalValueDescription:TextField;
      
      public var tfAngerBarLabel:TextField;
      
      public var mcAngerBar:W3StatIndicator;
      
      public var mcMask:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var mcRewordIcon1:MovieClip;
      
      public var mcRewordIcon2:MovieClip;
      
      public var mcRewordIcon3:MovieClip;
      
      private var mcAngerBarTween:Tween;
      
      private var _baseValue:int;
      
      public function QuantityMonsterBarganingPopup()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.tfBaseValueDescription.htmlText = "[[panel_hud_dialogue_bar_base]]";
         this.tfBonusValueDescription.htmlText = "[[panel_hud_dialogue_bar_bonus]]";
         this.tfFinalValueDescription.htmlText = "[[panel_hud_dialogue_bar_final]]";
         this.tfAngerBarLabel.htmlText = "[[panel_hud_dialogue_bar_label_anger]]";
         this.tfPlus.htmlText = "+";
         this.tfEqual.htmlText = "=";
      }
      
      override protected function alignControls() : void
      {
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         if(_data)
         {
            this._baseValue = _data.baseValue as int;
            this.tfBaseValue.htmlText = this._baseValue.toString();
            this.tfBonusValue.htmlText = (_data.currentValue - this._baseValue).toString();
            this.tfFinalValue.htmlText = _data.currentValue.toString();
            this.setBarValue(_data.anger);
            mcInpuFeedback.handleSetupButtons(_data.ButtonsList);
            if(!_data.ShowPrice)
            {
               this.tfAngerBarLabel.y = 258;
               this.mcAngerBar.y = 299;
            }
            else
            {
               this.tfAngerBarLabel.y = 294;
               this.mcAngerBar.y = 333;
            }
            if(_data.alternativeRewardType)
            {
               this.mcRewordIcon1.gotoAndStop("potatoes");
               this.mcRewordIcon2.gotoAndStop("potatoes");
               this.mcRewordIcon3.gotoAndStop("potatoes");
               mcPriceIcon.gotoAndStop("potatoes");
            }
         }
      }
      
      override protected function handlSliderChanged(param1:SliderEvent) : void
      {
         super.handlSliderChanged(param1);
         this.tfBonusValue.htmlText = (_currentQuantity - this._baseValue).toString();
         this.tfFinalValue.htmlText = _currentQuantity.toString();
      }
      
      public function setBarValue(param1:Number) : void
      {
         this.mcAngerBar.value = param1;
         if(this.mcAngerBarTween)
         {
            this.mcAngerBarTween.paused = true;
         }
         this.mcAngerBarTween = new Tween(500,this.mcAngerBar,{"value":param1},{"paused":false});
      }
   }
}
