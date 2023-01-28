package red.game.witcher3.menus.journal
{
   import flash.display.MovieClip;
   import red.core.CoreComponent;
   import red.game.witcher3.menus.common.FeedbackDropdownMenuListItem;
   
   public class QuestDropdownMenuListItem extends FeedbackDropdownMenuListItem
   {
       
      
      public var headerColor:MovieClip;
      
      public function QuestDropdownMenuListItem()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         bLabelSortingEnabled = false;
         super.configUI();
      }
      
      override public function HasInitialSelection() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < dropDownData.length)
         {
            if(dropDownData[_loc1_].selected)
            {
               selectedIndex = _loc1_;
               dropDownData[_loc1_].isNew = false;
               dropDownData[_loc1_].selected = false;
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      override public function setDropdownData(param1:Object) : void
      {
         var _loc2_:Array = param1 as Array;
         if(Boolean(_loc2_) && Boolean(_loc2_.length))
         {
            this.setColorCoding(_loc2_[0]);
         }
         super.setDropdownData(param1);
      }
      
      override public function updateDropdownDataSurgically(param1:Array) : void
      {
         if(Boolean(param1) && Boolean(param1.length))
         {
            this.setColorCoding(param1[0]);
         }
         super.updateDropdownDataSurgically(param1);
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         var _loc2_:Array = param1 as Array;
         if(this.headerColor && _loc2_ && Boolean(_loc2_.length))
         {
            this.setColorCoding(_loc2_[0]);
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(CoreComponent.isArabicAligmentMode)
         {
            if(mcCollapseBtnIcon)
            {
               mcCollapseBtnIcon.x = textField.x + textField.width - textField.textWidth - mcCollapseBtnIcon.width;
            }
         }
      }
      
      protected function setColorCoding(param1:Object) : void
      {
         if(param1.status == 2 || param1.status == 3)
         {
            this.headerColor.gotoAndStop(1);
            return;
         }
         switch(param1.isStory)
         {
            case 0:
               this.headerColor.gotoAndStop("main");
               break;
            case 1:
               this.headerColor.gotoAndStop("main");
               break;
            case 2:
               this.headerColor.gotoAndStop("secondary");
               break;
            case 3:
               this.headerColor.gotoAndStop("contract");
               break;
            case 4:
               this.headerColor.gotoAndStop("treasurehunt");
               break;
            default:
               this.headerColor.gotoAndStop(1);
         }
      }
      
      override public function toString() : String
      {
         return "[W3 QuestDropdownMenuListItem]";
      }
   }
}
