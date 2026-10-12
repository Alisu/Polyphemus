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
			   required: #( 'handle' 'process' )) }
