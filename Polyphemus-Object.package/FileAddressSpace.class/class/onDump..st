instance creation
onDump: aFileReference

	"The dump in that file, read by what it is: a Windows minidump, or else an ELF core (which
	refuses anything that is not one)."

	| magic |
	magic := aFileReference asFileReference binaryReadStreamDo: [ :stream | stream next: 4 ].
	^ (magic = 'MDMP' asByteArray
		   ifTrue: [ WindowsMinidump ]
		   ifFalse: [ ElfCoreDump ]) on: aFileReference
