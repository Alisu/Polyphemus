private
reboundThrough: anIdentityDictionary

	"Point every wrapper this one holds, and its reading, at their counterparts there. A
	collection of them is copied, not changed: the wrapper this one was copied from shares it."

	1 to: self class instSize do: [ :index |
		| value |
		value := self instVarAt: index.
		self instVarAt: index put: (anIdentityDictionary at: value ifAbsent: [
				 (value isKindOf: Collection)
					 ifTrue: [ value collect: [ :each | anIdentityDictionary at: each ifAbsent: [ each ] ] ]
					 ifFalse: [ value ] ]) ]
