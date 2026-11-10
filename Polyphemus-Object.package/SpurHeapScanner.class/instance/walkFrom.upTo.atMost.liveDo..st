walking
walkFrom: anAddress upTo: aLimit atMost: aCount liveDo: aBlock

	"As walkFrom:upTo:atMost:, giving aBlock each live object's address and header, when there
	is a block. Each header is read once (#152)."

	| count free liveBytes freeBytes consecutiveFree current header soa answer lastLiveEnd |
	count := 0. free := 0. liveBytes := 0. freeBytes := 0. consecutiveFree := 0.
	current := anAddress.
	header := self headerAt: current.
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
		| slots wrong size |
		header ifNil: [ ^ answer value: current value: #outsideTheRegion ].
		slots := self slotsAt: current header: header.
		wrong := self whyNotAnObjectAt: current header: header slots: slots.
		wrong ifNotNil: [ ^ answer value: current value: wrong ].
		size := 8 + ((slots max: 1) * 8).
		(self classIndexIn: header) = 0
			ifTrue: [
				free := free + 1.
				freeBytes := freeBytes + size.
				consecutiveFree := consecutiveFree + 1.
				consecutiveFree > 10000 ifTrue: [
					^ answer value: current value: #nothingButFreeSpace ] ]
			ifFalse: [
				count := count + 1.
				(aCount notNil and: [ count >= aCount ]) ifTrue: [
					^ answer value: current value: #enoughObjects ].
				liveBytes := liveBytes + size.
				lastLiveEnd := current + size.
				consecutiveFree := 0.
				aBlock ifNotNil: [ aBlock value: current value: header ].
				(soa isNil and: [
					 self
						 looksLikeTheSpecialObjectsArrayAt: current
						 header: header
						 slots: slots
						 from: anAddress ]) ifTrue: [ soa := current ] ].
		"The next object, past an overflow word when there is one, as objectAfter: steps."
		current := current + size.
		header := self headerAt: current.
		(header notNil and: [ SpurHeader overflowsItsSlotCount: header ]) ifTrue: [
			current := current + 8.
			header := self headerAt: current ] ].

	^ answer value: current value: #reachedTheLimit
