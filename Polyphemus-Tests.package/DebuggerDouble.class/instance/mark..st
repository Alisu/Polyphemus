accessing
mark: aString

	"As the debugger of a reading does: in front of its title."

	marks := (marks ifNil: [ #(  ) ]) , { aString }.
	title := '[' , aString , '] ' , title
