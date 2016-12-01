%% @author Quinn
%% @doc @todo Add description to test2.


-module(test2).
-include_lib("eunit/include/eunit.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([sort/1, testlistgen/1]).



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






				
				
				