accessing
close

	"Let go of the file or the copy read from; what was reified goes with the handle (#180)."

	reified ifNotNil: [ :reading | reading closeWhatItReads ]
