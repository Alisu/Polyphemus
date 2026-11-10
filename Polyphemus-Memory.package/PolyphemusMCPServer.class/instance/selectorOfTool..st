protocol
selectorOfTool: aName

	"The method answering a tool tools lists, named after it: where_stuck by whereStuck:."

	| parts |
	((self tools collect: [ :each | each at: 'name' ]) includes: aName) ifFalse: [ ^ nil ].
	parts := aName substrings: '_'.
	^ (parts first , (String join: (parts allButFirst collect: [ :each | each capitalized ])) , ':') asSymbol
