checking
readsAsItsOwnSource: aMethod

	"Whether the text at aMethod's source pointer parses as a method of aMethod's selector. Not
	so where its selector or its source does not read."

	| selector source node |
	selector := [ aMethod oopSelector asString asSymbol ] on: PolyphemusError do: [ :refusal | ^ false ].
	source := [ aMethod sourceCode ] on: PolyphemusError do: [ :refusal | ^ false ].
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ false ].
	node := ForeignCode
		        askingPharo: [ AbstractReifiedMemory parserClass parseMethod: source onError: [ :message :position | ^ false ] ]
		        ifItFails: [ ^ false ].
	^ node selector = selector
