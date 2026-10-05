naming
locationOf: aPc codeZone: anAssociationOrNil files: someMappedFiles

	"Where a pc lies: Cog's code zone (machine code), or a mapped file by name with the
	function holding it when the file's symbols say, or neither."

	| file |
	(anAssociationOrNil notNil and: [ aPc >= anAssociationOrNil key and: [ aPc < anAssociationOrNil value ] ])
		ifTrue: [ ^ 'machine code, in Cog''s code zone' ].
	file := someMappedFiles detect: [ :each | aPc between: each start and: each stop - 1 ] ifNone: [ ^ 'anonymous memory' ].
	^ (self functionAt: aPc in: file among: someMappedFiles)
		  ifNil: [ file path asFileReference basename ]
		  ifNotNil: [ :name | file path asFileReference basename , ', in ' , name ]
