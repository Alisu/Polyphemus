baselines
baseline: spec
	<baseline>

	"VMMaker is pinned here, where a load can see it, rather than only in a build script.
	Polyphemus subclasses VMMaker's *test* classes, and the one it leans on hardest --
	VMSpurMemoryManagerTest>>newInterpreter -- was removed in v10.0.4. An unpinned load
	resolves whatever VMMaker it likes and breaks in a way that says nothing about why."

	spec for: #common do: [
		spec postLoadDoIt: #postLoad.
		spec
			baseline: 'VMMaker'
			with: [ spec repository: 'github://pharo-project/pharo-vm:v10.0.0/smalltalksrc' ].
		spec package: 'Polyphemus-Helper' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Memory' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Object' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Tests' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Builder' with: [ spec requires: #( 'VMMaker' ) ] ]
