package red.game.witcher3.menus.glossary
{
   import red.core.CoreMenu;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.common.IconItemRenderer;
   import red.game.witcher3.menus.common.PlainListModule;
   import red.game.witcher3.menus.common.TextAreaModuleCustomInput;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   
   public class GlossaryEncyclopediaMenu extends CoreMenu
   {
       
      
      public var mcModuleList:PlainListModule;
      
      public var mcModuleEntryDesc:TextAreaModuleCustomInput;
      
      public var mcModuleEntryImage:GlossaryTextureSubListModule;
      
      public function GlossaryEncyclopediaMenu()
      {
         super();
      }
      
      override protected function get menuName() : String
      {
         return "GlossaryEncyclopediaMenu";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         focused = 1;
         currentModuleIdx = 0;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"glossary.encyclopedia.list",[this.handleListData]));
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.mcModuleList.mcScrollingList.addEventListener(ListEvent.INDEX_CHANGE,this.handleIndexChanged,false,0,true);
      }
      
      override public function ShowSecondaryModules(param1:Boolean) : *
      {
         super.ShowSecondaryModules(param1);
         this.mcModuleEntryDesc.active = param1;
         this.mcModuleEntryImage.visible = param1;
         this.mcModuleEntryImage.enabled = param1;
      }
      
      public function setEntryText(param1:String, param2:String) : void
      {
         if(param1 != "" || param2 != "")
         {
            this.mcModuleEntryDesc.visible = true;
            this.mcModuleEntryDesc.SetTitle(param1);
            this.mcModuleEntryDesc.SetText(param2);
         }
         else
         {
            this.mcModuleEntryDesc.visible = false;
         }
         this.mcModuleEntryDesc.validateNow();
         if(Boolean(this.mcModuleEntryDesc.focused) && !this.mcModuleEntryDesc.hasSelectableItems())
         {
            currentModuleIdx = 0;
         }
      }
      
      public function setEntryImg(param1:String) : void
      {
         if(param1 == "")
         {
            this.mcModuleEntryImage.visible = false;
         }
         else
         {
            this.mcModuleEntryImage.visible = true;
            this.mcModuleEntryImage.setImage(param1);
         }
      }
      
      protected function handleListData(param1:Array) : void
      {
         this.mcModuleList.data = param1;
      }
      
      protected function handleIndexChanged(param1:ListEvent) : void
      {
         var _loc2_:IconItemRenderer = this.mcModuleList.mcScrollingList.getSelectedRenderer() as IconItemRenderer;
         if(Boolean(_loc2_) && Boolean(_loc2_.data))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEntrySelected",[_loc2_.data.tag]));
         }
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
   }
}
