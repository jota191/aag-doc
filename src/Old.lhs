%if False

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FunctionalDependencies #-}
> {-# LANGUAGE UndecidableInstances #-}
> {-# LANGUAGE GADTs #-}


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

< class (A x, B x) => C x

y GHC debe probar {\tt C a}, primero se matchea la \emph{cabeza}
{\tt C x}, agregando las restricci\'on {\tt x \~ a}, y
{\bf luego} tratando de probar el contexto. Si se falla habr\'a un error
de compilaci\'on se abortar\'a.

En Prolog es v\'alido:

< c(X) :- a(X), b(X)
< c(X) :- d(X), e(X)

Si se trata de probar {\tt c(X)} y fallan {\tt a(X)} o {\tt b(X)},
el int\'erprete hace \emph{bactracking} y busca probar la alternativa.

En particular entonces no podemos decidir la implementaci\'on de los
m\'etdos(TODO usar termino correcto) de una clase a partir de la
resoluci\'on de un contexto u otro.
Esto sigue siendo relevante cuando programamos con las t\'ecniicas modernas
y existe una soluci\'on sistem\'atica que ilustraremos m\'as adelante [REF]

\subsubsection{Turing Completness}

Con estas t\'ecnicas se pueden realizar computaciones sofisticadas
en tiempo de compilaci\'on (como en ~\cite{parker:tlii}),
y puede demostrarse que de hecho, que el sistema de tipos con estas
extensiones tiene el poder de expresividad de un lenguaje Turing Completo,
lo cual queda demostrado al codificar, por ejemplo un calculo de
combinadores SKI ~\cite{OlegSKI}.


\subsection{Tipado a nivel de Tipos}

N\'otese que los constructores {\tt Zero} y {\tt Succ} tienen kinds
{\tt *} y {\tt * $\rightarrow$ *}.
Nada impide entonces construir instancias patol\'ogicas de tipos como
{\tt Succ Bool}, o {\tt Succ (Succ (Maybe Int))}.

El lenguaje a nivel de tipos es entonces escencialmente \emph{untyped}.

Una soluci\'on al problema de las instancias inv\'alidas es programar un
predicado (una nueva typeclass) que indique cuando un tipo representa un
natural a nivel de tipos, y requerirla como contexto cada vez que se
quiere asegurar que solo se puedan construir instancias v\'alidas, as\'i:

> class TNat a
> instance TNat Zero
> instance TNat n => TNat (Succ n)

Por ejemplo la funci\'on add entonces puede definirse como:

< class (TNat m, TNat n, TNat smn) => Add m n smn | m n -> smn where
<   tAdd :: m -> n -> smn

\subsubsection{Aplicaciones}

La mayor utilidad de estas t\'ecnicas no pasa por
realizar computaciones de prop\'osito general en nivel de tipos, sino por
codificar chequeos de propiedades que nuestro programa debe cumplir, como
se hace usualmente con lenguajes de tipos dependientes aunque con algunas
limitaciones, pero tambi\'en con algunas ventajas.

La propia biblioteca AspectAG ~\cite{Viera:2009:AGF:1596550.1596586} o
HList ~\cite{Kiselyov:2004:STH:1017472.1017488} (sobre la cual AspectAG hace
uso intensivo) son buenos ejemplos de la utilidad de \'este uso.

Para ejemplificar, consideremos un cl\'asico ejemplo de tipo de datos
dependiente: Las listas indizadas por su tama\~no.

\fbox{
[TODO] Esto requiere GADTs, GADTs se introduce en ghc 6.8.1
igual que FunctionalDependencies

Ademas el contexto requiere Datatypecontexts que se introduce en 7.0.1
(hay que decidir si lo usamos aca o no, no era estrictamente necesario
igual)
}

> {-TNat n => -}
> data Vec a n where
>   VZ :: Vec a Zero
>   VS :: a -> Vec a n -> Vec a (Succ n)

Ejemplos:

> safeHead :: (TNat n) =>  Vec a (Succ n) -> a
> safeHead (VS a _) = a


< <interactive>:3:10: error:
<     - Couldn't match type 'Zero' with 'Succ n0'
<       Expected type: Vec a (Succ n0)
<         Actual type: Vec a Zero
<     - In the first argument of 'safeHead', namely 'VZ'
<       In the expression: safeHead VZ
<       In an equation for 'it': it = safeHead VZ


TODO Ejemplo con HList?? para ver predicados sobre tipos
lista con todos los tipos distintos por ej



\section{Limitaciones}

TODO
