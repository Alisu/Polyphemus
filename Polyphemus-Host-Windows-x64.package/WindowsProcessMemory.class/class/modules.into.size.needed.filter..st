library
modules: aHandle into: aBuffer size: aSize needed: aNeeded filter: aFilter

	^ self ffiCall: #( int32 K32EnumProcessModulesEx ( uint64 aHandle , void * aBuffer , uint32 aSize , void * aNeeded , uint32 aFilter ) )
