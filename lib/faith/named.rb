module Faith
  module Named
    def root?
      name == 'root'
    end

    def full_name
      (parent && !parent.root?) ? "#{parent.full_name}:#{name}" : name
    end
  end
end