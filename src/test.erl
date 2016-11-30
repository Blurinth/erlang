%% @author Quinn
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([getDigitsX/1, getDigits/1, count/1, count/0, reverseList/1, sort/1, sort1/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

getDigitsX(N) when N > 10 ->
	io:format("~p ~n", [N rem 10]),
	test:getDigitsX(N div 10);
getDigitsX(N) ->
	io:format("~p ~n", [N]).

count(0) -> 
	ok;
count(N) ->
	io:format("~p ~n", [N]),
	count(N-1).
count() -> 
	count(10).

getDigits(N) ->
	getDigits2(N, []);
getDigits(0) ->
	[0].
getDigits2(0, L) ->
	L;
getDigits2(N, L) ->
	getDigits2(N div 10, [N rem 10 | L]).

reverseList(L) ->
	reverseList(L, []).
reverseList([A | B], L2) ->
	reverseList(B, [A | L2]);
reverseList([], L2) ->
	L2.

sort1(In) ->
	sort1(In, [], 0).
sort1([Big, Small | Rest], Out, Swaps) when Big > Small ->
	sort1([Big | Rest], [Small | Out], Swaps+1);
sort1([Small, Big | Rest], Out, Swaps) ->
	sort1([Big | Rest], [Small | Out], Swaps);
sort1([Last], Out, Swaps) ->
	sort1([], [Last | Out], Swaps);
sort1([], Out, Swaps) ->
	{Swaps, lists:reverse(Out)}.

sort({Swaps, List}) when Swaps > 0 ->
	sort(List);
sort({Swaps, List}) ->
	List;
sort(List) ->
	sort(sort1(List)).

	






