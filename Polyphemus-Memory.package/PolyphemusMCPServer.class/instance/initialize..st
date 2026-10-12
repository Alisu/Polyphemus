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
		  at: 'instructions' put: 'Reads Pharo images (64-bit Spur, Pharo 10 to 14) from outside, without running them. Open an image file with open_image, then ask about it by its handle. Every answer says what it read; what cannot be read is said, not guessed.';
		  yourself
