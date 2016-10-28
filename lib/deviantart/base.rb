module DeviantArt
  class Base
    @@points_class_mapping = {}

    def initialize(attrs)
      @attrs = attrs
      define_hash_attrs(self, @attrs, [])
    end

    def self.point_to_class(point, klass)
      @@points_class_mapping[point] = klass
    end

    private

    def define_hash_attrs(receiver, attrs, point)
      that = self
      attrs.each_pair do |key, value|
        receiver.instance_eval do
          define_singleton_method(:"#{key}=", ->(sym, obj){instance_variable_set(sym, obj)}.curry.(:"@#{key}"))
          define_singleton_method(key.to_sym, proc { instance_variable_get(:"@#{key}") })
          instance_variable_set(:"@#{key}", that.__send__(:nested_value, value, point + [key.to_sym]))
        end
      end
      receiver
    end

    def define_array_attrs(array, attrs, point)
      attrs.each do |value|
        array << nested_value(value, point)
      end
      array
    end

    def nested_value(value, point)
      if @@points_class_mapping.include?(point)
        @@points_class_mapping[point].new(value)
      else
        case value
        when Array
          define_array_attrs(Array.new, value, point + [:[]])
        when Hash
          define_hash_attrs(Object.new, value, point)
        else
          value
        end
      end
    end
  end

  class Deviation < Base; end
  class User < Base; end
  class Status < Base; end
end
