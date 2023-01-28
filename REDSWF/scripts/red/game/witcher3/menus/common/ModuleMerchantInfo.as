package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class ModuleMerchantInfo extends UIComponent
   {
      
      private static const ICON_PADDING:Number = 2;
      
      private static const TITLE_PADDING:Number = 10;
       
      
      public var txtType:TextField;
      
      public var txtLevelValue:TextField;
      
      public var txtMoney:TextField;
      
      public var mcCoinIcon:MovieClip;
      
      public var bkImage:MovieClip;
      
      public var txtTypeInitY:Number;
      
      protected var _data:Object;
      
      public function ModuleMerchantInfo()
      {
         super();
         this.cleanup();
         this.txtTypeInitY = this.txtType.y;
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
      
      public function setMerchantTypeCheck(param1:Boolean, param2:Boolean) : void
      {
      }
      
      private function populateData() : void
      {
         var _loc1_:String = null;
         this.cleanup();
         this.visible = true;
         if(this._data.type)
         {
            _loc1_ = String(this._data.typeName);
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtType.htmlText = "<p align=\"right\">" + _loc1_ + "</p>";
            }
            else
            {
               this.txtType.htmlText = _loc1_;
               CommonUtils.toSmallCaps(this.txtType);
            }
         }
         if(this._data.level)
         {
            _loc1_ = String(this._data.level);
            this.txtLevelValue.htmlText = _loc1_;
            this.txtLevelValue.htmlText = CommonUtils.toUpperCaseSafe(_loc1_);
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtLevelValue.htmlText = "<p align=\"right\">" + _loc1_ + "</p>";
            }
         }
         if(this.txtLevelValue.text == "")
         {
            this.txtType.y = -5.6;
         }
         else
         {
            this.txtType.y = this.txtTypeInitY;
         }
         var _loc2_:Number = Number(this._data.money);
         if(!isNaN(_loc2_) && _loc2_ >= 0)
         {
            this.txtMoney.text = _loc2_.toString();
            this.mcCoinIcon.visible = true;
         }
         if(Boolean(this.bkImage) && Boolean(this._data.type))
         {
            this.bkImage.gotoAndStop(this._data.type);
         }
      }
      
      private function cleanup() : void
      {
         this.visible = false;
         this.txtType.text = "";
         this.txtLevelValue.text = "";
         this.txtMoney.text = "";
         this.mcCoinIcon.visible = false;
      }
   }
}
