# typed: false
RSpec.describe Faith do
  it 'has a version number' do
    expect(Faith::VERSION).not_to be nil
  end

  context 'basic tasks' do
    it 'can be executed' do
      x = 0

      Faith::Task.new('example', nil) do
        x += 1
      end.run(Faith::Context.new)

      expect(x).to eq 1
    end
  end

  context 'depedencies' do
    it 'are executed correctly' do
      x = 0

      root = Faith::Group.new('root', nil, [])

      root.children << Faith::Task.new('dep', root) do
        x += 10
      end

      root.children << example = Faith::Task.new('example', root, dependencies: ['dep']) do
        x += 1
      end
      
      root.resolve_self!
      example.run(Faith::Context.new)

      expect(x).to eq 11
    end

    it 'only run once' do
      x = 0

      root = Faith::Group.new('root', nil, [])

      root.children << Faith::Task.new('dep', root) do
        x += 10
      end

      root.children << Faith::Task.new('a', root, dependencies: ['dep']) do
        x += 5
      end
      root.children << Faith::Task.new('b', root, dependencies: ['dep']) do
        x += 3
      end

      root.children << example = Faith::Task.new('example', root, dependencies: ['a', 'b']) do
        x += 1
      end

      root.resolve_self!
      example.run(Faith::Context.new)

      expect(x).to eq 19
    end
  end

  context 'mixins' do
    it 'are executed correctly' do
      x = 0

      root = Faith::Group.new('root', nil, [])

      root.children << Faith::Mixin.new('mix', root, before: ->_{ x += 5 }, after: ->_{ x += 10 })

      root.children << example = Faith::Task.new('example', root, mixins: ['mix']) do
        x += 1
      end
      
      root.resolve_self!
      example.run(Faith::Context.new)

      expect(x).to eq 16
    end

    it 'run multiple times' do
      x = 0

      root = Faith::Group.new('root', nil, [])

      root.children << Faith::Mixin.new('mix', root, before: ->_{ x += 5 }, after: ->_{ x += 10 })

      root.children << Faith::Task.new('a', root, mixins: ['mix']) do
        x += 5
      end
      root.children << Faith::Task.new('b', root, mixins: ['mix']) do
        x += 3
      end

      root.children << example = Faith::Task.new('example', root, dependencies: ['a', 'b']) do
        x += 1
      end
      
      root.resolve_self!
      example.run(Faith::Context.new)

      expect(x).to eq ((5 + 10) * 2 + 5 + 3 + 1)
    end
  end
end
