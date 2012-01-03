class RESandBox
    def initialize(m, attrs, body)
        @m     = m

        @attrs = {}
        attrs.strip.split.each do |a|
            k,v = a.split("=")
            @attrs.store(k,v)
        end

        @body  = body
    end

    def eval(code)
        pipe = IO.popen(["ruby",{ STDERR => STDOUT }], "r+")
        pipe.puts code
        pipe.close_write

        pipe.readlines.join.strip
    end

    def format_body()
        o =  "\n"+"~"*8+"\n"
        o << @body
        o << "\n"+"~"*8+"\n"
        o << "{: lang=\"ruby\"}\n"
        o << "{: .ruby}\n\n"
    end

    def format_out(out)
        o =  "\n"+"~"*8+"\n"
        o << out
        o << "\n"+"~"*8+"\n"
        o << "{: .output}\n\n"
    end

    def run()
        out = eval @body

        #puts @attrs
        #puts "b='#{@body}'"
        #puts "out='#{out}'"

        format_body+format_out(out)
    end

end

class RubyEval

    def initialize()
        super
    end

    def run(content)
        content.gsub(/{::rubyeval([^}]*)}(.*){:\/rubyeval}/m) do |m|
            RESandBox.new(m, $1.strip, $2.strip).run
        end
    end
end
