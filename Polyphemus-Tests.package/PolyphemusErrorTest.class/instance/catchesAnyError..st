running
catchesAnyError: aMethod

	"Whether it holds a handler of every Error: on:do: naming Error or Exception, alone or in a set
	with others on either side, or one of the two shorthands for it."

	^ aMethod ast sendNodes anySatisfy: [ :node |
		  (#( #onErrorDo: #ifError: ) includes: node selector) or: [
			  node selector = #on:do: and: [ (self classesCaughtBy: node arguments first) includesAny: #( 'Error' 'Exception' ) ] ] ]
