Stage one: reaching the scheduler and its processes in a snapshot.

Runs on the candle image, whose classes are named PCProcess, PCProcessorScheduler and
so on. The walk must therefore be structural and never match on class names.
