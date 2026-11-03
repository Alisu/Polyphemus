private
indexOurMethods

	"One pass over every method of the image, keeping ours by the selectors they send and the
	globals they refer to: the walk's steps look these up rather than search again (#131)."

	imageSearches := self imageSearches + 1.
	senders := Dictionary new.
	references := Dictionary new.
	Smalltalk allClassesAndTraits do: [ :each |
		{ each. each classSide } do: [ :behavior |
			behavior localMethods do: [ :method |
				(self isOurs: method) ifTrue: [
					method messages do: [ :selector | (senders at: selector ifAbsentPut: [ Set new ]) add: method ].
					self literalsIn: method do: [ :literal |
						literal isSymbol ifTrue: [ (senders at: literal ifAbsentPut: [ Set new ]) add: method ].
						literal isVariableBinding ifTrue: [
							(references at: literal key ifAbsentPut: [ Set new ]) add: method ] ] ] ] ] ]
