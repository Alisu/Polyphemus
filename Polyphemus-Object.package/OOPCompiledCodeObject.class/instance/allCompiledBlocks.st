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
	        literals := [ code allLiterals ] on: PolyphemusError do: [ :e | #(  ) ].
	        code isCompiledBlockOop ifTrue: [
		        literals := literals allButLast ].
	        literals do: [ :each |
		        (each isCompiledBlockOop and: [
			         (seen includes: each) not ]) ifTrue: [
			        seen add: each.
			        blocks add: each.
			        walk value: each ] ] ].
	walk value: self.
	^ blocks
