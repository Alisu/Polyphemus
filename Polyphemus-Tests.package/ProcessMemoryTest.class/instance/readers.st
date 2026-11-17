helpers
readers

	"The readers of a running process this image has loaded: each host's on its own system."

	^ #( #LinuxProcessMemory #MacProcessMemory #WindowsProcessMemory )
		  collect: [ :each | Smalltalk at: each ifAbsent: [ nil ] ]
		  thenSelect: [ :each | each notNil ]
