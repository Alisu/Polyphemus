downloading
downloadNameForPharo: aNumber

	"Pinned to one build: 'latest-64' moves under the tests, and VMMaker v10.0.0 cannot
	interpret a Pharo 11 image. Each is the build its edition's host is made from
	(bin/ci-setup.sh), so the host compiles the target's methods as the target did (#6)."

	aNumber = 10 ifTrue: [ ^ 'Pharo10.0.1-0.build.527.sha.0542643.arch.64bit' ].
	aNumber = 11 ifTrue: [ ^ 'Pharo11-SNAPSHOT.build.688.sha.cf3d3fd.arch.64bit' ].
	aNumber = 12 ifTrue: [ ^ 'Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit' ].
	aNumber = 13 ifTrue: [ ^ 'Pharo13.0-SNAPSHOT.build.749.sha.d7c6f761d5.arch.64bit' ].
	aNumber = 14 ifTrue: [ ^ 'Pharo14.0-SNAPSHOT.build.771.sha.bf1210affa.arch.64bit' ].
	^ 'latest-64'
