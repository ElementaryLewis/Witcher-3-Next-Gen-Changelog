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
      
      public function set lastMoveWasMouse(value:Boolean) : void
      {
         this._lastMoveWasMouse = value;
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
      
      public function showWithData(data:Array) : void
      {
         super.show();
         this.mcList.dataProvider = new DataProvider(data);
         this.mcList.validateNow();
         if(!this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = 0;
         }
         this.registerMouseEvents();
      }
      
      protected function OnListItemSelectionChange(event:ListEvent) : void
      {
         if(event.index == -1)
         {
            this.txtSelectionInfo.text = "";
         }
         else
         {
            this.txtSelectionInfo.htmlText = (this.mcList.getRendererAt(event.index) as InstalledDLCMItemRenderer).getDLCDescription();
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
      
      protected function registerMouseEventsForItem(item:InstalledDLCMItemRenderer) : void
      {
         item.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver,false,0,true);
         item.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut,false,0,true);
      }
      
      protected function unregisterMouseEventsForItem(item:InstalledDLCMItemRenderer) : void
      {
         item.removeEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         item.removeEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
      }
      
      protected function onItemMouseOver(event:MouseEvent) : void
      {
         var currentTarget:InstalledDLCMItemRenderer = event.currentTarget as InstalledDLCMItemRenderer;
         this._lastMouseOveredItem = this.mcList.getRenderers().indexOf(currentTarget);
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = currentTarget.index;
         }
      }
      
      protected function onItemMouseOut(event:MouseEvent) : void
      {
         this._lastMouseOveredItem = -1;
         if(this._lastMoveWasMouse)
         {
            this.mcList.selectedIndex = -1;
         }
      }
      
      override public function handleInputNavigate(event:InputEvent) : void
      {
         if(!visible)
         {
            return;
         }
         var details:InputDetails = event.details;
         CommonUtils.convertWASDCodeToNavEquivalent(details);
         this.mcList.handleInput(event);
         if(!event.handled)
         {
            super.handleInputNavigate(event);
         }
      }
      
      private function handleScroll(e:Event) : void
      {
         var currentTarget:InstalledDLCMItemRenderer = null;
         this.mcList.validateNow();
         if(this._lastMouseOveredItem != -1 && this.lastMoveWasMouse)
         {
            currentTarget = this.mcList.getRendererAt(this._lastMouseOveredItem) as InstalledDLCMItemRenderer;
            if(currentTarget)
            {
               this.mcList.selectedIndex = currentTarget.index;
               this.mcList.validateNow();
            }
         }
      }
   }
}
