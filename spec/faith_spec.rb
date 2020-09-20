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

      dep = Faith::Task.new('dep', nil) do
        x += 10
      end

      Faith::Task.new('example', nil, dependencies: [dep]) do
        x += 1
      end.run(Faith::Context.new)

      expect(x).to eq 11
    end

    it 'only run once' do
      x = 0

      dep = Faith::Task.new('dep', nil) do
        x += 10
      end

      a = Faith::Task.new('a', nil, dependencies: [dep]) do
        x += 5
      end
      b = Faith::Task.new('b', nil, dependencies: [dep]) do
        x += 3
      end

      Faith::Task.new('example', nil, dependencies: [a, b]) do
        x += 1
      end.run(Faith::Context.new)

      expect(x).to eq 19
    end
  end
end
