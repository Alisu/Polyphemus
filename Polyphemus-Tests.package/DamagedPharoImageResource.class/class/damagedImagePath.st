building
damagedImagePath

	"Its name counts the versions of #damagesIn:, so a copy built for other damage is not taken."

	| clean damaged |
	clean := PharoImageAccessor pathToPharo10 asFileReference.
	damaged := clean parent / 'cleanP10-damaged-4.image'.
	damaged exists ifFalse: [ self buildDamagedCopyFrom: clean to: damaged ].
	^ damaged fullName
