module Faith
  class Task
    def initialize(name, parent, mixins: [], dependencies: [], &action)
      @name = name
      @parent = parent
      @mixins = mixins
      @dependencies = dependencies
      @action = action
    end
    
    attr_accessor :name, :parent, :mixins, :dependencies, :action

    include Named

    def run(context)
      context.tasks_executed << self
      
      # Run dependencies, if not run before
      any_dependencies = dependencies.reject { |dep| context.ran?(dep) }.any?
      if any_dependencies
        context.output.dependencies(self)
        context.output.indent
      end
      dependencies.each do |dep|
        unless context.ran?(dep)
          dep.run(context) 
        end
      end
      context.output.dedent if any_dependencies

      # Instantiate mixins
      new_mixin_instances = mixins.map { |m| m.instantiate(context) }
      new_mixin_instances.each do |m|
        context.output.mixin(m.mixin)
        context.output.indent
        context.output.mixin_action("before")
        m.instance_exec(context, &m.mixin.before) unless m.mixin.before.nil?
        context.mixin_instances << m
      end

      # Run this task
      context.instance_exec(context, &action)
      context.output.run(self) unless is_a?(Sequence)

      # Tear down mixins
      new_mixin_instances.each do |m|
        context.output.mixin_action("after")
        m.instance_exec(context, &m.mixin.after) unless m.mixin.after.nil?
        context.output.dedent
        context.mixin_instances.delete(m)
      end
    end

    def resolve_self!
      @mixins = ensure_all_resolved(@mixins)
      @dependencies = ensure_all_resolved(@dependencies)
    end

    def ensure_all_resolved(objs)
      objs.map { |obj| ensure_resolved(obj) }
    end

    def ensure_resolved(obj)
      if obj.is_a?(String)
        resolve(obj)
      elsif obj.is_a?(Task) || obj.is_a?(Mixin)
        obj
      else
        raise "cannot resolve using #{obj} (of type #{obj.class})"
      end
    end 

    def resolve(name_to_resolve)
      parts = name_to_resolve.split(':')
      raise 'empty name' if parts.length.zero?

      current = self
      until parts.empty?
        current_child = current.child(parts.shift)
        
        # If nil, give up finding here
        if current_child.nil?
          if parent.nil?
            raise "could not resolve #{name_to_resolve}"
          else
            return parent.resolve(name_to_resolve)
          end
        end

        current = current_child
      end

      # If we actually managed to get parts to be empty, then we found what we were looking for
      current
    end

    def child(name_to_resolve)
      if is_a?(Namespace)
        children.find { |child| child.name == name_to_resolve }
      else
        nil
      end
    end
  end
end