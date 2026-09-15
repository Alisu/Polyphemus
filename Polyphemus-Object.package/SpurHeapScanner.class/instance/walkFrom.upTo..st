walking
walkFrom: anAddress upTo: aLimit

	"Step from object to object and answer how far it got, counting live objects and free
	chunks apart.

	It is the live count that says a region is a heap. Untouched memory reads as one enormous
	free chunk after another -- zeros are a free chunk of no slots -- so a walk that finds
	nothing but free chunks has found nothing, however far it went. That is also why it gives
	up after a long run of them."

	| count free consecutiveFree current |
	count := 0.
	free := 0.
	consecutiveFree := 0.
	current := anAddress.
	[ current < aLimit ] whileTrue: [
		| wrong |
		wrong := self whyNotAnObjectAt: current.
		wrong ifNotNil: [
			^ SpurHeapWalk new
				  count: count free: free at: current because: wrong;
				  yourself ].
		(self isFreeChunkAt: current)
			ifTrue: [
				free := free + 1.
				consecutiveFree := consecutiveFree + 1.
				consecutiveFree > 10000 ifTrue: [
					^ SpurHeapWalk new
						  count: count free: free at: current because: #nothingButFreeSpace;
						  yourself ] ]
			ifFalse: [
				count := count + 1.
				consecutiveFree := 0 ].
		current := self objectAfter: current.
		current ifNil: [
			^ SpurHeapWalk new
				  count: count free: free at: aLimit because: #couldNotStep;
				  yourself ] ].

	^ SpurHeapWalk new
		  count: count free: free at: current because: #reachedTheLimit;
		  yourself
