as a compilation scope
compiler

	"A compiler set up to read source that came from this class, in the image it came
	from: names in it resolve through this class, not through ours."

	^ OpalCompiler new
		  class: self;
		  yourself
