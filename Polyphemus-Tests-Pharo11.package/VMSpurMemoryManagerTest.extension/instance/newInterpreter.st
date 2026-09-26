*Polyphemus-Tests-Pharo11
newInterpreter

	"Removed in VMMaker v10.0.4, where setUp builds the whole environment: our fixtures open an
	image in the simulator instead, so they need only the interpreter and memory it builds. A
	test resource's instance is not parameterized: its images are single files."

	imageReaderClass ifNil: [ imageReaderClass := SpurImageReader ].
	imageWriterClass ifNil: [ imageWriterClass := SpurImageWriter ].
	environmentBuilder := VMSimulatedEnvironmentBuilder new.
	self configureEnvironmentBuilder.
	environmentBuilder doBuildSimulator.
	memory := environmentBuilder objectMemory.
	^ interpreter := environmentBuilder interpreter
