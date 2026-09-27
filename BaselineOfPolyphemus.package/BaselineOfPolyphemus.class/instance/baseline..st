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

	"The edition, chosen by the host's Pharo: one package each, defining forThisHost, and the
	VMMaker it reads with -- the one its targets' VM was generated from (docs/editions.md)."
	{ 10 -> 'v10.0.0'. 11 -> 'v10.0.5'. 12 -> 'v10.3.2' } do: [ :each |
		spec for: ('pharo' , each key printString , '.x') asSymbol do: [
			| edition |
			spec baseline: 'VMMaker' with: [
				spec
					repository: 'github://pharo-project/pharo-vm:' , each value , '/smalltalksrc';
					loads: #( 'core' ) ].
			spec
				project: 'VMMakerWithItsTests'
				copyFrom: 'VMMaker'
				with: [ spec loads: #( 'core' 'tests' ) ].
			edition := 'Polyphemus-Edition-Pharo' , each key printString.
			spec package: edition with: [ spec requires: #( 'Polyphemus-Object' ) ].
			spec group: 'core' with: { edition } ] ].

	"What VMMaker v10.0.4 and later need -- the memory map, VM 10's split memory -- for the tool
	and for its tests."
	spec for: #( #'pharo11.x' #'pharo12.x' ) do: [
		spec
			package: 'Polyphemus-VMMaker-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Object' ) ];
			package: 'Polyphemus-Tests-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Tests' ) ].
		spec group: 'core' with: #( 'Polyphemus-VMMaker-MemoryMap' ).
		spec group: 'tests' with: #( 'Polyphemus-Tests-MemoryMap' ) ]
