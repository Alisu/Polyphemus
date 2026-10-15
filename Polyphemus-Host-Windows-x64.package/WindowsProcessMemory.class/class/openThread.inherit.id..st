library
openThread: anAccess inherit: aFlag id: anId

	^ self ffiCall: #( uint64 OpenThread ( uint32 anAccess , int32 aFlag , uint32 anId ) )
