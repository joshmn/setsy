module Setsy
  class Attribute
    delegate_missing_to :to_s
    def initialize(options)
      @attribute_value = options[:value]
      @default = options[:default]
      @options = options
    end

    def to_s
      @to_s ||= cast(@attribute_value).to_s
    end

    def default
      @default ||= cast(@default)
    end

    def as_json
      cast(@attribute_value)
    end

    def default?
      cast(@attribute_value) === cast(@default)
    end

    private

    def klass
      @klass ||= begin
        klass = @default.class.to_s
        if %w[true false trueclass falseclass].include?(klass.to_s.downcase)
          klass = 'Boolean'
        end
        klass
      end
    end

    def cast(val)
      val = val.is_a?(Hash) ? val[:value] : val
      ActiveModel::Type.lookup(klass.downcase.to_sym).cast(val)
    end
  end
end