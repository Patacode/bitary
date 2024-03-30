# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Decorator::KwargsValidator do
  let(:fake_class) do
    Class.new do
      def execute(**kwargs)
        kwargs
      end

      def run(**kwargs)
        kwargs
      end
    end
  end

  describe '::new' do
    it 'returns a new Decorator instance with given wrappee and spec' do
      spec = {
        execute: {
          one: {}
        },
        run: {
          two: {
            required: true,
            type: String,
            predicate: {
              callback: ->(value) { value.empty? },
              error: ArgumentError
            }
          },
          three: {
            default: 44
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco).to be_instance_of(Bitary::Decorator::KwargsValidator)
    end

    it 'accepts empty spec' do
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, {})

      expect(deco).to be_instance_of(Bitary::Decorator::KwargsValidator)
    end

    it 'raises an ArgumentError if spec is not Hash' do
      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, [])
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if spec refers to unknown wrappee methods' do
      spec = {
        execute: {},
        unknown: {}
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if method specs are not all Hashes' do
      spec = {
        execute: {},
        run: []
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if arg specs are not all Hashes' do
      spec = {
        execute: {
          one: {},
          two: []
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if args specs contain invalid keys' do
      spec = {
        execute: {
          one: {
            required: true
          },
          two: {
            unknown: 4
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if required arg spec is not boolean' do
      spec = {
        execute: {
          one: {
            required: 'invalid'
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if type arg spec is not a Class' do
      spec = {
        execute: {
          one: {
            type: 'invalid'
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if predicate arg spec is not a Hash' do
      spec = {
        execute: {
          one: {
            predicate: []
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an KeyError if predicate arg spec refers to empty Hash' do
      spec = {
        execute: {
          one: {
            predicate: {}
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if predicate arg spec has unknown keys' do
      spec = {
        execute: {
          one: {
            predicate: {
              error: ArgumentError,
              unknown: 1
            }
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it(
      'raises a KeyError if predicate arg spec does not contain ' \
      'callback and error keys'
    ) do
      spec = {
        execute: {
          one: {
            predicate: {
              error: ArgumentError
            }
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if predicate callback is not a Proc' do
      spec = {
        execute: {
          one: {
            predicate: {
              callback: true,
              error: ArgumentError
            }
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if predicate error is not a class' do
      spec = {
        execute: {
          one: {
            predicate: {
              callback: ->(_value){ true },
              error: 4
            }
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if predicate error is not an error class' do
      spec = {
        execute: {
          one: {
            predicate: {
              callback: ->(_value){ true },
              error: Integer
            }
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it(
      'raises an ArgumentError if required and default arg specs are both ' \
      'given'
    ) do
      spec = {
        execute: {
          one: {
            required: true,
            default: 'value'
          }
        }
      }

      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if no spec is given' do
      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if no args are given' do
      expect { Bitary::Decorator::KwargsValidator.new }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if more than 2 pos args are given' do
      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, {}, 1)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect do
        Bitary::Decorator::KwargsValidator.new(fake_class.new, {}, a: 1)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'wrappee instance methods matching spec' do
    it 'validates required arg' do
      spec = {
        execute: {
          one: {
            required: true
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: 'hello')).to eq({ one: 'hello' })
    end

    it 'validates type arg' do
      spec = {
        execute: {
          one: {
            type: Integer
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: 44)).to eq({ one: 44 })
    end

    it 'validates default arg' do
      spec = {
        execute: {
          one: {
            default: 44
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute).to eq({ one: 44 })
    end

    it 'validates predicate arg' do
      spec = {
        execute: {
          one: {
            predicate: {
              callback: ->(value) { value > 10 },
              error: ArgumentError
            }
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: 11)).to eq({ one: 11 })
    end

    it 'validates multiple arg spec' do
      spec = {
        execute: {
          one: {
            required: true,
            type: Integer,
            predicate: {
              callback: ->(value) { value > 10 },
              error: ArgumentError
            }
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: 11)).to eq({ one: 11 })
    end

    it 'sets required to false if not given' do
      spec = {
        execute: {
          one: {
            default: 'hello'
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute).to eq({ one: 'hello' })
    end

    it 'sets type to Object if not given' do
      spec = {
        execute: {
          one: {
            required: true
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)
      obj = Object.new

      expect(deco.execute(one: obj)).to eq({ one: obj })
    end

    it 'sets default to nil if not given' do
      spec = {
        execute: {
          one: {}
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute).to eq({ one: nil })
    end

    it 'sets predicate to be always true if not given' do
      spec = {
        execute: {
          one: {
            required: true,
            type: Integer
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: -55)).to eq({ one: -55 })
    end

    it 'overrides default value if non-required arg is given' do
      spec = {
        execute: {
          one: {
            default: 'test'
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect(deco.execute(one: 'two')).to eq({ one: 'two' })
    end

    it 'raises an ArgumentError if required arg is not given' do
      spec = {
        execute: {
          one: {
            required: true
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect { deco.execute }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if provided arg is not of the right type' do
      spec = {
        execute: {
          one: {
            type: String 
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect { deco.execute(one: 1) }.to raise_error(ArgumentError)
    end

    it 'raises the predicate error if provided arg do not match predicate' do
      spec = {
        execute: {
          one: {
            required: true,
            type: Integer,
            predicate: {
              callback: ->(value) { value >= 0 && value < 10 },
              error: IndexError
            }
          }
        }
      }
      deco = Bitary::Decorator::KwargsValidator.new(fake_class.new, spec)

      expect { deco.execute(one: -1) }.to raise_error(IndexError)
    end
  end
end
