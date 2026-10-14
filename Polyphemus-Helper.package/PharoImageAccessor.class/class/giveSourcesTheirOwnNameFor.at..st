pathFinding
giveSourcesTheirOwnNameFor: aNumber at: anImagePath

	"The download renames the sources after the image, where the image looks for them by the
	name it was built with: link that name to them, once (#38); copy on Windows, where links
	need rights a user does not have."

	| name linked sources |
	name := (self sourcesNameForPharo: aNumber) ifNil: [ ^ self ].
	linked := anImagePath asFileReference parent / name.
	linked exists ifTrue: [ ^ self ].
	sources := anImagePath asFileReference withExtension: 'sources'.
	OSPlatform current isWindows ifTrue: [ ^ sources copyTo: linked ].
	LibC system: 'ln -s ' , sources fullName , ' ' , linked fullName
