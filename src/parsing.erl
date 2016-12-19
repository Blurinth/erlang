%% @author Quinn
-module(parsing).
-export([get_number/1, get_operator/1, main/1]).
-include_lib("eunit/include/eunit.hrl").

get_number(String) ->
	get_number(String, []).
get_number([], Out) ->
	{list_to_integer(lists:reverse(Out)), []};
get_number([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) -> get_number(Ls, [L | Out]);
		L == $. -> get_number_float(Ls, [L | Out]);
		true -> {list_to_integer(lists:reverse(Out)), List}
	end.
get_number_float([], Out) ->
	{list_to_float(lists:reverse(Out)), []};
get_number_float([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) -> get_number_float(Ls, [L | Out]);
		L == $. -> erlang:error(badarg);
		true -> {list_to_float(lists:reverse(Out)), List}
	end.
get_operator([L | Ls]) ->
	if
		L == $+ -> {'+', Ls};
		L == $- -> {'-', Ls};
		L == $* -> {'*', Ls};
		L == $/ -> {'/', Ls};
		L == $( -> {'(', Ls};
		L == $) -> {')', Ls};
		true -> erlang:error(badarg)
	end.
main(String) ->
	main(String, []).
main([], Out) ->
	lists:reverse(Out);
main([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) ->
			try get_number(List) of
				_ ->
					{A, B} = get_number(List),
					main(B, [A | Out])
			catch
				error:badarg -> main(Ls, Out)
			end;
		L == $ -> main(Ls, Out);
		true ->
			try get_operator(List) of
				_ ->
					{A, B} = get_operator(List),
					main(B, [A | Out])
			catch
				error:badarg -> main(Ls, Out)
			end
	end.
main_test() ->
[1,'+',2] = main("1+2"),
[0.45,'/',6.5] = main("0.45/6.5"),
[0,'*',1.567] = main("0*1.567"), 
[5,'-',0] = main("5-0"). 