helpers
readers

	"The readers of a running process this image has loaded: Linux always, macOS and Windows on
	their own systems."

	^ #( #LinuxProcessMemory #MacProcessMemory #WindowsProcessMemory )
		  collect: [ :each | Smalltalk at: each ifAbsent: [ nil ] ]
		  thenSelect: [ :each | each notNil ]
