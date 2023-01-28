package red.game.witcher3.menus.common_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.TabListItem;
   import red.game.witcher3.utils.CommonUtils;
   
   public class MenuHubTabListItem extends TabListItem
   {
       
      
      public var mcHasNewIcon:MovieClip;
      
      public var txtLabel:TextField;
      
      public var isSmallTab:Boolean = false;
      
      public function MenuHubTabListItem()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcHasNewIcon)
         {
            this.mcHasNewIcon.visible = false;
         }
         doubleClickEnabled = false;
      }
      
      public function set hasNewIcon(param1:Boolean) : void
      {
         if(Boolean(this.mcHasNewIcon) && enabled)
         {
            this.mcHasNewIcon.visible = param1;
         }
      }
      
      public function setLabel(param1:String) : void
      {
         if(this.txtLabel)
         {
            this.updateLabelPosition();
            this.txtLabel.htmlText = CommonUtils.toUpperCaseSafe(param1);
            this.txtLabel.height = this.txtLabel.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         }
      }
      
      public function updateLabelPosition() : void
      {
         if(this.isSmallTab)
         {
            if(this.txtLabel.numLines > 1)
            {
               this.txtLabel.y = 4;
            }
            else
            {
               this.txtLabel.y = 11.55;
            }
         }
      }
      
      override public function get selectable() : Boolean
      {
         return enabled;
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
         if(Boolean(this.txtLabel) && Boolean(data))
         {
            this.txtLabel.htmlText = CommonUtils.toUpperCaseSafe(data.label);
            this.txtLabel.height = this.txtLabel.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.updateLabelPosition();
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(Boolean(this.txtLabel) && Boolean(param1))
         {
            this.txtLabel.htmlText = CommonUtils.toUpperCaseSafe(param1.label);
            this.txtLabel.height = this.txtLabel.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         }
      }
   }
}
