accessing
allCompiledBlocks

	"Every compiled block, outermost first in literal order, skipping each block's back-
	pointer literal and anything already visited."

	| blocks seen walk |
	blocks := OrderedCollection new.
	seen := OrderedCollection new.
	walk := nil.
	walk := [ :code |
	        | literals |
	        literals := [ code allLiterals ] on: Error do: [ :e | #(  ) ].
	        ([ code isCompiledBlockOop ] on: Error do: [ :e | false ]) ifTrue: [
		        literals := literals allButLast ].
	        literals do: [ :each |
		        (([ each isCompiledBlockOop ] on: Error do: [ :e | false ]) and: [
			         (seen includes: each) not ]) ifTrue: [
			        seen add: each.
			        blocks add: each.
			        walk value: each ] ] ].
	walk value: self.
	^ blocks
