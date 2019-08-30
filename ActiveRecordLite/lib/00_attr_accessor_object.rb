class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}") do
        instance_variable_get("@#{name}")
      end
      
      # name2 = "#{name}="
      define_method("#{name}=") do |p|
        instance_variable_set("@#{name}", p)
      end

    end
  end
end
