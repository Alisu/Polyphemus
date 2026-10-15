library
information: aHandle module: aModule into: aBuffer size: aSize

	^ self ffiCall: #( int32 K32GetModuleInformation ( uint64 aHandle , uint64 aModule , void * aBuffer , uint32 aSize ) )
