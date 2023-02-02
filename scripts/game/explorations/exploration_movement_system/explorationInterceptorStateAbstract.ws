/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/









class CExplorationInterceptorStateAbstract extends CExplorationStateTransitionAbstract
{
	protected	editable	var			m_InterceptStateN	: name;


	
	public function IsMachForThisStates( _FromN, _ToN : name ) : bool
	{
		return m_InterceptStateN == _ToN;
	}
}