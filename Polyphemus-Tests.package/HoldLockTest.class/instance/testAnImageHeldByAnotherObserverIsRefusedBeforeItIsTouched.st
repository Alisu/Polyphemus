tests
testAnImageHeldByAnotherObserverIsRefusedBeforeItIsTouched

	"No reader at all: refused before the image is stopped or rung."

	self lockOwnedBy: self aPidThatRuns.
	self should: [ (HeldImage new setReader: nil directory: directory) holdWithin: 1 second ] raise: HoldFailed
