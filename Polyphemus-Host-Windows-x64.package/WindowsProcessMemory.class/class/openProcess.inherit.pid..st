library
openProcess: anAccess inherit: aFlag pid: aPid

	^ self ffiCall: #( uint64 OpenProcess ( uint32 anAccess , int32 aFlag , uint32 aPid ) )
