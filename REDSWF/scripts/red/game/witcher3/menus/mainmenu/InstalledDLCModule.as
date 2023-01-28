package red.game.witcher3.menus.mainmenu
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class InstalledDLCModule extends StaticOptionModule
   {
       
      
      public var mcScrollbar:ScrollBar;
      
      public var mcList:W3ScrollingList;
      
      public var mcItemRenderer1:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer2:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer3:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer4:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer5:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer6:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer7:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer8:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer9:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer10:InstalledDLCMItemRenderer;
      
      public var mcItemRenderer11:InstalledDLCMItemRenderer;
      
      public var txtSelectionInfo:TextField;
      
      public var _lastMoveWasMouse:Boolean = false;
      
      protected var _mouseEventsRegistered:Boolean = false;
      
      protected var _lastMouseOveredItem:int = -1;
      
      public function InstalledDLCModule()
      {
         super();
      }
      
      public function get lastMoveWasMouse() : Boolean
      {
         return this._lastMoveWasMouse;
      }
      
      public function set lastMoveWasMouse(param1:Boolean) : void
      {
         this._lastMoveWasMouse = param1;
         if(!this._lastMoveWasMouse)
         {
            if(this.mcList.selectedIndex == -1)
            {
               this.mcList.selectedIndex = 0;
            }
         }
         else
         {
            this.mcList.selectedIndex = this._lastMouseOveredItem;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focusable = false;
         if(this.mcScrollbar)
         {
            this.mcScrollbar.addEventListener(Event.SCROLL,this.handleScroll,false,1,true);
         }
         if(this.mcList)
         {
            this.mcList.addEventListener(ListEvent.INDEX_CHANGE,this.OnListItemSelectionChange,false,0,true);
         }
      }
      
      public function showWithData(param1:Array) : void
      {
         super.show();
         this.mcList.dataProvider = new DataProvider(param1);
         this.mcList.validateNow();
         if(!this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = 0;
         }
         this.registerMouseEvents();
      }
      
      protected function OnListItemSelectionChange(param1:ListEvent) : void
      {
         if(param1.index == -1)
         {
            this.txtSelectionInfo.text = "";
         }
         else
         {
            this.txtSelectionInfo.htmlText = (this.mcList.getRendererAt(param1.index) as InstalledDLCMItemRenderer).getDLCDescription();
         }
      }
      
      override public function hide() : void
      {
         super.hide();
         this.unregisteredMouseEvents();
      }
      
      public function registerMouseEvents() : void
      {
         if(!this._mouseEventsRegistered)
         {
            this._mouseEventsRegistered = true;
            this.registerMouseEventsForItem(this.mcItemRenderer1);
            this.registerMouseEventsForItem(this.mcItemRenderer2);
            this.registerMouseEventsForItem(this.mcItemRenderer3);
            this.registerMouseEventsForItem(this.mcItemRenderer4);
            this.registerMouseEventsForItem(this.mcItemRenderer5);
            this.registerMouseEventsForItem(this.mcItemRenderer6);
            this.registerMouseEventsForItem(this.mcItemRenderer7);
            this.registerMouseEventsForItem(this.mcItemRenderer8);
            this.registerMouseEventsForItem(this.mcItemRenderer9);
            this.registerMouseEventsForItem(this.mcItemRenderer10);
            this.registerMouseEventsForItem(this.mcItemRenderer11);
         }
      }
      
      public function unregisteredMouseEvents() : void
      {
         if(this._mouseEventsRegistered)
         {
            this._mouseEventsRegistered = false;
            this.unregisterMouseEventsForItem(this.mcItemRenderer1);
            this.unregisterMouseEventsForItem(this.mcItemRenderer2);
            this.unregisterMouseEventsForItem(this.mcItemRenderer3);
            this.unregisterMouseEventsForItem(this.mcItemRenderer4);
            this.unregisterMouseEventsForItem(this.mcItemRenderer5);
            this.unregisterMouseEventsForItem(this.mcItemRenderer6);
            this.unregisterMouseEventsForItem(this.mcItemRenderer7);
            this.unregisterMouseEventsForItem(this.mcItemRenderer8);
            this.unregisterMouseEventsForItem(this.mcItemRenderer9);
            this.unregisterMouseEventsForItem(this.mcItemRenderer10);
            this.unregisterMouseEventsForItem(this.mcItemRenderer11);
         }
      }
      
      protected function registerMouseEventsForItem(param1:InstalledDLCMItemRenderer) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,0,true);
      }
      
      protected function unregisterMouseEventsForItem(param1:InstalledDLCMItemRenderer) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
      }
      
      protected function onItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:InstalledDLCMItemRenderer = param1.currentTarget as InstalledDLCMItemRenderer;
         this._lastMouseOveredItem = this.mcList.getRenderers().indexOf(_loc2_);
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = _loc2_.index;
         }
      }
      
      protected function onItemMouseOut(param1:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = -1;
         }
      }
      
      override public function handleInputNavigate(param1:InputEvent) : void
      {
         if(!visible)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         this.mcList.handleInput(param1);
         if(!param1.handled)
         {
            super.handleInputNavigate(param1);
         }
      }
      
      private function handleScroll(param1:Event) : void
      {
         var _loc2_:InstalledDLCMItemRenderer = null;
         this.mcList.validateNow();
         if(this._lastMouseOveredItem != -1 && this.lastMoveWasMouse)
         {
            _loc2_ = this.mcList.getRendererAt(this._lastMouseOveredItem) as InstalledDLCMItemRenderer;
            if(_loc2_)
            {
               this.mcList.selectedIndex = _loc2_.index;
               this.mcList.validateNow();
            }
         }
      }
   }
}
