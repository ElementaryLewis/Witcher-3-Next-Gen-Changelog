package red.game.witcher3.menus.glossary
{
   import flash.display.MovieClip;
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3DropdownMenuListItem;
   import red.game.witcher3.menus.common.DropdownListModuleBase;
   import red.game.witcher3.menus.common.IconItemRenderer;
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.gfx.Extensions;
   
   public class GlossaryBooksMenu extends CoreMenu
   {
      
      {
         Extensions.enabled = true;
         Extensions.noInvisibleAdvance = true;
      }
      
      public var mcMainListModule:DropdownListModuleBase;
      
      public var mcTextAreaModule:TextAreaModuleCustomInput;
      
      public var mcModuleEntryImage:GlossaryTextureSubListModule;
      
      public var mcImageAnchor:MovieClip;
      
      protected var _imageLoader:UILoader;
      
      public function GlossaryBooksMenu()
      {
         super();
         this.mcMainListModule.selectModuleOnClick = true;
         this.mcMainListModule.menuName = this.menuName;
         this.mcMainListModule.sortFunc = this.sortGroupListFunction;
         this.mcMainListModule.mcDropDownList.addEventListener(ListEvent.INDEX_CHANGE,this.handleSelectChange,false,0,true);
         W3DropdownMenuListItem.staticSortedFunction = this.sortListFunction;
         this.__setProp_mcMainListModule_Scene1_dropdown_0();
      }
      
      override protected function get menuName() : String
      {
         return "GlossaryBooksMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         focused = 1;
         this.mcTextAreaModule.visible = false;
         currentModuleIdx = 0;
         this.mcModuleEntryImage.visible = false;
         this.mcModuleEntryImage.enabled = false;
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
      }
      
      public function handleSelectChange(param1:ListEvent) : void
      {
         var _loc2_:IconItemRenderer = null;
         var _loc3_:String = null;
         _loc2_ = param1.itemRenderer as IconItemRenderer;
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            removeChild(this._imageLoader);
            this._imageLoader = null;
         }
         if(_loc2_)
         {
            _loc3_ = CommonUtils.fixFontStyleTags(_loc2_.data.text);
            this.mcTextAreaModule.SetText(_loc3_);
            this.mcTextAreaModule.SetTitle(_loc2_.data.label);
            this.mcTextAreaModule.visible = true;
            if(_loc2_.data.isPainting)
            {
               this._imageLoader = new UILoader();
               this._imageLoader.source = _loc2_.data.imagePath;
               this._imageLoader.x = this.mcImageAnchor.x;
               this._imageLoader.y = this.mcImageAnchor.y;
               addChild(this._imageLoader);
            }
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnReadBook",[_loc2_.data.itemId]));
         }
         else
         {
            this.mcTextAreaModule.visible = false;
         }
      }
      
      public function sortGroupListFunction(param1:Array) : void
      {
         param1.sortOn("sortIdx");
      }
      
      public function sortListFunction(param1:Array) : void
      {
         param1.sortOn(["isNew","sortIdx"],Array.DESCENDING);
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:UIComponent = null;
         if(param1.handled)
         {
            return;
         }
         for each(_loc2_ in actualModules)
         {
            if(param1.handled)
            {
               param1.stopImmediatePropagation();
               return;
            }
            _loc2_.handleInput(param1);
         }
         super.handleInput(param1);
      }
      
      internal function __setProp_mcMainListModule_Scene1_dropdown_0() : *
      {
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcMainListModule.DataBindingKey = "glossary.books.list";
         this.mcMainListModule.DropDownItemRendererClass = "IconDropDownListItem";
         this.mcMainListModule.DropDownListClass = "DropDownList";
         this.mcMainListModule.enabled = true;
         this.mcMainListModule.enableInitCallback = false;
         this.mcMainListModule.itemInputFeedbackLabel = "";
         this.mcMainListModule.ItemListClass = "W3ScrollingListNoBG";
         this.mcMainListModule.ItemRendererClass = "IconListItemRef";
         this.mcMainListModule.visible = true;
         try
         {
            this.mcMainListModule["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
