/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/

enum EGuiSceneControllerRenderFocus
{
	GSCRF_Body,
	GSCRF_Head,
	GSCRF_Torso,
	GSCRF_Legs,
	
	GSCRF_Max
}

class CR4GuiSceneController
{
	private var _isEntitySpawning			: bool;				default _isEntitySpawning = false;

	private var _entityTemplateAlias		: string;
	private var _entityAppearance			: name;
	private var _environmentAlias			: string;
	private var _environmentSunRotation		: EulerAngles;
	private var _cameraUpdate  				: bool;
	private var _cameraLookAt				: Vector;
	private var _cameraRotation				: EulerAngles;
	private var _cameraDistance				: float;
	private var _fov						: float;
	private var _updateItems				: bool;
	
	private var _cachedDyes					: array< name >;
	private var _appliedDyesPreview			: array< name >;
	
	private var _entityPosition 			: Vector;
	private var _entityRotation 			: EulerAngles;
	private var _entityScale				: Vector;
	private var _updateEntityTransform		: bool; default _updateEntityTransform = false;
	
	private var m_charRenderFocus			: EGuiSceneControllerRenderFocus; default m_charRenderFocus = GSCRF_Body;
	private var m_charFocusOriginZ			: float;
	private var m_charFocusOriginDistance	: float;
	private var m_charFocusTargetZ			: float;
	private var m_charFocusTargetDistance	: float;
	private var m_charFocusBlendTimer		: float;
	private var m_charFocusBlendTime		: float; default m_charFocusBlendTime = 0.5f;
	
	private var m_distanceMin				: float; default m_distanceMin	= 1.85f;
	private var m_distanceMax				: float; default m_distanceMax	= 3.2f;
	private var m_zMin						: float; default m_zMin			= 0.5f;
	private var m_zMax						: float; default m_zMax			= 1.5f;
	private var m_zBody						: float; default m_zBody		= 0.92f;

	function OnGuiSceneEntitySpawned()
	{
		_isEntitySpawning = false;
		
		if ( _entityTemplateAlias != "" )
		{
			SetEntityTemplate( _entityTemplateAlias );
			_entityTemplateAlias = "";
		}
		else
		{
			if ( _entityAppearance != '' )
			{
				SetEntityAppearance( _entityAppearance );
				_entityAppearance = '';
			}
			if ( _environmentAlias != "" )
			{
				SetEnvironmentAndSunRotation( _environmentAlias, _environmentSunRotation );
				_environmentAlias = "";
			}
			
			if ( _cameraUpdate )
			{
				_cameraUpdate = false;
				SetCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
			}
			
			if ( _updateItems )
			{
				_updateItems = false;
				SetEntityItems( _updateItems );
			}
			
			if (_updateEntityTransform)
			{
				_updateEntityTransform = false;
				SetEntityTransform( _entityPosition, _entityRotation, _entityScale );
			}
			else
			{
				
				_entityRotation.Yaw = 0;
				_entityRotation.Pitch = 0;
				_entityRotation.Roll = 0;
				
				_entityScale.X = 1;
				_entityScale.Y = 1;
				_entityScale.Z = 1;
				
				SetEntityTransform( _entityPosition, _entityRotation, _entityScale );
			}
		}
	}

	function OnGuiSceneEntityDestroyed()
	{
	
	}
	
	public function Update( deltaTime : float )
	{
		var blend : float;
		if( m_charFocusBlendTimer > 0.0f )
		{
			m_charFocusBlendTimer -= deltaTime;
			if( m_charFocusBlendTimer <= 0.0f )
			{
				_cameraLookAt.Z = m_charFocusTargetZ;
				_cameraDistance = m_charFocusTargetDistance;
			}
			else
			{
				blend = 1.0f - ( m_charFocusBlendTimer / m_charFocusBlendTime );
				_cameraLookAt.Z = BlendF( _cameraLookAt.Z, m_charFocusTargetZ, blend );
				_cameraDistance = BlendF( _cameraDistance, m_charFocusTargetDistance, blend );
			}
			theGame.GetGuiManager().SetupSceneCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
		}
	}
	
	private function ResetRenderFocus( full : bool )
	{
		if( full )
		{
			m_charRenderFocus = GSCRF_Body;
		}
		m_charFocusBlendTimer = 0.0f;
	}
	
