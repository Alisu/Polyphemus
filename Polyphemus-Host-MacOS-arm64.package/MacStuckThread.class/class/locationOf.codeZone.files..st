naming
locationOf: aPc codeZone: anAssociationOrNil files: someMappedFiles

	"Cog's code zone or a file mapped into the process, as on Linux; else the system's shared
	libraries, which map no file of their own."

	| location |
	location := super locationOf: aPc codeZone: anAssociationOrNil files: someMappedFiles.
	location = 'anonymous memory' ifFalse: [ ^ location ].
	^ (self functionAt: aPc) ifNil: [ location ]
