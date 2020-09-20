require 'rainbow'

module Faith
  class Output
    def initialize
      @indent_level = 0
    end

    def indent; @indent_level += 1; end
    def dedent; @indent_level -= 1; end

    def indented(x)
      "#{'  ' * @indent_level}#{x}"
    end

    def run(task)
      puts indented(Rainbow(task.full_name).bold)
    end

    def dependencies(task)
      puts indented("#{Rainbow("Dependencies of #{task.full_name} -").purple.bold}")
    end

    def mixin(mixin)
      puts indented("#{Rainbow("Mixin #{mixin.full_name} -").blue.bold}")
    end

    def sequence(task)
      puts indented("#{Rainbow("Sequence #{task.full_name} -").blue.bold}")
    end

    def mixin_action(action)
      puts indented("#{Rainbow(action).dark.bold}")
    end
  end
end
