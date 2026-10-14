reading
buildIdIn: aHeaderPage

	"A PE has no build id: its timestamp, size of image and checksum stand for one. Nil unless
	aHeaderPage starts with an MZ header leading to a PE signature."

	| header |
	(aHeaderPage size >= 16r40 and: [ (aHeaderPage first: 2) asString = 'MZ' ]) ifFalse: [ ^ nil ].
	header := self unsignedIn: aHeaderPage at: 16r3C size: 4.
	header + 24 + 68 > aHeaderPage size ifTrue: [ ^ nil ].
	(aHeaderPage copyFrom: header + 1 to: header + 4) = #[80 69 0 0] ifFalse: [ ^ nil ].
	^ {
		  (self unsignedIn: aHeaderPage at: header + 8 size: 4).
		  (self unsignedIn: aHeaderPage at: header + 24 + 56 size: 4).
		  (self unsignedIn: aHeaderPage at: header + 24 + 64 size: 4) }
