tests
testSourceIsReadFromTheImageOwnSourcesFile

	"Several images share the resources directory. The source of a Pharo 10 image must
	come from its own .sources: reading a Pharo 11 one answers quiet nonsense."

	| chosen |
	chosen := reifiedMemory
		          fileNamed: 'cleanP10.sources'
		          orAnyMatching: '*.sources'
		          in: reifiedMemory interpreter imageName asFileReference parent.

	self assert: chosen basename equals: 'cleanP10.sources'
