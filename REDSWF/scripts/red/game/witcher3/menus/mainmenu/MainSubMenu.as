package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ScrollBar;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MainSubMenu extends CoreMenu
   {
       
      
      public var mcMenuList:W3ScrollingList;
      
      public var mcMenuListItem1:BaseListItem;
      
      public var mcMenuListItem2:BaseListItem;
      
      public var mcMenuListItem3:BaseListItem;
      
      public var mcMenuListItem4:BaseListItem;
      
      public var mcMenuListItem5:BaseListItem;
      
      public var mcScrollbar:ScrollBar;
      
      public var mcAnchor_MODULE_Tooltip:MovieClip;
      
      public var dataBindingKey:String = "mainmenu.main.entries";
      
      public function MainSubMenu()
      {
         super();
         _enableMouse = true;
      }
      
      override protected function get menuName() : String
      {
         return "not important";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         _contextMgr.defaultAnchor = this.mcAnchor_MODULE_Tooltip;
         _contextMgr.addGridEventsTooltipHolder(stage);
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,this.dataBindingKey,[this.handleOptionsList]));
         focused = 1;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcMenuList.addEventListener(ListEvent.ITEM_CLICK,this.onItemClicked,false,0,true);
         this.mcMenuList.ShowRenderers(true);
         this.mcMenuList.selectedIndex = 0;
         this.mcMenuList.focused = 1;
         this.mcMenuList.focusable = false;
      }
      
      private function onItemClicked(param1:ListEvent) : void
      {
         var _loc3_:InputManager = null;
         var _loc2_:BaseListItem = this.mcMenuList.getRendererAt(param1.index,this.mcMenuList.scrollPosition) as BaseListItem;
         if(_loc2_)
         {
            trace("HUD onItemClicked renderer.data.tag " + _loc2_.data.tag);
            _loc3_ = InputManager.getInstance();
            _loc3_.reset();
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnItemChosen",[_loc2_.data.tag]));
         }
         else
         {
            trace("MainMenu renderer is fucked " + param1.target);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(!_loc3_ && !param1.handled)
         {
            switch(_loc2_.navEquivalent)
            {
               case NavigationCode.GAMEPAD_A:
                  param1.handled = true;
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfirm"));
            }
         }
         this.mcMenuList.handleInput(param1);
      }
      
      protected function handleOptionsList(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(param2 > 0)
         {
            this.mcMenuList.dataProvider = new DataProvider(_loc3_);
         }
         else if(_loc3_)
         {
            this.mcMenuList.dataProvider = new DataProvider(_loc3_);
         }
         trace("HUD dataArray.length " + _loc3_.length + " mcMenuList.dataProvider " + this.mcMenuList.dataProvider.length);
         this.mcMenuList.ShowRenderers(true);
      }
      
      override protected function closeMenu() : void
      {
         var _loc1_:InputManager = null;
         _loc1_ = InputManager.getInstance();
         _loc1_.reset();
         super.closeMenu();
      }
   }
}
