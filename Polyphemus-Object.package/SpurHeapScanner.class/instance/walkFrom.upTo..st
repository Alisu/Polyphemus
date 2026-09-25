walking
walkFrom: anAddress upTo: aLimit

	"Walk objects from anAddress, counting live objects and free chunks apart and noting the
	special objects array. Gives up after a long run of free chunks."

	| count free liveBytes freeBytes consecutiveFree current soa answer lastLiveEnd |
	count := 0. free := 0. liveBytes := 0. freeBytes := 0. consecutiveFree := 0.
	current := anAddress.
	answer := [ :where :why |
		          SpurHeapWalk new
			          count: count
			          free: free
			          bytes: liveBytes
			          freeBytes: freeBytes
			          at: where
			          because: why;
			          specialObjectsArray: soa;
			          lastLiveEnd: lastLiveEnd;
			          yourself ].
	[ current < aLimit ] whileTrue: [
		| wrong size |
		wrong := self whyNotAnObjectAt: current.
		wrong ifNotNil: [ ^ answer value: current value: wrong ].
		size := self bytesOfObjectAt: current.
		(self isFreeChunkAt: current)
			ifTrue: [
				free := free + 1.
				freeBytes := freeBytes + size.
				consecutiveFree := consecutiveFree + 1.
				consecutiveFree > 10000 ifTrue: [
					^ answer value: current value: #nothingButFreeSpace ] ]
			ifFalse: [
				count := count + 1.
				liveBytes := liveBytes + size.
				lastLiveEnd := current + size.
				consecutiveFree := 0.
				(soa isNil and: [
					 self looksLikeTheSpecialObjectsArrayAt: current from: anAddress ])
					ifTrue: [ soa := current ] ].
		current := self objectAfter: current.
		current ifNil: [ ^ answer value: aLimit value: #couldNotStep ] ].

	^ answer value: current value: #reachedTheLimit
