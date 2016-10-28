module DeviantArt
  class Base
    def initialize(attrs)
      @attrs = attrs
      define_hash_attrs(self, @attrs)
    end

    private

    def define_hash_attrs(receiver, attrs)
      that = self
      attrs.each_pair do |key, value|
        receiver.instance_eval do
          define_singleton_method(:"#{key}=", ->(sym, obj){instance_variable_set(sym, obj)}.curry.(:"@#{key}"))
          define_singleton_method(key.to_sym, proc { instance_variable_get(:"@#{key}") })
          instance_variable_set(:"@#{key}", that.__send__(:nested_value, value))
        end
      end
      receiver
    end

    def define_array_attrs(array, attrs)
      attrs.each do |value|
        array << nested_value(value)
      end
      array
    end

    def nested_value(value)
      case value
      when Array
        define_array_attrs(Array.new, value)
      when Hash
        define_hash_attrs(Object.new, value)
      else
        value
      end
    end
  end
end
