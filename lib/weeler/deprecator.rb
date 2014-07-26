module Weeler
  class Deprecator
    def deprecation_warning(deprecated_method_name, version = nil, caller_backtrace = nil)
      version = "#{Weeler::VERSION::MAJOR + 1}.0.0" if version.blank?
      message = "DEPRECATION WARNING: #{deprecated_method_name} is deprecated and will be removed from Weeler #{version}."
      Kernel.warn message
    end
  end
end
