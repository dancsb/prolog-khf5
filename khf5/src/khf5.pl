% :- type parcMutat� ==    int-int.          % egy parcella hely�t meghat�roz� eg�szsz�m-p�r
% :- type f�k ==           list(parcMutat�). % a f�k helyeit tartalmaz� lista
% :- type ir�ny    --->    n                 % �szak 
%                        ; e                 % kelet 
%                        ; s                 % d�l   
%                        ; w.                % nyugat
% :- type ir�nylista ==    list(irany).      % egy adott f�hoz rendelt s�tor
                                             % lehets�ges ir�nyait megad� lista
% :- type ir�nylist�k ==   list(ir�nylista). % az �sszes fa ir�nylist�ja

% :- pred iranylistak(parcMutat�::in         % NM
%                     f�k::in,               % Fs
%                     ir�nylist�k::out)      % ILs
                                             
% :- pred sator_szukites(f�k::in,            % Fs
%                        int::in,            % I
%                        ir�nylist�k::in,    % ILs0
%                        ir�nylist�k::out)   % ILs
