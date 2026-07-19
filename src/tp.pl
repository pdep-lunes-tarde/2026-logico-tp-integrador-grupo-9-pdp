//Base de conocimiento//
//Punto 1//
//Parte a//

% habitante(Nombre, Pueblo, AnioNacimiento, Raza).

habitante(denken, auberst, 1290, humano).
habitante(voll, ende, 1200, enano).
habitante(serie, weise, 500, elfo).
habitante(fern, weise, 1370, humano).
habitante(stark, riegel, 1368, humano).
habitante(lawine, auberst, 1372, humano).
habitante(kanne, weise, 1365, humano).
habitante(wirbel, klares, 1350, humano).
habitante(lernen, auberst, 1315, humano).
habitante(frieren, weise, 100, elfo).
habitante(eisen, riegel, 1150, enano).

//Parte b//

% muerte(Persona, Anio) 
muerte(Persona, Anio) :-
    habitante(Persona, _, AnioNacimiento, Raza),
    Raza \= elfo,
    promedio_vida(Raza, Vida),
    Anio > AnioNacimiento + Vida.

% estaViva(Persona, Anio) 
estaViva(Persona, Anio) :-
    habitante(Persona, _, AnioNacimiento, _),
    AnioNacimiento =< Anio,
    not(muerte(Persona, Anio)).

% conocimiento(Persona, Hazaña, Anio, Medio)

% hazaña = hazaña(NombreHazaña, Protagonistas, Lugar)
% medio  = presencio | escucho_cancion | leyo_libro(CantidadPaginas)

//Punto 2//
//Parte a//

conocimiento(wirbel,
             hazaña(rescatar_hermana_de_wirbel, [stark, fern], klares),
             1390, presencio).

conocimiento(frieren,
             hazaña(rescatar_hermana_de_wirbel, [stark, fern], klares),
             1390, presencio).

conocimiento(lawine,
             hazaña(destruir_demonio_aura, [frieren], weise),
             1393, escucho_cancion).

conocimiento(voll,
             hazaña(destruir_demonio_aura, [denken], auberst),
             1400, leyo_libro(50)).

conocimiento(serie,
             hazaña(destruir_rey_demonio, [frieren, himmel, heiter, eisen], ende),
             1335, leyo_libro(100)).

conocimiento(kanne,
             hazaña(recuperar_gato_perdido, [himmel, frieren], weise),
             1375, presencio).

% recuerda(Persona, NombreHazaña, Anio)

recuerda(Persona, NombreHazaña, Anio) :-
    conocimiento(Persona, hazaña(NombreHazaña, _, _), AnioConocimiento, Medio),
    AnioConocimiento =< Anio,
    estaViva(Persona, Anio),
    dentro_de_duracion(Medio, AnioConocimiento, Anio).


dentro_de_duracion(presencio, _, _).

dentro_de_duracion(escucho_cancion, AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + 15.

dentro_de_duracion(leyo_libro(Paginas), AnioConocimiento, Anio) :-
    Anio =< AnioConocimiento + Paginas.



//Parte b//

% version(NombreHazaña, ProtagonistasOrdenados, Lugar)

version(NombreHazaña, ProtagonistasOrdenados, Lugar) :-
    conocimiento(_, hazaña(NombreHazaña, Protagonistas, Lugar), _, _),
    msort(Protagonistas, ProtagonistasOrdenados).

% corroborada(NombreHazaña)

corroborada(NombreHazaña) :-
    version(NombreHazaña, ProtagonistasRef, LugarRef),
    forall(version(NombreHazaña, Protagonistas, Lugar),
           (Protagonistas == ProtagonistasRef, Lugar == LugarRef)).
           
//Parte c//

al_olvido(NombreHazaña, Anio) :-
    conocimiento(_, hazaña(NombreHazaña, _, _), _, _),  % la hazaña existe
    not(recuerda(_, NombreHazaña, Anio)).

:- begin_tests(tpIntegrador, []).

:- end_tests(tpIntegrador).
