accessing
packagesEachMayName

	"Each package of the tool, and those whose classes it may name: the core none, what works
	without a window the core, the MCP server and the windows those two, never one another."

	| core |
	core := #( 'Polyphemus-Object' ).
	^ Dictionary new
		  at: 'Polyphemus-Object' put: #(  );
		  at: 'Polyphemus-Headless' put: core;
		  at: 'Polyphemus-MCP' put: #( 'Polyphemus-Object' 'Polyphemus-Headless' );
		  at: 'Polyphemus-Memory' put: #( 'Polyphemus-Object' 'Polyphemus-Headless' );
		  at: 'Polyphemus-VMMaker-MemoryMap' put: core;
		  at: 'Polyphemus-Host-Linux-x64' put: core;
		  at: 'Polyphemus-Host-MacOS-arm64' put: core;
		  at: 'Polyphemus-Host-Windows-x64' put: core;
		  at: 'Polyphemus-Edition-Pharo10' put: core;
		  at: 'Polyphemus-Edition-Pharo11' put: core;
		  at: 'Polyphemus-Edition-Pharo12' put: core;
		  at: 'Polyphemus-Edition-Pharo13' put: core;
		  at: 'Polyphemus-Edition-Pharo14' put: core;
		  yourself
