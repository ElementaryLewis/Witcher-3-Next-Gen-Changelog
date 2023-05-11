/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CR4HudModuleBuffs extends CR4HudModuleBase
{
	private var _currentEffects : array <CBaseGameplayEffect>;
	private var _previousEffects : array <CBaseGameplayEffect>;
	private var _forceUpdate : bool;
	
	private var m_fxSetPercentSFF : CScriptedFlashFunction;
	private var m_fxShowBuffUpdateFx : CScriptedFlashFunction;
	private var m_fxsetViewMode : CScriptedFlashFunction;
	
	private var m_flashValueStorage : CScriptedFlashValueStorage;	
	private var iCurrentEffectsSize : int;	default iCurrentEffectsSize = 0;
	private var bDisplayBuffs : bool; default bDisplayBuffs = true;
	
	private var m_runword5Applied : bool; default m_runword5Applied = false;
	
	
	

	event  OnConfigUI()
	{
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;
		
		m_anchorName = "mcAnchorBuffs";
		m_flashValueStorage = GetModuleFlashValueStorage();
		super.OnConfigUI();
		
		flashModule = GetModuleFlash();	
		m_fxSetPercentSFF				= flashModule.GetMemberFlashFunction( "setPercent" );
		m_fxShowBuffUpdateFx			= flashModule.GetMemberFlashFunction( "showBuffUpdateFx" );
		m_fxsetViewMode 				= flashModule.GetMemberFlashFunction( "setViewMode" );
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		if (hud)
		{
			hud.UpdateHudConfig('BuffsModule', true);
		}
	}

	function ForceUpdate()
	{
		_forceUpdate = true;
	}
	
	event OnTick( timeDelta : float )
	{
		var effectsSize : int;
		var effectArray : array< CBaseGameplayEffect >;
		var i : int;
		var offset : int;
		var duration : float;
		var extraValue : int;
		var initialDuration : float;
		var hasRunword5 : bool;
		var oilEffect : W3Effect_Oil;
		var aerondightEffect	: W3Effect_Aerondight;
		var effectType : EEffectType;

		if ( !CanTick( timeDelta ) )
			return true;

		_previousEffects = _currentEffects;
		_currentEffects.Clear();
		
		if( bDisplayBuffs && GetEnabled() )
		{		
			offset = 0;
			
			effectArray = thePlayer.GetCurrentEffects();
			effectsSize = effectArray.Size();
			hasRunword5 = false;
			
			for ( i = 0; i < effectsSize; i += 1 )
			{
				if(effectArray[i].ShowOnHUD() && effectArray[i].GetEffectNameLocalisationKey() != "MISSING_LOCALISATION_KEY_NAME" )
				{	
					
					initialDuration = effectArray[i].GetInitialDurationAfterResists();
					
					if ( (W3RepairObjectEnhancement)effectArray[i] && GetWitcherPlayer().HasRunewordActive('Runeword 5 _Stats') )
					{
						hasRunword5 = true;
						
						if (!m_runword5Applied)
						{
							m_runword5Applied = true;
							UpdateBuffs();
							break;
						}
					}

					effectType = effectArray[i].GetEffectType();

					if( initialDuration < 1.0)
					{
						initialDuration = 1;
						duration = 1;
					}
					else
					{
						duration = effectArray[i].GetDurationLeft();
						if ( thePlayer.CanUseSkill( S_Perk_14 ) &&
							( effectType == EET_ShrineAxii || 
							  effectType == EET_ShrineIgni || 
							  effectType == EET_ShrineQuen || 
							  effectType == EET_ShrineYrden || 
							  effectType == EET_ShrineAard
							)
						   )
						{
							
							duration = effectArray[i].GetInitialDuration() + 1;
						}
						else if ( effectType == EET_EnhancedWeapon ||
								  effectType == EET_EnhancedArmor )
						{
							if ( GetWitcherPlayer().HasRunewordActive('Runeword 5 _Stats') )
							{
								
								duration = effectArray[i].GetInitialDuration() + 1;
							}
						}
						else
						{
							if(duration < 0.f)
								duration = 0.f;		
						}
					}
					
					if ( effectType == EET_Oil )
					{
						oilEffect = (W3Effect_Oil)effectArray[ i ];
						if ( oilEffect )
						{
							
							if (oilEffect.GetAmmoCurrentCount() > 0 && GetWitcherPlayer().CanUseSkill(S_Alchemy_s06) && GetWitcherPlayer().GetSkillLevel(S_Alchemy_s06) > 2)
							{
								initialDuration = oilEffect.GetAmmoMaxCount();
								duration		= oilEffect.GetAmmoMaxCount();
							}
							else
							{
								initialDuration = oilEffect.GetAmmoMaxCount();
								duration		= oilEffect.GetAmmoCurrentCount();
							}
						}
					}					
					else if( effectType == EET_Aerondight )
					{
						aerondightEffect = (W3Effect_Aerondight)effectArray[i];
						if( aerondightEffect )
						{
							initialDuration = aerondightEffect.GetMaxCount();
							duration		= aerondightEffect.GetCurrentCount();
						}
					}
					else if( effectType == EET_BasicQuen )
					{
						
						extraValue = ( ( W3Effect_BasicQuen ) effectArray[i] ).GetStacks();
						
					}
					else if( effectType == EET_Mutation3 )
					{						
						duration = ( ( W3Effect_Mutation3 ) effectArray[i] ).GetStacks();
						initialDuration = duration;
					}
					else if( effectType == EET_Mutation4 )
					{						
						duration = ( ( W3Effect_Mutation4 ) effectArray[i] ).GetStacks();
						initialDuration = duration;
					}
					else if( effectType == EET_Mutation5 )
					{						
						duration = ( ( W3Effect_Mutation5 ) effectArray[i] ).GetStacks();
						initialDuration = ( ( W3Effect_Mutation5 ) effectArray[i] ).GetMaxStacks();
					}
					else if( effectType == EET_Mutation7Buff || effectType == EET_Mutation7Debuff )
					{	
						
						extraValue = ( ( W3Mutation7BaseEffect ) effectArray[i] ).GetStacks();
					}
					else if( effectType == EET_Mutation10 )
					{						
						duration = ( ( W3Effect_Mutation10 ) effectArray[i] ).GetStacks();
						initialDuration = duration;
					}
					
					if(_currentEffects.Size() < i+1-offset)
					{
						_currentEffects.PushBack(effectArray[i]);
						m_fxSetPercentSFF.InvokeSelfFourArgs( FlashArgNumber(i-offset),FlashArgNumber( duration ), FlashArgNumber( initialDuration ), FlashArgInt( extraValue ) );
					}
					else if( effectArray[i].GetEffectType() == _currentEffects[i-offset].GetEffectType() )
					{
						m_fxSetPercentSFF.InvokeSelfFourArgs( FlashArgNumber(i-offset),FlashArgNumber( duration ), FlashArgNumber( initialDuration ), FlashArgInt( extraValue ) );
					}
					else
					{
						LogChannel('HUDBuffs',i+" something wrong");
					}
				}
				else
				{
					offset += 1;
					
				}
			}
			
			if (!hasRunword5 && m_runword5Applied)
			{
				m_runword5Applied = false;
				UpdateBuffs();
			}
		}

		
		if ( _currentEffects.Size() == 0 && _previousEffects.Size() == 0 )
			return true;

		
		if ( buffListHasChanged(_currentEffects, _previousEffects) || _forceUpdate )
		{
			_forceUpdate = false;
			UpdateBuffs();
		}

	}

	
	private function buffListHasChanged( currentEffects : array<CBaseGameplayEffect>, previousEffects : array<CBaseGameplayEffect> ) : bool
	{
		var i : int;
		var currentSize : int = currentEffects.Size();
		var previousSize : int = previousEffects.Size();

		
		if( currentSize != previousSize )
			return true;
		else 
		{
			
			for( i = 0; i < currentSize; i+=1 )
			{
				if ( currentEffects[i] != previousEffects[i] )
					return true;
			}

			
			return false;
		}
	}
	
	public function SetMinimalViewMode( value : bool )
	{
		m_fxsetViewMode.InvokeSelfOneArg(FlashArgBool( value ));
	}

	function UpdateBuffs()
	{
		var l_flashObject			: CScriptedFlashObject;
		var l_flashArray			: CScriptedFlashArray;
		var i 						: int;
		var oilEffect				: W3Effect_Oil;
		var aerondightEffect		: W3Effect_Aerondight;
		var buffDisplayLimit		: int = 16;
		var mut3Buff 				: W3Effect_Mutation3;
		var mut4Buff 				: W3Effect_Mutation4;
		var mut5Buff 				: W3Effect_Mutation5;
		var effectType				: EEffectType;
		var mut7Buff 				: W3Mutation7BaseEffect;
		var mut10Buff 				: W3Effect_Mutation10;
		var buffState				: int;
		var format					: int;
		var quenBuff 				: W3Effect_BasicQuen;
		
		
		var isOilInfinite : bool;

		l_flashArray = GetModuleFlashValueStorage()().CreateTempFlashArray();
		for(i = 0; i < Min(buffDisplayLimit,_currentEffects.Size()); i += 1) 
		{
			if(_currentEffects[i].ShowOnHUD() && _currentEffects[i].GetEffectNameLocalisationKey() != "MISSING_LOCALISATION_KEY_NAME" )
			{
				if(_currentEffects[i].IsNegative())
				{
					buffState = 0;
				}
				else if ( _currentEffects[i].IsPositive() )
				{
					buffState = 1;
				}
				else if ( _currentEffects[i].IsNeutral() )
				{
					buffState = 2;
				}

				effectType = _currentEffects[i].GetEffectType();

				
				if(thePlayer.IsSkillEquipped( S_Alchemy_s06 ) && GetWitcherPlayer().CanUseSkill(S_Alchemy_s06) && GetWitcherPlayer().GetSkillLevel(S_Alchemy_s06) > 2)
					isOilInfinite = true;
				
				if ( effectType == EET_Oil && isOilInfinite )
				{
					
					format = 0;
				}
				else if ( effectType == EET_Oil || effectType == EET_Aerondight )
				{
					
					format = 1;
				}
				else if ( effectType == EET_Mutation3 || effectType == EET_Mutation4 || effectType == EET_Mutation5 || effectType == EET_Mutation10 )
				{
					
					format = 2;
				}
				else if ( effectType == EET_Mutation7Buff || effectType == EET_Mutation7Debuff || effectType == EET_BasicQuen )
				{
					
					format = 4;
				}
				else
				{
					
					format = 3;
				}
				
				l_flashObject = m_flashValueStorage.CreateTempFlashObject();
				l_flashObject.SetMemberFlashBool("isVisible",_currentEffects[i].ShowOnHUD());
				l_flashObject.SetMemberFlashString("iconName",_currentEffects[i].GetIcon());
				l_flashObject.SetMemberFlashString("title",GetLocStringByKeyExt(_currentEffects[i].GetEffectNameLocalisationKey()));
				l_flashObject.SetMemberFlashBool("IsPotion",_currentEffects[i].IsPotionEffect());
				l_flashObject.SetMemberFlashInt("isPositive", buffState);
				l_flashObject.SetMemberFlashInt("format", format);
				
				if ( effectType == EET_Oil )
				{	
					oilEffect = (W3Effect_Oil)_currentEffects[i];
					if ( oilEffect )
					{
						
						if (oilEffect.GetAmmoCurrentCount() > 0 && isOilInfinite)
						{
							l_flashObject.SetMemberFlashNumber("duration",        oilEffect.GetAmmoMaxCount() 	  * 1.0 );
							l_flashObject.SetMemberFlashNumber("initialDuration", oilEffect.GetAmmoMaxCount() 	  * 1.0 );
							l_flashObject.SetMemberFlashInt("format", 0);
						}
						
						else
						{
							l_flashObject.SetMemberFlashNumber("duration",        oilEffect.GetAmmoCurrentCount() * 1.0 );
							l_flashObject.SetMemberFlashNumber("initialDuration", oilEffect.GetAmmoMaxCount() 	  * 1.0 );
						}
					}
				}
				else if( effectType == EET_Aerondight )
				{
					aerondightEffect = (W3Effect_Aerondight)_currentEffects[i];
					if( aerondightEffect )
					{
						l_flashObject.SetMemberFlashNumber("duration",        aerondightEffect.GetCurrentCount() * 1.0 );
						l_flashObject.SetMemberFlashNumber("initialDuration", aerondightEffect.GetMaxCount()	 * 1.0 );
					}
				}
				
				
				else if( effectType == EET_Mutation3 )
				{						
					mut3Buff = ( W3Effect_Mutation3 ) _currentEffects[i];						
					l_flashObject.SetMemberFlashNumber("duration", 			mut3Buff.GetStacks() );
					l_flashObject.SetMemberFlashNumber("initialDuration", 	mut3Buff.GetStacks() );
				}
				else if( effectType == EET_Mutation4 )
				{						
					mut4Buff = ( W3Effect_Mutation4 ) _currentEffects[i];						
					l_flashObject.SetMemberFlashNumber("duration", 			mut4Buff.GetStacks() );
					l_flashObject.SetMemberFlashNumber("initialDuration", 	mut4Buff.GetStacks() );
				}
				else if( effectType == EET_Mutation5 )
				{						
					mut5Buff = ( W3Effect_Mutation5 ) _currentEffects[i];						
					l_flashObject.SetMemberFlashNumber("duration", 			mut5Buff.GetStacks() );
					l_flashObject.SetMemberFlashNumber("initialDuration", 	mut5Buff.GetStacks() );
				}
				
				
				else if( effectType == EET_Mutation10 )
				{						
					mut10Buff = ( W3Effect_Mutation10 ) _currentEffects[i];						
					l_flashObject.SetMemberFlashNumber("duration", 			mut10Buff.GetStacks() );
					l_flashObject.SetMemberFlashNumber("initialDuration", 	mut10Buff.GetStacks() );
				}
				else if ( (W3RepairObjectEnhancement)_currentEffects[i] && GetWitcherPlayer().HasRunewordActive('Runeword 5 _Stats') )
				{
					l_flashObject.SetMemberFlashNumber("duration", -1 );
					l_flashObject.SetMemberFlashNumber("initialDuration", -1 );
				}
				else
				{
					l_flashObject.SetMemberFlashNumber("duration",_currentEffects[i].GetDurationLeft() );
					l_flashObject.SetMemberFlashNumber("initialDuration", _currentEffects[i].GetInitialDurationAfterResists());
				}
				l_flashArray.PushBackFlashObject(l_flashObject);	
			}
		}
		
		m_flashValueStorage.SetFlashArray( "hud.buffs", l_flashArray );
	}
	
	protected function UpdateScale( scale : float, flashModule : CScriptedFlashSprite ) : bool
	{
		return true;
	}
	
	protected function UpdatePosition(anchorX:float, anchorY:float) : void
	{
		var l_flashModule 		: CScriptedFlashSprite;
		var tempX				: float;
		var tempY				: float;
		
		l_flashModule 	= GetModuleFlash();
		
		
		
		
		tempX = anchorX + (660.0 * (1.0 - theGame.GetUIHorizontalFrameScale()));
		tempY = anchorY + (645.0 * (1.0 - theGame.GetUIVerticalFrameScale())); 
		
		l_flashModule.SetX( tempX );
		l_flashModule.SetY( tempY );	
	}
	
	event  OnBuffsDisplay( value : bool )
	{
		bDisplayBuffs = value;
	}
	
	public function ShowBuffUpdate() :void
	{
		m_fxShowBuffUpdateFx.InvokeSelf();
	}
	
	public function SetDisplayBuffs( b : bool )
	{
		bDisplayBuffs = b;
	}
}

exec function testBf()
{
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	if (hud)
	{
		hud.ShowBuffUpdate();
	}
}
