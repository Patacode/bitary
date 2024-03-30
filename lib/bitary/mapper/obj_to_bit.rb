# frozen_string_literal: true

class Bitary
  class Mapper
    class ObjToBit < Bitary::Mapper
      def map(value)
        case !!value
        when true then IntToBit.new.map(value)
        when false then 0
        end
      end
    end
  end
end
