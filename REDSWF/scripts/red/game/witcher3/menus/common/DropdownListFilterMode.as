package red.game.witcher3.menus.common
{
   public class DropdownListFilterMode extends CheckboxListMode
   {
       
      
      public function DropdownListFilterMode()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         var _loc1_:Array = null;
         super.configUI();
         mcTitle.text = "[[gui_panel_filter_by]]";
         _loc1_ = [{
            "key":"HasIngredients",
            "label":"[[gui_panel_filter_has_ingredients]]",
            "isChecked":true
         },{
            "key":"MissingIngredients",
            "label":"[[gui_panel_filter_elements_missing]]",
            "isChecked":true
         },{
            "key":"AlreadyCrafted",
            "label":"[[gui_panel_filter_already_crafted]]",
            "isChecked":true
         }];
         setData(_loc1_);
      }
   }
}
