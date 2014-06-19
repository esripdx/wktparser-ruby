module Wktparser

  class Lexer

    def init options = {}
      @EOF = 1
      @options = Options.new(options)
      @rules = []
      @conditions = {}
    end

    def parse_error str, hash
    end

    def set_input input
    end

    def input
    end

    def unput str
    end

    def more
    end

    def less n
    end

    def parse_input
    end

    def upcoming_input
    end

    def show_position
    end

    def test_match regex_match_array, rule_index
    end

    def next
    end

    def lex
    end

    def begin condition
    end

    def pop_state
    end

    def _current_rules
    end

    def top_state
    end

    def push_state condition
    end

    def perform_action yy, yy_, avoiding_name_collisions, yy_start
    end

  end

end
