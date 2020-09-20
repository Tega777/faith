module Faith
  class MixinInstance
    def initialize(mixin, provided: [])
      @mixin = mixin
      @provided = provided
    end

    attr_accessor :mixin, :provided

    def method_missing(name, *args, &block)
      return provided[name] if provided.has_key?(name) && args.length.zero? && block.nil?
      super
    end

    def provide(**items)
      provided.merge! items
    end
  end
end