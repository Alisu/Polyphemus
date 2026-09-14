as a compilation scope
hasTempVector

	"Asked while generating code for a block that captures a variable: the code generator
	walks outwards through the scopes looking for the vectors it must push. A class holds
	no temporaries, so it holds no vector either."

	^ false
