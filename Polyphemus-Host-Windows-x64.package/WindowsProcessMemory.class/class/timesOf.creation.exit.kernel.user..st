library
timesOf: aThread creation: aCreation exit: anExit kernel: aKernel user: aUser

	^ self ffiCall: #( int32 GetThreadTimes ( uint64 aThread , void * aCreation , void * anExit , void * aKernel , void * aUser ) )
