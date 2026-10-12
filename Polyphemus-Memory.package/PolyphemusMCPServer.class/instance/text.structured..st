results
text: aString structured: aDictionary

	^ Dictionary new
		  at: 'content' put: { (Dictionary new at: 'type' put: 'text'; at: 'text' put: aString; yourself) };
		  at: 'structuredContent' put: aDictionary;
		  at: 'isError' put: false;
		  yourself
