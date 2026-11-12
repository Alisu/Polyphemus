source
sourceServing: aDirectory bell: aSource limit: aDurationOrNil

	"The agent: request.N in, run apart, stopped at the request limit (#161), answer.N out; go to end,
	or ends itself after aDurationOrNil idle or its observer's heartbeat silent (#163). Always spins,
	the image never left without a runnable process, on the bell's third slot (#49); nil: its own.
	It waits in a block of its own: small enough for the JIT, which compiles nothing this long (#167)."

	^ '| dir count going workspace bell limit requestLimit last now silence beat silent wait |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
[ dir exists ] whileFalse: [ [ dir ensureCreateDirectory ] on: DirectoryExists do: [ :e | ] ].
count := 0.
workspace := Dictionary new.
workspace at: #agent put: Processor activeProcess.
bell := ' , (aSource ifNil: [ 'Semaphore new.
(dir / ''bell-index.tmp'') ensureDelete; writeStreamDo: [ :stream | stream print: (Smalltalk registerExternalObject: bell) ].
(dir / ''bell-index.tmp'') renameTo: ''bell-index''' ]) , '.
limit := ' , (aDurationOrNil ifNil: [ 'nil' ] ifNotNil: [ :limit | limit asMilliSeconds printString ]) , '.
requestLimit := ' , self requestLimit asMilliSeconds printString , '.
silence := ' , self observerSilenceLimit asMilliSeconds printString , '.
beat := Time millisecondClockValue.
silent := false.
going := (dir / ''go'') exists.
going ifFalse: [ (dir / ''serving'') ensureCreateFile ].
last := Time millisecondClockValue.
wait := [
	[ (bell instVarAt: 3) > 0 or: [ (limit notNil and: [
		now := Time millisecondClockValue.
		now < last ifTrue: [ last := now ].
		now - last > limit ]) or: [
		now := Time millisecondClockValue.
		now - last > silence and: [ (now - beat) abs > 1000 and: [
			beat := now.
			silent := (dir / ''alive'') exists and: [
				(DateAndTime now - (dir / ''alive'') modificationTime) asMilliSeconds > silence ] ] ] ] ] ] whileFalse: [ ] ].
[ going ] whileFalse: [
	| request |
	wait value.
	(bell instVarAt: 3) > 0
		ifTrue: [
			bell instVarAt: 3 put: 0.
			request := dir / (''request.'' , (count + 1) printString).
			request exists
				ifTrue: [
					| answer written worker watchdog finished stopped |
					count := count + 1.
					finished := false.
					stopped := false.
					worker := [
						answer := [ ''ok'' , String lf , (Smalltalk compiler receiver: workspace; evaluate: request contents) printString ]
							on: Error , UnhandledException , (Warning - Deprecation) , (Smalltalk globals at: #SyntaxErrorNotification ifAbsent: [ Error ])
							do: [ :error | ''error'' , String lf , error class name , '': '' , error messageText asString ].
						finished := true ] newProcess.
					worker priority: Processor activePriority; name: ' , self requestProcessName printString , '.
					watchdog := [
						(Delay forMilliseconds: requestLimit) wait.
						finished ifFalse: [ stopped := true. worker terminate ] ] newProcess.
					watchdog priority: Processor activePriority + 1.
					watchdog resume.
					worker resume.
					[ finished or: [ stopped ] ] whileFalse: [ Processor yield ].
					watchdog terminate.
					stopped ifTrue: [
						answer := ''error'' , String lf , ''RequestStopped: stopped after '' , (requestLimit // 1000) printString , '' s, as it had not ended'' ].
					written := dir / ''answer.tmp''.
					written ensureDelete.
					written writeStreamDo: [ :stream | stream nextPutAll: answer ].
					written renameTo: ''answer.'' , count printString ]
				ifFalse: [ going := (dir / ''go'') exists ].
			last := Time millisecondClockValue ]
		ifFalse: [
			| expired |
			silent ifTrue: [ (dir / ''observer-silent'') ensureCreateFile ].
			expired := dir / ''expired.tmp''.
			expired writeStreamDo: [ :stream | stream nextPutAll: limit printString ].
			expired renameTo: ''expired''.
			(workspace at: #letGo ifAbsent: [ nil ]) ifNotNil: [ :letGo | letGo value ].
			going := true ] ]' , (aSource ifNil: [ '.
(dir / ''bell-ended'') ensureCreateFile.
Smalltalk unregisterExternalObject: bell' ] ifNotNil: [ '' ])
