# Continuation objects are generated by Kernel#callcc. They hold a
# return address and execution context, allowing a nonlocal return to
# the end of the callcc block from anywhere within a
# program. Continuations are somewhat analogous to a structured
# version of C's setjmp/longjmp (although they contain more state, so
# you might consider them closer to threads).
class Continuation
  # identical to Smalltalk class RubyContinuation
  primitive_nobridge '__cc_call', 'ccCall:'

  def [](*args)
    __run(args)
  end

  def call(*args)
    __run(args)
  end

  def __run(args)
    if args.empty?
      __cc_call(nil)
    elsif args.size == 1
      __cc_call(args.first)
    else
      __cc_call(args)
    end
  end
end
