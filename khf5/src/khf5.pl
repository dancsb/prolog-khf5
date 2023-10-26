% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak 
%                        ; e                 % kelet 
%                        ; s                 % dél   
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- pred iranylistak(parcMutató::in         % NM
%                     fák::in,               % Fs
%                     iránylisták::out)      % ILs
                                             
% :- pred sator_szukites(fák::in,            % Fs
%                        int::in,            % I
%                        iránylisták::in,    % ILs0
%                        iránylisták::out)   % ILs

get_directions(N-M, Fs, Fx-Fy, Dir) :-
    (Fy1p is Fy + 1, Fy1p =< M, nonmember(Fx-Fy1p, Fs) -> EDir = [e]; EDir = []),
    (Fx1n is Fx - 1, Fx1n >= 1, nonmember(Fx1n-Fy, Fs) -> append(EDir, [n], NDir); NDir = EDir),
    (Fx1p is Fx + 1, Fx1p =< N, nonmember(Fx1p-Fy, Fs) -> append(NDir, [s], SDir); SDir = NDir),
    (Fy1n is Fy - 1, Fy1n >= 1, nonmember(Fx-Fy1n, Fs) -> append(SDir, [w], WDir); WDir = SDir),
    Dir = WDir.

iranylistak_core(_, _, [], []).

iranylistak_core(N-M, Fs, [F | RestFs], [Dir | RestILs]) :-
    get_directions(N-M, Fs, F, Dir),
    iranylistak_core(N-M, Fs, RestFs, RestILs).

iranylistak(N-M, Fs, ILs) :-
    iranylistak_core(N-M, Fs, Fs, ILs),
    !.