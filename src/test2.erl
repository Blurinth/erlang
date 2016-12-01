%% @author Quinn
%% @doc @todo Add description to test2.


-module(test2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([sortbig/1, sortsmall/1, sort/1]).



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

sort(List) ->
	sort(sortbig(List), 1).
sort({List, Swaps}, 1) when Swaps > 0->
	sort(sortbig(List), 2);
sort({List, Swaps}, 2) when Swaps > 0->
	sort(sortsmall(List), 1);
sort({List, 0}, _) ->
	List.

				
				
				
				
				
				
				
				
				