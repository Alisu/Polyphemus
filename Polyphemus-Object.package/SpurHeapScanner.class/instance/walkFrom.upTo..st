walking
walkFrom: anAddress upTo: aLimit

	"Step from object to object and answer how far it got. The count is the whole point: it is
	the length of the run that says a region is a heap, never any single header."

	| count current |
	count := 0.
	current := anAddress.
	[ current < aLimit ] whileTrue: [
		| wrong |
		wrong := self whyNotAnObjectAt: current.
		wrong ifNotNil: [
			^ SpurHeapWalk new
				  count: count at: current because: wrong;
				  yourself ].
		count := count + 1.
		current := self objectAfter: current.
		current ifNil: [
			^ SpurHeapWalk new
				  count: count at: aLimit because: #couldNotStep;
				  yourself ] ].

	^ SpurHeapWalk new
		  count: count at: current because: #reachedTheLimit;
		  yourself
