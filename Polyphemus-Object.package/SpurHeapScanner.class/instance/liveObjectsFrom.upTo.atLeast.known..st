finding a heap
liveObjectsFrom: anAddress upTo: aLimit atLeast: aCount known: aDictionary

	"How many live objects walk from anAddress, aCount at most, free chunks stepped over. A walk
	that falls short leaves, for each object it stepped over, its count to where it stopped."

	| path live current header total |
	path := OrderedCollection new.
	live := 0.
	current := anAddress.
	[ current notNil and: [ current < aLimit and: [ (aDictionary includesKey: current) not ] ] ] whileTrue: [
		header := self headerAt: current.
		(header notNil and: [ (self whyNotAnObjectAt: current) isNil ]) ifFalse: [
			current := nil ].
		current ifNotNil: [
			| isLive |
			isLive := (self classIndexIn: header) ~= 0.
			path add: current -> isLive.
			isLive ifTrue: [ (live := live + 1) >= aCount ifTrue: [ ^ aCount ] ].
			current := self objectAfter: current ] ].
	total := current ifNil: [ 0 ] ifNotNil: [ aDictionary at: current ifAbsent: [ 0 ] ].
	path reverseDo: [ :each |
		each value ifTrue: [ total := total + 1 ].
		aDictionary at: each key put: (total min: aCount) ].
	^ aDictionary at: anAddress ifAbsent: [ total min: aCount ]