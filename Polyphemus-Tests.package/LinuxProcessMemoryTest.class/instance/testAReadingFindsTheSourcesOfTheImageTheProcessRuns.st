tests
testAReadingFindsTheSourcesOfTheImageTheProcessRuns

	"Named after the image the process runs, which the VM keeps, a reading finds that image's
	sources -- not whichever sit in our own working directory (#39)."

	| pid reader |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStoppedWhenQuiet: [
		| dumped reading class |
		dumped := SpurDumpedMemory on: reader.
		self
			assert: dumped imageName
			equals: PharoImageAccessor pathToPharo10 asFileReference fullName.
		reading := dumped reifiedMemory.
		class := reading oopClassNamed: 'SmallInteger'.
		self assert:
			((class methodNamed: 'even') getSourceFromFile beginsWith: 'even') ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
