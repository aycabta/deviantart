module DeviantArt
  ##
  # Base of response class
  class Base
    attr_reader :attrs
    @points_class_mapping = {}

    def initialize(attrs)
      @attrs = attrs
      define_hash_attrs(self, @attrs, [])
    end

    class << self
      def points_class_mapping
        @points_class_mapping ||= {}
      end

      def point_to_class(point, klass)
        self.points_class_mapping[point] = klass
      end
    end

    def to_s
      self.class.name
    end

    private def define_hash_attrs(receiver, attrs, point)
      attrs.each_pair do |key, value|
        attr_accessor_with_receiver(receiver, key)
        receiver.instance_variable_set(:"@#{key}", nested_value(value, point + [key.to_sym]))
      end
      receiver
    end

    private def attr_accessor_with_receiver(receiver, name)
      receiver.instance_eval do
        reader_name = name.to_sym
        writer_name = :"#{name}="
        variable_name = :"@#{name}"
        if !receiver.respond_to?(reader_name)
          define_singleton_method(reader_name, proc { |dummy=nil| instance_variable_get(variable_name) })
        end
        if !receiver.respond_to?(writer_name)
          define_singleton_method(writer_name, method(:instance_variable_set).to_proc.curry.(variable_name))
        end
      end
    end

    private def define_array_attrs(array, attrs, point)
      attrs.each do |value|
        array << nested_value(value, point)
      end
      array
    end

    private def nested_value(value, point)
      if self.class.points_class_mapping.include?(point)
        self.class.points_class_mapping[point].new(value)
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
