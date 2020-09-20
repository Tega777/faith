module Faith
  class Group < Namespace
    def initialize(name, parent, children, mixins: [], dependencies: [])
      super(name, parent, children, mixins: mixins, dependencies: dependencies) do
        raise 'cannot run a group'
      end
    end
  end
end
