library
currentProcessId

	^ self ffiCall: #( uint32 GetCurrentProcessId ( ) )
