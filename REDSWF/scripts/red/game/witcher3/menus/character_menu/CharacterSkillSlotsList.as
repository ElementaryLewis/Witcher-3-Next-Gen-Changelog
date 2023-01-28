package red.game.witcher3.menus.character_menu
{
   import flash.display.DisplayObject;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListBase;
   
   public class CharacterSkillSlotsList extends SlotsListBase
   {
       
      
      private var _widthPadding:int = 0;
      
      private var _heightPadding:int = 0;
      
      private var _numRows = 0;
      
      private var _dataByColumns:Array;
      
      private var _columnNames:Array;
      
      public function CharacterSkillSlotsList()
      {
         this._dataByColumns = new Array();
         this._columnNames = new Array();
         super();
      }
      
      public function get widthPadding() : int
      {
         return this._widthPadding;
      }
      
      public function set widthPadding(param1:int) : void
      {
         this._widthPadding = param1;
      }
      
      public function get heightPadding() : int
      {
         return this._heightPadding;
      }
      
      public function set heightPadding(param1:int) : void
      {
         this._heightPadding = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function get numColumns() : uint
      {
         return this._dataByColumns.length;
      }
      
      override public function get numRows() : uint
      {
         return this._numRows;
      }
      
      override public function getColumn(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return param1 % (this.numColumns - 1);
      }
      
      override public function getRow(param1:int) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return Math.abs(param1 / this.numColumns);
      }
      
      public function getSkillWithType(param1:int) : SlotBase
      {
         var _loc4_:SlotBase = null;
         var _loc2_:int = int(_renderers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = _renderers[_loc3_] as SlotBase) && _loc4_.data && _loc4_.data.skillType == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      override protected function populateData() : void
      {
         this.organizeData();
         var _loc1_:int = 0;
         while(_loc1_ < this._dataByColumns.length)
         {
            if(_loc1_ > 4)
            {
            }
            _loc1_++;
         }
         this.setupRenderers();
      }
      
      private function organizeData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         this._dataByColumns.length = 0;
         this._columnNames.length = 0;
         this._numRows = 0;
         _loc1_ = 0;
         while(_loc1_ < _data.length)
         {
            _loc3_ = String(_data[_loc1_].skillSubPath);
            _loc4_ = -1;
            _loc2_ = 0;
            while(_loc2_ < this._columnNames.length)
            {
               if(this._columnNames[_loc2_] == _loc3_)
               {
                  _loc4_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            if(_loc4_ == -1)
            {
               this._columnNames.push(_loc3_);
               this._dataByColumns.push(new Array(_data[_loc1_]));
               if(this._numRows < 1)
               {
                  this._numRows = 1;
               }
            }
            else
            {
               this._dataByColumns[_loc4_].push(_data[_loc1_]);
               if(this._dataByColumns[_loc4_].length > this._numRows)
               {
                  this._numRows = this._dataByColumns[_loc4_].length;
               }
            }
            _loc1_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this._dataByColumns.length)
         {
            this._dataByColumns[_loc4_].sort(this.sortDataByRequiredPoints);
            _loc4_++;
         }
      }
      
      protected function sortDataByRequiredPoints(param1:*, param2:*) : int
      {
         if(!param1.isCoreSkill && Boolean(param2.isCoreSkill))
         {
            return 1;
         }
         if(Boolean(param1.isCoreSkill) && !param2.isCoreSkill)
         {
            return -1;
         }
         if(int(param1.requiredPointsSpent) > int(param2.requiredPointsSpent))
         {
            return 1;
         }
         if(int(param1.requiredPointsSpent) < int(param2.requiredPointsSpent))
         {
            return -1;
         }
         return 0;
      }
      
      private function setupRenderers() : void
      {
         this.adjustRendererCount();
         this.positionRenderers();
         this.updateRendererData();
         selectedIndex = 0;
      }
      
      private function adjustRendererCount() : void
      {
         var _loc2_:SlotBase = null;
         var _loc3_:SlotBase = null;
         var _loc1_:int = this._numRows * this._columnNames.length;
         if(_loc1_ < 0)
         {
            throw new Error("GFX - adjusting renderer count to an invalid value: " + _loc1_);
         }
         while(_renderers.length != _loc1_)
         {
            if(_renderers.length > _loc1_)
            {
               _loc2_ = _renderers.pop() as SlotBase;
               if(!_loc2_)
               {
                  throw new Error("GFX - trying to remove a slotRenderer of invalid type. Will NOT be properly removed!");
               }
               _loc2_.cleanup();
               _canvas.removeChild(_loc2_ as DisplayObject);
            }
            else
            {
               if(_renderers.length >= _loc1_)
               {
                  throw new Error("GFX - something has gone horribly wrong!");
               }
               _loc3_ = new _slotRendererRef() as SlotBase;
               if(!_loc3_)
               {
                  throw new Error("GFX - unsupported _slotRendererRef() used: " + _slotRendererRef);
               }
               setupRenderer(_loc3_);
               _canvas.addChild(_loc3_);
               _loc3_.index = _renderers.length;
               _renderers.push(_loc3_);
            }
         }
         _renderersCount = _renderers.length;
      }
      
      private function positionRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc4_:SlotBase = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _renderers.length)
         {
            _loc4_ = _renderers[_loc1_] as SlotBase;
            _loc2_ = _loc1_ % this._columnNames.length;
            _loc3_ = Math.floor(_loc1_ / this._columnNames.length);
            _loc4_.x = _loc2_ * this._widthPadding;
            _loc4_.y = _loc3_ * this._heightPadding;
            _loc1_++;
         }
      }
      
      private function updateRendererData() : void
      {
         var _loc1_:int = 0;
         var _loc4_:SlotBase = null;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(data && data.length && Boolean(data[0].perkPosition))
         {
            _loc1_ = 0;
            while(_loc1_ < _renderers.length)
            {
               (_loc4_ = _renderers[_loc1_] as SlotBase).enabled = false;
               _loc4_.visible = false;
               _loc1_++;
            }
            (_loc7_ = data).sortOn("perkPosition",Array.NUMERIC);
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc9_ = _loc7_[_loc8_];
               (_loc4_ = _renderers[_loc8_] as SlotBase).setData(_loc9_);
               _loc4_.validateNow();
               _loc4_.enabled = true;
               _loc4_.visible = true;
               _loc8_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < _renderers.length)
            {
               _loc4_ = _renderers[_loc1_] as SlotBase;
               _loc2_ = _loc1_ % this._columnNames.length;
               _loc3_ = Math.floor(_loc1_ / this._columnNames.length);
               if(this._dataByColumns[_loc2_].length > _loc3_)
               {
                  _loc4_.enabled = true;
                  _loc4_.visible = true;
                  _loc4_.setData(this._dataByColumns[_loc2_][_loc3_]);
                  _loc4_.validateNow();
                  _loc5_++;
               }
               else
               {
                  _loc4_.enabled = false;
                  _loc4_.visible = false;
                  _loc6_++;
               }
               _loc1_++;
            }
         }
      }
   }
}
