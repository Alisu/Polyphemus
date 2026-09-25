live images
debugProcess: aPid watchedIn: aDirectory

	"Pharo's debugger on what a running image was busy with: its buttons step it there,
	accepting nothing yet, and proceeding lets it go (holdProcess:watchedIn:)."

	^ StDebugger
		  openOn: (self holdProcess: aPid watchedIn: aDirectory)
		  withFullView: true
