tests
testASharedDirectoryThisUserCannotWriteIsLeftForItsOwn

	"Made by root before it was opened to all, it would leave a user's observer unable to stop
	anything: that user's own directory then, as before #163."

	| own |
	own := FileLocator temp / ('polyphemus-own-' , UUID new asString).
	[
	self assert: (StopHelper directoryShared: '/dev/null/polyphemus-stop' asFileReference else: own) equals: own.
	self assert: own exists ] ensure: [ own ensureDeleteAll ]
