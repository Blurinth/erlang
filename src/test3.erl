%% @author Quinn
%% @doc @todo Add description to test3.

-module(test3).
-export([sqr/2, sqrt/1, getstart/1]).

sqr(Num, Times) ->
	sqr(Num, Num, Times).
sqr(Num, _, 1) ->
	Num;
sqr(Num, Base, Times) ->
	sqr(Num * Num, Base, Times - 1).

getstart(Num) ->
	getstart(Num, 1).
getstart(Num, N) when Num > 10 ->
	getstart(Num/10, 10*N);
getstart(_, N) -> 
	N.

sqrt(Num) when Num == 0 ->
	0;
sqrt(Num) when Num < 0 ->
	erlang:error(badarith);
sqrt(Num) ->
	sqrt(Num, getstart(Num), Num).
sqrt(Num, Place, Test) ->
	io:format("~p, ~p~n", [Place, Test]),
	A = Test - Place,
	if
		A =:= Test -> Test;
		A * A < Num -> sqrt(Num, Place / 10, Test);
		true -> sqrt(Num, Place, Test - Place)
	end.
