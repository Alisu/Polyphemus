helpers
launchTargetDefining: aClassName thenRunning: someStatements

	"The pinned target with a class of its own (aClassName, package Trial, its methods compiled
	by someStatements, which may name it as cls), then left running; its pid once started."

	^ self launchTargetRunning: '| dir cls |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
(Object << #' , aClassName , ' package: ''Trial'') install.
cls := Smalltalk at: #' , aClassName , '.
' , someStatements , '
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
Smalltalk exitSuccess'
