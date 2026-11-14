highlighting
blocksOfHost: aCompiledCode

	"Every compiled block of aCompiledCode, outermost first in literal order, skipping each
	block's last literal (its outer code)."

	| blocks literals |
	blocks := OrderedCollection new.
	literals := aCompiledCode literals.
	(aCompiledCode isCompiledBlock and: [ literals isEmpty not ]) ifTrue: [
		literals := literals allButLast ].
	literals do: [ :each |
		each isCompiledBlock ifTrue: [
			blocks add: each.
			blocks addAll: (self blocksOfHost: each) ] ].
	^ blocks
