package red.game.witcher3.menus.common_menu
{
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.ListItemRenderer;
   
   public class MenuTab extends ListItemRenderer
   {
      
      protected static const DISABLED_ALPHA:Number = 0.5;
       
      
      public var iconHolder:MovieClip;
      
      protected var _targetMenuIdx:uint;
      
      protected var _subMenuRef:String;
      
      protected var _iconName:String;
      
      public function MenuTab()
      {
         super();
         constraintsDisabled = true;
      }
      
      public function get iconName() : String
      {
         return this._iconName;
      }
      
      public function set iconName(param1:String) : *
      {
         this._iconName = param1;
         this.updateIconFrame();
      }
      
      protected function updateIconFrame() : void
      {
         var warningMsg:String = null;
         if(Boolean(this.iconHolder) && Boolean(this._iconName))
         {
            try
            {
               this.iconHolder.gotoAndStop(this._iconName);
            }
            catch(er:Error)
            {
               warningMsg = "** WARNING ** Icon for menu tab " + _iconName + " is not defined, see MenuCommon.fla [iconHolder]";
            }
         }
      }
      
      protected function updateIconState(param1:Boolean) : void
      {
         var _loc2_:ColorMatrixFilter = null;
         if(!param1)
         {
            _loc2_ = CommonUtils.getDesaturateFilter();
            this.iconHolder.filters = [_loc2_];
            this.iconHolder.alpha = DISABLED_ALPHA;
         }
         else
         {
            this.iconHolder.filters = [];
            this.iconHolder.alpha = 1;
         }
      }
      
      override public function set label(param1:String) : void
      {
         super.label = CommonUtils.toUpperCaseSafe(param1);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.updateIconState(param1);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         preventAutosizing = true;
         constraintsDisabled = true;
         focusable = false;
         displayFocus = true;
      }
      
      override protected function changeFocus() : void
      {
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
         this.updateIconFrame();
         this.updateIconState(enabled);
      }
   }
}
