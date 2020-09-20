module Faith
  class Context
    def initialize
      @mixin_instances = []
      @tasks_executed = []
    end

    attr_accessor :mixin_instances, :tasks_executed

    def ran?(task)
      tasks_executed.include?(task)
    end

    def mixins
      mixin_instances.to_h { |x| [x.mixin.name, x] }
    end
  end
end
