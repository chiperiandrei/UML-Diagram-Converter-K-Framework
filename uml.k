module UML-SYNTAX 

  syntax Blocuri ::= "start" Stmt "stop" 
                  | "start" "stop"
                  | "start1" "stop1"
                  | "@startuml" Stmt "@enduml"
  syntax Ceva ::= String
              | Ceva Ceva [right]
  syntax Stmt ::= "if" "(" Ceva ")" "then" Ceva Ceva "else" Ceva Ceva "endif" [left]
                | Ceva Ceva "repeat" Ceva "until" "(" Ceva ")"
                | Blocuri
                | "start1" Ceva "stop1"
                | "print" "(" Stmt ")"  [strict]
                | "print" "(" Ceva ")"  [strict]
                | "while" "(" Ceva ")" Ceva "endwhile"
                | "afiseaza" Ceva [strict]
                | "clasa" Ceva "{" Ceva ";" Ceva ";" "}"
                > Stmt Stmt [right]

endmodule
module UML
  imports UML-SYNTAX
  syntax KResult ::= Bool | Int | String

  configuration <k> $PGM:Stmt </k>
                <out stream="stdout"> .List </out>

  rule S1:Stmt S2:Stmt => S1 ~> S2
  // print
  syntax Printable ::= Id | String 
  syntax Stmt ::= Printable
  syntax Noduri ::= Printable
  syntax Ceva::= Printable
  rule <k> (print(V:Printable) => .) ...</k>
      <out>... (.List => ListItem(V)) </out>
   rule <k> (afiseaza V:Printable => .) ...</k>
      <out>... (.List => ListItem(V)) </out>
    rule afiseaza X:Ceva =>  print(X:Ceva)
   
  //start diagrama
  rule @startuml X:Stmt @enduml => print("\\documentclass[a4paper,12pt]{article}\n\\usepackage[T1]{fontenc}\n\\usepackage[utf8x]{inputenc}\n\\usepackage[french]{babel}\n\\usepackage{fullpage}\n\\usepackage{tikz-uml}\n\\usepackage{tikz}\n\\usetikzlibrary{arrows,backgrounds,calc,chains,decorations,positioning,fit,shapes}\n\\title{Modelling languages - Make diagrams in LaTeX}\n\\author{Chiperi Andrei(grupa A1)}\n\\date{\\today}\n\\begin{document}") X:Stmt print ("\\end{document}")
  //block
  rule start1 V:Ceva stop1 => print("\\begin{tikzpicture}[node distance = 1 cm,> = stealth,start chain = going below,every node/.style = {align=center},startstop/.style = {circle, rounded corners, draw=black, fill=green!20,minimum width=0.3cm, minimum height=0.3cm, on chain},decision/.style = {draw=#1, fill=#1!20,diamond, minimum width=3cm, minimum height=1cm, on chain},block/.style = {draw=#1, fill=#1!20,rectangle, rounded corners, text width=4cm, minimum height=1cm},process/.style = {block=#1, on chain},normal/.style = {rectangle, draw, fill=white, text width=3cm, text=red, on chain},arrow/.style = {thick,->},arrow_red/.style = {thick,->,draw=red}]\n\\node (start)       [startstop]     {Start};\n\\node (ins_before)  [process=gray]  {") afiseaza V:Ceva
    print("};\n\\node (stop)        [startstop]     {Stop};\n\\draw [arrow]   (start)         edge    (ins_before)\n(ins_before)            edge    (stop);\n\\end{tikzpicture}  \\newpage")
  rule start stop => .
  rule start1 stop1 => .
  rule start V:Stmt stop => V:Stmt
  //if 
  rule if(A:Ceva) then B:Ceva C:Ceva else D:Ceva E:Ceva endif => print("\\begin{tikzpicture}[\nnode distance = 1 cm,\n> = stealth,\nstart chain = going below,\nevery node/.style = {align=center},\nstsp/.style = {rectangle, rounded corners, draw=red, fill=red!20,\nminimum width=3cm, minimum height=1cm, on chain},\ndecision/.style = {draw=#1, fill=#1!20,\ndiamond, minimum width=3cm, minimum height=1cm, on chain},\nblock/.style = {draw=#1, fill=#1!20,\nrectangle, rounded corners, \ntext width=4cm, minimum height=1cm},\nprocess/.style = {block=#1, on chain},\nnormal/.style = {rectangle, draw, fill=white, \ntext width=3cm, text=red, on chain},\narrow/.style = {thick,->},\n]\n\\node (inceput)        [stsp]     {Start};\n\\node (testt)        [decision=gray] {") afiseaza A:Ceva print("};\n\\node (iterativ)   [process=gray]  {") afiseaza C:Ceva print("};\n\\node (ins_afterr)   [process=gray]  {") afiseaza E:Ceva print("};\n\\node (stopp)        [stsp]     {Sfarsit};\n\\draw [arrow]         \n(inceput) edge (testt)\n(testt) edge node[right] {") afiseaza B:Ceva print("} (iterativ);\n\\draw [arrow]   (testt.west)  -- node[anchor=south] {") afiseaza D:Ceva print("} ++(-1.5,0) coordinate (auxiliary)    |- \n($(ins_afterr.north)+(0,0.5)$) -|  (ins_afterr)\n(iterativ.east)  -- node[anchor=south] ++(1.5,0) coordinate (auxiliary)    |- \n($(stopp.east)+(0,0.1)$) |-  (stopp);\n\\draw [arrow]   (ins_afterr) -- (stopp);\n\\end{tikzpicture}   \\newpage ")
  rule A:Ceva B:Ceva repeat X:Ceva until (Y:Ceva) => print("\\begin{tikzpicture}[\nnode distance = 1 cm,\n> = stealth,\nstart chain = going below,\nevery node/.style = {align=center},\nstartstop/.style = {circle, rounded corners, draw=black, fill=green!20,minimum width=0.3cm, minimum height=0.3cm, on chain},\ndecision/.style = {draw=#1, fill=#1!20,\n diamond, minimum width=3cm, minimum height=1cm, on chain},\n block/.style = {draw=#1, fill=#1!20,\nrectangle, rounded corners, \ntext width=4cm, minimum height=1cm},\nprocess/.style = {block=#1, on chain},\nnormal/.style = {rectangle, draw, fill=white, \n text width=3cm, text=red, on chain},\narrow/.style = {thick,->},\narrow_red/.style = {thick,->,draw=red}]\n\n\\node (start)       [startstop]     {Start};\n\\node (ins_before)  [process=gray]  {") afiseaza X:Ceva print("};\n\\node (test)        [decision=gray] {") afiseaza Y:Ceva print("};\n\\node (stop)        [startstop]     {Stop};\n\\scoped[on background layer]\n\\node (instructions) [ inner xsep=0.5cm,]   {};\n\\draw [arrow]   (start)         edge    (ins_before)\n(ins_before) edge    (test)\n(test) edge node[right] {") afiseaza A:Ceva print("} (stop.north);\n\\draw [arrow]   (test.west)  -- node[anchor=north] {") afiseaza B:Ceva print("} ++(-1.5,0) \ncoordinate (auxiliary)    |- \n($(ins_before.west)+(0,0.1)$) |-  (ins_before.west);\n\\end{tikzpicture}  \\newpage  ")
  //while

  rule while (X:Ceva) Y:Ceva endwhile => print("\\begin{tikzpicture}[\nnode distance = 1 cm,\n> = stealth,\nstart chain = going below,\nevery node/.style = {align=center},\nstartstop/.style = {circle, rounded corners, draw=black, fill=green!20,minimum width=0.3cm, minimum height=0.3cm, on chain},\ndecision/.style = {draw=#1, fill=#1!20,diamond, minimum width=3cm, minimum height=1cm, on chain},\nblock/.style = {draw=#1, fill=#1!20,rectangle, rounded corners, text width=4cm, minimum height=1cm},\nprocess/.style = {block=#1, on chain},\nnormal/.style = {rectangle, draw, fill=white, text width=3cm, text=red, on chain},\narrow/.style = {thick,->},\narrow_red/.style = {thick,->,draw=red}]\\node (start)       [startstop]     {Start};\n\\node (test)        [decision=gray] {")
    afiseaza X:Ceva print("};\n\\node (block1)      [normal,draw=none,fill=none]  {") afiseaza Y:Ceva print("};\n\\node (break)       [normal]        {break;};\n\\node (continue)    [normal]        {continue;};\n\\node (block2)      [normal,draw=none,fill=none]  {instructions};\n\\node (stop)        [startstop]     {Stop};\n\\scoped[on background layer]\n\\node (instructions) [block=gray, inner xsep=0.5cm,fit=(block1) (break) (block2)]   {};\n\\draw [arrow]   (start)        edge   (test)(test) edge node[right] {Adevarat} (instructions.north);\n\\draw [arrow]   (test.west)  -- node[anchor=south] {Fals} ++(-1.5,0) coordinate (auxiliary)     |-  (stop);\n\\draw [arrow]   (instructions.east)  -- ++(1.5,0) |- (test);\n\\end{tikzpicture}    ")

  rule clasa A:Ceva { B:Ceva; C:Ceva; }=>print("\\begin{center}\n\\begin{tikzpicture}\n\\umlclass[y=-3]{") afiseaza A:Ceva print("}{") afiseaza B:Ceva print("}{\\umlvirt{}") afiseaza C:Ceva print("}\n\\end{tikzpicture}\n\\end{center}")
endmodule