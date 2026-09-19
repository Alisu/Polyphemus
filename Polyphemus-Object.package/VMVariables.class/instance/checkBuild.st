private
checkBuild

	"A symbol of another build names some other word: refuse unless the build-ids agree."

	checked ifTrue: [ ^ self ].
	(self library buildId notNil and: [ self buildIdInMemory = self library buildId ])
		ifFalse: [ ^ self refuse: #itsVMLibraryIsAnotherBuild ].
	checked := true
