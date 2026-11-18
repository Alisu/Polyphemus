holding
runUntil: aMethodSource within: aDuration

	"Let the image run until some process reaches that method, and hold it there, its debugger
	at the method's own context. Answers whether it was; if not, it is held where it got to. However
	it ends, no trap is wanted after it: one left in the image takes itself out (#181)."

	| reached |
	[
	self armTheTrapUntil: aMethodSource.
	reached := self runToTheTrapOf: aMethodSource within: aDuration ] valueThenLetGo: [
		reached ifNil: [ self giveUpTheTrap ] ifNotNil: [ self forget: #( 'trap-wanted' ) ] ].
	^ reached
