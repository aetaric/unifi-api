module UniFi
  module Errors
    class InvalidCredentials < StandardError
      def initalize(msg="Invalid Credentials Specified")
        super(msg)
      end
    end
  end
end
