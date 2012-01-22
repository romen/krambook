require 'stringio'

class RESandBox
    @@INPUT__YMEDXND1 = "%%%'f'o'o'"
    def initialize(m, attrs, body)
        @m     = m

        @attrs = {}
        attrs.gsub(/([^ ]*?)="(.*?[^\\])"/) do |m|
            k,v = [$1,$2.gsub(/\\n/,"\n")]
            @attrs.store(k.intern,v)
        end unless attrs.nil?

        if @attrs[:select].nil?
            @attrs[:select] = 'both'
        end

        if @attrs[:input].nil?
            @input = ''
        else
            @input = @attrs[:input]
        end

        @body  = body.strip unless body.nil?
    end

    def realExecuteCode (__yMeDXnd1__code, __yMeDXnd1__input)
        # Wrap code to catch errors and to stop SystemExit.
        __yMeDXnd1__code = <<-END_CODE
          begin
            #{__yMeDXnd1__code}
          rescue SystemExit
          rescue Exception => error
            puts error.inspect
          end
        END_CODE

        strIO = StringIO.new

        unless __yMeDXnd1__input.empty?
            __yMeDXnd1__input = StringIO.new(__yMeDXnd1__input, 'r')
            class << strIO;
                self;
            end.module_eval do
                ['gets', 'getc', 'read'].each do |meth|
                    define_method(meth) do |*params|
                        inStr = __yMeDXnd1__input.method(meth).call(*params)
                        puts @@INPUT__YMEDXND1+inStr.chomp+(@@INPUT__YMEDXND1.reverse) # Echo input
                        inStr
                    end
                end
            end
        end

        # Pass these methods to strIO:
        kernelMethods = ['puts', 'putc', 'gets']

        # Swap out Kernel methods...
        kernelMethods.each do |meth|
            Kernel.module_eval "alias __temp__tutorial__#{meth}__ #{meth}"
            Kernel.module_eval do
                define_method(meth) do |*params|
                    strIO.method(meth).call(*params)
                end
            end
        end

        begin
            strIO.instance_eval __yMeDXnd1__code
        rescue Exception => error # Catch parse errors.
            return error.inspect
        ensure
            # ... and swap them back in
            kernelMethods.each do |meth|
                Kernel.module_eval "alias #{meth} __temp__tutorial__#{meth}__"
            end
        end

        strIO.string
    end

    def saferExecuteCode(code, input)
        out = nil
        IO.popen("-","w+") do |pipe|
            if pipe #father
                out = pipe.read
            else #child
                srand
                puts realExecuteCode(code,input)
            end
        end
        out
    end

    def format_body()
        o =  "\n"+"~"*8+"\n"
        o << @body
        o << "\n"+"~"*8+"\n"
        o << "{: lang=\"ruby\"}\n"
        o << "{: .ruby}\n\n"
    end

    def format_out(out)
        o  = '<pre class="output">'+"\n"
        o << out.gsub(/#{@@INPUT__YMEDXND1}(.*?)#{@@INPUT__YMEDXND1.reverse}\n*/m) do
            '<span class="REinput">'+$1+"</span>\n"
        end
        o << '</pre>'
    end

    alias executeCode saferExecuteCode

    def run()

        #puts @attrs
        #puts "b='#{@body}'"
        #puts "out='#{out}'"
        #puts @input unless @input.empty?

        case @attrs[:select].downcase
        when 'source', 'body' then
            format_body
        when 'output','out' then
            format_out(executeCode(@body, @input))
        else
            format_body+format_out(executeCode(@body, @input))
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

