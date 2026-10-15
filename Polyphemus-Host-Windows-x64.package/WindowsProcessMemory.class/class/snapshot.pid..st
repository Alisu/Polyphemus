library
snapshot: aFlags pid: aPid

	^ self ffiCall: #( uint64 CreateToolhelp32Snapshot ( uint32 aFlags , uint32 aPid ) )
