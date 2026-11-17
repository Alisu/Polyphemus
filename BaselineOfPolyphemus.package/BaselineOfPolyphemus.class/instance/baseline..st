baselines
baseline: spec
	<baseline>

	"VMMaker is pinned where a load sees it (Polyphemus-Tests subclasses its test classes). Groups:
	'reading' reads and holds without a window, 'mcp' adds the MCP server, 'core' is the whole tool
	with its windows; a load without a group adds the tests and what only they use."

	spec for: #common do: [
		spec postLoadDoIt: #postLoad.

		spec package: 'Polyphemus-Helper' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Headless' with: [ spec requires: #( 'Polyphemus-Object' ) ].
		spec package: 'Polyphemus-Memory' with: [ spec requires: #( 'VMMaker' 'Polyphemus-Object' 'Polyphemus-Headless' ) ].
		spec package: 'Polyphemus-MCP' with: [ spec requires: #( 'Polyphemus-Object' 'Polyphemus-Headless' ) ].
		spec package: 'Polyphemus-Object' with: [ spec requires: #( 'VMMaker' ) ].
		spec package: 'Polyphemus-Builder' with: [ spec requires: #( 'VMMaker' 'Polyphemus-Object' ) ].
		spec package: 'Polyphemus-Tests' with: [
			spec requires:
				#( 'VMMakerWithItsTests' 'Polyphemus-Object' 'Polyphemus-Headless' 'Polyphemus-Memory'
				   'Polyphemus-MCP' 'Polyphemus-Builder' 'Polyphemus-Helper' ) ].

		spec
			group: 'reading' with: #( 'Polyphemus-Object' 'Polyphemus-Headless' );
			group: 'mcp' with: #( 'reading' 'Polyphemus-MCP' );
			group: 'core' with: #( 'reading' 'Polyphemus-Memory' 'Polyphemus-MCP' );
			group: 'tests' with: #( 'Polyphemus-Helper' 'Polyphemus-Builder' 'Polyphemus-Tests' );
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
			spec group: 'reading' with: { edition } ] ].

	"The host: one Polyphemus-Host package each, naming the operating system and processor every
	edition is made for, picked by the attribute customProjectAttributes adds. A host with none
	loads no edition that would run."
	{ #'linux-x64' -> 'Polyphemus-Host-Linux-x64'. #'macos-arm64' -> 'Polyphemus-Host-MacOS-arm64'.
	  #'windows-x64' -> 'Polyphemus-Host-Windows-x64' } do: [ :each |
		spec for: each key do: [
			| itsTests |
			itsTests := each value copyReplaceAll: 'Polyphemus-Host-' with: 'Polyphemus-Tests-Host-'.
			spec package: each value with: [ spec requires: #( 'Polyphemus-Object' ) ].
			spec package: itsTests with: [ spec requires: { each value. 'Polyphemus-Tests' } ].
			spec group: 'reading' with: { each value }.
			spec group: 'tests' with: { itsTests } ] ].

	"What VMMaker v10.0.4 and later need -- the memory map, VM 10's split memory -- for the tool
	and for its tests."
	spec for: #( #'pharo11.x' #'pharo12.x' #'pharo13.x' #'pharo14.x' ) do: [
		spec
			package: 'Polyphemus-VMMaker-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Object' ) ];
			package: 'Polyphemus-Tests-MemoryMap'
			with: [ spec requires: #( 'Polyphemus-Tests' ) ].
		spec group: 'reading' with: #( 'Polyphemus-VMMaker-MemoryMap' ).
		spec group: 'tests' with: #( 'Polyphemus-Tests-MemoryMap' ) ]
