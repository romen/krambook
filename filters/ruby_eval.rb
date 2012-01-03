class RESandBox
    def initialize(m, attrs, body)
        @m     = m

        @attrs = {}
        attrs.strip.split.each do |a|
            k,v = a.split("=")
            @attrs.store(k.intern,v)
        end unless attrs.nil?

        if @attrs[:select].nil?
            @attrs[:select] = 'both'
        end

        @body  = body.strip unless body.nil?
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

        case @attrs[:select].downcase
        when 'source', 'body' then
            format_body
        when 'output','out' then
            format_out(out)
        else
            format_body+format_out(out)
        end
    end

end

class RubyEval

    def initialize()
        super
    end

    def run(content)
        content.gsub(/{::rubyeval( (.*?))?}(.*?){:\/rubyeval}/m) do |m|
            #puts "\t$2:\t"+$2 unless $2.nil?
            #puts "\t$3:\t"+$3 unless $3.nil?
            RESandBox.new(m, $2, $3).run
        end
    end
end
