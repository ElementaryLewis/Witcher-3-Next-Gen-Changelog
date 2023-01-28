package red.game.witcher3.menus.overlay
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import red.core.constants.KeyCode;
   import red.game.witcher3.menus.common_menu.ModuleInputFeedback;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   
   public class BasePopup extends UIComponent
   {
       
      
      public var mcInpuFeedback:ModuleInputFeedback;
      
      protected var _data:Object;
      
      protected var _fixedPosition:Boolean;
      
      public function BasePopup()
      {
         super();
         this.mcInpuFeedback.addHotkey(KeyCode.ENTER,KeyCode.SPACE);
         this.mcInpuFeedback.addHotkey(KeyCode.ENTER,KeyCode.NUMPAD_ENTER);
         this.mcInpuFeedback.addHotkey(KeyCode.ENTER,KeyCode.E);
         this.mcInpuFeedback.addHotkey(KeyCode.E,KeyCode.ENTER);
         this.mcInpuFeedback.addHotkey(KeyCode.E,KeyCode.NUMPAD_ENTER);
         this.mcInpuFeedback.addHotkey(KeyCode.E,KeyCode.SPACE);
         this.mcInpuFeedback.buttonAlign = "center";
         this.mcInpuFeedback.coloringButtons = true;
         visible = false;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.populateData();
      }
      
      public function get fixedPosition() : Boolean
      {
         return this._fixedPosition;
      }
      
      public function set fixedPosition(param1:Boolean) : void
      {
         this._fixedPosition = param1;
      }
      
      protected function populateData() : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:MovieClip = null;
         visible = true;
         if(this._fixedPosition)
         {
            return;
         }
         if(this._data.ScreenPosX > 0 || this._data.ScreenPosY > 0)
         {
            _loc3_ = CommonUtils.getScreenRect();
            _loc4_ = _loc3_.x + _loc3_.width * this._data.ScreenPosX;
            _loc5_ = _loc3_.y + _loc3_.height * this._data.ScreenPosY;
            x = _loc4_;
            y = _loc5_;
         }
         else
         {
            _loc6_ = CommonUtils.getScreenRect();
            if(_loc7_ = getChildByName("mcBackground") as MovieClip)
            {
               x = _loc6_.x + _loc6_.width / 2 - _loc7_.width / 2;
            }
            else
            {
               x = _loc6_.x + _loc6_.width / 2 - actualWidth / 2;
            }
            y = _loc6_.y + _loc6_.height / 2 - actualHeight / 2;
         }
         var _loc1_:* = 8;
         var _loc2_:* = y;
         alpha = 0;
         y -= _loc1_;
         GTweener.to(this,0.5,{
            "alpha":1,
            "y":_loc2_
         },{"ease":Exponential.easeOut});
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
      }
   }
}
