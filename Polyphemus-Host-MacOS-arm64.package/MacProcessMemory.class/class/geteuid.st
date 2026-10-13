library
geteuid

	^ self ffiCall: #( uint32 geteuid ( ) )
