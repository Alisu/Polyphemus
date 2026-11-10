asking
beatWhileServed

	"Tell the agent this observer lives, until it is let go, ends or is gone: one that hears nothing
	for its silence limit lets the image go (#163, risk 10)."

	heartbeat ifNotNil: [ ^ self ].
	heartbeat := [
	             [ self hasExpired or: [ self isGone ] ] whileFalse: [
		             directory exists ifTrue: [
			             (directory / 'alive') writeStreamDo: [ :stream | stream truncate; print: DateAndTime now ] ].
		             (Delay forMilliseconds: self class heartbeatEvery asMilliSeconds) wait ] ]
		             forkAt: Processor userInterruptPriority
		             named: 'Polyphemus heartbeat'
