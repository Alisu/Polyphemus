naming
read: aVariable ofScope: aScope in: anActivation

	"Read a variable this activation holds. Most live in the activation itself, one slot per
	name. A captured one lives in a vector that it holds, and the variable's index counts
	inside that vector: reading it as an ordinary temporary would answer whatever else is at
	that position."

	| vector |
	vector := self vectorHolding: aVariable inScope: aScope.
	vector ifNotNil: [
		^ (anActivation tempAt: vector index) reifiedSlotAt: aVariable index ].

	aVariable index ifNil: [
		^ self error: 'cannot tell where ' , aVariable name asString , ' is kept' ].

	^ anActivation tempAt: aVariable index
