package red.game.witcher3.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.net.URLRequest;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.controls.UILoader;
   
   public class W3UILoader extends UILoader
   {
       
      
      public var fallbackIconPath:String = "icons/inventory/raspberryjuice_64x64.dds";
      
      private var tmpHackTextField:Label;
      
      private var fallbackLoad:Boolean = true;
      
      private var _gridSize:int = 0;
      
      public function W3UILoader()
      {
         super();
      }
      
      override protected function handleLoadIOError(param1:Event) : void
      {
         if(this.fallbackLoad)
         {
            this.unload();
            loader.load(new URLRequest(this.fallbackIconPath));
            visible = true;
            this.fallbackLoad = false;
            return;
         }
      }
      
      override public function set source(param1:String) : void
      {
         this.fallbackLoad = true;
         if(super.source != param1)
         {
            super.source = param1;
         }
         if(Boolean(param1) && param1 != "")
         {
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      override public function unload() : void
      {
         super.unload();
         if(this.tmpHackTextField)
         {
            this.tmpHackTextField.visible = false;
            removeChild(this.tmpHackTextField);
         }
      }
      
      override public function get content() : DisplayObject
      {
         if(loader.content == null)
         {
            return null;
         }
         return loader.content;
      }
      
      override public function toString() : String
      {
         return "[W3 W3UILoader " + name + "]";
      }
      
      public function set GridSize(param1:int) : void
      {
         this._gridSize = param1;
      }
      
      public function get GridSize() : int
      {
         return this._gridSize;
      }
      
      override protected function draw() : void
      {
         if(!_loadOK)
         {
            return;
         }
         if(this.GridSize > 0 && isInvalid(InvalidationType.SIZE))
         {
            loader.scaleX = loader.scaleY = 1;
            visible = _visiblilityBeforeLoad;
            if(this.GridSize > 3)
            {
               loader.height = this.GridSize / 2 * 64;
               loader.width = this.GridSize / 2 * 64;
            }
            else
            {
               loader.height = this.GridSize * 64;
               loader.width = 64;
            }
         }
         else
         {
            super.draw();
         }
      }
   }
}
