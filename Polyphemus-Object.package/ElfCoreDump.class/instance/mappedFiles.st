accessing
mappedFiles

	"The files mapped into the process, from the NT_FILE note the kernel and gdb write.
	Empty for a dump with no such note."

	| found |
	found := OrderedCollection new.
	(segments select: [ :each | each kind = 4 ]) do: [ :notes |
		ElfNote
			in: (self bytesAtOffset: notes fileOffset count: notes sizeInFile)
			do: [ :type :name :description |
				type = 16r46494C45 ifTrue: [
					found addAll: (ElfNote fileMappingsIn: description) ] ] ].
	^ found
