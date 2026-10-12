running
setUp

	super setUp.
	server := PolyphemusMCPServer new.
	opening := STONJSON fromString: (server answer: (STONJSON toString: (Dictionary new
				              at: 'jsonrpc' put: '2.0';
				              at: 'id' put: 1;
				              at: 'method' put: 'tools/call';
				              at: 'params' put: (Dictionary new
						               at: 'name' put: 'open_image';
						               at: 'arguments' put: (Dictionary new at: 'path' put: PharoImageAccessor pathToPharo10; yourself);
						               yourself);
				              yourself))).
	handle := ((opening at: 'result') at: 'structuredContent') at: 'handle'.
	"The footprint is taken on the first packages call: on a Pharo 10 or 11 image it walks the
	heap for RPackages, too long for a test's time on a busy machine."
	server answer: (STONJSON toString: (Dictionary new
			  at: 'jsonrpc' put: '2.0';
			  at: 'id' put: 2;
			  at: 'method' put: 'tools/call';
			  at: 'params' put: (Dictionary new
					   at: 'name' put: 'packages';
					   at: 'arguments' put: (Dictionary new at: 'handle' put: handle; yourself);
					   yourself);
			  yourself))
