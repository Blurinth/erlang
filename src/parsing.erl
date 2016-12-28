%% @author Quinn
-module(parsing).
-export([parse/1, parse2/1, stackcalc/1]).
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
		L == $) -> {{'()', parse(lists:reverse(Out))}, Ls};
		true -> get_parentheses(Ls, [L | Out], N)
	end.
parse(String) ->
	parse(String, []).
parse([], Out) ->
	lists:reverse(Out);
parse([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) ->
			try get_number(List) of
				_ ->
					{A, B} = get_number(List),
					parse(B, [A | Out])
			catch
				error:badarg -> exit(baddeci)
			end;
		L == $( ->
			try get_parentheses(Ls) of
				_ ->
					{A, B} = get_parentheses(Ls),
					parse(B, [A | Out])
			catch
				error:badarg -> exit(badparens)
			end;
		L == $ -> parse(Ls, Out);
		true ->
			try get_operator(List) of
				_ ->
					{A, B} = get_operator(List),
					parse(B, [A | Out])
			catch
				error:badarg -> exit(badsymbol)
			end
	end.
parse_test() ->
	[1,'+',2] = parse("1+2"),
	[0.45,'/',6.5] = parse("0.45/6.5"),
	[0,'*',1.567] = parse("0*1.567"),
	[5,'-',0] = parse("5-0"),
	[5,'*',{'()',[6,'+',7]},'/',8] = parse("5*(6+7)/8"),
	[4,'*',{'()',[5,'-',{'()',[7,'/',8]}]}] = parse("4*(5-(7/8))"),
	[5,'*',{'()',[6,'/',4]},'+',{'()',[3,'*',4]}] = parse("5*(6/4)+(3*4)"),
	[1,'+',{'()',[2,'*',{'()',[4,'/',{'()',[5,'-',6]},'+',7]},'*',8]},'/',9] = parse("1+(2*(4/(5-6)+7)*8)/9"),
	?assertExit(badparens, parse("(4+(3)")),
	?assertExit(badsymbol, parse("5+b6")),
	?assertExit(baddeci, parse("4.00.3 + 6.4")),
	?assertExit(badparens, parse("((4*(5)+6")).
	
stackcalc(Instr) ->
	stackcalc(Instr, []).
stackcalc(['+' | Is], [A, B | Rest]) ->
	stackcalc(Is, [B + A | Rest]);
stackcalc(['-' | Is], [A, B | Rest]) ->
	stackcalc(Is, [B - A | Rest]);
stackcalc(['*' | Is], [A, B | Rest]) ->
	stackcalc(Is, [B * A | Rest]);
stackcalc(['/' | Is], [A, B | Rest]) ->
	stackcalc(Is, [B / A | Rest]);
stackcalc([I | Is], Stack) ->
	stackcalc(Is, [I | Stack]);
stackcalc([], [A]) ->
	A.
parse2(String) ->
	parse2b(parse(String)).
parse2b([L1, L2 | Ls]) ->
	if
		is_integer(L1) or is_float(L1) ->
			if
				L2 == '+' -> {'+', L1, parse2b(Ls)};
				L2 == '-' -> {'-', L1, parse2b(Ls)};
				L2 == '*' -> {'*', L1, parse2b(Ls)};
				L2 == '/' -> {'/', L1, parse2b(Ls)}
			end;
		is_tuple(L1) ->
			{_, A} = L1,
			if
				L2 == '+' -> {'()', [{'+', parse2b(A), parse2b(Ls)}]};
				L2 == '-' -> {'()', [{'-', parse2b(A), parse2b(Ls)}]};
				L2 == '*' -> {'()', [{'*', parse2b(A), parse2b(Ls)}]};
				L2 == '/' -> {'()', [{'/', parse2b(A), parse2b(Ls)}]}
			end
	end;
parse2b([L]) ->
	L.
















