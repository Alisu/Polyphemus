baselines
baseline: spec
	<baseline>

	"VMMaker is pinned where a load sees it: Polyphemus-Tests subclasses its test classes, and
	v10.0.4 removed VMSpurMemoryManagerTest>>newInterpreter. The tool asks only for VMMaker's
	'core' group; 'core' gets the tool, a load without a group the tests as well."

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
	{ 10 -> 'v10.0.0'. 11 -> 'v10.0.5'. 12 -> 'v10.3.2'. 13 -> 'v10.3.11'. 14 -> 'v12.0.5-beta' } do: [ :each |
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

	"The host: one Polyphemus-Host package each, naming the operating system and processor every
	edition is made for, picked by the attribute customProjectAttributes adds. A host with none
	loads no edition that would run."
	{ #'linux-x64' -> 'Polyphemus-Host-Linux-x64'. #'macos-arm64' -> 'Polyphemus-Host-MacOS-arm64'.
	  #'windows-x64' -> 'Polyphemus-Host-Windows-x64' } do: [ :each |
		spec for: each key do: [
			spec package: each value with: [ spec requires: #( 'Polyphemus-Object' ) ].
			spec group: 'core' with: { each value } ] ].

	"What VMMaker v10.0.4 and later need -- the memory map, VM 10's split memory -- for the tool
	and for its tests."
	spec for: #( #'pharo11.x' #'pharo12.x' #'pharo13.x' #'pharo14.x' ) do: [
		spec
			package: 'Polyphemus-VMMaker-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Object' ) ];
			package: 'Polyphemus-Tests-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Tests' ) ].
		spec group: 'core' with: #( 'Polyphemus-VMMaker-MemoryMap' ).
		spec group: 'tests' with: #( 'Polyphemus-Tests-MemoryMap' ) ]
