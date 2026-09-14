context protocol
isBlockContext

	"Running a block rather than a method. A frame says so through the code it runs."

	^ [ self compiledCode isCompiledBlockOop ] on: Error do: [ :e | false ]
