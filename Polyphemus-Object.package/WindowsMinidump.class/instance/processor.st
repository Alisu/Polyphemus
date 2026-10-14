accessing
processor

	"#x86_64 or #aarch64, by the SystemInfo stream's processor architecture (9 or 12); nil for
	another, or without that stream."

	| at architecture |
	at := (self streamOfType: 7 in: (self bytesAtOffset: 0 count: 32)) ifNil: [ ^ nil ].
	architecture := self unsignedFrom: (self bytesAtOffset: at count: 2) at: 1 size: 2.
	architecture = 9 ifTrue: [ ^ #x86_64 ].
	architecture = 12 ifTrue: [ ^ #aarch64 ].
	^ nil
