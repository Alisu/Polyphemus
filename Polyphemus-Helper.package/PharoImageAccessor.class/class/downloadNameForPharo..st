downloading
downloadNameForPharo: aNumber

	"Pinned to one build: 'latest-64' moves under the tests, and VMMaker v10.0.0 cannot
	interpret a Pharo 11 image."

	aNumber = 10 ifTrue: [ ^ 'Pharo10.0.1-0.build.527.sha.0542643.arch.64bit' ].
	^ 'latest-64'
