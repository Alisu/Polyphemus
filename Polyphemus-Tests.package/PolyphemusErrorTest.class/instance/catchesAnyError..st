running
catchesAnyError: aMethod

	"Whether it holds a handler of every Error: on:do: naming Error or Exception, alone or in a set
	with others on either side, or one of the two shorthands for it."

	^ aMethod ast sendNodes anySatisfy: [ :node |
		  (#( #onErrorDo: #ifError: ) includes: node selector) or: [
			  node selector = #on:do: and: [
				  | caught |
				  caught := node arguments first.
				  (caught isVariable or: [ caught isMessage and: [ caught selector = #, ] ]) and: [
					  (caught allChildren select: [ :each | each isVariable ]) anySatisfy: [ :each |
						  #( 'Error' 'Exception' ) includes: each name asString ] ] ] ] ]
