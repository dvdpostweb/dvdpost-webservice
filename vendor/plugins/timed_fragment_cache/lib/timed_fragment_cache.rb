module ActionController
  module Caching
    module TimedFragment
      def when_fragment_expired(name, expiry=nil)
        if fragment_exist?(name)
          if fragment_expired?(name)
            expire_timed_fragment(name)
            return yield
          else
            read_fragment(name)
          end
        else
          write_meta_fragment(name, expiry)
          write_fragment(name, yield)
        end
      end

      def expire_timed_fragment(name)
        expire_meta_fragment(name)
        expire_fragment(name)
      end

      private
      def fragment_expired?(name)
        expiry = read_meta_fragment(name)
        expiry && expiry < Time.zone.now
      end

      def write_meta_fragment(name, content)
        write_fragment("#{name}_meta", content)
      end

      def read_meta_fragment(name)
        read_fragment("#{name}_meta")
      end

      def expire_meta_fragment(name)
        expire_fragment("#{name}_meta")
      end
    end
  end
end

ActionController::Base.send :include, ActionController::Caching::TimedFragment
