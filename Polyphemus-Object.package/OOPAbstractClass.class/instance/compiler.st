as a compilation scope
compiler

	"A compiler reading source from this class in its own image: names resolve through this
	class. Semantic warnings are off, or unknown names land in OUR Undeclared."

	^ OpalCompiler new
		  class: self;
		  options: (memory compilerOptionsWith: #( + optionSkipSemanticWarnings ));
		  yourself
