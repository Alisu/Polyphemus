tests
testAStringWhoseHeaderIsZeroedReadsAsFreeSpaceTheListsDoNotKnow
	<readsAnUnsoundHeap>

	"#207: the header of a string zeroed, three widths of string. Classes are found by name before
	anything is reified, and VMMaker asserted on the size of a name that is no object. The ladder
	says the free lists do not know it; the file then reads, or VMMaker's walk stops there by name."

	#( 16 17 18 ) do: [ :format |
		self withACopyDamagedBy: (self firstObjectOfFormat: format) address -> 0 do: [ :copy |
			| outcome |
			self assert: ((Polyphemus readabilityOfImageFile: copy fullName) whyNot: #freeSpace) equals: #theListsAndTheHeapDisagreeAboutFreeSpace.
			outcome := [
			           Polyphemus readImageFile: copy fullName.
			           #read ]
				           on: SpurCannotRead
				           do: [ :refusal | refusal reason ].
			self assert: (#( #read #theSimulatorsWalkStopped ) includes: outcome) ] ]
