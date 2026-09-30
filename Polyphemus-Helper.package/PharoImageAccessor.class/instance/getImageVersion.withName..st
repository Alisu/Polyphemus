action
getImageVersion: aNumber withName: imageName

	LibC runCommand: (self class
			 fetchCommandFrom: 'https://files.pharo.org/image/' , (aNumber * 10) asString , '/' , imageName , '.zip'
			 named: (self class nameForVersion: aNumber imageName: imageName)
			 into: ((IceRepository registeredRepositoryIncludingPackage: self class package) location / 'resources') pathString)
