tests
testItListsTheFilesItMapsOncePerStop

	"The copy and the reading of one stop both ask which files the process maps: listed once while
	it is stopped, listed again once it ran (#135)."

	| pid reader first |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStopped: [
		first := reader mappedFiles.
		self assert: reader mappedFiles identicalTo: first ].
	reader whileStopped: [ self deny: reader mappedFiles identicalTo: first ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
