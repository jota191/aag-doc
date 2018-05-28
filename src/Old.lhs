
%if False

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FunctionalDependencies #-}
> {-# LANGUAGE UndecidableInstances #-}

%endif 

\subsubsection{Typeclasses y Typeclasses Multiparametro}

Haskell posee un sistema de \emph{TypeClasses} originalmente pensado para
proveer polimorfismo ad-hoc
~\cite{Hall:1996:TCH:227699.227700}.
Una interpretaci\'on usual es que una \emph{Typeclass}
funciona como un predicado sobre tipos.
Con la existencia de la extensi\'on  de GHC, {\tt MultiParamTypeclasses}
es posible programar type classes multiparametro. En realidad la
limitaci\'on original a clases monopar\'ametro es algo arbitraria.



\subsubsection{Dependencias Funcionales}

Una soluci\'on a un problema que surge
( cuando queremos typeclasses con tipos relacionados)
fu\'e tomada de las bases de datos relacionales
~\cite{DBLP:conf/esop/Jones00}
Tempranamente era sabido que el lenguaje a nivel de tipos es isomorfo
al lenguaje a nivel de valores, y las fundeps de forma
"a implies b" makes certain things able to resolve to a unique instance.

A fines del siglo pasado
~\cite{Hallgren00funwith}. blah blah 

-------------------------

\subsubsection{Ejemplo: Naturales a Nivel de tipos}

Considremos por ejemplo la siguiente implementaci\'on de los naturales
unarios, como tipo inductivo:

> data Nat = Zero
>          | Succ Nat

%if False

>          deriving Show

%endif

Notar que esta definici\'on introduce los constructores {\tt Zero::Nat}
y {\tt Succ::Nat -> Nat}


Podemos entonces construir t\'erminos de tipo {\tt Nat} de la forma

< n0 = Zero 
< n4 = Succ $ Succ $ Succ $ Zero 

O definir funciones de la siguiente manera:

> add :: Nat -> Nat -> Nat
> add n Zero     = n
> add n (Succ m) = Succ (add n m)

Consideramos la definici\'on a nivel de tipos:

> data Zero
> data Succ n

N\'otese que introduce constructores {\tt Zero::*} y {\tt Succ::*->*}
An\'alogamente podemos implementar la suma a nivel de tipos de la siguiente
manera:


> class Add m n smn | m n -> smn where
>   tAdd :: m -> n -> smn

> instance Add Zero m m
>   where tAdd = undefined

> instance Add n m k => Add (Succ n) m (Succ k)
>   where tAdd = undefined

Ahora el t\'ermino:

> u3 = tAdd (undefined :: Succ (Succ Zero))(undefined :: Succ Zero)

tiene tipo {\tt Succ (Succ (Succ Zero))}

\paragraph{Prolog vs TypeClasses}

\'Este tipo de programaci\'on se asemeja a la programaci\'on l\'ogica.

En Prolog[REF] escribir\'iamos:


< add(0,X,X) :-
<     nat(X).
< add(s(X),Y,s(Z)) :-
<     add(X,Y,Z).

Sin embargo, programar relaciones funcionales con Typeclasses difiere
respecto a programar en Prolog, dado que el type checker de GHC no realiza
backtracking al resolver una instancia. 

Cuando tenemos una sentencia de la forma:

< class (A x, B y) => C x y

y GHC debe probar {\tt C a b}, primero se matchea la \emph{cabeza}
{\tt C x y}, agregando las restricciones {\tt x \~ a, y ~\ b}, y
{\bf luego} tratando de satisfacer el contexto.

En particular no podemos decidir la pertenencia a una clase a partir de
la resoluci\'on de un contexto.
Esto sigue siendo relevante cuando programamos con las t\'ecniicas modernas
y existe una soluci\'on sistem\'atica que ilustraremos m\'as adelante [REF]

\paragraph{Clausura}

TODO

\subsubsection{Turing Completness}

Con estas t\'ecnicas se pueden realizar computaciones sofisticadas
en tiempo de compilaci\'on (como en ~\cite{parker:tlii}),
y puede demostrarse que de hecho, que el sistema de tipos con estas
extensiones tiene el poder de expresividad de un lenguaje Turing Completo,
lo cual queda demostrado al codificar, por ejemplo un calculo de
combinadores SKI ~\cite{OlegSKI}.


\subsubsection{M\'etodos Formales}

La mayor utilidad de estas t\'ecnicas no pasa por
realizar computaciones de prop\'osito general en nivel de tipos, sino por
codificar chequeos de propiedades que nuestro programa debe cuplir, como
se hace usualmente con lenguajes de tipos dependientes aunque con algunas
limitaciones, pero tambi\'en con algunas ventajas.

La propia biblioteca AspectAG ~\cite{Viera:2009:AGF:1596550.1596586} o
HList ~\cite{Kiselyov:2004:STH:1017472.1017488} (sobre la cual AspectAG hace
uso intensivo) son buenos ejemplos de la utilidad de \'este uso.

Para ejemplificar, consideremos un cl\'asico ejemplo de tipo de datos
dependiente: Las listas indizadas por su tama\~no.

> data Vec n a where
>   
