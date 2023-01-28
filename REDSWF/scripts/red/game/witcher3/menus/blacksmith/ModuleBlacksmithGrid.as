package red.game.witcher3.menus.blacksmith
{
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.menus.common.ModuleCommonPlayerGrid;
   import red.game.witcher3.menus.inventory_menu.GridTabSections;
   import red.game.witcher3.menus.inventory_menu.ItemSectionData;
   import red.game.witcher3.slots.SlotsListGrid;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.events.InputEvent;
   
   public class ModuleBlacksmithGrid extends ModuleCommonPlayerGrid
   {
       
      
      private const SECTION_BORDER_REF:String = "GridSegmentationRef";
      
      private const SECTION_BORDER_SIDE_PADDING:Number = 3;
      
      private const SECTION_BORDER_TOP_PADDING:Number = 9;
      
      public var mcSectionTitlesAnchor:MovieClip;
      
      protected var _sectionTitlesContainer:MovieClip;
      
      protected var _sectionTitlesList:Vector.<TextField>;
      
      protected var _sectionBordersList:Vector.<MovieClip>;
      
      protected var _itemSectionsList:GridTabSections;
      
      public function ModuleBlacksmithGrid()
      {
         this._sectionTitlesList = new Vector.<TextField>();
         this._sectionBordersList = new Vector.<MovieClip>();
         super();
         dataBindingKey = "repair.grid.player";
         mcPlayerGrid.handleScrollBar = true;
         mcPlayerGrid.ignoreGridPosition = true;
         mcPlayerGrid.useContextMgr = false;
      }
      
      public function checkItemsCount() : void
      {
         if(mcPlayerGrid.NumNonEmptyRenderers() > 0)
         {
            dispatchEvent(new Event(Event.ACTIVATE));
         }
         else
         {
            dispatchEvent(new Event(Event.DEACTIVATE));
         }
      }
      
      public function displaySection(param1:Array) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Class = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc10_:ItemSectionData = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:TextField = null;
         var _loc14_:MovieClip = null;
         var _loc2_:Number = SlotsListGrid.SECTION_PADDING;
         var _loc3_:Number = mcPlayerGrid.gridSquareSize;
         if(this._sectionTitlesContainer)
         {
            while(this._sectionTitlesList.length)
            {
               this._sectionTitlesContainer.removeChild(this._sectionTitlesList.pop());
            }
            while(this._sectionBordersList.length)
            {
               _loc4_ = this._sectionBordersList.pop();
               GTweener.removeTweens(_loc4_);
               this._sectionTitlesContainer.removeChild(_loc4_);
            }
            removeChild(this._sectionTitlesContainer);
            this._sectionTitlesContainer = null;
         }
         if(Boolean(param1) && Boolean(this.mcSectionTitlesAnchor))
         {
            _loc5_ = getDefinitionByName(this.SECTION_BORDER_REF) as Class;
            _loc6_ = int(param1.length);
            _loc7_ = 0;
            _loc8_ = this.localToGlobal(new Point(mcPlayerGrid.x,mcPlayerGrid.y));
            this._sectionTitlesContainer = new MovieClip();
            this._sectionTitlesContainer.y = this.mcSectionTitlesAnchor.y;
            this._sectionTitlesContainer.x = this.mcSectionTitlesAnchor.x - mcPlayerGrid.width / 2;
            addChild(this._sectionTitlesContainer);
            this._sectionTitlesContainer.mouseChildren = this._sectionTitlesContainer.mouseEnabled = false;
            _loc9_ = 0;
            while(_loc9_ < _loc6_)
            {
               if(_loc10_ = param1[_loc9_] as ItemSectionData)
               {
                  if((_loc11_ = (_loc10_.end - _loc10_.start + 1) * _loc3_) < 0)
                  {
                     throw new Error("Invalid grid sections structure. Check MenuInventory.as or InventoryTabbedListModule.as ;-)");
                  }
                  _loc12_ = _loc11_ / 2;
                  (_loc13_ = CommonUtils.spawnTextField(21)).text = _loc10_.label;
                  CommonUtils.toSmallCaps(_loc13_);
                  _loc13_.width = _loc13_.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                  _loc13_.x = _loc7_ + _loc12_ - _loc13_.width / 2;
                  this._sectionTitlesContainer.addChild(_loc13_);
                  (_loc14_ = new _loc5_() as MovieClip).x = _loc7_ - this.SECTION_BORDER_SIDE_PADDING;
                  _loc14_.y = -this.SECTION_BORDER_TOP_PADDING;
                  _loc14_.width = _loc11_ + this.SECTION_BORDER_SIDE_PADDING * 2;
                  this._sectionTitlesContainer.addChild(_loc14_);
                  _loc10_.border = _loc14_;
                  _loc14_.alpha = CommonConstants.BORDER_ALPHA_UNSELECTED;
                  mcPlayerGrid.lastSelectedSection = -1;
                  _loc7_ += _loc2_ + _loc11_;
               }
               _loc9_++;
            }
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
      }
      
      override protected function handleDataSet(param1:Object, param2:int) : void
      {
         mcPlayerGrid.selectedIndex = -1;
         mcPlayerGrid.validateNow();
         mcPlayerGrid.clearRenderers();
         mcPlayerGrid.validateNow();
         if(Boolean(param1) && (param1 as Array).length > 0)
         {
            super.handleDataSet(param1,param2);
            dispatchEvent(new Event(Event.ACTIVATE));
         }
         else
         {
            dispatchEvent(new Event(Event.DEACTIVATE));
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled || !focused)
         {
            return;
         }
         if(!param1.handled)
         {
            mcPlayerGrid.handleInputNavSimple(param1);
         }
         super.handleInput(param1);
      }
      
      override protected function handleModuleSelected() : void
      {
         super.handleModuleSelected();
         if(mcPlayerGrid.selectedIndex < 0)
         {
            mcPlayerGrid.findSelection();
         }
      }
   }
}
