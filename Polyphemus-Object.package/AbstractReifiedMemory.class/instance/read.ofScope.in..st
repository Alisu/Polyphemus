naming
read: aVariable ofScope: aScope in: anActivation

	"Read a variable of this activation: one slot per name, except a captured one, which lives
	in a vector the activation holds and is indexed inside it."

	| vector |
	vector := self vectorHolding: aVariable inScope: aScope.
	vector ifNotNil: [
		^ (anActivation tempAt: vector index) reifiedSlotAt: aVariable index ].

	aVariable index ifNil: [
		^ self error: 'cannot tell where ' , aVariable name asString , ' is kept' ].

	^ anActivation tempAt: aVariable index
