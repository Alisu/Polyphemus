testing
isActiveFrame

	"The one the interpreter's registers describe. Every other frame's state was written
	into the stack page when the VM left it."

	^ [ memory interpreter framePointer = framePointer ]
		  on: Error
		  do: [ :e | false ]
