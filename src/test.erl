%% @author Quinn
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([getDigitsX/1, getDigits/1, count/1, count/0, reverseList/1, sort/1, bettersort/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

getDigitsX(N) when N > 10 ->
	io:format("~p ~n", [N rem 10]),
	test:getDigitsX(N div 10);
getDigitsX(N) ->
	N.

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

swaps(In) ->
	swaps(In, [], 0).
swaps([Big, Small | Rest], Out, Swaps) when Big > Small ->
	swaps([Big | Rest], [Small | Out], Swaps+1);
swaps([Small, Big | Rest], Out, Swaps) ->
	swaps([Big | Rest], [Small | Out], Swaps);
swaps([Last], Out, Swaps) ->
	swaps([], [Last | Out], Swaps);
swaps([], Out, Swaps) ->
	{Swaps, Out}.

sort({Swaps, List}) when Swaps > 0 ->
	sort(List);
sort({Swaps, List}) ->
	List;
sort(List) ->
	sort(swaps(List)).

swapb(In) ->
	swapb(In, [], 0).
swapb([Small, Big | Rest], Out, Swaps) when Small < Big ->
	swapb([Small | Rest], [Big | Out], Swaps+1);
swapb([Big, Small | Rest], Out, Swaps) ->
	swapb([Big | Rest], [Small | Out], Swaps);
swapb([Last], Out, Swaps) ->
	swapb([], [Last | Out], Swaps);
swapb([], Out, Swaps) ->
	{Swaps, Out}.


bettersort({Swaps, In}) when Swaps > 0 ->
	bettersort2(swapb(In));
bettersort({Swaps, In}) ->
	In;
bettersort(In) ->
	bettersort2(swapb(In)).

bettersort2({Swaps, In}) when Swaps > 0 ->
	bettersort(swaps(In));
bettersort2({Swaps, In}) ->
	In;
bettersort2(In) ->
	bettersort(swaps(In)).

