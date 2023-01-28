package fl.controls.listClasses
{
   import fl.controls.LabelButton;
   import flash.events.MouseEvent;
   
   public class CellRenderer extends LabelButton implements ICellRenderer
   {
      
      private static var defaultStyles:Object = {
         "upSkin":"CellRenderer_upSkin",
         "downSkin":"CellRenderer_downSkin",
         "overSkin":"CellRenderer_overSkin",
         "disabledSkin":"CellRenderer_disabledSkin",
         "selectedDisabledSkin":"CellRenderer_selectedDisabledSkin",
         "selectedUpSkin":"CellRenderer_selectedUpSkin",
         "selectedDownSkin":"CellRenderer_selectedDownSkin",
         "selectedOverSkin":"CellRenderer_selectedOverSkin",
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":null,
         "textPadding":5
      };
       
      
      protected var _listData:ListData;
      
      protected var _data:Object;
      
      public function CellRenderer()
      {
         super();
         toggle = true;
         focusEnabled = false;
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
      }
      
      public function get listData() : ListData
      {
         return _listData;
      }
      
      public function set listData(param1:ListData) : void
      {
         _listData = param1;
         label = _listData.label;
         setStyle("icon",_listData.icon);
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
      }
      
      override public function get selected() : Boolean
      {
         return super.selected;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
      }
      
      override protected function toggleSelected(param1:MouseEvent) : void
      {
      }
      
      override protected function drawLayout() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = Number(getStyleValue("textPadding"));
         var _loc2_:Number = 0;
         if(icon != null)
         {
            icon.x = _loc1_;
            icon.y = Math.round(height - icon.height >> 1);
            _loc2_ = icon.width + _loc1_;
         }
         if(label.length > 0)
         {
            textField.visible = true;
            _loc3_ = Math.max(0,width - _loc2_ - _loc1_ * 2);
            textField.width = _loc3_;
            textField.height = textField.textHeight + 4;
            textField.x = _loc2_ + _loc1_;
            textField.y = Math.round(height - textField.height >> 1);
         }
         else
         {
            textField.visible = false;
         }
         background.width = width;
         background.height = height;
      }
   }
}
