package fl.controls.listClasses
{
   public interface ICellRenderer
   {
       
      
      function set y(param1:Number) : void;
      
      function set x(param1:Number) : void;
      
      function setSize(param1:Number, param2:Number) : void;
      
      function get listData() : ListData;
      
      function set listData(param1:ListData) : void;
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function get selected() : Boolean;
      
      function set selected(param1:Boolean) : void;
      
      function setMouseState(param1:String) : void;
   }
}
