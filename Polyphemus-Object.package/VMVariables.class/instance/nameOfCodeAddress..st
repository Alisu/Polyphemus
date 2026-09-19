accessing
nameOfCodeAddress: anAddress

	^ self trampolines at: anAddress ifAbsent: [ nil ]
