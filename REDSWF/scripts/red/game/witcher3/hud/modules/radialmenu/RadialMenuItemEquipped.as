package red.game.witcher3.hud.modules.radialmenu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.W3UILoader;
   
   public class RadialMenuItemEquipped extends RadialMenuItem
   {
      
      public static var enableAnimationFx:Boolean = false;
       
      
      public var mcItemCounter:RadialMenuItemCounter;
      
      public var mcAmmoCounter:MovieClip;
      
      public var mcEquipped:MovieClip;
      
      public var tfItemDescName:TextField;
      
      private var _subIndex:int;
      
      private var _subItemsCount:int;
      
      private var _subListViewer:RadialMenuSubItemView;
      
      private var _ammoTextField:TextField;
      
      private var _data:Object;
      
      private var _isPocketData:Boolean;
      
      private var _showChangeItemText:Boolean;
      
      private var _baseItemData:Object;
      
      private var _alterItemData:Object;
      
      private var _subItemsList:Array;
      
      protected var _cachedSourcePath:String;
      
      public function RadialMenuItemEquipped()
      {
         super();
         this.mcAmmoCounter.visible = false;
         this.tfItemDescName.visible = false;
         this._ammoTextField = this.mcAmmoCounter.textField;
         bItemField = true;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.updateData();
      }
      
      public function get subListViewer() : RadialMenuSubItemView
      {
         return this._subListViewer;
      }
      
      public function set subListViewer(param1:RadialMenuSubItemView) : void
      {
         this._subListViewer = param1;
         this.updateExternalViewer();
      }
      
      public function getCurrentGroupSlotName() : String
      {
         if(this._data)
         {
            return this._data.slotName;
         }
         return "";
      }
      
      public function getCurrentSlotName() : String
      {
         if(this._isPocketData)
         {
            if(this._baseItemData)
            {
               return this._baseItemData.slotName;
            }
         }
         else if(this._data)
         {
            return this._data.slotName;
         }
         return "";
      }
      
      public function isCrossbow() : Boolean
      {
         return !this._isPocketData;
      }
      
      public function ShowChangeItemText() : Boolean
      {
         return this._showChangeItemText;
      }
      
      public function isSwitchable() : Boolean
      {
         if(this._isPocketData)
         {
            return Boolean(this._baseItemData) && Boolean(this._alterItemData);
         }
         return Boolean(this._subItemsList) && this._subItemsList.length > 1;
      }
      
      protected function updateExternalViewer() : void
      {
         if(this._subListViewer && this._alterItemData && _isSelected)
         {
            if(!this._isPocketData)
            {
               if(this._alterItemData)
               {
                  this._subListViewer.setData(this._alterItemData.name,this._alterItemData.itemIconPath,this._subIndex,this._subItemsCount);
                  if(this._alterItemData.hasOwnProperty("id"))
                  {
                     dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipBolt",[uint(this._alterItemData.id)]));
                  }
               }
            }
         }
      }
      
      override public function SetSelected() : void
      {
         super.SetSelected();
         this.updateExternalViewer();
      }
      
      override public function SetDeselected() : void
      {
         super.SetDeselected();
         if(this._subListViewer)
         {
            this._subListViewer.cleanup();
         }
      }
      
      public function nextSubItem() : void
      {
         if(this._subItemsCount < 1)
         {
            return;
         }
         if(this._isPocketData)
         {
            this.swapPocketItems();
         }
         else if(Boolean(this._subItemsList) && this._subItemsList.length > 1)
         {
            if(this._subIndex < this._subItemsCount)
            {
               ++this._subIndex;
            }
            else
            {
               this._subIndex = 1;
            }
            this._alterItemData = this._subItemsList[this._subIndex - 1];
            if(this._alterItemData)
            {
               _itemDescription = this._alterItemData.description;
            }
            this.updateExternalViewer();
            this.updateAmmo(this._alterItemData,true);
            if(this._data)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnActivateSlot",[this._data.slotName,true,true]));
               this.mcEquipped.visible = true;
            }
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      public function priorSubItem() : void
      {
         if(this._subItemsCount < 1)
         {
            return;
         }
         if(this._isPocketData)
         {
            this.swapPocketItems();
         }
         else if(Boolean(this._subItemsList) && this._subItemsList.length > 1)
         {
            if(this._subIndex > 1)
            {
               --this._subIndex;
            }
            else
            {
               this._subIndex = this._subItemsCount;
            }
            this._alterItemData = this._subItemsList[this._subIndex - 1];
            if(this._alterItemData)
            {
               _itemDescription = this._alterItemData.description;
            }
            this.updateExternalViewer();
            this.updateAmmo(this._alterItemData,true);
            if(this._data)
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnActivateSlot",[this._data.slotName,true,true]));
               this.mcEquipped.visible = true;
            }
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      private function swapPocketItems() : void
      {
         var _loc1_:Object = null;
         if(this._alterItemData)
         {
            this._subIndex = this._subIndex == 1 ? 2 : 1;
            _loc1_ = this._alterItemData;
            this._alterItemData = this._baseItemData;
            this._baseItemData = _loc1_;
            this.setBaseDataFromObject(this._baseItemData);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnActivateSlot",[this._baseItemData.slotName,false,true]));
            this.mcEquipped.visible = true;
            dispatchEvent(new Event(Event.CHANGE,true));
         }
      }
      
      public function ResetPetardData() : void
      {
         this.cleanup();
         this._baseItemData = null;
         this._alterItemData = null;
         this._subItemsList.Clear();
      }
      
      protected function updateData() : void
      {
         if(!this._data)
         {
            this.cleanup();
            return;
         }
         this._isPocketData = this._data.isPocketData;
         this._showChangeItemText = this._data.showChangeItemText;
         if(this._isPocketData)
         {
            this.updatePocketData();
         }
         else
         {
            this.updateCrossbowData();
            this.mcEquipped.visible = Boolean(this._data) && Boolean(this._data.isEquipped);
         }
         if(this.mcEquipped.visible)
         {
            this.mcEquipped.gotoAndPlay(2);
         }
         enableAnimationFx = false;
      }
      
      protected function updatePocketData() : void
      {
         var _loc1_:Array = this._data.itemsList;
         var _loc2_:int = int(_loc1_.length);
         this._subItemsList = _loc1_;
         if(_loc2_ < 1)
         {
            this._subIndex = -1;
            this._subItemsCount = -1;
            this.cleanup();
            return;
         }
         if(_loc2_ < 2)
         {
            this._subIndex = 1;
            this._subItemsCount = 1;
            this._baseItemData = _loc1_[0];
            this._alterItemData = null;
         }
         else
         {
            this._subIndex = 1;
            this._subItemsCount = 2;
            if(_loc1_[0].isEquipped)
            {
               this._baseItemData = _loc1_[0];
               this._alterItemData = _loc1_[1];
            }
            else
            {
               this._baseItemData = _loc1_[1];
               this._alterItemData = _loc1_[0];
            }
         }
         this.setBaseDataFromObject(this._baseItemData);
         this.mcEquipped.visible = Boolean(this._baseItemData) && Boolean(this._baseItemData.isEquipped) || Boolean(this._alterItemData) && Boolean(this._alterItemData.isEquipped);
      }
      
      protected function updateCrossbowData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         this._subItemsList = this._data.itemsList;
         if(this._subItemsList)
         {
            this._subIndex = 1;
            this._subItemsCount = this._subItemsList.length;
            _loc1_ = [];
            _loc2_ = 0;
            while(_loc2_ < this._subItemsCount)
            {
               _loc3_ = this._subItemsList[_loc2_];
               if(_loc3_.isEquipped)
               {
                  this._alterItemData = _loc3_;
                  this._data.charges = this._alterItemData.charges;
                  if(this._alterItemData)
                  {
                     _itemDescription = this._alterItemData.description;
                  }
                  _loc1_.push(_loc3_);
                  this._subIndex = _loc2_ + 1;
               }
               else
               {
                  _loc1_.push(_loc3_);
               }
               _loc2_++;
            }
            this._subItemsList = _loc1_;
         }
         this.updateExternalViewer();
         this.setBaseDataFromObject(this._data,true);
         this.mcItemCounter.visible = false;
         this.tfItemDescName.y = this.mcItemCounter.y - this.mcItemCounter.height / 2;
      }
      
      protected function setBaseDataFromObject(param1:Object, param2:Boolean = false) : void
      {
         if(param1)
         {
            _iconPath = param1.itemIconPath;
            _itemName = param1.name;
            _itemCategory = param1.category;
            _itemDescription = param1.description;
            _radialName = param1.slotName;
            this.updateAmmo(param1,param2);
         }
         else
         {
            this.mcAmmoCounter.visible = false;
         }
         this.tfItemDescName.visible = true;
         this.tfItemDescName.htmlText = _itemName;
         this.tfItemDescName.height = this.tfItemDescName.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.mcItemCounter.value = this._subIndex;
         this.mcItemCounter.maximum = this._subItemsCount;
         this.loadIcon();
      }
      
      protected function updateAmmo(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:* = new Namespace("");
         var _loc4_:* = new Namespace("");
         if(!isNaN(param1.charges) && (param1.charges >= 0 || param2))
         {
            this.mcAmmoCounter.visible = true;
            if(param1.charges >= 0)
            {
               this._ammoTextField.text = param1.charges;
            }
            else if(param2)
            {
               this._ammoTextField.text = "∞";
            }
            _loc3_ = 16711680;
            _loc4_ = 13682879;
            if(param1.charges == 0)
            {
               this._ammoTextField.textColor = _loc3_;
            }
            else
            {
               this._ammoTextField.textColor = _loc4_;
            }
         }
         else
         {
            this.mcAmmoCounter.visible = false;
         }
      }
      
      protected function cleanup() : void
      {
         this._subItemsCount = 0;
         this._subIndex = 0;
         _iconPath = "";
         _itemName = "";
         _itemCategory = "";
         _itemDescription = "";
         _radialName = "";
         this.mcAmmoCounter.visible = false;
         this.tfItemDescName.visible = false;
         this.mcEquipped.visible = false;
         this.mcItemCounter.visible = false;
         var _loc1_:W3UILoader = mcIcon.mcLoader;
         if(_loc1_)
         {
            _loc1_.unload();
         }
      }
      
      protected function loadIcon() : void
      {
         var _loc1_:W3UILoader = null;
         var _loc2_:String = null;
         if(mcIcon)
         {
            if(_itemCategory != "crossbow")
            {
               mcIcon.gotoAndStop("iconLoader");
               _loc1_ = mcIcon.mcLoader;
            }
            else
            {
               mcIcon.gotoAndStop("iconLoaderLarge");
               _loc1_ = mcIcon.mcLoaderLarge;
            }
            _loc1_.fallbackIconPath = "img://" + GetDefaultFallbackIconFromType(_itemCategory);
            _loc2_ = "";
            if(_iconPath != "")
            {
               _loc2_ = "img://" + _iconPath;
            }
            else
            {
               _loc2_ = "";
            }
            if(this._cachedSourcePath != _loc2_)
            {
               _loc1_.source = _loc2_;
               mcIcon.filters = [];
            }
         }
      }
      
      private function onImageLoaded(param1:Event) : void
      {
      }
   }
}
