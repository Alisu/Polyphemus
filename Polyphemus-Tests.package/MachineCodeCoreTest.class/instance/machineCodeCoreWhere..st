helpers
machineCodeCoreWhere: aKind

	"A core of a spinning target caught in machine code, of aKind: #inItsFrame when its
	registers describe the newest frame, #inAFramelessCallee when that one has no frame of its
	own yet. gdb attaches up to fifteen times; each core is kept under its kind. nil if none."

	| pid |
	Cores ifNil: [ Cores := Dictionary new ].
	((Cores at: aKind ifAbsent: [ nil ]) ifNotNil: [ :file | file exists ] ifNil: [ false ]) ifTrue: [
		^ Cores at: aKind ].
	(LibC system: 'command -v gdb > /dev/null') = 0 ifFalse: [ ^ nil ].
	pid := self launchSpinningTarget.
	[
	(1 to: 15) do: [ :each |
		| attempt kind |
		attempt := PolyphemusEdition current scratch / 'polyphemus-machine-code-attempt.core'.
		attempt ensureDelete.
		LibC system: 'env -u LD_LIBRARY_PATH timeout 60 gdb -p ' , pid printString , ' --batch -ex "gcore '
			, attempt fullName , '" > /dev/null 2>&1'.
		kind := self kindOf: attempt.
		"renameTo: moves the reference too: only an attempt not kept is deleted."
		(kind notNil and: [ (Cores includesKey: kind) not ])
			ifTrue: [
				| kept |
				kept := PolyphemusEdition current scratch / ('polyphemus-machine-code-' , kind , '.core').
				kept ensureDelete.
				attempt renameTo: kept basename.
				Cores at: kind put: kept ]
			ifFalse: [ attempt ensureDelete ].
		(Cores includesKey: aKind) ifTrue: [ ^ Cores at: aKind ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ].
	^ nil
