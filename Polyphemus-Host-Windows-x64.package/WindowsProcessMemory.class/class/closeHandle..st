library
closeHandle: aHandle

	^ self ffiCall: #( int32 CloseHandle ( uint64 aHandle ) )
