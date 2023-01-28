package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import scaleform.clik.core.UIComponent;
   
   public class W3ListSelectionTracker extends UIComponent
   {
      
      protected static const ITEM_SIZE:Number = 6;
      
      protected static const ITEM_PADDING:Number = 2.5;
       
      
      public var mcSelectionTracker1:MovieClip;
      
      public var mcSelectionTracker2:MovieClip;
      
      public var mcSelectionTracker3:MovieClip;
      
      public var mcSelectionTracker4:MovieClip;
      
      public var mcSelectionTracker5:MovieClip;
      
      public var mcSelectionTracker6:MovieClip;
      
      public var mcSelectionTracker7:MovieClip;
      
      public var mcSelectionTracker8:MovieClip;
      
      public var mcSelectionTracker9:MovieClip;
      
      public var mcSelectionTracker10:MovieClip;
      
      public var mcSelectionTracker11:MovieClip;
      
      public var mcSelectionTracker12:MovieClip;
      
      public var mcSelectionTracker13:MovieClip;
      
      public var mcSelectionTracker14:MovieClip;
      
      public var mcSelectionTracker15:MovieClip;
      
      public var mcSelectionTracker16:MovieClip;
      
      public var mcSelectionTracker17:MovieClip;
      
      public var mcSelectionTracker18:MovieClip;
      
      public var mcSelectionTracker19:MovieClip;
      
      public var mcSelectionTracker20:MovieClip;
      
      protected var _indicatorsList:Vector.<MovieClip>;
      
      protected var _visibleWidth:Number;
      
      protected var _selectedIndex:int = -1;
      
      public function W3ListSelectionTracker()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setupIndicatorsList();
      }
      
      protected function setupIndicatorsList() : void
      {
         this._indicatorsList = new Vector.<MovieClip>();
         this._indicatorsList.push(this.mcSelectionTracker1);
         this._indicatorsList.push(this.mcSelectionTracker2);
         this._indicatorsList.push(this.mcSelectionTracker3);
         this._indicatorsList.push(this.mcSelectionTracker4);
         this._indicatorsList.push(this.mcSelectionTracker5);
         this._indicatorsList.push(this.mcSelectionTracker6);
         this._indicatorsList.push(this.mcSelectionTracker7);
         this._indicatorsList.push(this.mcSelectionTracker8);
         this._indicatorsList.push(this.mcSelectionTracker9);
         this._indicatorsList.push(this.mcSelectionTracker10);
         this._indicatorsList.push(this.mcSelectionTracker11);
         this._indicatorsList.push(this.mcSelectionTracker12);
         this._indicatorsList.push(this.mcSelectionTracker13);
         this._indicatorsList.push(this.mcSelectionTracker14);
         this._indicatorsList.push(this.mcSelectionTracker15);
         this._indicatorsList.push(this.mcSelectionTracker16);
         this._indicatorsList.push(this.mcSelectionTracker17);
         this._indicatorsList.push(this.mcSelectionTracker18);
         this._indicatorsList.push(this.mcSelectionTracker19);
         this._indicatorsList.push(this.mcSelectionTracker20);
      }
      
      public function set numElements(param1:int) : void
      {
         var _loc2_:int = 0;
         this._visibleWidth = ITEM_SIZE * param1 + ITEM_PADDING * (param1 - 1);
         _loc2_ = 0;
         while(_loc2_ < this._indicatorsList.length)
         {
            if(_loc2_ < param1)
            {
               if(_loc2_ == this._selectedIndex)
               {
                  this._indicatorsList[_loc2_].gotoAndStop("Active");
               }
               else
               {
                  this._indicatorsList[_loc2_].gotoAndStop("Inactive");
               }
            }
            else
            {
               this._indicatorsList[_loc2_].gotoAndStop("Hidden");
            }
            _loc2_++;
         }
      }
      
      public function getVisibleWidth() : Number
      {
         return this._visibleWidth;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 != this._selectedIndex)
         {
            if(this._selectedIndex != -1)
            {
               this._indicatorsList[this._selectedIndex].gotoAndStop("Inactive");
            }
            this._selectedIndex = param1;
            if(this._selectedIndex != -1)
            {
               this._indicatorsList[this._selectedIndex].gotoAndStop("Active");
            }
         }
      }
   }
}
