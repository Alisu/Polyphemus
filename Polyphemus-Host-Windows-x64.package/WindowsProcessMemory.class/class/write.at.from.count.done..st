library
write: aHandle at: anAddress from: aBuffer count: aCount done: aDone

	^ self ffiCall: #( int32 WriteProcessMemory ( uint64 aHandle , uint64 anAddress , void * aBuffer , uint64 aCount , void * aDone ) )
