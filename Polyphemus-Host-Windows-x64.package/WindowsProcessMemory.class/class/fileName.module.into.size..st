library
fileName: aHandle module: aModule into: aBuffer size: aSize

	^ self ffiCall: #( uint32 K32GetModuleFileNameExW ( uint64 aHandle , uint64 aModule , void * aBuffer , uint32 aSize ) )
