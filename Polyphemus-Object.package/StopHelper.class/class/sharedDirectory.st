accessing
sharedDirectory

	"The same for every user, so that a root observer's stop and a user's exclude each other."

	^ '/tmp/polyphemus-stop' asFileReference
