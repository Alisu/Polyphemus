tests
testTheAgentWaitsInCodeSmallEnoughForTheJIT

	"#167: Cog compiles no method of more than sixty literals, and the agent's script has more: its
	wait for a ring ran in the interpreter, the VM's own code, where a stop cannot tell whether
	the VM is remembering an object. The wait is a block of its own, which Cog does compile."

	| script waits |
	script := UndefinedObject compiler
		          source: 'polyphemusAgentScript
' , (PolyphemusAgent sourceServingOnItsOwnBell: directory);
		          compile.
	waits := script literals select: [ :each |
		         (each isKindOf: CompiledBlock) and: [
			         (each literals includes: #millisecondClockValue) and: [ each literals includes: #exists ] ] ].
	self assert: script numLiterals > 60.
	self assert: waits size equals: 1.
	self assert: waits first numLiterals <= 60
