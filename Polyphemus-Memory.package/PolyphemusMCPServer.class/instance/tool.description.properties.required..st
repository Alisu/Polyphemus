protocol
tool: aName description: aDescription properties: someProperties required: someNames

	"Every tool of this slice only reads: the annotations say so, for clients to show."

	^ Dictionary new
		  at: 'name' put: aName;
		  at: 'description' put: aDescription;
		  at: 'inputSchema' put: (Dictionary new
				   at: 'type' put: 'object';
				   at: 'properties' put: someProperties;
				   at: 'required' put: someNames asArray copy;
				   yourself);
		  at: 'annotations' put: (Dictionary new
				   at: 'readOnlyHint' put: true;
				   at: 'openWorldHint' put: false;
				   yourself);
		  yourself
