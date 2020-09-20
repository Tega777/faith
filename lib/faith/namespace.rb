module Faith
  class Namespace < Task
    def initialize(name, parent, children, mixins: [], dependencies: [], &action)
      super(name, parent, mixins: mixins, dependencies: dependencies, &action)
      @children = children
    end

    attr_accessor :children

    def resolve_self!
      super
      children.each(&:resolve_self!)
    end
  end
end