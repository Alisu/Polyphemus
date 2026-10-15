library
read: aHandle at: anAddress into: aBuffer count: aCount done: aDone

	^ self ffiCall: #( int32 ReadProcessMemory ( uint64 aHandle , uint64 anAddress , void * aBuffer , uint64 aCount , void * aDone ) )
