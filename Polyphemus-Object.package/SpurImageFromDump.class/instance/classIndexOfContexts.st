writing
classIndexOfContexts

	"What a context's header says its class is, read from a context of this memory."

	^ (dumped raw scanner headerAt: self aContextOfThisMemory) bitAnd: 16r3FFFFF
