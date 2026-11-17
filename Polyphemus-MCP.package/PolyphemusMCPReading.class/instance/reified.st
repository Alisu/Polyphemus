reading
reified

	"Its objects: an image file's reified when first asked for, a core's and a process's when it
	was opened. A held image is read through its session, not here."

	^ reified ifNil: [
		  memory ifNil: [
			  ^ ToolCallFailed signal: handle asString , ' is ' , kind , ': this tool reads an image file, a core or a process read' ].
		  reified := FullyReifiedMemory on: memory ]
