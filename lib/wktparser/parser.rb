module Wktparser

  class Parser

    def init options = {}
      @yy = {}
      @lexer = Lexer.new(options)
    end

    def trace
    end

    def perform_action yytext, yyleng, yylineo, yy, yystate
    end

    def parse_error str, hash
    end

    def parse input
    end

  end

end
