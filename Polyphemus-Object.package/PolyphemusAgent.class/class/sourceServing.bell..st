source
sourceServing: aDirectory bell: aSource

	"The agent: request.N in, answer.N out, go to end; see DirectoryChannel. Between requests it
	allocates nothing, so nothing we read moves: it spins until the bell's third slot is set, and
	consumes each ring before looking for the file it was rung for, so none is left behind (#49)."

	^ '| dir count going workspace bell |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.
count := 0.
going := false.
workspace := Dictionary new.
bell := ' , aSource , '.
(dir / ''serving'') ensureCreateFile.
[ going ] whileFalse: [
	| request |
	[ (bell instVarAt: 3) > 0 ] whileFalse: [ ].
	bell instVarAt: 3 put: 0.
	request := dir / (''request.'' , (count + 1) printString).
	request exists
		ifTrue: [
			| answer written |
			count := count + 1.
			answer := [ ''ok'' , String lf , (Smalltalk compiler receiver: workspace; evaluate: request contents) printString ]
				on: Error , SyntaxErrorNotification
				do: [ :error | ''error'' , String lf , error class name , '': '' , error messageText asString ].
			written := dir / ''answer.tmp''.
			written ensureDelete.
			written writeStreamDo: [ :stream | stream nextPutAll: answer ].
			written renameTo: ''answer.'' , count printString ]
		ifFalse: [ going := (dir / ''go'') exists ] ]'
