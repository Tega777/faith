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
  end
end
