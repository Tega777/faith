module Faith
  class Task
    def initialize(name, parent, mixins: [], dependencies: [], &action)
      @name = name
      @parent = parent
      @mixins = mixins
      @dependencies = dependencies
      @action = action
    end
    
    attr_accessor :name, :mixins, :dependencies, :action

    def full_name
      parent ? "#{parent.full_name}:#{name}" : name
    end

    def run(context)
      # Run dependencies, if not run before
      dependencies.each do |dep|
        dep.run(context) unless context.ran?(dep)
      end

      # Instantiate mixins
      new_mixin_instances = mixins.map { |m| m.instantiate(context) }
      new_mixin_instances.each do |m|
        m.instance_exec(context, &m.mixin.before)
        context.mixin_instances << m
      end

      # Run this task
      action.(context)
      context.tasks_executed << self

      # Tear down mixins
      new_mixin_instances.each do |m|
        m.instance_exec(context, &m.mixin.after)
        context.mixin_instances.delete(m)
      end
    end
  end
end