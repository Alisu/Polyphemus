library
taskThreads: aTask list: aListBuffer count: aCountBuffer

	^ self ffiCall: #( int task_threads ( uint32 aTask , void * aListBuffer , void * aCountBuffer ) )
