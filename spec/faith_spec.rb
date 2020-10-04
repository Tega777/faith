# typed: false
RSpec.describe Faith do
  it 'has a version number' do
    expect(Faith::VERSION).not_to be nil
  end

  context 'basic tasks' do
    it 'can be executed' do
      x = 0

      Faith::DSL.to_root do
        task 'example' do
          x += 1          
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 1
    end
  end

  context 'dependencies' do
    it 'are executed correctly' do
      x = 0

      Faith::DSL.to_root do
        task 'example', dependencies: ['dep'] do
          x += 1
        end

        task 'dep' do
          x += 10
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 11
    end

    it 'only run once' do
      x = 0

      Faith::DSL.to_root do
        task 'example', dependencies: ['a', 'b'] do
          x += 1
        end

        task 'a', dependencies: ['dep'] do
          x += 5
        end

        task 'b', dependencies: ['dep'] do
          x += 3
        end

        task 'dep' do
          x += 10
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 19
    end
  end

  context 'mixins' do
    it 'are executed correctly' do
      x = 0

      Faith::DSL.to_root do
        task 'example', mixins: ['mix'] do
          x += 1
        end

        mixin 'mix' do
          before do
            x += 5
          end

          after do
            x += 10
          end
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 16
    end

    it 'run multiple times' do
      x = 0

      Faith::DSL.to_root do
        task 'example', dependencies: ['a', 'b'] do
          x += 1
        end

        task 'a', mixins: ['mix'] do
          x += 5
        end

        task 'b', mixins: ['mix'] do
          x += 3
        end

        mixin 'mix' do
          before do
            x += 5
          end

          after do
            x += 10
          end
        end
      end.resolve('example').run(Faith::Context.new)
      
      expect(x).to eq ((5 + 10) * 2 + 5 + 3 + 1)
    end

    it 'can provide' do
      x = 0

      Faith::DSL.to_root do
        task 'example', mixins: ['a', 'b'] do
          x += mixins['a'].number * mixins['b'].number
        end

        mixin 'a' do
          before do
            provide number: 5
          end
        end

        mixin 'b' do
          before do
            provide number: 4
          end
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 20
    end
  end

  context 'sequences' do
    it 'are executed correctly' do
      x = 0

      Faith::DSL.to_root do
        sequence 'example' do
          task 'a' do
            x += 1
          end

          task 'b' do
            x += 5
          end
        end
      end.resolve('example').run(Faith::Context.new)

      expect(x).to eq 6
    end
  end

  context 'name validation' do
    it 'rejects : in names' do
      expect do
        Faith::DSL.to_root do
          task 'a:b' do end
        end
      end.to raise_error ArgumentError
    end

    it 'rejects the name \'root\'' do
      expect do
        Faith::DSL.to_root do
          task 'root' do end
        end
      end.to raise_error ArgumentError
    end
  end
end
