reifying
complete

	"Every object reified, when this reading was left to complete itself."

	| dumped |
	whole ifNil: [ ^ self ].
	dumped := whole.
	whole := nil.
	instancesByClassTag := nil.
	dumped reifyEverything: self
