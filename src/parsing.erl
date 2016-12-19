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
get_parentheses(List) ->
	get_parentheses(List, []).
get_parentheses([], _) ->
	erlang:error(badarg);
get_parentheses([L | Ls], Out) ->
	io:format("parent~n"),
	if
		L == $( -> 
			{A, B} = get_parentheses_nested(Ls, []),
			get_parentheses(A, [B | Out]);
		L == $) -> {{'()', main(lists:reverse(Out))}, Ls};
		true -> get_parentheses(Ls, [L | Out])
	end.
get_parentheses_nested([], _) ->
	erlang:error(badarg);
get_parentheses_nested([L | Ls], Out) ->
	io:format("nest~n"),
	if
		L == $( ->
			{A, B} = get_parentheses_nested(Ls, []),
			get_parentheses_nested(A, [{'()', B} | Out]);
		L == $) -> {Ls, {'()', main(lists:reverse(Out))}};
		true -> get_parentheses_nested(Ls, [L | Out])
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
		L == $( ->
			{A, B} = get_parentheses(Ls),
			main(B, [A | Out]);
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
[5,'-',0] = main("5-0"),
[5,'*',{'()',[6,'/',4]},'+',{'()',[3,'*',4]}] = main("5*(6/4)+(3*4)").










