as a compilation scope
compiler

	"A compiler set up to read source that came from this class, in the image it came from:
	names in it resolve through this class, not through ours.

	Semantic warnings are off. This compiler is handed out to whatever asks the class for
	one -- reading a method's syntax tree, for instance -- and left on, a name that image
	has and we cannot find is written into OUR Undeclared dictionary."

	^ OpalCompiler new
		  class: self;
		  options: (memory compilerOptionsWith: #( + optionSkipSemanticWarnings ));
		  yourself
