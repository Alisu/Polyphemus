protocol
initialize: someParams

	"The client's protocol version when it is one of ours, else our latest, for the client to accept or not."

	| asked |
	asked := someParams at: 'protocolVersion' ifAbsent: [ nil ].
	^ Dictionary new
		  at: 'protocolVersion' put: ((self class protocolVersions includes: asked)
				   ifTrue: [ asked ]
				   ifFalse: [ self class protocolVersions last ]);
		  at: 'capabilities' put: (Dictionary new at: 'tools' put: Dictionary new; yourself);
		  at: 'serverInfo' put: (Dictionary new at: 'name' put: 'polyphemus'; at: 'version' put: '0.1'; yourself);
		  at: 'instructions' put: 'Reads Pharo VMs (64-bit Spur, Pharo 10 to 14) from outside, without changing them: an image file (open_image), a core dump (open_core), or a running VM (open_process, held still only while it is copied). Then ask about it by its handle: processes, stack, inspect, census, packages. where_stuck says where a running VM''s threads wait, without reading its heap. A running VM takes the right to look into it: on Linux, being an ancestor of it or bin/pharo-debuggable; on macOS, this server run as root. Every answer says what it read; what cannot be read is said, not guessed.';
		  yourself
