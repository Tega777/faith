module Faith
  class Mixin
    def initialize(name, parent, before: nil, after: nil)
      @name = name
      @parent = parent
      @before = before
      @after = after
    end

    attr_accessor :name, :parent, :before, :after

    def instantiate(context)
      MixinInstance.new(self)
    end
  end
end