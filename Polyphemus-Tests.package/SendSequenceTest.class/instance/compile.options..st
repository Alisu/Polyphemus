running
compile: aSource options: someOptions

	^ OpalCompiler new
		  class: Point;
		  source: aSource;
		  options: someOptions;
		  compile
