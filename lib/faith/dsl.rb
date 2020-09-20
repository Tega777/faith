require 'docile'

module Faith
  module DSL
    def self.to_root(&block)
      root = Faith::Group.new('root', nil, [])
      Docile.dsl_eval(ChildBuilder.new(root), &block)
      root.resolve_self!
      root
    end

    class ChildBuilder
      def initialize(parent)
        @parent = parent
      end

      def task(name, mixins: [], dependencies: [], &action)
        @parent.children << Task.new(name, @parent, mixins: mixins, dependencies: dependencies, &action)
      end

      def mixin(name, &block)
        @parent.children << Docile.dsl_eval(MixinBuilder.new(name, @parent), &block).result
      end

      def group(name, &block)
        group = Group.new(name, @parent)
        @parent.children << group

        Docile.dsl_eval(ChildBuilder.new(group), &block)
      end
    end

    class MixinBuilder
      def initialize(name, parent)
        @mixin = Mixin.new(name, parent)
      end

      def before(&block)
        @mixin.before = block
      end

      def after(&block)
        @mixin.after = block
      end

      def result
        @mixin
      end
    end
  end
end
