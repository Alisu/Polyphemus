tests
testATargetLeavesThePinnedImagesChangesAlone

	"#145: a target appends to its changes; launched at once on the pinned image, two pointed a
	method's source into the other's text, and the trap read a selector out of it."

	| changes before pid |
	changes := PharoImageAccessor pathToTargetImage asFileReference withExtension: 'changes'.
	before := changes size.
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[ self assert: changes size equals: before ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
