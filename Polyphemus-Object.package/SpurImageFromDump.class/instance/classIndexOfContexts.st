writing
classIndexOfContexts

	"What a context's header says its class is, read from a context of this memory."

	^ SpurHeader classIndexOf: (dumped raw scanner headerAt: self aContextOfThisMemory)
