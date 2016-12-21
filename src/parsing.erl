%% @author Quinn
-module(parsing).
-export([main/1, stackcalc/1]).
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
		true -> erlang:error(badarg)
	end.
get_parentheses(List) ->
	get_parentheses(List, [], 0).
get_parentheses([], _, _) ->
	erlang:error(badarg);
get_parentheses([L | Ls], Out, N) ->
	if
		L == $( -> get_parentheses(Ls, [L | Out], N + 1);
		(L == $)) and (N > 0) -> get_parentheses(Ls, [L | Out], N - 1);
		L == $) -> {{'()', main(lists:reverse(Out))}, Ls};
		true -> get_parentheses(Ls, [L | Out], N)
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
				error:badarg -> exit(baddeci)
			end;
		L == $( ->
			try get_parentheses(Ls) of
				_ ->
					{A, B} = get_parentheses(Ls),
					main(B, [A | Out])
			catch
				error:badarg -> exit(badparens)
			end;
		L == $ -> main(Ls, Out);
		true ->
			try get_operator(List) of
				_ ->
					{A, B} = get_operator(List),
					main(B, [A | Out])
			catch
				error:badarg -> exit(badsymbol)
			end
	end.
main_test() ->
	[1,'+',2] = main("1+2"),
	[0.45,'/',6.5] = main("0.45/6.5"),
	[0,'*',1.567] = main("0*1.567"),
	[5,'-',0] = main("5-0"),
	[5,'*',{'()',[6,'+',7]},'/',8] = main("5*(6+7)/8"),
	[4,'*',{'()',[5,'-',{'()',[7,'/',8]}]}] = main("4*(5-(7/8))"),
	[5,'*',{'()',[6,'/',4]},'+',{'()',[3,'*',4]}] = main("5*(6/4)+(3*4)"),
	[1,'+',{'()',[2,'*',{'()',[4,'/',{'()',[5,'-',6]},'+',7]},'*',8]},'/',9] = main("1+(2*(4/(5-6)+7)*8)/9"),
	?assertExit(badparens, main("(4+(3)")),
	?assertExit(badsymbol, main("5+b6")),
	?assertExit(baddeci, main("4.00.3 + 6.4")),
	?assertExit(badparens, main("((4*(5)+6")).
	

stackcalc(Instr) ->
	io:format("start"),
	stackcalc(Instr, [], 0).
stackcalc([], [A], _) ->
	A;
stackcalc([I | Is], Stack, N) ->
	if
		(I >= $0) and (I =< $9) ->
			if
				N =< 2 -> erlang:error(badarg);
				N < 2 -> stackcalc(Is, [I | Stack], N + 1)
			end;
		N == 2 ->
			[A, B] = Stack,
			if
				I == $+ -> stackcalc(Is, [B + A], 1);
				I == $- -> stackcalc(Is, [B - A], 1);
				I == $* -> stackcalc(Is, [B * A], 1);
				I == $/ -> stackcalc(Is, [B / A], 1)
			end
	end.
		







