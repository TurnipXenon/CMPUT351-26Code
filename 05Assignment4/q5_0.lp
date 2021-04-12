%an input graph

vertex(1..6).
arc(1,(2;3;4)).  arc(2,(4;5;6)).  arc(3,(1;4;5)).
arc(4,(1;2)).   arc(5,(3;4;6)). arc(6,(2;3;5)).


% command line, e.g., 
%
%      clingo -c n=3 color.lp coloringIn0.lp
