printing
summary

	self isWaitingForEvents ifTrue: [ ^ 'idle, waiting for events in ' , self systemCallName ].
	self isInACCall ifTrue: [ ^ 'blocked in a C call, ' , self systemCallName , ' (no interrupt reaches it)' ].
	wasRunning ifTrue: [ ^ 'running, in ' , self location ].
	^ 'state ' , state
