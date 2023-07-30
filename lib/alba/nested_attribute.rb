module Alba
  # Representing nested attribute
  # @api private
  class NestedAttribute
    # @param key_transformation [Symbol] determines how to transform keys
    # @param block [Proc] class body
    def initialize(key_transformation: :none, &block)
      @key_transformation = key_transformation
      @block = block
    end

    # @param object [Object] the object being serialized
    # @param params [Hash] params Hash inherited from Resource
    # @return [Hash] hash serialized from running the class body in the object
    def value(object:, params:)
      resource_class = Alba.resource_class
      resource_class.transform_keys(@key_transformation)
      resource_class.define_singleton_method(:params) { params }
      resource_class.class_eval(&@block)
      resource_class.new(object, params: params).serializable_hash
    end
  end
end
