walking
walkFrom: anAddress upTo: aLimit

	"Step from object to object and answer how far it got: live objects and free chunks
	counted apart, and the bytes each takes up.

	It is the live count that says a region is a heap. Untouched memory reads as one enormous
	free chunk after another -- zeros are a free chunk of no slots -- so a walk that finds
	nothing but free chunks has found nothing, however far it went. That is also why it gives
	up after a long run of them.

	The bytes are worth having on their own: between them and the size of the mapping they say
	how much of its memory the image was using and how much the allocator was holding spare."

	| count free liveBytes freeBytes consecutiveFree current |
	count := 0. free := 0. liveBytes := 0. freeBytes := 0. consecutiveFree := 0.
	current := anAddress.
	[ current < aLimit ] whileTrue: [
		| wrong size |
		wrong := self whyNotAnObjectAt: current.
		wrong ifNotNil: [
			^ SpurHeapWalk new
				  count: count free: free bytes: liveBytes freeBytes: freeBytes
				  at: current because: wrong;
				  yourself ].
		size := self bytesOfObjectAt: current.
		(self isFreeChunkAt: current)
			ifTrue: [
				free := free + 1.
				freeBytes := freeBytes + size.
				consecutiveFree := consecutiveFree + 1.
				consecutiveFree > 10000 ifTrue: [
					^ SpurHeapWalk new
						  count: count free: free bytes: liveBytes freeBytes: freeBytes
						  at: current because: #nothingButFreeSpace;
						  yourself ] ]
			ifFalse: [
				count := count + 1.
				liveBytes := liveBytes + size.
				consecutiveFree := 0 ].
		current := self objectAfter: current.
		current ifNil: [
			^ SpurHeapWalk new
				  count: count free: free bytes: liveBytes freeBytes: freeBytes
				  at: aLimit because: #couldNotStep;
				  yourself ] ].

	^ SpurHeapWalk new
		  count: count free: free bytes: liveBytes freeBytes: freeBytes
		  at: current because: #reachedTheLimit;
		  yourself
