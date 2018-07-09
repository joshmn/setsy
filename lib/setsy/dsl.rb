module Setsy
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end
    module ClassMethods
      def setsy(attribute_name, options = {})
        readers = {}
        options[:column] ||= "#{attribute_name}_data".to_sym
        options[:defaults] ||= self.const_defined?(:SETSY_DEFAULTS) ? self.const_get(:SETSY_DEFAULTS) : {}
        readers = yield(Setsy::Configuration) if block_given?
        class_eval do
          define_method(:setsy_configuration) do
            options[:defaults] || {}
          end
          define_singleton_method(:setsy_default) do
            options[:defaults] || {}
          end
        end
        instance_eval do
          define_method(:setsy_configuration) do
            if send(options[:column]).try(:empty?)
              self.class.setsy_default
            else
              send(options[:column])
            end
          end
          define_method(:setsy_default) do
            self.class.setsy_default
          end
          define_method(attribute_name) do
            Setsy::Configuration.from_set(self, setsy_configuration, readers)
          end
        end
      end
    end
  end
end
