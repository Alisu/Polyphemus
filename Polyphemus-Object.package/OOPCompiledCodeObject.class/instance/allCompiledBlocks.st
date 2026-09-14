accessing
allCompiledBlocks

	"Every compiled block of this code and of its blocks, outermost first, in the order the
	compiler laid them down as literals. That order is what lets a running block be matched
	to the block in the source it came from.

	The last literal of a compiled block is the code it is installed in, so following
	literals blindly walks back out to the method and then in again forever. Dropping that
	literal cuts the loop; the visited set is there because a file that has been corrupted
	does not owe us a tree."

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
