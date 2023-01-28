package red.game.witcher3.menus.mainmenu
{
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3Slider;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.SliderEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GammaSettingModule extends StaticOptionModule
   {
       
      
      public var txtTitle:TextField;
      
      public var mcSlider:W3Slider;
      
      private var _data:Object;
      
      public function GammaSettingModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
      }
      
      public function showWithData(param1:Object) : void
      {
         super.show();
         this._data = param1;
         if(param1.subElements.length >= 3)
         {
            this.mcSlider.snapInterval = Number((param1.subElements[1] - param1.subElements[0]) / param1.subElements[2]);
         }
         else
         {
            this.mcSlider.snapInterval = 1;
         }
         if(param1.subElements.length >= 2)
         {
            this.mcSlider.maximum = Number(param1.subElements[1]);
         }
         else
         {
            this.mcSlider.maximum = 1;
         }
         if(param1.subElements.length >= 1)
         {
            this.mcSlider.minimum = Number(param1.subElements[0]);
         }
         else
         {
            this.mcSlider.minimum = 0;
         }
         this.mcSlider.offsetLeft = 35;
         this.mcSlider.offsetRight = 35;
         this.mcSlider.snapping = true;
         this.mcSlider.value = Number(param1.current);
         this.mcSlider.addEventListener(SliderEvent.VALUE_CHANGE,this.OnSliderValueChanged,false);
      }
      
      override public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         if(visible)
         {
            _loc2_ = param1.details;
            CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
            if(this.mcSlider)
            {
               this.mcSlider.handleInput(param1);
            }
         }
         super.handleInputNavigate(param1);
      }
      
      internal function OnSliderValueChanged(param1:SliderEvent) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = this.mcSlider.value;
         this._data.current = _loc2_.toString();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnOptionValueChanged",[this._data.groupID,this._data.tag,this._data.current]));
      }
   }
}