	public function OnChangeCharRenderFocus( next : bool )
	{
		var focusInt, focusIntNew : int;
		
		focusInt = m_charRenderFocus;
		focusIntNew = focusInt;
		if( next )
		{
			focusIntNew = Clamp( focusInt + 1, 0, GSCRF_Max - 1 );
		}
		else
		{
			
			focusIntNew = Clamp( focusInt - 1, 0, GSCRF_Max - 1 );
		}
		
		if( focusIntNew != focusInt || focusIntNew == GSCRF_Body )
		{
			m_charRenderFocus = focusIntNew;
			
			SetFocusTargets();
			
			m_charFocusOriginZ			= _cameraLookAt.Z;
			m_charFocusOriginDistance	= _cameraDistance;
			m_charFocusBlendTimer		= 0.5f;
		}
	}
	
	public function SetFocusTargets()
	{
		switch( m_charRenderFocus )
		{
		case GSCRF_Body:
			m_charFocusTargetZ			= m_zBody;
			m_charFocusTargetDistance	= m_distanceMax;
			break;
			
		case GSCRF_Head:
			m_charFocusTargetZ			= m_zMax;
			m_charFocusTargetDistance	= m_distanceMin;
			break;
			
		case GSCRF_Torso:
			m_charFocusTargetZ			= 1.2f;
			m_charFocusTargetDistance	= m_distanceMin;
			break;
			
		case GSCRF_Legs:
			m_charFocusTargetZ			= m_zMin;
			m_charFocusTargetDistance	= m_distanceMin;
			break;
		}
	}
	
