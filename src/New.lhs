%if False

> {-# LANGUAGE DataKinds            #-}
> {-# LANGUAGE FlexibleContexts     #-}
> {-# LANGUAGE GADTs                #-}
> {-# LANGUAGE KindSignatures       #-}
> {-# LANGUAGE PatternSynonyms      #-}
> {-# LANGUAGE Rank2Types           #-}
> {-# LANGUAGE ScopedTypeVariables  #-}
> {-# LANGUAGE TypeFamilies         #-}
> {-# LANGUAGE TypeOperators        #-}
> {-# LANGUAGE FlexibleInstances     #-}
> {-# LANGUAGE UndecidableInstances  #-}
> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE PolyKinds #-}


%endif




\subsubsection{TypeFamilies}

INTRO

Algunas definiciones posibles:




\subsubsection{DataKinds}
Con el desarrollo del concepto de datatype promotion
~\cite{Yorgey:2012:GHP:2103786.2103795}
es un importante salto de expresividad. En lugar de tener un sistema
de kinds en donde solamente se logra expresar la aridad de los tipos,
pueden \emph{promoverse} datatypes adecuados.

Con la extensi\'on {\tt -XDataKinds}, cada declaraci\'on de tipos como

> data Nat = Zero | Succ Nat

se duplica a nivel de Kinds.

Adem\'as de introducir los t\'erminos {\tt Zero} y {\tt Succ} de tipo
{\tt Nat}, y al propio tipo {\tt Nat } de kind {\tt *}, introduce
los TIPOS {\tt Zero} y {\tt Succ} de Kind {\tt Nat} (y al propio kind Nat).

El kind {\tt *} pasa entonces a ser el de los tipos habitados, y cada vez que
declaramos un tipo promovible se introducen tipos no habitados del nuevo kind.


En el ejemplo de la secci\'on anterior, el tipo {\tt Vec } ten\'ia kind
{\tt * $\rightarrow$ * $\rightarrow$ *} por lo que {\tt Vec Bool Char}
era un tipo v\'alido.
Con DataKinds podemos construir: (+KindSignatures para anotar)

> data Vec :: Nat -> * -> * where
>   VZ :: Vec Zero a
>   VS :: a -> Vec n a -> Vec (Succ n) a

\subsubsection{{\tt GHC.TypeLits}}

intro del modulo

Usando {\tt GHC.TypeLits} podemos escribir: (+TypeOperators)

< data Vec :: Nat -> * -> * where
<   VZ :: Vec 0 a
<   VS :: a -> Vec n a -> Vec (n+1) a

Podemos entonces implementar funciones seguras con estos tipos
"dependientes".

< data Proxy (n :: k) = Proxy --PolyKinds

> vHead :: Vec (Succ n) a -> a
> vHead (VS a _) = a

> vTail :: Vec (Succ n) a -> Vec n a
> vTail (VS _ as) = as

> vZipWith :: (a -> b -> c) -> Vec n a -> Vec n b -> Vec n c
> vZipWith _ VZ VZ = VZ
> vZipWith f (VS x xs) (VS y ys)
>   = VS (f x y)(vZipWith f xs ys)

COMENTAR TOTALIDAD, safety

MAS EJEMPLOS?

\subsubsection{Proxys y Singletons}




