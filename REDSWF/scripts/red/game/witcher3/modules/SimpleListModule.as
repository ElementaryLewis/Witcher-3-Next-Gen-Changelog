package red.game.witcher3.modules
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.menus.mainmenu.IngameMenu;
   import red.game.witcher3.menus.mainmenu.W3MenuListItemRenderer;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ListEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class SimpleListModule extends CoreMenuModule
   {
       
      
      public var mcList:W3ScrollingList;
      
      public var mcListItem1:W3MenuListItemRenderer;
      
      public var mcListItem2:W3MenuListItemRenderer;
      
      public var mcListItem3:W3MenuListItemRenderer;
      
      public var mcListItem4:W3MenuListItemRenderer;
      
      public var mcListItem5:W3MenuListItemRenderer;
      
      public var mcListItem6:W3MenuListItemRenderer;
      
      public var mcListItem7:W3MenuListItemRenderer;
      
      public var mcListItem8:W3MenuListItemRenderer;
      
      public var mcListItem9:W3MenuListItemRenderer;
      
      public var mcListItem10:W3MenuListItemRenderer;
      
      public var txtMenuListDescripion:TextField;
      
      public var txtMenuListTitle:TextField;
      
      public var mcMenuTitleUnderline:MovieClip;
      
      public var mcGameLogo:MovieClip;
      
      protected var _lastMoveWasMouse:Boolean = false;
      
      protected var _lockedSelectionIndex:int = -1;
      
      protected var _lastMouseOveredItem:int = -1;
      
      private var _hideSelection:Boolean = false;
      
      public function SimpleListModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.txtMenuListDescripion)
         {
            this.txtMenuListDescripion.visible = false;
         }
         this.registerMouseEvents();
         if(this.mcList)
         {
            this.mcList.focusable = false;
            this.mcList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
         }
      }
      
      public function onLastMoveStatusChanged(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         if(!param1)
         {
            if(this._lockedSelectionIndex != -1)
            {
               this.hideSelection = true;
               this.mcList.selectedIndex = this._lockedSelectionIndex;
            }
            else
            {
               this.hideSelection = false;
               if(this.mcList.selectedIndex == -1)
               {
                  this.mcList.selectedIndex = 0;
               }
            }
         }
         else if(this._lastMouseOveredItem != -1)
         {
            this.hideSelection = false;
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      public function get lockSelectionIndex() : int
      {
         return this._lockedSelectionIndex;
      }
      
      public function set lockSelection(param1:Boolean) : void
      {
         if(param1)
         {
            this._lockedSelectionIndex = this.mcList.selectedIndex;
            if(this._lockedSelectionIndex != -1)
            {
               (this.mcList.getRendererAt(this._lockedSelectionIndex) as W3MenuListItemRenderer).showOpen = true;
            }
            if(this._lastMoveWasMouse && this._lastMouseOveredItem == -1 || !this._lastMoveWasMouse)
            {
               this.hideSelection = true;
            }
         }
         else
         {
            if(this._lockedSelectionIndex != -1)
            {
               (this.mcList.getRendererAt(this._lockedSelectionIndex) as W3MenuListItemRenderer).showOpen = false;
            }
            this._lockedSelectionIndex = -1;
            this.hideSelection = false;
         }
      }
      
      public function registerMouseEvents() : void
      {
         this.registerMouseEventsForItem(this.mcListItem1);
         this.registerMouseEventsForItem(this.mcListItem2);
         this.registerMouseEventsForItem(this.mcListItem3);
         this.registerMouseEventsForItem(this.mcListItem4);
         this.registerMouseEventsForItem(this.mcListItem5);
         this.registerMouseEventsForItem(this.mcListItem6);
         this.registerMouseEventsForItem(this.mcListItem7);
         this.registerMouseEventsForItem(this.mcListItem8);
         this.registerMouseEventsForItem(this.mcListItem9);
         this.registerMouseEventsForItem(this.mcListItem10);
      }
      
      protected function registerMouseEventsForItem(param1:W3MenuListItemRenderer) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onItemClicked,false,1,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,1,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,1,true);
      }
      
      protected function onItemClicked(param1:MouseEvent) : void
      {
         var _loc3_:IngameMenu = null;
         this.onItemMouseOver(param1);
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            _loc3_ = parent as IngameMenu;
            if(_loc3_)
            {
               _loc3_.activateMenuListItem();
               param1.stopImmediatePropagation();
            }
         }
      }
      
      protected function onItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:W3MenuListItemRenderer = param1.currentTarget as W3MenuListItemRenderer;
         this._lastMouseOveredItem = this.mcList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.hideSelection = false;
            this.mcList.selectedIndex = _loc2_.index;
         }
      }
      
      protected function onItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.hideSelection = true;
            this.mcList.selectedIndex = this._lockedSelectionIndex;
         }
      }
      
      protected function handleIndexChanged(param1:ListEvent) : void
      {
         this.updateSelectedItemDescriptionText();
      }
      
      protected function updateSelectedItemDescriptionText() : void
      {
         var _loc1_:W3MenuListItemRenderer = null;
         var _loc2_:Object = null;
         if(this.txtMenuListDescripion)
         {
            _loc1_ = this.mcList.getSelectedRenderer() as W3MenuListItemRenderer;
            if(_loc1_)
            {
               _loc2_ = _loc1_.data;
               if(Boolean(_loc2_) && Boolean(_loc2_.description))
               {
                  this.txtMenuListDescripion.text = _loc2_.description;
                  this.txtMenuListDescripion.visible = true;
               }
               else
               {
                  this.txtMenuListDescripion.visible = false;
               }
            }
            else
            {
               this.txtMenuListDescripion.visible = false;
            }
         }
      }
      
      public function get hideSelection() : Boolean
      {
         return this._hideSelection;
      }
      
      public function set hideSelection(param1:Boolean) : void
      {
         if(this._hideSelection == param1)
         {
            return;
         }
         this._hideSelection = param1;
         if(this.mcListItem1)
         {
            this.mcListItem1.hideSelection = param1;
         }
         if(this.mcListItem2)
         {
            this.mcListItem2.hideSelection = param1;
         }
         if(this.mcListItem3)
         {
            this.mcListItem3.hideSelection = param1;
         }
         if(this.mcListItem4)
         {
            this.mcListItem4.hideSelection = param1;
         }
         if(this.mcListItem5)
         {
            this.mcListItem5.hideSelection = param1;
         }
         if(this.mcListItem6)
         {
            this.mcListItem6.hideSelection = param1;
         }
         if(this.mcListItem7)
         {
            this.mcListItem7.hideSelection = param1;
         }
         if(this.mcListItem8)
         {
            this.mcListItem8.hideSelection = param1;
         }
         if(this.mcListItem9)
         {
            this.mcListItem9.hideSelection = param1;
         }
         if(this.mcListItem10)
         {
            this.mcListItem10.hideSelection = param1;
         }
      }
      
      public function set titleText(param1:String) : void
      {
         if(param1 == "")
         {
            this.txtMenuListTitle.visible = false;
            if(this.mcMenuTitleUnderline)
            {
               this.mcMenuTitleUnderline.visible = false;
            }
         }
         else
         {
            this.txtMenuListTitle.visible = true;
            this.txtMenuListTitle.text = param1;
            if(this.mcMenuTitleUnderline)
            {
               this.mcMenuTitleUnderline.visible = true;
               this.mcMenuTitleUnderline.y = this.txtMenuListTitle.y + this.txtMenuListTitle.textHeight;
            }
         }
      }
      
      public function setGameLogoLanguage(param1:String) : void
      {
         if(this.mcGameLogo)
         {
            this.mcGameLogo.gotoAndStop(param1);
         }
      }
      
      public function setListData(param1:DataProvider, param2:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc4_:IngameMenu;
         if(_loc4_ = parent as IngameMenu)
         {
            _loc5_ = false;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_].type == IngameMenu.IGMActionType_Back)
               {
                  _loc5_ = true;
                  break;
               }
               _loc3_++;
            }
            if(_loc4_.previousEntries.length > 0 && !_loc5_)
            {
               _loc6_ = new Array();
               _loc7_ = {
                  "id":"credits",
                  "tag":666,
                  "label":"[[panel_mainmenu_back]]",
                  "type":IngameMenu.IGMActionType_Back,
                  "subElements":_loc6_
               };
               param1.push(_loc7_);
            }
         }
         this.mcList.dataProvider = param1;
         this.mcList.validateNow();
         if(this._lastMoveWasMouse && this._lastMouseOveredItem != -1)
         {
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
         else
         {
            this.mcList.selectedIndex = param2;
         }
         this.repositionRenderers();
         this.updateSelectedItemDescriptionText();
      }
      
      public function repositionRenderers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:W3MenuListItemRenderer = null;
         var _loc3_:Number = 0;
         _loc1_ = 0;
         while(_loc1_ < this.mcList.numRenderers)
         {
            _loc2_ = this.mcList.getRendererAt(_loc1_) as W3MenuListItemRenderer;
            if(_loc2_)
            {
               _loc2_.y = _loc3_;
               _loc3_ += _loc2_.textField.textHeight + 17;
            }
            _loc1_++;
         }
      }
   }
}