	public function SetEntityTemplate( entityTemplateAlias : string )
	{
		var templateResource : CEntityTemplate;

		if ( _isEntitySpawning )
		{
			_entityTemplateAlias = entityTemplateAlias;
		}
		else
		{
			templateResource = ( CEntityTemplate )LoadResource( entityTemplateAlias );
			if ( templateResource )
			{
				_isEntitySpawning = true;
				theGame.GetGuiManager().SetSceneEntityTemplate( templateResource );
			}
		}
		
		_cachedDyes.Clear();
		_appliedDyesPreview.Clear();
		_cachedDyes.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );
		_appliedDyesPreview.Resize( EnumGetMax( 'EEquipmentSlots' ) + 1 );
	}
	
	public function SetEntityAppearance( appearance : name )
	{
		if ( _isEntitySpawning )
		{
			_entityAppearance = appearance;
		}
		else
		{
			theGame.GetGuiManager().ApplyAppearanceToSceneEntity( appearance );
		}
	}

	public function SetEnvironmentAndSunRotation( environmentAlias : string, environmentSunRotation : EulerAngles )
	{
		var environment : CEnvironmentDefinition;

		if ( _isEntitySpawning )
		{
			_environmentAlias = environmentAlias;
			_environmentSunRotation = environmentSunRotation;
		}
		else
		{
			environment = ( CEnvironmentDefinition )LoadResource( environmentAlias );
			if ( environment )
			{
				theGame.GetGuiManager().SetSceneEnvironmentAndSunPosition( environment, environmentSunRotation );
			}
		}
	}
	
	public function SetCamera( cameraLookAt : Vector, cameraRotation : EulerAngles, cameraDistance : float, fov : float )
	{
		_cameraLookAt   = cameraLookAt;
		_cameraRotation = cameraRotation;
		_cameraDistance = cameraDistance;
		_fov = fov;
		
		if ( _isEntitySpawning )
		{
			_cameraUpdate = true;
		}
		else
		{
			theGame.GetGuiManager().SetupSceneCamera( cameraLookAt, cameraRotation, cameraDistance, fov );
		}
	}
	
	public function SetEntityTransform(position : Vector, rotation : EulerAngles, scale : Vector)
	{		
		_entityPosition = position;
		_entityRotation = rotation;
		_entityScale = scale;
		
		if (_isEntitySpawning)
		{
			_updateEntityTransform = true;
		}
		else
		{
			theGame.GetGuiManager().SetEntityTransform(position, rotation, scale);
		}
	}
	
	
	
	public function ResetEntityPosition():void
	{
		_entityRotation.Yaw = 0;
		_entityRotation.Pitch = 0;
		_entityRotation.Roll = 0;
		
		_cameraLookAt.Z  = m_zBody;
		_cameraRotation.Yaw = 190.71;
		_cameraDistance = m_distanceMax;
		
		ResetRenderFocus( true );
		
		theGame.GetGuiManager().SetEntityTransform( _entityPosition, _entityRotation, _entityScale );
		theGame.GetGuiManager().SetupSceneCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
	}
	
	public function GetEntityRotation():EulerAngles
	{
		return _entityRotation;
	}
	
	public function RotateEntity( delta : float ):void
	{
		var newValue:float = _cameraDistance + delta * 0.2;
		
		_entityRotation.Yaw = _entityRotation.Yaw + delta * 3;
		theGame.GetGuiManager().SetEntityTransform( _entityPosition, _entityRotation, _entityScale);
	}
	
	public function ZoomEntity( delta : float, isPad : bool ):void
	{
		var newZoom:float = _cameraDistance - delta * 0.2;
		var zoomRatio:float;
		
		if( isPad )
		{
			if( m_charFocusBlendTimer <= 0.0f ) 
			{
				_cameraDistance = ClampF( newZoom, m_distanceMin, m_distanceMax );
				if( m_charRenderFocus == GSCRF_Body ||
					m_charRenderFocus == GSCRF_Head )
				{
					if( _cameraDistance <= m_distanceMin )
					{
						m_charRenderFocus = GSCRF_Head;
					}
					else if( _cameraDistance > m_distanceMin )
					{
						m_charRenderFocus = GSCRF_Body;
					}
					
					zoomRatio = 1.0f - ( ( _cameraDistance - m_distanceMin ) / ( m_distanceMax - m_distanceMin ) );
					_cameraLookAt.Z = LerpF( zoomRatio, m_zBody, m_zMax, true );
				}
			}
		}
		else
		{
			m_charFocusBlendTimer = 0.0f;
			_cameraDistance = ClampF( newZoom, m_distanceMin, m_distanceMax );
		}
		theGame.GetGuiManager().SetupSceneCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
	}
	
	public function GetCameraLookZ() : float
	{
		return _cameraLookAt.Z;
	}
	
	public function GetEntityZoom() : float
	{
		return _cameraDistance;
	}
	
	public function ZoomShiftEntity( delta : float ):void
	{
		var newValue:float = _cameraLookAt.Z + delta * 0.06;
		
		_cameraLookAt.Z = ClampF( newValue, m_zMin, m_zMax );
		
		ResetRenderFocus( false );
		
		theGame.GetGuiManager().SetupSceneCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
	}
	
	public function MoveEntity( delta : float ):void
	{		
		var newValue:float = _cameraLookAt.Z + delta * 0.035;
		
		_cameraLookAt.Z = ClampF( newValue, m_zMin, m_zMax );
		
		ResetRenderFocus( false );
		
		theGame.GetGuiManager().SetupSceneCamera( _cameraLookAt, _cameraRotation, _cameraDistance, _fov );
	}
	
	
	
	public function SetEntityItems( updateItems : bool, optional previewItems : array<SItemUniqueId>, optional dyePreviewSlots: array<SItemUniqueId>)
	{
		var inventory : CInventoryComponent;
		var enhancements : array< SGuiEnhancementInfo >;
		var info : SGuiEnhancementInfo;
		var enhancementNames : array< name >;
		var items : array< SItemUniqueId >;
		var witcher : W3PlayerWitcher;
		var i, j : int;
		var itemsId : array< SItemUniqueId >;
		var itemId : SItemUniqueId;
		var itemName : name;
		
		var previewItemsCount 	: int;
		var previewBySlotList	: array<SItemUniqueId>;
		var previewSlot 		: EEquipmentSlots;
		var previewItem 		: SItemUniqueId;
		var previewDye   		: SItemUniqueId;	
		
		var dyeColorAbility     : SAbilityAttributeValue;
		var dyeAbilities		: array < name >;
		
		var appliedDye          : name;		
		var cachedDye   		: name;
		var cachedColorId       : float;
		
		if( _isEntitySpawning )
		{
			_updateItems = updateItems;
		}
		else
		{
			inventory = thePlayer.GetInventory();
			
			previewItemsCount = previewItems.Size();
			previewBySlotList.Resize( EnumGetMax('EEquipmentSlots') + 1 );
			
			for( j = 0; j < previewItemsCount; j += 1)
			{
				previewItem = previewItems[j];
				
				if( inventory.IsIdValid( previewItem ) && !inventory.IsItemDye( previewItem ) )
				{
					previewSlot = inventory.GetSlotForItemId(previewItem);
					previewBySlotList[previewSlot] = previewItem;
				}
			}
			
			if( inventory )
			{
				inventory.GetHeldAndMountedItems( itemsId );
				
				witcher = (W3PlayerWitcher) thePlayer;
				
				if( witcher )
				{
					witcher.GetMountableItems( itemsId );
				}
				
				for( i = 0; i < itemsId.Size(); i += 1 )
				{
					itemId = itemsId[i];
					
					previewSlot = inventory.GetSlotForItemId(itemId);
					if( previewItemsCount > 0 )
					{
						if( inventory.IsIdValid( previewBySlotList[previewSlot] ))
						{
							
							itemId = previewBySlotList[previewSlot];
						}
					}

					itemName = inventory.GetItemName( itemId );		
					items.PushBack( itemId );
					
					inventory.GetItemEnhancementItems( itemId, enhancementNames );
					for( j = 0; j < enhancementNames.Size(); j += 1 )
					{
						info.enhancedItem = itemName;
						info.enhancement = enhancementNames[j];
						enhancements.PushBack( info );
					}
					
					previewDye = dyePreviewSlots[ previewSlot ];
					
					if( inventory.IsIdValid( previewDye ) )
					{
						inventory.GetItemAbilities( previewDye, dyeAbilities );
						dyeColorAbility = inventory.GetItemAttributeValue( previewDye, 'item_color' );
						
						appliedDye = inventory.GetItemColor( itemId );
						cachedDye = _cachedDyes[ previewSlot ];
						
						if( appliedDye != 'None' && cachedDye == '' )
						{
							_cachedDyes[ previewSlot ] = appliedDye;
						}
						
						info.dyeColor = RoundF( dyeColorAbility.valueBase );
						info.dyeItem = itemName;
						info.dye = inventory.GetItemName( previewDye );
						enhancements.PushBack( info );
						
						_appliedDyesPreview[ previewSlot ]  = info.dye;
						
						inventory.SetPreviewColor( itemId, info.dyeColor );
					}
					else
					if( inventory.IsIdValid( itemId ) && !inventory.ItemHasTag( itemId, 'NoShow' ) )
					{
						cachedDye = _cachedDyes[ previewSlot ];
						
						if (cachedDye != '')
						{
							inventory.GetItemStatByName(cachedDye , 'item_color', cachedColorId );
							
							info.dyeColor = RoundF( cachedColorId );
							info.dye = cachedDye;
							
							info.dyeItem = itemName;
							
							_appliedDyesPreview[ previewSlot ] = '';
							inventory.ClearPreviewColor( itemId );
						}
						else
						if ( _appliedDyesPreview[ previewSlot ] != '' )
						{							
							
							info.dyeColor = 0;
							info.dye = 'Dye Default';
							_appliedDyesPreview[ previewSlot ] = '';
							inventory.ClearPreviewColor( itemId );
							
							info.dyeItem = itemName;
							
						}
						else
						if( inventory.IsItemColored( itemId ) )
						{
							appliedDye = inventory.GetItemColor( itemId );	
							inventory.GetItemStatByName(appliedDye , 'item_color', cachedColorId );
							
							info.dyeColor = RoundF( cachedColorId );
							info.dye = appliedDye;
							info.dyeItem = itemName;
							
						}
					}
					
					if( inventory.ItemHasAnyActiveOilApplied( itemsId[i] ) )
					{
						info.oilItem = itemName;
						info.oil = inventory.GetNewestOilAppliedOnItem( itemsId[i], true ).GetOilItemName();
						enhancements.PushBack( info );
					}
					
				}
				
				theGame.GetGuiManager().UpdateSceneEntityItems( items, enhancements );
			}
		}
	}
	

}
