locking
release

	"Ours no more; another observer's is left as it is."

	self owner = self hosts ownPid ifTrue: [ self lockDirectory ensureDeleteAll ]
