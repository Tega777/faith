require 'docile'

module Faith
  module DSL
    def self.to_root(&block)
      root = Faith::Group.new('root', nil, [])
      Docile.dsl_eval(ChildBuilder.new(root), &block)
      root.resolve_self!
      root
    end

    def self.validate_name!(name)
      raise ArgumentError, 'names cannot include :' if name.include?(':')
      raise ArgumentError, '\'root\' is a reserved name' if name == 'root'
    end

    class ChildBuilder
      def initialize(parent)
        @parent = parent
      end

      def task(name, mixins: [], dependencies: [], &action)
        DSL.validate_name!(name)
        
        @parent.children << Task.new(name, @parent, mixins: mixins, dependencies: dependencies, &action)
      end

      def mixin(name, &block)
        DSL.validate_name!(name)

        @parent.children << Docile.dsl_eval(MixinBuilder.new(name, @parent), &block).result
      end

      def group(name, &block)
        DSL.validate_name!(name)

        group = Group.new(name, @parent, [])
        @parent.children << group

        Docile.dsl_eval(ChildBuilder.new(group), &block)
      end

      def sequence(name, &block)
        DSL.validate_name!(name)

        seq = Sequence.new(name, @parent, [])
        @parent.children << seq

        Docile.dsl_eval(ChildBuilder.new(seq), &block)
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
