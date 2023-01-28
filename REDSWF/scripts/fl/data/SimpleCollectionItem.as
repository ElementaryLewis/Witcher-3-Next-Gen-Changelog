package fl.data
{
   public dynamic class SimpleCollectionItem
   {
       
      
      public var label:String;
      
      public var data:String;
      
      public function SimpleCollectionItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[SimpleCollectionItem: " + label + "," + data + "]";
      }
   }
}
