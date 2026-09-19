checking
readsAsItsOwnSource: aMethod

	"Whether the text at aMethod's source pointer parses as a method of aMethod's selector."

	| source node |
	source := [ aMethod sourceCode ] on: Error do: [ :e | ^ false ].
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ false ].
	node := RBParser parseMethod: source onError: [ :message :position | ^ false ].
	^ [ node selector = aMethod oopSelector asString asSymbol ] on: Error do: [ :e | false ]
