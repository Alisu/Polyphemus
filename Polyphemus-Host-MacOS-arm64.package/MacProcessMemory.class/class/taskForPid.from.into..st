library
taskForPid: aPid from: aTask into: aPortBuffer

	^ self ffiCall: #( int task_for_pid ( uint32 aTask , int aPid , void * aPortBuffer ) )
