helpers
launchTargetMakingTheGraphs

	"The pinned target, making every seed's graph and keeping them in a global; answers its pid
	once it has."

	^ self launchTargetRunning: 'Smalltalk at: #PolyphemusGraphs put: ((' , self seeds storeString
		  , ') collect: [ :seed | (' , self generatorSource , ') value: seed ]).
Smalltalk garbageCollect.
(' , (self spikeDirectory / 'started') fullName printString , ' asFileReference) ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait'
