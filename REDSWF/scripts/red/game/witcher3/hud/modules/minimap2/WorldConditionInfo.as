package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class WorldConditionInfo extends UIComponent
   {
       
      
      public var mcWeather:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var textField:TextField;
      
      private var _initialBackgroundX:Number;
      
      private var _minimalSize:Number = 0;
      
      public function WorldConditionInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.visible = false;
         this._initialBackgroundX = this.mcBackground.x;
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"hud.worldcondition.weather",[this.handleSetWeatherIcon]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"hud.worldcondition.text",[this.handleSetText]));
      }
      
      private function handleSetWeatherIcon(param1:String) : *
      {
         if(param1 != "")
         {
            this.visible = true;
            if(this.mcWeather)
            {
               this.mcWeather.mcIcons.gotoAndStop(param1);
            }
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function handleSetText(param1:String) : *
      {
         var _loc2_:Number = NaN;
         if(this.textField)
         {
            this.textField.htmlText = CommonUtils.toUpperCaseSafe(param1);
            _loc2_ = this.textField.textWidth;
            this.mcBackground.x = Math.min(this.mcBackground.width - _loc2_ - this._initialBackgroundX,Math.max(this._initialBackgroundX,this.mcBackground.width - 20 - this._minimalSize)) + 12;
         }
      }
      
      public function get minimalSize() : Number
      {
         return this._minimalSize;
      }
      
      public function set minimalSize(param1:Number) : void
      {
         this._minimalSize = param1;
      }
   }
}
