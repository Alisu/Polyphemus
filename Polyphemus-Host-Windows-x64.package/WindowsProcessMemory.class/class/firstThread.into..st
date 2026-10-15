library
firstThread: aSnapshot into: anEntry

	^ self ffiCall: #( int32 Thread32First ( uint64 aSnapshot , void * anEntry ) )
