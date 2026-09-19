tests
testAJittedFrameReadsItsMethodAndReceiverButNotItsPC

	"Its method comes through the CogMethod it runs. Its pc is an address in machine code,
	which needs Cog's map to become a bytecode pc, so it answers none."

	| jitted |
	jitted := self allFrames select: [ :each | each isMachineCodeFrame ].

	self assert: jitted size >= 28.
	jitted do: [ :each |
		self assert: (each compiledCode isCompiledMethodOop or: [ each compiledCode isCompiledBlockOop ]).
		self assert: each oopReceiver notNil.
		self assert: each pc isNil ]
