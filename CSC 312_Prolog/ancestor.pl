parent(peter,john,P):- P=['rule1: peter is johns parent'].
parent(peter,ann,P):- P=['rule2: peter is anns parent'].
parent(ann,joan,P):- P=['rule3: ann is joans parent'].
parent(ann,jane, P):- P=['rule4: ann is janes parent'].
parent(jane,mary,P):- P=['rule5: jane is marys parent'].
parent(jane,tom,P):- P=['rule6: jane is toms parent'].
ancestor(Anc,Prs,P):- parent(Anc,Prs,P1),string_to_atom(S1, Anc), string_to_atom(S2, Prs),
					 string_concat('rule7: ', S1, S3), string_concat(S3, ' is ', S4),
					 string_concat(S4, S2, S5),string_concat(S5, 's Ancestor ', S6),P=[S6,P1],!.
ancestor(Anc,Prs,P):- parent(Smbd,Prs,P1),ancestor(Anc, Smbd,P2),string_to_atom(S1, Anc), 
					string_to_atom(S2, Prs),string_concat('rule8: Ancestor ', S1, S3), 
					string_concat(S3, ' ', S4), string_concat(S4, S2, S5),P=[S5,P1,P2],!.

print_explanation([],_):- nl.
print_explanation([H1|T],TabCount):-   \+ is_list(H1),\+ T=[],nl,tab(TabCount),writef(H1), write(' coz by '),
										N is TabCount+2, print_explanation(T,N).
print_explanation([H1|T],TabCount):-   \+ is_list(H1), T=[],nl,tab(TabCount),writef(H1).
										
print_explanation([H1|T],TabCount):-  \+ is_list(H1),nl,tab(TabCount),writef(H1),
										N is TabCount+2, print_explanation(T,N).										
										
print_explanation([H1|T],TabCount):-   is_list(H1),
									   print_explanation(H1,TabCount),(T=[];write(' and')),
									   print_explanation(T,TabCount).
									   