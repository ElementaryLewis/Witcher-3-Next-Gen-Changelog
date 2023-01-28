package red.game.witcher3.slots
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.menus.character_menu.SkillsGroupTitle;
   
   public class SlotsListCategorized extends SlotsListBase
   {
      
      protected static const ITEM_PADDING:Number = 4;
      
      protected static const GROUP_TITLE_PADDING:Number = 10;
      
      protected static const GROUP_TITLE_REF:String = "SkillGroupTitleRef";
       
      
      protected var _rendererWidth:Number;
      
      protected var _rendererHeight:Number;
      
      protected var _columnsCount:int;
      
      protected var _dataCount:int;
      
      protected var _disableGroupTitle:Boolean = true;
      
      protected var _itemPadding:Number = 4;
      
      public function SlotsListCategorized()
      {
         super();
      }
      
      public function get disableGroupTitle() : Boolean
      {
         return this._disableGroupTitle;
      }
      
      public function set disableGroupTitle(param1:Boolean) : void
      {
         this._disableGroupTitle = param1;
      }
      
      public function get itemPadding() : Number
      {
         return this._itemPadding;
      }
      
      public function set itemPadding(param1:Number) : void
      {
         this._itemPadding = param1;
      }
      
      override public function get numColumns() : uint
      {
         return this._columnsCount;
      }
      
      override public function get rendererHeight() : Number
      {
         return this._rendererHeight;
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         var _loc1_:Array = _data;
         _loc1_.sort(this.sortSkills);
         this.cleanupRenderers();
         this.populateRenderers(_loc1_);
      }
      
      protected function sortSkills(param1:Object, param2:Object) : int
      {
         if(param1.skillSubPath == param2.skillSubPath)
         {
            if(param1.requiredPointsSpent > param2.requiredPointsSpent)
            {
               return 1;
            }
            if(param1.requiredPointsSpent < param2.requiredPointsSpent)
            {
               return -1;
            }
            return 0;
         }
         if(param1.skillSubPath > param2.skillSubPath)
         {
            return 1;
         }
         if(param1.skillSubPath < param2.skillSubPath)
         {
            return -1;
         }
         return 0;
      }
      
      protected function cleanupRenderers() : void
      {
         var _loc1_:IBaseSlot = null;
         while(_renderers.length > 0)
         {
            _loc1_ = _renderers.pop();
            cleanUpRenderer(_loc1_);
            _canvas.removeChild(_loc1_ as DisplayObject);
         }
      }
      
      override public function GetDropdownListHeight() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         if(this._dataCount != 0 && this._columnsCount != 0)
         {
            _loc1_ = ITEM_PADDING + this._rendererHeight;
            _loc2_ = Math.ceil(this._dataCount / this._columnsCount) * _loc1_;
            return _loc2_ + ITEM_PADDING;
         }
         return _canvas.height;
      }
      
      override public function findSelection() : void
      {
         selectedIndex = 0;
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 > 0 && param1 != focused)
         {
            if(selectedIndex < 0)
            {
               this.findSelection();
            }
         }
         super.focused = param1;
      }
      
      protected function populateRenderers(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc7_:Object = null;
         var _loc8_:IBaseSlot = null;
         this._dataCount = param1.length;
         var _loc3_:Number = this._disableGroupTitle ? ITEM_PADDING : 0;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         this.calcRendererSize();
         _renderersCount = this._dataCount;
         var _loc6_:int = 0;
         while(_loc6_ < this._dataCount)
         {
            _loc7_ = param1[_loc6_];
            if(!this._disableGroupTitle)
            {
               if(_loc7_.skillSubPath != _loc2_)
               {
                  _loc2_ = String(_loc7_.skillSubPath);
                  if(_loc3_ != 0)
                  {
                     _loc3_ += this._rendererHeight;
                  }
                  _loc3_ += this.createCategoryTitle(_loc2_,_loc7_.skillPath,_loc3_);
                  _loc5_ = 0;
                  _loc4_ = 0;
               }
            }
            _loc8_ = new _slotRendererRef() as IBaseSlot;
            _loc7_.gridSize = 1;
            _loc8_.data = _loc7_;
            _loc8_.y = _loc3_;
            _loc8_.x = _loc4_;
            if(_loc5_ >= this._columnsCount - 1)
            {
               _loc5_ = 0;
               _loc4_ = 0;
               _loc3_ += this._rendererHeight + ITEM_PADDING;
            }
            else
            {
               _loc5_++;
               _loc4_ += this._rendererWidth + ITEM_PADDING;
            }
            _loc8_.index = _loc6_;
            setupRenderer(_loc8_);
            _canvas.addChild(_loc8_ as DisplayObject);
            _renderers.push(_loc8_);
            _loc8_.validateNow();
            _loc6_++;
         }
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      protected function createCategoryTitle(param1:String, param2:String, param3:Number) : Number
      {
         var _loc5_:SkillsGroupTitle;
         var _loc4_:Class;
         (_loc5_ = new (_loc4_ = getDefinitionByName(GROUP_TITLE_REF) as Class)() as SkillsGroupTitle).title = param1;
         _loc5_.skillGroup = param2;
         _loc5_.y = param3 + GROUP_TITLE_PADDING;
         _canvas.addChild(_loc5_);
         return GROUP_TITLE_PADDING * 2 + _loc5_.actualHeight;
      }
      
      protected function calcRendererSize() : void
      {
         var _loc1_:IBaseSlot = null;
         var _loc2_:Rectangle = null;
         if(_slotRendererRef)
         {
            _loc1_ = new _slotRendererRef() as IBaseSlot;
            _loc2_ = _loc1_.getSlotRect();
            this._rendererWidth = _loc2_.width;
            this._rendererHeight = _loc2_.height;
            this._columnsCount = Math.floor(this.actualWidth / (this._rendererWidth + ITEM_PADDING));
         }
      }
      
      override public function getColumn(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return param1 % (this._columnsCount - 1);
      }
      
      override public function getRow(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return Math.abs(param1 / this._columnsCount);
      }
   }
}
