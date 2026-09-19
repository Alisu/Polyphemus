frames
vmLayout

	"How the VM that wrote this memory laid out its frames and compiled methods. A simulator's by default; a dump sets Cog's."

	^ vmLayout ifNil: [ vmLayout := OOPStackInterpreterLayout on: self ]
