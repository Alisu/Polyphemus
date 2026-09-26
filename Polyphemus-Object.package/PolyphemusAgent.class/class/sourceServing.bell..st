source
sourceServing: aDirectory bell: aSource

	"The agent's source, serving that directory: request.N in, answer.N out, each written under
	another name and renamed so a half-written file is never read; a file named go ends it. Each
	request runs with a workspace kept between them as self; one that does not parse is answered.
	Between requests it allocates nothing -- so the image moves nothing we read -- spinning until
	the third slot of the bell is set; it looks for a request first, so no ring is missed."

	^ '| dir count going workspace bell |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.
count := 0.
going := false.
workspace := Dictionary new.
bell := ' , aSource , '.
[ going ] whileFalse: [
	| request |
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
		ifFalse: [
			(going := (dir / ''go'') exists) ifFalse: [
				[ (bell instVarAt: 3) > 0 ] whileFalse: [ ].
				bell instVarAt: 3 put: 0 ] ] ]'
