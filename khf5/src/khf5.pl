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
:- use_module(library(lists)).

get_tent(Fx-Fy, e, Tx-Ty) :- Fy1 is Fy + 1, Tx-Ty = Fx - Fy1.
get_tent(Fx-Fy, n, Tx-Ty) :- Fx1 is Fx - 1, Tx-Ty = Fx1 - Fy.
get_tent(Fx-Fy, s, Tx-Ty) :- Fx1 is Fx + 1, Tx-Ty = Fx1 - Fy.
get_tent(Fx-Fy, w, Tx-Ty) :- Fy1 is Fy - 1, Tx-Ty = Fx - Fy1.

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
    iranylistak_core(N-M, Fs, Fs, Dir),
    (nonmember([], Dir) -> ILs = Dir; ILs = []),
    !.

reevaluate_directions(Fx-Fy, Ix-Iy, PrevDir, Dir) :-
    (member(e, PrevDir), get_tent(Fx-Fy, e, Txe-Tye), Dxe is Ix - Txe, Dye is Iy - Tye, (abs(Dxe) > 1; abs(Dye) > 1) -> EDir = [e]; EDir = []),
    (member(n, PrevDir), get_tent(Fx-Fy, n, Txn-Tyn), Dxn is Ix - Txn, Dyn is Iy - Tyn, (abs(Dxn) > 1; abs(Dyn) > 1) -> append(EDir, [n], NDir); NDir = EDir),
    (member(s, PrevDir), get_tent(Fx-Fy, s, Txs-Tys), Dxs is Ix - Txs, Dys is Iy - Tys, (abs(Dxs) > 1; abs(Dys) > 1) -> append(NDir, [s], SDir); SDir = NDir),
    (member(w, PrevDir), get_tent(Fx-Fy, w, Txw-Tyw), Dxw is Ix - Txw, Dyw is Iy - Tyw, (abs(Dxw) > 1; abs(Dyw) > 1) -> append(SDir, [w], WDir); WDir = SDir),
    Dir = WDir.

sator_szukites_core([], _, _, [], []).

sator_szukites_core([F | RestFs], If, Ixy, [Dir | RestILs0], [NewDir | RestILs]) :-
    (If \= F -> reevaluate_directions(F, Ixy, Dir, NewDir); NewDir = Dir),
    sator_szukites_core(RestFs, If, Ixy, RestILs0, RestILs).

sator_szukites(Fs, I, ILs0, ILs) :-
    nth1(I, Fs, If),
    nth1(I, ILs0, Id),
    length(Id, Len),
    Len = 1,
    [IdH | _] = Id,
    get_tent(If, IdH, Ixy),
    sator_szukites_core(Fs, If, Ixy, ILs0, Dir),
    (nonmember([], Dir) -> ILs = Dir; ILs = []),
    !.