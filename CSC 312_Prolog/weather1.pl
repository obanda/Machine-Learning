initialise1:-dynamic(temp/1),dynamic(barometer/1),dynamic(humidity/1),dynamic(sky/1).
clear1:-abolish(temp/1),abolish(barometer/1),abolish(humidity/1),abolish(sky/1).

%rules for the weather
rule(1,weather(good),[temp(high),humidity(dry),sky(sunny)]).
rule(2,weather(bad),[humidity(wet)]).
rule(3,weather(bad),[temp(low)]).
rule(4,weather(bad),[sky(overcast)]).
rule(5,weather(uncertain),[]).
%rules for forecast
rule(6,forecast(good),[weather(good)]).
rule(7,forecast(bad),[weather(bad)]).
rule(8,forecast(uncertain),[weather(uncertain)]).

start:-initialise1,dynamic(known/2),dynamic(forecast/1),dynamic(weather/1),
			prove(forecast(X),[]), write('The forcast is '),write(X),
			abolish(weather/1),abolish(forecast/1), abolish(known/2), clear1.
prove(X,L1):- X,!. 
prove(X,L1):- functor(X,F, N),askable(F, Menu), arg(1,X, V),ask(F,Menu,V,L1),!.
prove(X,L1):- rule(N,X,L),proveL(L,[N|L1]).
proveL([],_).
proveL([H|T],L1):-prove(H,L1),proveL(T,L1).

askable(temp, 'high, low, why').
askable(barometer, 'high, low, why').
askable(humidity, 'dry, wet, why').
askable(sky, 'overcast, sunny, why').
ask(Pred, Menu, Val,L1):-known(Pred, Val),!.
ask(Pred, Menu, Val,L1):-known(Pred, Val1), \+ Val=Val1,!, fail.
ask(Pred, Menu, Val,L1):-nl, write(Pred), write(' : '),write(Menu),write(':'),
			read(Ans), !,((Ans=why, write(L1),nl, ask(Pred, Menu, Val,L1) );
			(assert(known(Pred,Ans)), Ans=Val)).
	
