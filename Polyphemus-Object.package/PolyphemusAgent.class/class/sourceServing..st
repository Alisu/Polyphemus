source
sourceServing: aDirectory

	"The agent's source, serving that directory: request.N in, answer.N out, each written under
	another name and renamed so a half-written file is never read; a file named go ends it."

	^ '| dir count going |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.
count := 0.
going := false.
[ going ] whileFalse: [
	| request |
	request := dir / (''request.'' , (count + 1) printString).
	request exists
		ifTrue: [
			| answer written |
			count := count + 1.
			answer := [ ''ok'' , String lf , (Smalltalk compiler evaluate: request contents) printString ]
				on: Error
				do: [ :error | ''error'' , String lf , error class name , '': '' , error messageText asString ].
			written := dir / ''answer.tmp''.
			written ensureDelete.
			written writeStreamDo: [ :stream | stream nextPutAll: answer ].
			written renameTo: ''answer.'' , count printString ]
		ifFalse: [ going := (dir / ''go'') exists ] ]'
