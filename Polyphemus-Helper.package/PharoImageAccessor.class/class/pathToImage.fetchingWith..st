pathFinding
pathToImage: anImageName fetchingWith: aBlock

	"The image in resources/, fetched by aBlock once if missing; still missing, an error says
	which and where, where retrying looped until a test timed out (no flock on macOS)."

	| path |
	path := self pathToImageNamed: anImageName.
	path asFileReference exists ifTrue: [ ^ path ].
	aBlock value.
	path asFileReference exists ifFalse: [
		self error: 'Could not fetch ' , anImageName , ' into ' , path asFileReference parent fullName
			, ': is curl there, and files.pharo.org reachable?' ].
	^ path
