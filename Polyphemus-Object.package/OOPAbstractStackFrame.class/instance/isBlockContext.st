context protocol
isBlockContext

	"Running a block rather than a method. A frame says so through the code it runs; false where
	that does not read."

	^ [ self compiledCode ifNil: [ false ] ifNotNil: [ :code | code isCompiledBlockOop ] ]
		  on: PolyphemusError
		  do: [ :e | false ]
