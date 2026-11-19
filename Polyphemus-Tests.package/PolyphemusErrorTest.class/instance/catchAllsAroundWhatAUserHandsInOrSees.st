accessing
catchAllsAroundWhatAUserHandsInOrSees

	"Source or a value a user typed, saved or evaluated, and a window's own figures: what fails is
	told to the user where they typed it."

	^ #( 'MethodSave>>tell:at:' 'MethodSave>>writeWith:' 'OOPAbstractEntity>>storeTyped:inItemKeyed:telling:'
	     'ReifiedDebugSession>>evaluate:in:' 'StatForPresenterPresenter>>updateForMemory:' )
