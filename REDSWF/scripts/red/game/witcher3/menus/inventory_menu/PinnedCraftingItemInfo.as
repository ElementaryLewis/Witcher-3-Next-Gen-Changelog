package red.game.witcher3.menus.inventory_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.menus.common.ColorSprite;
   import scaleform.clik.core.UIComponent;
   
   public class PinnedCraftingItemInfo extends UIComponent
   {
       
      
      public var txtName:TextField;
      
      public var txtQuantity:TextField;
      
      public var iconLoader:W3UILoader;
      
      public var backgroundColor:ColorSprite;
      
      public var mcHighlight:MovieClip;
      
      private var iconLoaderStartY:Number = Infinity;
      
      private var iconLoaderStartX:Number = Infinity;
      
      public function PinnedCraftingItemInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         visible = false;
      }
      
      public function setItemData(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            visible = false;
            return;
         }
         visible = true;
         if(param1.quantity == -1)
         {
            this.txtQuantity.visible = false;
         }
         else
         {
            this.txtQuantity.visible = true;
            this.txtQuantity.htmlText = param1.quantity + "/" + param1.reqQuantity;
            if(param1.quantity < param1.reqQuantity)
            {
               this.txtQuantity.textColor = 16483974;
            }
            else
            {
               this.txtQuantity.textColor = 5755704;
            }
         }
         _loc2_ = String(param1.txtName);
         this.txtName.htmlText = _loc2_;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.txtName.htmlText = "<p align=\"right\">" + _loc2_ + "</p>";
         }
         this.iconLoader.source = "img://" + param1.imgLoc;
         this.iconLoader.GridSize = param1.gridSize;
         if(this.iconLoaderStartX == Number.POSITIVE_INFINITY)
         {
            this.iconLoaderStartX = this.iconLoader.x;
         }
         if(this.iconLoaderStartY == Number.POSITIVE_INFINITY)
         {
            this.iconLoaderStartY = this.iconLoader.y;
         }
         if(param1.gridSize == 1)
         {
            this.iconLoader.x = this.iconLoaderStartX;
            this.iconLoader.y = this.iconLoaderStartY;
            this.iconLoader.scaleX = this.iconLoader.scaleY = 1;
         }
         else
         {
            this.iconLoader.x = this.iconLoaderStartX + 12;
            this.iconLoader.y = this.iconLoaderStartY - 10;
            this.iconLoader.scaleX = this.iconLoader.scaleY = 0.6;
         }
         if(this.mcHighlight)
         {
            this.mcHighlight.visible = param1.highlight;
         }
         if(param1.quality)
         {
            this.backgroundColor.setByItemQuality(param1.quality);
            this.backgroundColor.visible = true;
         }
         else
         {
            this.backgroundColor.visible = false;
         }
      }
   }
}
