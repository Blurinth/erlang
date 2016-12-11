%% @author Quinn
%% @doc @todo Add description to test2.


-module(test2).
-include_lib("eunit/include/eunit.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([sort/1, testlistgen/1, editlist/2, editlist2/3, mergelists/3, split/1, mergesort/1, mergesort/2, quicksort/1, quicksort2/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%movest biggest right, reverses list
sortbig(In) ->
	sortbig(In, [], 0).
sortbig([Big, Small | Rest], Out, Swaps) when Big > Small ->
	sortbig([Big | Rest], [Small | Out], Swaps + 1);
sortbig([Small, Big | Rest], Out, Swaps) ->
	sortbig([Big | Rest], [Small | Out], Swaps);
sortbig([Last], Out, Swaps) ->
	sortbig([], [Last | Out], Swaps);
sortbig([], Out, Swaps) ->
	{Out, Swaps}.
%moves smallest right, reverses list
sortsmall(In) ->
	sortsmall(In, [], 0).
sortsmall([Small, Big | Rest], Out, Swaps) when Small < Big ->
	sortsmall([Small | Rest], [Big | Out], Swaps + 1);
sortsmall([Big, Small | Rest], Out, Swaps) ->
	sortsmall([Small | Rest], [Big | Out], Swaps);
sortsmall([Last], Out, Swaps) ->
	sortsmall([], [Last | Out], Swaps);
sortsmall([], Out, Swaps) ->
	{Out, Swaps}.
%alternates sorting between small to right vs big to right, stops when list sorted
sort(List) ->
	sort(sortbig(List), 1).
sort({List, Swaps}, 1) when Swaps > 0->
	sort(sortbig(List), 2);
sort({List, Swaps}, 2) when Swaps > 0->
	sort(sortsmall(List), 1);
sort({List, 0}, 2) ->
	sort(sortsmall(List), 1);
sort({List, 0}, 1) ->
	List.
%unit test
sort_test() ->
	sort_test([testlistgen(20) | [[],[1],[2,1],[3,1,2]]]).
sort_test([A | Tests]) ->
	Correct = lists:sort(A),
	Correct = sort(A),
	sort_test(Tests);
sort_test([]) ->
	ok.
%generates an N long list of lists with a random number(0-10) of random numbers(0-10)				
testlistgen(N) ->
	[[rand:uniform(11)-1 || _ <- lists:seq(0, rand:uniform(11)-2)] || _ <- lists:seq(1, N)].
%applies Function on all the items in List
editlist(Function, List) ->
	[Function(A) || A <- List].
%Applies Function1 to item in List if Function2 returns true for that item
editlist2(Function1, Function2, List) -> 
	editlist2(Function1, Function2, List, []).
editlist2(F1, F2, [L | Ls], Out) ->
	case F2(L) of
		true -> editlist2(F1, F2, Ls, [F1(L) | Out]);
		false -> editlist2(F1, F2, Ls, Out)
	end;
editlist2(_, _, [], Out) ->
	lists:reverse(Out).
%merge two lists sorted by a function
mergelists(L1, L2) ->
	mergelists(L1, L2, fun(A, B) -> A<B end).
mergelists(L1, L2, Function) ->
	mergelists(L1, L2, Function, []).
mergelists([], [], _, Out) ->
	lists:reverse(Out);
mergelists([], [B | Bs], F, Out) ->
	mergelists([], Bs, F, [B | Out]);
mergelists([A | As], [], F, Out) ->
	mergelists(As, [], F, [A | Out]);
mergelists([A | As], [B | Bs], F, Out) ->
	case F(A, B) of
		true -> mergelists(As, [B | Bs], F, [A | Out]);
		false -> mergelists([A | As], Bs, F, [B | Out])
	end.

split(List) ->
	split(List, length(List) div 2).
split(Out, 0) ->
	Out;
split([_ | Ls], Length) ->
	split(Ls, Length -1).

mergesort(List) ->
	put(count, 0),
	mergesort(List, fun(A, B) -> put(count, get(count) + 1), A<B end).
mergesort([], Fun) ->
	[];
mergesort([A], Fun) ->
	[A];
mergesort(List, Fun) ->
	mergelists(mergesort(split(List), Fun), mergesort(lists:reverse(split(lists:reverse(List))), Fun), Fun).



quicksort([]) ->
	[];
quicksort([A]) ->
	[A];
quicksort(List) ->
	[A | [B | _]] = quicksort2(List),
	quicksort(A) ++ quicksort(B).
quicksort2([]) ->
	[[], []];
quicksort2([A]) ->
	[[A], []];
quicksort2([A, B]) when A < B ->
	[[A], [B]];
quicksort2([A, B]) ->
	[[B], [A]];
quicksort2([Pivot | Rest]) ->
	quicksort2(Pivot, Rest, [] ,[]).
quicksort2(P, [L | Ls], Out1, Out2) when L < P ->
	quicksort2(P, Ls, [L | Out1], Out2);
quicksort2(P, [L | Ls], Out1, Out2) ->
	quicksort2(P, Ls, Out1, [L | Out2]);
quicksort2(P, [], Out1, Out2) ->
  	[Out1, [P | Out2]].
	













				
				
				