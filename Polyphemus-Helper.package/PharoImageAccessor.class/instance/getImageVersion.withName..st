action
getImageVersion: aNumber withName: imageName

	| url name resources |
	url := 'https://files.pharo.org/image/' , (aNumber * 10) asString , '/' , imageName , '.zip'.
	name := self class nameForVersion: aNumber imageName: imageName.
	resources := (IceRepository registeredRepositoryIncludingPackage: self class package) location / 'resources'.
	OSPlatform current isWindows ifTrue: [ ^ self fetchWithoutShellFrom: url named: name into: resources ].
	LibC runCommand: (self class fetchCommandFrom: url named: name into: resources pathString)
