contexts
whetherCode: someCode holdsBlock: aBlock

	"true where that method or block holds the block, as a literal or in a closure that is one
	(a clean or a constant block from Pharo 11); false where every literal reads and none does;
	nil where one does not read, the block's place perhaps: then it cannot be told."

	| unread |
	unread := false.
	(2 to: someCode numberOfLiterals + 1) do: [ :index |
		(someCode slotAt: index) = aBlock address ifTrue: [ ^ true ].
		[
		| literal |
		literal := someCode reifiedSlotAt: index.
		((literal isKindOf: OOPAbstractObject) and: [
			 literal oopFormat = 3 and: [
				 (1 to: (literal oopNumberOfSlots min: 8)) anySatisfy: [ :slot | (literal slotAt: slot) = aBlock address ] ] ]) ifTrue: [
			^ true ] ]
			on: PolyphemusError
			do: [ :unreadable | unread := true ] ].
	^ unread
		  ifTrue: [ nil ]
		  ifFalse: [ false ]
