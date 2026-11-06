tests
testALinkIsReadAsItIs

	"#159: /proc links a descriptor to pipe:[123] or socket:[456], no path: Pharo's targetPath takes
	them for one (Pharo 13) or does not read links at all (Pharo 10)."

	| link |
	OSPlatform current isUnix ifFalse: [ ^ self skip: 'symbolic links as Unix has them' ].
	link := self spikeDirectory ensureCreateDirectory / 'a-link'.
	link ensureDelete.
	LibC system: 'ln -s "pipe:[12345]" ' , link fullName.
	self assert: (StuckThread linkTargetOf: link fullName) equals: 'pipe:[12345]'.
	self assert: (StuckThread linkTargetOf: (self spikeDirectory / 'no-such-link') fullName) isNil.
	link ensureDelete
