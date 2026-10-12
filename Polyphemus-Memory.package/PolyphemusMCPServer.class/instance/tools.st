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
			   required: #( 'handle' )) }
