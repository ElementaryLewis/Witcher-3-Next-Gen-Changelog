package red.game.witcher3.menus.common_menu
{
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import red.game.witcher3.data.PlayerStatsData;
   import scaleform.clik.core.UIComponent;
   
   public class MenuPlayerStats extends UIComponent
   {
       
      
      public var mcLevelStat:MenuLevelIndicator;
      
      public var tfMoney:TextField;
      
      public var tfWeight:TextField;
      
      protected var _data:PlayerStatsData;
      
      protected var _weightTextGlowRed:GlowFilter;
      
      protected var _weightTextGlowWhite:GlowFilter;
      
      public function MenuPlayerStats()
      {
         super();
      }
      
      public function setLevel(param1:Number, param2:Number, param3:Number) : void
      {
         this.mcLevelStat.setLevel(String(param1));
         this.mcLevelStat.setLevelProgress(param2,param3);
      }
      
      public function setWeight(param1:Number, param2:Number) : void
      {
         this.tfWeight.htmlText = param1 + " / " + param2;
         if(param1 > param2)
         {
            this.tfWeight.textColor = 16720418;
            if(!this._weightTextGlowRed)
            {
               this._weightTextGlowRed = new GlowFilter(11993088,1,16,16,1.5,BitmapFilterQuality.HIGH);
            }
            this.tfWeight.filters = [this._weightTextGlowRed];
         }
         else
         {
            this.tfWeight.textColor = 16777215;
            if(!this._weightTextGlowWhite)
            {
               this._weightTextGlowWhite = new GlowFilter(16777215,1,16,16,1.5,BitmapFilterQuality.HIGH);
            }
            this.tfWeight.filters = [this._weightTextGlowWhite];
         }
      }
      
      public function setMoney(param1:Number) : void
      {
         this.tfMoney.text = String(param1);
      }
   }
}
