%% @author Quinn
-module(parsing).
-export([get_number/1, get_operator/1, main/1]).


get_number(String) ->
	get_number(String, []).
get_number([], Out) ->
	{lists:reverse(Out), []};
get_number([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) -> get_number(Ls, [L | Out]);
		L == $. -> get_number_float(Ls, [L | Out]);
		true -> {list_to_integer(lists:reverse(Out)), List}
	end.
get_number_float([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) -> get_number_float(Ls, [L | Out]);
		L == $. -> erlang:error(badargs);
		true -> {list_to_float(lists:reverse(Out)), List}
	end.
get_operator([L | Ls]) ->
	if
		L == $+ -> {'+', Ls};
		L == $- -> {'-', Ls};
		L == $* -> {'*', Ls};
		L == $/ -> {'/', Ls};
		true -> erlang:error(badargs)
	end;
get_operator(L) ->
	if
		L == $+ -> {'+', []};
		L == $- -> {'-', []};
		L == $* -> {'*', []};
		L == $/ -> {'/', []};
		true -> erlang:error(badargs)
	end.
main(String) ->
	main(String, []).
main([], Out) ->
	lists:reverse(Out);
main([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) ->
			{A, B} = get_number(List),
			main(B, [A | Out]);
		L == $ -> main(Ls, Out);
		true ->
			try get_operator(List) of
				_ ->
					{A, B} = get_operator(List),
					main(B, [A | Out])
			catch
				error:badargs -> main(Ls, Out)
			end
	end.













