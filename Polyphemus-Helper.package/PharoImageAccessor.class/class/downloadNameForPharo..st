downloading
downloadNameForPharo: aNumber

	"Pinned to one build: 'latest-64' moves under the tests, and VMMaker v10.0.0 cannot
	interpret a Pharo 11 image. Pharo 12's is the one VMMaker v10.3.2 is built on."

	aNumber = 10 ifTrue: [ ^ 'Pharo10.0.1-0.build.527.sha.0542643.arch.64bit' ].
	aNumber = 12 ifTrue: [ ^ 'Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit' ].
	^ 'latest-64'
