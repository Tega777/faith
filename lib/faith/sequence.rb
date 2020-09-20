module Faith
  class Sequence < Namespace
    def initialize(name, parent, children, mixins: [], dependencies: [])
      s = self
      super(name, parent, children, mixins: mixins, dependencies: dependencies) do |ctx|
        ctx.output.sequence(s)
        ctx.output.indent
        children.each { |child| child.run(ctx) }
        ctx.output.dedent
      end
    end
  end
end
