%% @author Quinn
%% @doc @todo Add description to parsing.


-module(parsing).

%% ====================================================================
%% API functions
%% ====================================================================
-export([get_number/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

get_number(String) ->
	get_number(String, []).
get_number([], Out) ->
	[lists:reverse(Out), []];
get_number([L | Ls] = List, Out) ->
	if
		(L >= $0) and (L =< $9) -> get_number(Ls, [L | Out]);
		L == $. -> get_number(Ls, [L | Out]);
		true -> [lists:reverse(Out), List]
	end.
		
