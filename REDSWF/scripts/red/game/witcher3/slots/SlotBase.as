package red.game.witcher3.slots
{
   import com.gskinner.motion.GTweener;
   import fl.transitions.easing.Strong;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.controls.W3UILoaderSlot;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.managers.ContextInfoManager;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.ColorSprite;
   import red.game.witcher3.menus.inventory.InventorySlotOverlay;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.UILoader;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.ListData;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotBase extends UIComponent implements IBaseSlot, IDragTarget
   {
      
      protected static const INVALIDATE_TOOLTIP_HIDE:String = "INVALIDATE_TOOLTIP_HIDE";
      
      protected static const INVALIDATE_TOOLTIP_SHOW:String = "INVALIDATE_TOOLTIP_SHOW";
      
      protected static const NO_IMAGE_SPRITE_REF:String = "ImageStubRef";
      
      protected static const DISABLED_ACTION_ALPHA:Number = 0.6;
      
      protected static const BOOK_READED_ALPHA:Number = 0.3;
      
      protected static const DRAG_ALPHA:Number = 0.5;
      
      protected static const DISABLE_ALPHA:Number = 0.5;
      
      protected static const OVER_GLOW_COLOR:Number = 15990722;
      
      protected static const OVER_GLOW_BLUR:Number = 15;
      
      protected static const OVER_GLOW_STRENGHT:Number = 0.75;
      
      protected static const INDICATE_ANIM_SCALE:Number = 1;
      
      protected static const ICON_FILTER_TIMER:Number = 300;
      
      protected static const RECT_MARGIN:Number = 0;
      
      public static var NEW_FLAG_CLEARED:String = "New Flag reset on item";
      
      public static var AUTO_SHOW_COLLAPSED_ICON:Boolean = false;
      
      public static var OPT_MODE:Boolean = false;
       
      
      protected var INDICATE_ANIM_DURATION:Number = 1.5;
      
      public var mcSlotOverlays:InventorySlotOverlay;
      
      public var mcHitArea:MovieClip;
      
      public var mcSizeAnchor:Sprite;
      
      public var mcFrame:MovieClip;
      
      public var mcStateSelectedActive:MovieClip;
      
      public var mcStateSelectedPassive:MovieClip;
      
      public var mcStateDropTarget:MovieClip;
      
      public var mcStateDropReady:MovieClip;
      
      public var mcColorBackground:ColorSprite;
      
      public var mcBackground:MovieClip;
      
      public var mcCantEquipIcon:MovieClip;
      
      protected var _indicators:Vector.<MovieClip>;
      
      protected var _imageLoader:W3UILoaderSlot;
      
      protected var _imageStub:UIComponent;
      
      protected var _loadedImagePath:String;
      
      protected var _data:Object;
      
      protected var _index:uint;
      
      protected var _gridSize:int = 1;
      
      protected var _owner:UIComponent;
      
      protected var _currentIdicator:MovieClip;
      
      protected var _ownerFocused:Boolean;
      
      protected var _selected:Boolean;
      
      protected var _highlight:Boolean;
      
      protected var _over:Boolean;
      
      protected var _dropSelection:Boolean;
      
      protected var _dragSelection:Boolean;
      
      protected var _isEmpty:Boolean;
      
      protected var _isGamepad:Boolean;
      
      protected var _selectable:Boolean = true;
      
      protected var _imageLoaded:Boolean;
      
      protected var _isTargetsSelected:Boolean;
      
      protected var _glowFilter:GlowFilter;
      
      protected var _desaturateFilter:ColorMatrixFilter;
      
      protected var _warningFilter:ColorMatrixFilter;
      
      protected var _iconFilterTimer:Timer;
      
      protected var _defaultTooltipAnchor:String = "tooltipLeftAnchor";
      
      protected var _tooltipAlignment:String = "Right";
      
      protected var _showCollapsedTooltipIcon:Boolean;
      
      protected var _mcCollapsedTooltipIcon:MovieClip;
      
      public var awaitingCompleteValidation:Boolean = false;
      
      protected var _navigationUp:int;
      
      protected var _navigationRight:int;
      
      protected var _navigationDown:int;
      
      protected var _navigationLeft:int;
      
      protected var _draggingEnabled:Boolean = true;
      
      public var _unprocessedNewFlagRemoval:Boolean = false;
      
      protected var _useContextMgr:Boolean = true;
      
      protected var _activeSelectionEnabled:Boolean = true;
      
      protected var _validationBounds:Rectangle = null;
      
      protected var initValidation:Boolean = false;
      
      protected var _forceNextValidation:Boolean = false;
      
      protected var _tooltipRequested:Boolean;
      
      public function SlotBase()
      {
         super();
         this._isEmpty = true;
         if(!OPT_MODE)
         {
            this.constructor_init();
         }
      }
      
      public function get showCollapsedTooltipIcon() : Boolean
      {
         return this._showCollapsedTooltipIcon;
      }
      
      public function set showCollapsedTooltipIcon(param1:Boolean) : void
      {
         var _loc2_:ContextInfoManager = null;
         if(this._showCollapsedTooltipIcon != param1)
         {
            _loc2_ = ContextInfoManager.getInstanse();
            this._showCollapsedTooltipIcon = param1;
            if(this._mcCollapsedTooltipIcon)
            {
               this.updateToggledToolipIcon();
               _loc2_.removeEventListener(ContextInfoManager.EVENT_TOOLTIP_HIDDEN,this.handleTooltipHidden);
               _loc2_.removeEventListener(ContextInfoManager.EVENT_TOOLTIP_SHOWN,this.handleTooltipShown);
               if(this._showCollapsedTooltipIcon)
               {
                  _loc2_.addEventListener(ContextInfoManager.EVENT_TOOLTIP_HIDDEN,this.handleTooltipHidden,false,0,true);
                  _loc2_.addEventListener(ContextInfoManager.EVENT_TOOLTIP_SHOWN,this.handleTooltipShown,false,0,true);
               }
            }
         }
      }
      
      protected function handleTooltipHidden(param1:Event) : void
      {
         this.updateToggledToolipIcon();
      }
      
      protected function handleTooltipShown(param1:Event) : void
      {
         this.updateToggledToolipIcon();
      }
      
      protected function updateToggledToolipIcon() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this._mcCollapsedTooltipIcon)
         {
            _loc1_ = this._showCollapsedTooltipIcon && ContextInfoManager.getInstanse().isHidden() && enabled;
            _loc2_ = Boolean(this._owner) && (Boolean(this._owner.focused) || !this._owner.focusable);
            this._mcCollapsedTooltipIcon.visible = _loc1_ && _loc2_ && this._selected && this._activeSelectionEnabled;
         }
      }
      
      public function get navigationUp() : int
      {
         return this._navigationUp;
      }
      
      public function set navigationUp(param1:int) : void
      {
         this._navigationUp = param1;
      }
      
      public function get navigationRight() : int
      {
         return this._navigationRight;
      }
      
      public function set navigationRight(param1:int) : void
      {
         this._navigationRight = param1;
      }
      
      public function get navigationDown() : int
      {
         return this._navigationDown;
      }
      
      public function set navigationDown(param1:int) : void
      {
         this._navigationDown = param1;
      }
      
      public function get navigationLeft() : int
      {
         return this._navigationLeft;
      }
      
      public function set navigationLeft(param1:int) : void
      {
         this._navigationLeft = param1;
      }
      
      public function get gridSize() : int
      {
         return this._gridSize;
      }
      
      public function set gridSize(param1:int) : void
      {
         this._gridSize = param1;
         invalidateSize();
      }
      
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._selectable = param1;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function get draggingEnabled() : Boolean
      {
         return this._draggingEnabled;
      }
      
      public function set draggingEnabled(param1:Boolean) : void
      {
         this._draggingEnabled = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected && this._selected != param1)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnPlaySoundEvent",["gui_global_highlight"]));
         }
         this._selected = param1;
         if(this.mcSlotOverlays)
         {
            if(this.activeSelectionEnabled)
            {
               this.clearNewFlag();
            }
         }
         if(this.selectingTooltipShowCheck())
         {
            if(this._selected)
            {
               this.showTooltip();
            }
            else
            {
               this.hideTooltip();
            }
         }
         invalidateState();
      }
      
      protected function selectingTooltipShowCheck() : Boolean
      {
         return InputManager.getInstance().isGamepad();
      }
      
      protected function clearNewFlag() : void
      {
         if(this._data && this._data.hasOwnProperty("isNew") && Boolean(this._data.isNew))
         {
            this._data.isNew = false;
            this._unprocessedNewFlagRemoval = true;
            this.mcSlotOverlays.SetIsNew(false);
            this.mcSlotOverlays.updateIcons();
            dispatchEvent(new Event(NEW_FLAG_CLEARED));
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnClearSlotNewFlag",[this.data.id]));
         }
      }
      
      public function get dragSelection() : Boolean
      {
         return this._dragSelection;
      }
      
      public function set dragSelection(param1:Boolean) : void
      {
         this._dragSelection = param1;
         invalidateState();
         if(this._dragSelection && this._tooltipRequested)
         {
            this.fireTooltipHideEvent();
         }
         this._over = false;
         invalidateState();
      }
      
      public function get useContextMgr() : Boolean
      {
         return this._useContextMgr;
      }
      
      public function set useContextMgr(param1:Boolean) : void
      {
         this._useContextMgr = param1;
      }
      
      public function get owner() : UIComponent
      {
         return this._owner;
      }
      
      public function set owner(param1:UIComponent) : void
      {
         if(this._owner != param1)
         {
            if(this._owner)
            {
               this._owner.removeEventListener(FocusEvent.FOCUS_IN,this.handelOwnerFocusIn);
               this._owner.removeEventListener(FocusEvent.FOCUS_OUT,this.handelOwnerFocusOut);
            }
            this._owner = param1;
            if(this._owner)
            {
               this._owner.addEventListener(FocusEvent.FOCUS_IN,this.handelOwnerFocusIn,false,0,true);
               this._owner.addEventListener(FocusEvent.FOCUS_OUT,this.handelOwnerFocusOut,false,0,true);
               this._ownerFocused = this._owner.focused > 0;
            }
         }
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         if(param1)
         {
            this._data = param1;
            this._isEmpty = false;
            this.awaitingCompleteValidation = true;
            this.gridSize = this._data.gridSize;
            this.data_set_init();
         }
      }
      
      protected function data_set_init() : void
      {
         if(this.selected && this.selectingTooltipShowCheck())
         {
            this.fireTooltipShowEvent();
         }
         invalidateData();
         SlotsTransferManager.getInstance().addDragTarget(this);
      }
      
      public function get activeSelectionEnabled() : Boolean
      {
         var _loc1_:SlotsListBase = null;
         if(this._activeSelectionEnabled)
         {
            _loc1_ = parent as SlotsListBase;
            if(!_loc1_ || _loc1_.activeSelectionVisible)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set activeSelectionEnabled(param1:Boolean) : void
      {
         this._activeSelectionEnabled = param1;
         invalidateState();
         if(this.selectingTooltipShowCheck())
         {
            if(param1 && this.selected && this.isParentEnabled())
            {
               this.fireTooltipShowEvent(false);
            }
            else
            {
               this.fireTooltipHideEvent(false);
            }
         }
         if(this.activeSelectionEnabled && this.selected)
         {
            this.clearNewFlag();
         }
      }
      
      protected function setBackgroundColor() : void
      {
         this.mcColorBackground.setByItemQuality(this._data.quality);
      }
      
      public function GetNavigationIndex(param1:String) : int
      {
         switch(param1)
         {
            case NavigationCode.UP:
               return this._navigationUp;
            case NavigationCode.RIGHT:
               return this._navigationRight;
            case NavigationCode.DOWN:
               return this._navigationDown;
            case NavigationCode.LEFT:
               return this._navigationLeft;
            default:
               return -1;
         }
      }
      
      public function cleanup() : void
      {
         this.unloadIcon();
         var _loc1_:SlotsTransferManager = SlotsTransferManager.getInstance();
         _loc1_.removeDragTarget(this);
         this._data = null;
         this._isEmpty = true;
         if(this.selected)
         {
            if(this.selectingTooltipShowCheck())
            {
               this.hideTooltip();
            }
            else if(this._tooltipRequested)
            {
               this.fireTooltipHideEvent();
            }
         }
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.visible = false;
         }
         if(this.mcColorBackground)
         {
            this.mcColorBackground.visible = false;
         }
         if(this.mcCantEquipIcon)
         {
            this.mcCantEquipIcon.visible = false;
         }
         if(this.isOver() && !this._isGamepad)
         {
            SlotsTransferManager.getInstance().hideDropTargets();
         }
         this._over = false;
      }
      
      public function isEmpty() : Boolean
      {
         return this._isEmpty;
      }
      
      public function getHitArea() : DisplayObject
      {
         return !!this.mcHitArea ? this.mcHitArea : this;
      }
      
      public function getAvatar() : UILoader
      {
         if(this._imageLoader)
         {
            return this._imageLoader;
         }
         return null;
      }
      
      public function canDrag() : Boolean
      {
         return this._draggingEnabled;
      }
      
      public function getDragData() : *
      {
         return this.data;
      }
      
      public function executeAction(param1:Number, param2:InputEvent) : Boolean
      {
         if(this.canExecuteAction())
         {
            this.executeDefaultAction(param1,param2);
            return true;
         }
         return false;
      }
      
      public function getGlobalSlotRect() : Rectangle
      {
         var _loc1_:Rectangle = this.getSlotRect();
         var _loc2_:Point = localToGlobal(new Point(_loc1_.x,_loc1_.y));
         _loc1_.x = _loc2_.x + RECT_MARGIN;
         _loc1_.y = _loc2_.y + RECT_MARGIN;
         return _loc1_;
      }
      
      public function getSlotRect() : Rectangle
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = NaN;
         if(this.mcSizeAnchor)
         {
            _loc1_ = new Rectangle(this.mcSizeAnchor.x,this.mcSizeAnchor.y,this.mcSizeAnchor.width,this.mcSizeAnchor.height);
         }
         else
         {
            _loc2_ = CommonConstants.INVENTORY_GRID_SIZE;
            _loc1_ = new Rectangle(0,0,_loc2_,_loc2_ * this._gridSize);
         }
         return _loc1_;
      }
      
      public function isOver() : Boolean
      {
         return this._over;
      }
      
      protected function constructor_init_call() : void
      {
      }
      
      protected function constructor_init() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this._indicators = new Vector.<MovieClip>();
         this._warningFilter = CommonUtils.getRedWarningFilter();
         this._glowFilter = new GlowFilter(OVER_GLOW_COLOR,1,OVER_GLOW_BLUR,OVER_GLOW_BLUR,OVER_GLOW_STRENGHT,BitmapFilterQuality.HIGH);
         this._desaturateFilter = CommonUtils.getDesaturateFilter();
         if(OPT_MODE)
         {
         }
         if(this.mcCantEquipIcon)
         {
            this.mcCantEquipIcon.visible = false;
         }
         if(this.mcColorBackground)
         {
            this.mcColorBackground.visible = false;
         }
         if(this.mcSlotOverlays)
         {
            this.mcSlotOverlays.visible = false;
         }
         if(this.mcStateSelectedActive)
         {
            this._indicators.push(this.mcStateSelectedActive);
         }
         if(this.mcStateSelectedPassive)
         {
            this._indicators.push(this.mcStateSelectedPassive);
         }
         if(this.mcStateDropTarget)
         {
            this._indicators.push(this.mcStateDropTarget);
         }
         if(this.mcStateDropReady)
         {
            this._indicators.push(this.mcStateDropReady);
         }
         var _loc1_:int = int(this._indicators.length);
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._indicators[_loc2_];
            _loc3_.mouseEnabled = false;
            _loc3_.mouseChildren = false;
            _loc3_.alpha = 0;
            _loc2_++;
         }
         if(this.mcSlotOverlays)
         {
            this._mcCollapsedTooltipIcon = this.mcSlotOverlays.mcCollapsedTooltipIcon;
         }
         this.initCollapsedIconBehavior();
      }
      
      protected function initCollapsedIconBehavior() : void
      {
         if(AUTO_SHOW_COLLAPSED_ICON && Boolean(this._mcCollapsedTooltipIcon))
         {
            this.showCollapsedTooltipIcon = true;
         }
      }
      
      protected function resetIndicators() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc1_:int = int(this._indicators.length);
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._indicators[_loc2_];
            GTweener.removeTweens(_loc3_);
            _loc3_.alpha = 0;
            _loc2_++;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(!OPT_MODE)
         {
            this.config_init_call();
         }
      }
      
      protected function config_init_call() : *
      {
         doubleClickEnabled = true;
         var _loc1_:MovieClip = this.getHitArea() as MovieClip;
         _loc1_.doubleClickEnabled = true;
         _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut,false,0,true);
         _loc1_.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleMouseDoubleClick,false,0,true);
         _loc1_.addEventListener(MouseEvent.CLICK,this.handleMouseClick,false,0,true);
         this._isGamepad = InputManager.getInstance().isGamepad();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
      }
      
      public function set validationBounds(param1:Rectangle) : void
      {
         this._validationBounds = param1;
      }
      
      public function canBeValidated() : Boolean
      {
         return this._validationBounds == null || getBounds(stage).intersects(this._validationBounds);
      }
      
      override public function validateNow(param1:Event = null) : void
      {
         if((!initialized || _invalid) && this.canBeValidated())
         {
            if(!this.initValidation)
            {
               this.initValidation = true;
               if(OPT_MODE)
               {
                  this.constructor_init();
                  this.config_init_call();
                  this.data_set_init();
               }
            }
            super.validateNow();
         }
      }
      
      public function forceValidateNow() : void
      {
         this._forceNextValidation = true;
         super.validateNow();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this._validationBounds == null || getBounds(stage).intersects(this._validationBounds);
         if(this._forceNextValidation)
         {
            this._forceNextValidation = false;
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this.awaitingCompleteValidation = false;
            super.draw();
            if(isInvalid(InvalidationType.DATA) && Boolean(this._data))
            {
               this.updateData();
            }
            if(isInvalid(InvalidationType.STATE))
            {
               this.updateState();
            }
            if(isInvalid(InvalidationType.SIZE))
            {
               this.updateSize();
            }
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(!param1 && this._tooltipRequested)
         {
            this.hideTooltip();
         }
         super.enabled = param1;
         invalidateState();
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(this.useContextMgr && !_loc2_)
         {
            this.updateMouseContext();
         }
         if(!this._over && !_loc2_ && this.selectable && !SlotsTransferManager.getInstance().isDragging())
         {
            this._over = true;
            this.fireTooltipShowEvent(true);
         }
         invalidateState();
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(this._over && !_loc2_ && this.selectable && !SlotsTransferManager.getInstance().isDragging())
         {
            this._over = false;
            this.fireTooltipHideEvent(true);
         }
         invalidateState();
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
      }
      
      protected function updateMouseContext() : void
      {
      }
      
      protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            if(this.canExecuteAction())
            {
               this.executeDefaultAction(KeyCode.PAD_A_CROSS,null);
            }
         }
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
      }
      
      protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this._isGamepad = param1.isGamepad;
         invalidateState();
      }
      
      protected function handelOwnerFocusIn(param1:FocusEvent) : void
      {
         this._ownerFocused = true;
         invalidateState();
      }
      
      protected function handelOwnerFocusOut(param1:FocusEvent) : void
      {
         this._ownerFocused = false;
         invalidateState();
      }
      
      public function showTooltip() : void
      {
         if(this.selectingTooltipShowCheck() && this.isParentEnabled())
         {
            removeEventListener(Event.ENTER_FRAME,this.pendedTooltipShow);
            removeEventListener(Event.ENTER_FRAME,this.pendedTooltipHide);
            addEventListener(Event.ENTER_FRAME,this.pendedTooltipShow,false,0,true);
         }
      }
      
      public function hideTooltip() : void
      {
         if(this.selectingTooltipShowCheck() && this.isParentEnabled())
         {
            removeEventListener(Event.ENTER_FRAME,this.pendedTooltipShow);
            removeEventListener(Event.ENTER_FRAME,this.pendedTooltipHide);
            addEventListener(Event.ENTER_FRAME,this.pendedTooltipHide,false,0,true);
         }
      }
      
      protected function pendedTooltipShow(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendedTooltipShow);
         if(this.selectable)
         {
            this.fireTooltipShowEvent(false);
         }
      }
      
      protected function pendedTooltipHide(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.pendedTooltipHide);
         if(this.selectable)
         {
            this.fireTooltipHideEvent(false);
         }
      }
      
      protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if((this.activeSelectionEnabled || !this._isGamepad) && this._data && this.isParentEnabled())
         {
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,this.index,-1,-1,null,this._data as Object);
            _loc2_.isMouseTooltip = param1;
            _loc2_.anchorRect = this.getGlobalSlotRect();
            _loc2_.defaultAnchor = this._defaultTooltipAnchor;
            _loc2_.tooltipAlignment = CommonConstants.ALIGNMENT_RIGHT;
            if(!this._data.showExtendedTooltip)
            {
               _loc2_.tooltipContentRef = "ItemDescriptionTooltipRef";
            }
            _loc2_.tooltipMouseContentRef = "ItemTooltipRef_mouse";
            dispatchEvent(_loc2_);
            this._tooltipRequested = true;
            this.clearNewFlag();
         }
      }
      
      protected function fireTooltipHideEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if(this._tooltipRequested)
         {
            _loc2_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,this.index,-1,-1,null,this._data as Object);
            dispatchEvent(_loc2_);
            this._tooltipRequested = false;
         }
      }
      
      protected function updateState() : void
      {
         var _loc3_:Object = null;
         if(!enabled)
         {
            if(this._currentIdicator)
            {
               this._currentIdicator.visible = false;
               this._currentIdicator = null;
            }
            if(this.mcFrame)
            {
               this.mcFrame.alpha = DISABLE_ALPHA;
            }
            this.updateImageLoaderStates();
            this.updateToggledToolipIcon();
            return;
         }
         if(this.mcFrame)
         {
            this.mcFrame.alpha = 1;
         }
         var _loc1_:MovieClip = this.getTargetIndicator();
         var _loc2_:Object = {"alpha":1};
         if(_loc1_ != this._currentIdicator)
         {
            if(this._currentIdicator)
            {
               _loc3_ = {"alpha":0};
               GTweener.removeTweens(this._currentIdicator);
               GTweener.to(this._currentIdicator,this.INDICATE_ANIM_DURATION,_loc3_,{"ease":Strong.easeOut});
            }
            this._currentIdicator = _loc1_;
            if(this._currentIdicator)
            {
               this._currentIdicator.visible = true;
               this._currentIdicator.alpha = 0;
               GTweener.removeTweens(this._currentIdicator);
               GTweener.to(this._currentIdicator,this.INDICATE_ANIM_DURATION,_loc2_,{"ease":Strong.easeOut});
            }
         }
         else if(Boolean(this._currentIdicator) && (this._currentIdicator.visible == false || this._currentIdicator.alpha == 0))
         {
            this._currentIdicator.visible = true;
            this._currentIdicator.alpha = 0;
            GTweener.removeTweens(this._currentIdicator);
            GTweener.to(this._currentIdicator,this.INDICATE_ANIM_DURATION,_loc2_,{"ease":Strong.easeOut});
         }
         this.updateImageLoaderStates();
         this.updateToggledToolipIcon();
      }
      
      protected function updateImageLoaderStates() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Boolean = false;
         if(Boolean(this._imageLoader) && this._imageLoaded)
         {
            _loc1_ = [];
            _loc2_ = this._over && !this._isGamepad && !this._isEmpty;
            if(!this._dragSelection && !this._currentIdicator && _loc2_)
            {
               _loc1_.push(this._glowFilter);
            }
            if(Boolean(this._data) && Boolean(this._data.disableAction))
            {
               _loc1_.push(this._warningFilter);
               this._imageLoader.alpha = DISABLED_ACTION_ALPHA;
            }
            else if(this._dragSelection)
            {
               _loc1_.push(this._desaturateFilter);
               this._imageLoader.alpha = DRAG_ALPHA;
            }
            else if(Boolean(this._data) && Boolean(this._data.isReaded))
            {
               this._imageLoader.alpha = BOOK_READED_ALPHA;
            }
            else
            {
               this._imageLoader.alpha = 1;
            }
            this._imageLoader.filters = _loc1_;
         }
      }
      
      protected function updateData() : *
      {
         if(this._data)
         {
            if(this.mcCantEquipIcon)
            {
               this.mcCantEquipIcon.visible = this._data.cantEquip;
            }
            if(this.mcSlotOverlays)
            {
               this.mcSlotOverlays.visible = true;
               this.mcSlotOverlays.updateSlots(this._data.socketsCount,this._data.socketsUsedCount);
               if(this._data.charges)
               {
                  this.mcSlotOverlays.SetQuantity(this._data.charges);
               }
               else
               {
                  this.mcSlotOverlays.SetQuantity(this._data.quantity);
               }
               this.mcSlotOverlays.setPreviewIcon(this._data.isPreviewItem);
               this.mcSlotOverlays.setOilApplied(this._data.isOilApplied);
               this.mcSlotOverlays.SetNeedRepair(this._data.needRepair);
               this.mcSlotOverlays.SetIsNew(this._data.isNew);
               this.mcSlotOverlays.SetIsQuestItem(this._data.isQuest,this._data.questTag);
               this.mcSlotOverlays.SetEnchantment(this._data.enchanted,this._data.socketsCount);
               this.mcSlotOverlays.SetAppliedDyeColor(this._data.itemColor);
               this.mcSlotOverlays.SetDyePreview(this._data.isDyePreview);
               this.mcSlotOverlays.updateIcons();
            }
            if(this.mcColorBackground)
            {
               if(this._data.quality)
               {
                  this.mcColorBackground.visible = true;
                  this.setBackgroundColor();
                  this.mcColorBackground.colorBlind = CoreComponent.isColorBlindMode;
               }
            }
            if(this._data.iconPath != "")
            {
               if(this._loadedImagePath != this._data.iconPath || this._imageLoader == null)
               {
                  this._loadedImagePath = this._data.iconPath;
                  this.loadIcon(this._loadedImagePath);
               }
            }
            else
            {
               this.unloadIcon();
            }
         }
      }
      
      protected function updateSize() : *
      {
      }
      
      protected function getTargetIndicator() : MovieClip
      {
         if(this._selected)
         {
            if(this._owner && (this._owner.focused || !this._owner.focusable) && this._activeSelectionEnabled)
            {
               return this.mcStateSelectedActive;
            }
         }
         if(this._highlight && Boolean(this.mcStateDropReady))
         {
            return this.mcStateDropReady;
         }
         if(this._dropSelection)
         {
            return this.mcStateDropTarget;
         }
         if(this._selected && this._isGamepad)
         {
            return this.mcStateSelectedPassive;
         }
         return null;
      }
      
      protected function loadIcon(param1:String) : void
      {
         this.unloadIcon();
         this._imageLoader = new W3UILoaderSlot();
         if(this._data)
         {
            this._imageLoader.slotType = this._data.slotType;
         }
         this._imageLoader.maintainAspectRatio = false;
         this._imageLoader.autoSize = false;
         this._imageLoader.addEventListener(Event.COMPLETE,this.handleIconLoaded,false,0,true);
         this._imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadIOError,false,0,true);
         this._imageLoader.source = param1;
         this._imageLoader.mouseChildren = false;
         this._imageLoader.mouseEnabled = false;
         addChild(this._imageLoader);
         if(this.mcCantEquipIcon)
         {
            addChild(this.mcCantEquipIcon);
         }
         if(this.mcStateSelectedActive)
         {
            addChild(this.mcStateSelectedActive);
         }
         if(this.mcSlotOverlays)
         {
            addChild(this.mcSlotOverlays);
         }
         if(this.mcHitArea)
         {
            addChild(this.mcHitArea);
         }
      }
      
      protected function unloadIcon() : void
      {
         if(this._imageLoader)
         {
            this._imageLoader.unload();
            this._imageLoader.removeEventListener(Event.COMPLETE,this.handleIconLoaded);
            removeChild(this._imageLoader);
            this._imageLoader = null;
            this._loadedImagePath = "";
         }
         if(this._imageStub)
         {
            removeChild(this._imageStub);
            this._imageStub = null;
         }
         if(this._imageLoaded)
         {
            GTweener.removeTweens(this._imageLoader);
         }
         this._imageLoaded = false;
      }
      
      public function desaturateIcon(param1:Number) : void
      {
         this.filters = [CommonUtils.generateDesaturationFilter(param1)];
      }
      
      public function darkenIcon(param1:Number) : void
      {
         this.filters = [CommonUtils.generateDarkenFilter(param1)];
      }
      
      protected function handleLoadIOError(param1:Event) : void
      {
         var _loc2_:Class = null;
         try
         {
            _loc2_ = getDefinitionByName(NO_IMAGE_SPRITE_REF) as Class;
            this._imageStub = new _loc2_() as UIComponent;
            addChild(this._imageStub);
            this.fitImage(this._imageStub);
         }
         catch(er:Error)
         {
         }
      }
      
      protected function handleIconLoaded(param1:Event) : void
      {
         var _loc2_:Bitmap = Bitmap(param1.target.content);
         if(_loc2_)
         {
            _loc2_.smoothing = true;
            _loc2_.pixelSnapping = PixelSnapping.NEVER;
         }
         if(this._imageLoader)
         {
            this.fitImage(this._imageLoader);
         }
         if(this._iconFilterTimer)
         {
            this._iconFilterTimer.stop();
            this._iconFilterTimer.removeEventListener(TimerEvent.TIMER,this.handleIconFilter,false);
         }
         this._iconFilterTimer = new Timer(ICON_FILTER_TIMER,1);
         this._iconFilterTimer.addEventListener(TimerEvent.TIMER,this.handleIconFilter,false,0,true);
         this._iconFilterTimer.start();
      }
      
      protected function handleIconFilter(param1:TimerEvent) : void
      {
         this._imageLoaded = true;
         if(this._iconFilterTimer)
         {
            this._iconFilterTimer.stop();
            this._iconFilterTimer.removeEventListener(TimerEvent.TIMER,this.handleIconFilter,false);
            this._iconFilterTimer = null;
         }
         this.updateImageLoaderStates();
      }
      
      protected function fitImage(param1:UIComponent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Rectangle = this.getSlotRect();
         var _loc4_:Number = _loc2_.width / param1.actualWidth;
         var _loc5_:Number = _loc2_.height / param1.actualHeight;
         var _loc6_:Number = Math.min(_loc4_,_loc5_);
         param1.scaleX = param1.scaleY = _loc6_;
         param1.x = _loc2_.x + (_loc2_.width - param1.actualWidth) / 2;
         param1.y = _loc2_.y + (_loc2_.height - param1.actualHeight) / 2;
      }
      
      protected function canExecuteAction() : Boolean
      {
         return Boolean(this._data) && !this._isEmpty;
      }
      
      protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
      {
         if(!this.canExecuteAction())
         {
            return;
         }
         if(param1 == KeyCode.PAD_A_CROSS || param1 == KeyCode.ENTER || param1 == KeyCode.NUMPAD_ENTER || param1 == KeyCode.E || param1 == KeyCode.SPACE)
         {
            if(!this._data)
            {
               return;
            }
            if(param2)
            {
               param2.handled = true;
            }
            this.fireActionEvent(this._data.actionType);
            switch(this._data.actionType)
            {
               case InventoryActionType.EQUIP:
                  this.defaultSlotEquipAction(this._data);
                  break;
               case InventoryActionType.CONSUME:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnConsumeItem",[this._data.id]));
                  break;
               case InventoryActionType.READ:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnReadBook",[this._data.id]));
               case InventoryActionType.DROP:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnDropItem",[this._data.id,this._data.quantity]));
                  break;
               case InventoryActionType.TRANSFER:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnTransferItem",[this._data.id,this._data.quantity,-1]));
                  break;
               case InventoryActionType.SELL:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnSellItem",[this._data.id,this._data.quantity]));
                  break;
               case InventoryActionType.BUY:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuyItem",[this._data.id,this._data.quantity,-1]));
                  break;
               case InventoryActionType.REPAIR:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnRepairItem",[this._data.id]));
                  break;
               case InventoryActionType.SOCKET:
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnPutInSocket",[this._data.id]));
            }
         }
         else if(param1 == KeyCode.PAD_Y_TRIANGLE)
         {
            if(this._data.slotType != InventorySlotType.Potion1 && this._data.slotType != InventorySlotType.Potion2 && this._data.slotType != InventorySlotType.Petard1 && this._data.slotType != InventorySlotType.Petard2 && this._data.slotType != InventorySlotType.Quickslot1 && this._data.slotType != InventorySlotType.Quickslot2)
            {
               this.defaultSlotDropAction(this._data);
            }
            this.fireActionEvent(InventoryActionType.DROP);
         }
         else if(param1 == KeyCode.PAD_X_SQUARE)
         {
            this.fireActionEvent(InventoryActionType.SUB_ACTION,SlotActionEvent.EVENT_SECONDARY_ACTION);
         }
      }
      
      protected function defaultSlotEquipAction(param1:Object) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipItem",[param1.id,param1.slotType,param1.quantity]));
      }
      
      protected function defaultSlotDropAction(param1:Object) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnDropItem",[param1.id,param1.quantity]));
      }
      
      protected function fireActionEvent(param1:int, param2:String = "event_activate", param3:Boolean = false) : void
      {
         var _loc4_:SlotActionEvent;
         (_loc4_ = new SlotActionEvent(param2,true)).actionType = param1;
         _loc4_.targetSlot = this;
         _loc4_.isMouseEvent = param3;
         dispatchEvent(_loc4_);
      }
      
      override public function toString() : String
      {
         return "Slot [ " + this.name + ", activeSel: " + this.activeSelectionEnabled + " ]";
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
      
      protected function isParentEnabled() : Boolean
      {
         var _loc1_:UIComponent = this.owner as UIComponent;
         return !!_loc1_ ? _loc1_.enabled : true;
      }
      
      public function setListData(param1:ListData) : void
      {
      }
      
      public function setData(param1:Object) : void
      {
         this.data = param1;
      }
   }
}
