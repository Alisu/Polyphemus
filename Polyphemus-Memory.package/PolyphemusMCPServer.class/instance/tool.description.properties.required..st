protocol
tool: aName description: aDescription properties: someProperties required: someNames

	"A tool that only reads, as the annotations say for clients to show; acting: says otherwise."

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
