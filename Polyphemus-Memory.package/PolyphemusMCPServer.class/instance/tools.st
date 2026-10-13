protocol
tools

	^ {
		  (self tool: 'open_image'
			   description: 'Read a Pharo image file (64-bit Spur, Pharo 10 to 14) without running it. Answers a handle for the other tools, and how many objects and bytes its old space holds.'
			   properties: (Dictionary new at: 'path' put: (self schema: 'string' saying: 'Absolute path of the .image file, on the machine Polyphemus runs on.'); yourself)
			   required: #( 'path' )).
		  (self tool: 'census'
			   description: 'Instances and bytes (headers included) of each class of an opened image, the heaviest first. Read from the raw object headers.'
			   properties: (Dictionary new
					    at: 'handle' put: (self schema: 'string' saying: 'As answered by open_image.');
					    at: 'top' put: (self schema: 'integer' saying: 'How many classes, 20 if not given.');
					    yourself)
			   required: #( 'handle' )).
		  (self tool: 'packages'
			   description: 'What each package of an opened image owns, in bytes, the heaviest first: its classes and metaclasses, method dictionaries, methods, blocks and method state. Extension methods count for the class''s package; what class variables keep alive is not counted.'
			   properties: (Dictionary new
					    at: 'handle' put: (self schema: 'string' saying: 'As answered by open_image.');
					    at: 'top' put: (self schema: 'integer' saying: 'How many packages, 20 if not given.');
					    yourself)
			   required: #( 'handle' )).
		  (self tool: 'open_core'
			   description: 'Read a core dump of a Pharo VM (Linux, 64-bit Spur, Pharo 10 to 14): the kernel''s, gcore''s or bin/take-dump.sh''s. Takes up to a minute. Answers a handle for processes and stack.'
			   properties: (Dictionary new at: 'path' put: (self schema: 'string' saying: 'Absolute path of the core file, on the machine Polyphemus runs on.'); yourself)
			   required: #( 'path' )).
		  (self tool: 'processes'
			   description: 'The Smalltalk processes of an opened image or core, numbered for stack: state, priority, name, how many frames, and the method on top.'
			   properties: (Dictionary new at: 'handle' put: (self schema: 'string' saying: 'As answered by open_image or open_core.'); yourself)
			   required: #( 'handle' )).
		  (self tool: 'stack'
			   description: 'The frames of one process, top first: method, the statement it was in, receiver, temporaries with their values. Temporaries are named only where this host compiles the method as the image did; otherwise their values are given by number, and the frame says why.'
			   properties: (Dictionary new
					    at: 'handle' put: (self schema: 'string' saying: 'As answered by open_image or open_core.');
					    at: 'process' put: (self schema: 'integer' saying: 'Its number, as processes answers it.');
					    at: 'depth' put: (self schema: 'integer' saying: 'How many frames, 20 if not given.');
					    yourself)
			   required: #( 'handle' 'process' )).
		  (self tool: 'inspect'
			   description: 'An object of an opened image or core, by its address (processes and stack give addresses): its class, format, named slots with their values, the first indexable ones, a string''s characters. Each slot that holds an object gives its address, to inspect in turn.'
			   properties: (Dictionary new
					    at: 'handle' put: (self schema: 'string' saying: 'As answered by open_image or open_core.');
					    at: 'address' put: (self schema: 'integer' saying: 'The object''s address.');
					    at: 'limit' put: (self schema: 'integer' saying: 'How many indexable slots, 20 if not given.');
					    yourself)
			   required: #( 'handle' 'address' )).
		  (self tool: 'where_stuck'
			   description: 'Where a running Pharo VM is, on Linux, from /proc: for each thread the system call it waits in, or where its pc is (machine code, a library and its function), and the signals the VM catches. A process that is running rather than waiting is stopped for a moment to look, then let go; nothing in it is changed. Needs permission to read that process (an ancestor, or bin/pharo-debuggable).'
			   properties: (Dictionary new at: 'pid' put: (self schema: 'integer' saying: 'The process id of the Pharo VM.'); yourself)
			   required: #( 'pid' )).
		  (self tool: 'open_process'
			   description: 'Read a running Pharo VM''s memory, from /proc on Linux or its task port on macOS (the observer run as root): it is held still while it is copied, at a moment it is quiet, then let go, and nothing in it is changed. Answers a handle for processes, stack and inspect, on that moment: the image runs on after it. Refused, with the reason, if the process is not a Pharo VM, cannot be read (an ancestor, or bin/pharo-debuggable, may read it) or never goes quiet (quietness is measured on Linux only).'
			   properties: (Dictionary new at: 'pid' put: (self schema: 'integer' saying: 'The process id of the Pharo VM.'); yourself)
			   required: #( 'pid' )) }
