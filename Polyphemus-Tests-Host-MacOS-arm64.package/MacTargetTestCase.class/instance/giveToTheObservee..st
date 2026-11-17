helpers
giveToTheObservee: aDirectory

	"aDirectory, made here, made the observee user's (observeeUser), as one it made itself."

	self observeeUser ifNotNil: [ :user | LibC system: 'chown -R ' , user , ' "' , aDirectory fullName , '"' ].
	^ aDirectory
