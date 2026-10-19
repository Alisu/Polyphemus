initialization
setLines: someLines

	selectors := Set new.
	classes := Set new.
	someLines do: [ :each |
		| parts |
		parts := each substrings: ' '.
		parts size >= 2
			ifTrue: [ selectors add: parts first -> parts second asSymbol ]
			ifFalse: [ parts ifNotEmpty: [ classes add: parts first ] ] ]
