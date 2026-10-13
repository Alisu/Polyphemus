instance creation
onSelf

	^ self new setTask: self selfTask pid: self getpid
