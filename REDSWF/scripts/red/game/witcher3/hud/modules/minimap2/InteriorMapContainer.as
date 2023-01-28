package red.game.witcher3.hud.modules.minimap2
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   import scaleform.clik.core.UIComponent;
   
   public class InteriorMapContainer extends UIComponent
   {
       
      
      private var _interior:MinimapLoader;
      
      private var _interiorPosX:Number;
      
      private var _interiorPosY:Number;
      
      private var _interiorYaw:Number;
      
      private const PENDING_NOTHING:int = 0;
      
      private const PENDING_INTERIOR:int = 1;
      
      private const PENDING_EXTERIOR:int = 2;
      
      private var _pendingAction:int = 0;
      
      private var _pendingInteriorPosX:Number;
      
      private var _pendingInteriorPosY:Number;
      
      private var _pendingInteriorYaw:Number;
      
      private var _pendingInteriorTexture:String;
      
      public function InteriorMapContainer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._interior = new MinimapLoader();
         this._interior.autoSize = false;
         this._interior.addEventListener(Event.COMPLETE,this.handleTextureLoaded,false,0,true);
         this._interior.addEventListener(IOErrorEvent.IO_ERROR,this.handleTextureFailed,false,0,true);
      }
      
      public function NotifyPlayerEnteredInterior(param1:Number, param2:Number, param3:Number, param4:String) : *
      {
         var _loc5_:String = null;
         if(this._interior.IsLoading())
         {
            this._pendingAction = this.PENDING_INTERIOR;
            this._pendingInteriorPosX = param1;
            this._pendingInteriorPosY = param2;
            this._pendingInteriorYaw = param3;
            this._pendingInteriorTexture = param4;
            return;
         }
         _loc5_ = "img://" + param4;
         if(this._interior.source != _loc5_)
         {
            this._interior.source = _loc5_;
            addChild(this._interior);
            this._interior.x = 0;
            this._interior.y = 0;
         }
         this._interiorPosX = param1;
         this._interiorPosY = param2;
         this._interiorYaw = param3;
         rotation = -this._interiorYaw;
      }
      
      public function NotifyPlayerExitedInterior() : *
      {
         if(this._interior.IsLoading())
         {
            this._pendingAction = this.PENDING_EXTERIOR;
            return;
         }
         this._interior.source = "";
      }
      
      private function handleTextureLoaded(param1:Event) : *
      {
         var _loc2_:Bitmap = Bitmap(param1.currentTarget.content);
         this._interior.x = -_loc2_.width / 2;
         this._interior.y = -_loc2_.height / 2;
         this._interior.visible = true;
         this._interior.OnLoadingComplete();
         this.RunPendingAction();
      }
      
      protected function handleTextureFailed(param1:Event) : void
      {
         this._interior.OnLoadingError();
         this.RunPendingAction();
      }
      
      private function RunPendingAction() : *
      {
         if(this._pendingAction == this.PENDING_INTERIOR)
         {
            this._pendingAction = this.PENDING_NOTHING;
            this.NotifyPlayerEnteredInterior(this._pendingInteriorPosX,this._pendingInteriorPosY,this._pendingInteriorYaw,this._pendingInteriorTexture);
         }
         else if(this._pendingAction == this.PENDING_EXTERIOR)
         {
            this._pendingAction = this.PENDING_NOTHING;
            this.NotifyPlayerExitedInterior();
         }
      }
      
      public function UpdatePosition() : *
      {
         x = HudModuleMinimap2.WorldToInteriorMapX(this._interiorPosX - HudModuleMinimap2.m_playerWorldPosX);
         y = HudModuleMinimap2.WorldToInteriorMapY(this._interiorPosY - HudModuleMinimap2.m_playerWorldPosY);
      }
   }
}
