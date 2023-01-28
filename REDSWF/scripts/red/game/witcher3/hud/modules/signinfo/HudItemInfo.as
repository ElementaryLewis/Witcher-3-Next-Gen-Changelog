package red.game.witcher3.hud.modules.signinfo
{
   import flash.display.MovieClip;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   
   public class HudItemInfo extends UIComponent
   {
       
      
      public var mcIconLoader:UILoader;
      
      public var mcBckArrow:MovieClip;
      
      public var mcError:MovieClip;
      
      private var _IconName:String;
      
      public function HudItemInfo()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcBckArrow)
         {
            this.mcBckArrow.visible = false;
         }
      }
      
      override public function toString() : String
      {
         return this.name;
      }
      
      private function updateIcon() : void
      {
         if(this._IconName && this._IconName != "" && this._IconName != "icons/items/None_64x64.dds")
         {
            this.mcIconLoader.source = "img://" + this._IconName;
            this.visible = true;
         }
         else
         {
            this.mcIconLoader.source = "";
            this.visible = false;
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
      
      public function set IconDimmed(param1:Boolean) : void
      {
         if(param1)
         {
            this.mcIconLoader.alpha = 0.5;
         }
         else
         {
            this.mcIconLoader.alpha = 1;
         }
      }
   }
}
