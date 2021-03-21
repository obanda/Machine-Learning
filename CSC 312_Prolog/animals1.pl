/*attributs and objects represent the ontology*/
isa(A, mammal):-has(A, hair),!.
isa(A,mammal):-produces(A, milk),!.

isa(A,bird):-has(A, feathers),!.
isa(A, bird):-motion(A,fly),produces(A,eggs),!.

isa(A, carnivore):-eats(A, meat), has(A, claws),has(A, pointed_teeth),!.
isa(A, carnivore):- eats(A, meat), has(A, claws), has(A, curved_beak),!.
isa(A, herbivore):-eats(A,grass),has(A,hooves).

instance(A, cheetah):-isa(A,mammal), isa(A, carnivore), color(A, gold), has(A, dark_spots),!.
instance(A, tiger):-isa(A,mammal), isa(A, carnivore), color(A, gold), has(A, black_stripes),!.
instance(A,zebra):-isa(A,mammal),isa(A, herbivore),color(A,white),has(A, black_stripes),!.

instance(A, penguin):-isa(A, bird), \+ motion(A, fly), motion(A,swim),!.
instance(A, owl):-isa(A,bird), isa(A,carnvore), eyes(A, large), sound(A,hoot),!.

/*Ask rules*/

has(A, Val):-ask(has, A, Val).
produces(A, Val):-ask(produces, A, Val).
eats(A, Val):-ask(eats, A, Val).
color(A,Val):-ask(color,A, Val).
spots(A,Val):-ask(spots, A, Val).
stripes(A,Val):-ask(stripes, A, Val).
ask(Pred, Obj, Val):-known(Pred, Obj, Val, true),!.
ask(Pred, Obj, Val):-known(Pred, Obj, Val, false),!, fail.
ask(Pred, Obj, Val):-nl, write(Pred), write(' '),write(Obj),write(' '),
			write( Val) , write('?(y/n)'), read(Ans), !,
			((Ans=y, assert(known(Pred,Obj, Val, true)));(assert(known(Pred, Obj, Val, false)),fail)).
	

 
/* for motion predicate, use the ask menu*/
motion(O, V):- known(motion, O, V, true),!.
motion(O, V):- known(motion, O, V, false),!, false.
motion(O, V):- menuask(motion, O, V, [fly,swim]). 

 
/*creating a menu*/
menuask(Pred, O, V, MenuList) :-
		write('For the '), write(O), write(', What is the value for '),
		write(Pred), write('?'), nl,write(' select from the following list:'),
		write(MenuList), nl,read(X),
		check_val(Pred,O, V, X, MenuList),asserta( known(Pred, O, X,true) ),X==V.

check_val(Pred,O, V, X, MenuList) :- member(X, MenuList), !.

check_val(Pred,O, V, X, MenuList) :-
write(X), write(' is not a legal value, try again.'), nl,
menuask(Pred,O, V, MenuList).

identify:-nl,write('Identifying a new animal..........'),nl,instance(animal, Animal),!,nl,
			write('The animal is a '), write(Animal).
identify:- nl, write('Sorry. We cannot identify the animal described !!').

start:-repeat, abolish(known/4),dynamic(known/4), retractall(known/4), identify,nl,nl, write('Try again ? (y/n)'),read(Resp),\+ Resp=y,
		nl,write('Bye !!! We hope you had a fruitful interaction'),abolish(known,4) .
