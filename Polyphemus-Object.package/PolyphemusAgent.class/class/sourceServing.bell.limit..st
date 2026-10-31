source
sourceServing: aDirectory bell: aSource limit: aDurationOrNil

	"The agent: request.N in, answer.N out, go to end, or ends itself after aDurationOrNil without a
	request. Allocating nothing between requests, it spins on the bell's third slot, consuming each
	ring before looking for its file (#49). Bell nil: its own, named in bell-index (#137)."

	^ '| dir count going workspace bell limit last now |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
[ dir exists ] whileFalse: [ [ dir ensureCreateDirectory ] on: DirectoryExists do: [ :e | ] ].
count := 0.
workspace := Dictionary new.
bell := ' , (aSource ifNil: [ 'Semaphore new.
(dir / ''bell-index.tmp'') ensureDelete; writeStreamDo: [ :stream | stream print: (Smalltalk registerExternalObject: bell) ].
(dir / ''bell-index.tmp'') renameTo: ''bell-index''' ]) , '.
limit := ' , (aDurationOrNil ifNil: [ 'nil' ] ifNotNil: [ :limit | limit asMilliSeconds printString ]) , '.
going := (dir / ''go'') exists.
going ifFalse: [ (dir / ''serving'') ensureCreateFile ].
last := Time millisecondClockValue.
[ going ] whileFalse: [
	| request |
	[ (bell instVarAt: 3) > 0 or: [ limit notNil and: [
		now := Time millisecondClockValue.
		now < last ifTrue: [ last := now ].
		now - last > limit ] ] ] whileFalse: [ ].
	(bell instVarAt: 3) > 0
		ifTrue: [
			bell instVarAt: 3 put: 0.
			request := dir / (''request.'' , (count + 1) printString).
			request exists
				ifTrue: [
					| answer written |
					count := count + 1.
					answer := [ ''ok'' , String lf , (Smalltalk compiler receiver: workspace; evaluate: request contents) printString ]
						on: Error , (Smalltalk globals at: #SyntaxErrorNotification ifAbsent: [ Error ])
						do: [ :error | ''error'' , String lf , error class name , '': '' , error messageText asString ].
					written := dir / ''answer.tmp''.
					written ensureDelete.
					written writeStreamDo: [ :stream | stream nextPutAll: answer ].
					written renameTo: ''answer.'' , count printString ]
				ifFalse: [ going := (dir / ''go'') exists ].
			last := Time millisecondClockValue ]
		ifFalse: [
			| expired |
			expired := dir / ''expired.tmp''.
			expired writeStreamDo: [ :stream | stream nextPutAll: limit printString ].
			expired renameTo: ''expired''.
			(workspace at: #letGo ifAbsent: [ nil ]) ifNotNil: [ :letGo | letGo value ].
			going := true ] ]' , (aSource ifNil: [ '.
(dir / ''bell-ended'') ensureCreateFile.
Smalltalk unregisterExternalObject: bell' ] ifNotNil: [ '' ])
