context protocol
readLocal: aVariable ofScope: aScope

	"Read a variable this frame holds. Most live in the frame itself, one slot per name,
	after the six fixed ones. A captured one lives in a vector that the frame holds, and
	its index counts inside that vector, not in the frame: reading it as an ordinary
	temporary would answer whatever else is at that position."

	| vector |
	vector := self vectorHolding: aVariable inScope: aScope.
	vector ifNotNil: [
		^ (self tempAt: vector index) reifiedSlotAt: aVariable index ].

	aVariable index ifNil: [
		^ self error: 'cannot tell where ' , aVariable name asString , ' is kept' ].

	^ self tempAt: aVariable index
