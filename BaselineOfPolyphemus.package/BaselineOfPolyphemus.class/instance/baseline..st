baselines
baseline: spec
	<baseline>

	"VMMaker is pinned here, where a load can see it, rather than only in a build script.
	Polyphemus subclasses VMMaker's *test* classes, and the one it leans on hardest --
	VMSpurMemoryManagerTest>>newInterpreter -- was removed in v10.0.4. An unpinned load
	resolves whatever VMMaker it likes and breaks in a way that says nothing about why.

	Only Polyphemus-Tests needs those. Everything the tool itself runs on -- the Spur memory
	managers, the interpreter simulators, the Cogit, the image reader and writer -- is in
	VMMaker's own 'core' group, so the tool asks for that alone and skips VMMakerTests,
	VMMaker-Tools, Unicorn and the LLVM disassembler. Loading 'core' gets the tool; loading
	without a group gets the tests as well, as it always did."

	spec for: #common do: [
		spec postLoadDoIt: #postLoad.
		spec baseline: 'VMMaker' with: [
			spec
				repository: 'github://pharo-project/pharo-vm:v10.0.0/smalltalksrc';
				loads: #( 'core' ) ].
		spec
			project: 'VMMakerWithItsTests'
			copyFrom: 'VMMaker'
			with: [ spec loads: #( 'core' 'tests' ) ].

		spec package: 'Polyphemus-Helper' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Memory' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Object' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Builder' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Tests' with: [
			spec requires:
				#( 'VMMakerWithItsTests' 'Polyphemus-Object' 'Polyphemus-Builder' ) ].

		spec
			group: 'core'
			with: #( 'Polyphemus-Helper' 'Polyphemus-Memory' 'Polyphemus-Object'
			         'Polyphemus-Builder' );
			group: 'tests' with: #( 'Polyphemus-Tests' );
			group: 'default' with: #( 'core' 'tests' ) ].

	"The edition, chosen by the host's Pharo: one package each, defining forThisHost."
	#( 10 11 ) do: [ :major |
		spec for: ('pharo' , major printString , '.x') asSymbol do: [
			| edition |
			edition := 'Polyphemus-Edition-Pharo' , major printString.
			spec package: edition with: [ spec requires: #( 'Polyphemus-Object' ) ].
			spec group: 'core' with: { edition } ] ]
