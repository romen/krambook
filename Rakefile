#!/usr/bin/env ruby
# encoding: utf-8

require 'rake/clean'

CLEAN.include('**/*.{aux,log,out}')
CLEAN.include('tmp/**/*')
CLOBBER.include('**/*.pdf')
CLOBBER.include('content/**/*.tex')
CLOBBER.include('site/**/*.html')
CLOBBER.include('site/**/*.svg')
CLOBBER.include('site/include/*')
CLOBBER.exclude('site/js')

task :default => [:compile]

task :svg do
    class HTMLCompile
        def initialize
            eval File.read('config.rb')
            puts @pdfname
        end

        def run
            FileUtils.mkdir_p("site") 

            if not FileTest.exists?( "tmp/#{@pdfname}.pdf" )
                puts "run `rake compile` to generate the pdf file please"
                exit 1
            end
            command=%{pdf2svg tmp/#{@pdfname}.pdf svgsite/#{@pdfname}-%d.svg all}
            puts command
            system(command)
            hdecal=110
            vdecal=120
            nb_pages=0
            Dir["svgsite/*.svg"].each do |fic|
                f=File.open(fic,"r")
                res=f.read().sub( /viewBox="(\d+) (\d+) (\d+) (\d+)"/) do
                    res=%{viewBox="}
                    res<<=%{#{Integer($1) + hdecal} }
                    res<<=%{#{Integer($2) + vdecal} }
                    res<<=%{#{Integer($3) - hdecal} }
                    res<<=%{#{Integer($4) - vdecal}"} 
                end
                f.close
                f=File.open(fic,"w")
                f.write( res )
                f.close
                nb_pages+=1
            end
            target=File.open("svgsite/index.html","w")
            src=File.open("include/index.html","r")
            res=src.read()
            src.close

            res.sub!("var nb_pages=0","var nb_pages=#{nb_pages}")
            target.write(res)
            target.close
        end
    end
    x=HTMLCompile.new
    x.run
end

task :html do
    require 'rubygems'
    require 'kramdown'
    require_relative 'filters/markdown_macros'
    require_relative 'filters/markdown_postmacros'
    require_relative 'filters/html_template'
    require_relative 'filters/fix_postmacros'
    require_relative 'filters/mathjax'
    require_relative 'filters/links'

    class KrambookCompile
        require_relative 'config_html.rb'
        require 'date'

        attr_accessor :filelist

        def initialize

            @kramdown_opts={}
            eval File.new('config_html.rb','r').read

            @prefilters=[]
            @prefilters<<=MarkdownMacros.new
            @prefilters<<=MarkdownPostMacros.new
            @prefilters<<=FixPostMacros.new

            @postfilters=[]
            html_template=HTMLTemplate.new
            html_template.template=@general_template
            html_template.title=@title
            html_template.subtitle=@subtitle
            html_template.author=@author
            html_template.homeURL="index.html"
            @postfilters<<=Links.new
            @postfilters<<=html_template
            @postfilters<<=MathJax.new

            @filelist=Dir.glob("content/**/*.md").sort.map do |fic|
                    [ fic, fic.sub(/^content\//,"site/").sub(/.md$/,".html") ]
                end
        end

        # take a string from kramdown 
        # returns LaTeX after filter
        def compile_text(tmp)
            @prefilters.each do |f| 
                tmp=f.run( tmp )
            end

            # compile to latex
            # puts tmp
            tmp=Kramdown::Document.new(tmp, @kramdown_opts).to_html

            # post filters
            @postfilters.each{ |f| tmp=f.run(tmp) }
            return tmp
        end

        def process_template
            txt=File.read(@template_file)

            # puts "READ: " + txt
            txt.sub!( /<!-- INCLUDES -->/ ) do
                    @filelist.map do |source,dest| 
                        if File::basename(source) =~ /\.hidden\./
                            ""
                        else
                            %{<div class="block">
                                <h3>
                                    <a href="#{dest.sub(/^site\//,'')}">
                                        #{File::basename(dest,'.html').sub(/^\d+_/,'')}
                                        <span class="nicer">»</span>
                                    </a>
                                </h3>
                            </div>}
                        end
                    end.join("\n") + '</ul>'
                end
            txt.gsub!(%r{<!-- Date -->},Date.today.to_s)
            # puts "AFTER INCLUDES: " + txt
            txt.gsub!(%r{<!-- Author -->},@author)
            # puts "AFTER AUTHOR: " + txt
            txt.gsub!(%r{<!-- Title -->},@title)
            txt.gsub!(%r{<!-- Subtitle -->},@subtitle)
            # puts "AFTER TITLE: " + txt
            fic=File.new("site/index.html","w")
            fic.write(txt)
            fic.close
        end

        def run
            i=-1
            @filelist.each do |doublon|
                i+=1
                source=doublon[0]
                dest=doublon[1]
                puts source

                # read and compile in LaTeX the .md file
                templateindex=1
                @postfilters[templateindex].nextURL =
                    if (i+1)<@filelist.size
                        nexturl = @filelist[i + 1][1].gsub('site/','')
                        if (nexturl =~ /\.hidden\./)
                            "#"
                        else
                            nexturl
                        end
                    else
                        "#"
                    end
                @postfilters[templateindex].prevURL =
                    if (i-1)>=0
                        prevurl = @filelist[i - 1][1].gsub('site/','')
                        if (prevurl =~ /\.hidden\./)
                            "#"
                        else
                            prevurl
                        end
                    else
                        "#"
                    end
                text=compile_text( File.new(source,"r").read )

                # create directory if necessary
                if not FileTest::directory?(File.dirname(dest))
                    FileUtils.mkdir_p(File.dirname(dest)) 
                end

                # write the .tex file
                fic = File.new(dest,"w")
                fic.write(text)
                fic.close

            end

            # write the .tex file containing all includes
            process_template

            system("cp -rf include site/")
        end
    end
    KrambookCompile.new.run
end

task :compile do
    require 'rubygems'
    require 'kramdown'
    require_relative 'filters/markdown_macros'
    require_relative 'filters/markdown_postmacros'
    require_relative 'filters/fix_postmacros_latex'

    class KrambookCompile
        require_relative 'config.rb'

        attr_accessor :filelist

        # take a string from kramdown 
        # returns LaTeX after filter
        def compile_text(tmp)
            @prefilters.each do |f| 
                tmp=f.run( tmp )
            end

            # compile to latex
            tmp=Kramdown::Document.new(tmp, @kramdown_opts).to_latex

            # post filters
            @postfilters.each{ |f| tmp=f.run(tmp) }
            return tmp
        end

        def process_template
            template=File.new(@template_file,"r")
            txt=template.read
            template.close

            txt.sub!( /%%#INCLUDES#%%/ ) do
                    @filelist.map do |source,dest| 
                        "\\include{#{dest.sub(/^tmp\//,'').sub(/.tex/,'')}}"
                    end.join("\n")
                end.
                sub!(%{\\author\{\}},'\author{'+@author+'}').
                sub!(%{\\title\{\}},'\title{'+@title+'}')
            fic=File.new("tmp/#{@pdfname}.tex","w")
            fic.write(txt)
            fic.close
        end

        def initialize

            @kramdown_opts={}
            eval File.new('config.rb','r').read
            if @kramdown_opts[:latex_header].nil?
                @kramdown_opts.merge!({:latex_headers =>
                  %w(chapter section subsection paragraph subparagraph subsubparagraph)})
            end

            @prefilters=[]
            @prefilters<<=MarkdownMacros.new
            @prefilters<<=MarkdownPostMacros.new
            @prefilters<<=FixPostMacros.new

            @postfilters=[]

            @filelist=Dir.glob("content/**/*.md").sort.map do |fic|
                    [ fic, fic.sub(/^content\//,"tmp/").sub(/.md$/,".tex") ]
                end
        end

        def run
            @filelist.each do |doublon|
                source=doublon[0]
                dest=doublon[1]
                puts source

                # read and compile in LaTeX the .md file
                text=compile_text( File.new(source,"r").read )

                # create directory if necessary
                if not FileTest::directory?(File.dirname(dest))
                    FileUtils.mkdir_p(File.dirname(dest)) 
                end

                # write the .tex file
                fic = File.new(dest,"w")
                fic.write(text)
                fic.close

            end

            # write the .tex file containing all includes
            process_template

            # launch the xelatex process
            system("cp -rf include tmp/")

            Dir.chdir("tmp") do
                2.times { system("xelatex #{@pdfname}") }

                # open the pdf
                system("open #{@pdfname}.pdf")
                # on Ubuntu replace by
                # system("gnome-open #{@pdfname}.pdf")
            end


        end
    end
    KrambookCompile.new.run
end
