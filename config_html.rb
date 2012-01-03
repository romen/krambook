# Use this file to configure some general variables

@title=%{Krambook}
@subtitle=%{<span class="small">Write Books like an
       <code>UB3R 1337</code> <em>(Hacker)</em></span>}

@author="Yann Esposito"

# file name
@pdfname="krambook"

# LaTeX headers (before \begin{document})
@html_headers=''

# change the template file in case latex_headers is not enough 
# Remember to not remove lines begining by %%#
# look at include/template.tex for example
@template_file="include/toc_template.html"
@general_template="include/template.html"

@kramdown_opts={
    :coderay_wrap              => 'div',
    :coderay_line_numbers      => 'table',
    :coderay_line_number_start => 1,
    :coderay_tab_width         => 4,
    :coderay_bold_every        => 10,
    :coderay_css               => 'class'
}

