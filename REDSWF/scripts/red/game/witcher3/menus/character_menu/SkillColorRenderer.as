package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.SkillColor;
   import scaleform.clik.controls.ListItemRenderer;
   
   public class SkillColorRenderer extends ListItemRenderer
   {
       
      
      private const TEXT_PADDING = 10;
      
      public var mcIcon:MovieClip;
      
      public var tfLabel:TextField;
      
      public function SkillColorRenderer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         preventAutosizing = true;
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         gotoAndStop(_data.color);
         this.tfLabel.textColor = SkillColor.enumToColor(_data.color);
         this.tfLabel.text = _data.colorLocName;
         this.tfLabel.width = this.tfLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
      }
      
      override public function get width() : Number
      {
         var _loc1_:Number = 110;
         if(Boolean(this.tfLabel) && Boolean(this.mcIcon))
         {
            return _loc1_;
         }
         return super.width;
      }
   }
}
