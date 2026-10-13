library
dlsym: aHandle named: aName

	^ self ffiCall: #( uint64 dlsym ( int64 aHandle , String aName ) )
