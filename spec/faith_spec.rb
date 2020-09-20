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

  context 'depedencies' do
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
  end
end
