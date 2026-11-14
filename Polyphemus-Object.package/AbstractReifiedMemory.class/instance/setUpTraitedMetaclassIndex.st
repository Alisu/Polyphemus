initialization
setUpTraitedMetaclassIndex

	traitedMetaclassIndex := (self preFindClassNamed: 'TraitedMetaclass' ifAbsent: [ 0 ]) - 1
