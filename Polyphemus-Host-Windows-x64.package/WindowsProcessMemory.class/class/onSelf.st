instance creation
onSelf

	^ self new setHandle: (self openProcess: 16r0C38 inherit: 0 pid: self currentProcessId) pid: self currentProcessId
