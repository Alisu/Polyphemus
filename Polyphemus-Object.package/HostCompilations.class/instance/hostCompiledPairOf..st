highlighting
hostCompiledPairOf: anActivation

	"{method. tree} for the activation's method, compiled here once. Cached per method."

	^ self onceForTheMethodOf: anActivation as: 'hostCompilation' do: [ self compileHostSourceFor: anActivation ]
