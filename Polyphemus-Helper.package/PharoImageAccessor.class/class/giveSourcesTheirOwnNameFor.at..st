pathFinding
giveSourcesTheirOwnNameFor: aNumber at: anImagePath

	"The download renames the sources after the image, where the image looks for them by the
	name it was built with: link that name to them, once (#38)."

	| name linked |
	name := (self sourcesNameForPharo: aNumber) ifNil: [ ^ self ].
	linked := anImagePath asFileReference parent / name.
	linked exists ifTrue: [ ^ self ].
	LibC system: 'ln -s ' , (anImagePath asFileReference withExtension: 'sources') fullName , ' '
		, linked fullName
