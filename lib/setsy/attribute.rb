module Setsy
  class Attribute
    KLASS_MAP = {
        'true' => 'Boolean',
        'false' => 'Boolean',
        'trueclass' => 'Boolean',
        'falseclass' => 'Boolean',
        'fixnum' => 'Integer'
    }.freeze

    def initialize(options)
      @attribute_value = options[:value]
      @default = options[:default]
      @options = options
    end

    def to_s
      @to_s ||= cast(@attribute_value).to_s
    end

    def value
      @value ||= cast(@attribute_value)
    end
    alias as_json value

    def default
      @default ||= cast(@default)
    end

    def default?
      value == default
    end

    def respond_to_missing?(name, include_private = false)
      to_s.respond_to?(name) || super
    end

    def method_missing(method, *args, &block)
      if to_s.respond_to?(method)
        to_s.public_send(method, *args, &block)
      else
        begin
          super
        rescue NoMethodError
          if to_s.nil?
            raise DelegationError, "\#{to_s} delegated to #{to_s}, but #{to_s} is nil"
          else
            raise
          end
        end
      end
    end
    

    private

    def klass
      @klass ||= begin
        klass = @default.class.to_s
        klass = KLASS_MAP[klass.to_s.downcase] || klass
        klass.downcase.to_sym
      end
    end

    def cast(val)
      ActiveModel::Type.lookup(klass).cast(val)
    end
  end
end