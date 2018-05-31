\documentclass{article}

%include lhs2TeX.fmt
%include lhs2TeX.sty

%format -> = "\rightarrow"


\usepackage{cite}

\author{Juan Garc\'ia Garland}
\title{Reimplementación de \emph{AspectAG} basada en nuevas
       extensiones de Haskell
}

\setlength\parindent{0pt} % noindent in all file
\usepackage{geometry}
\geometry{margin=1.3in}



\begin{document}

\maketitle
\date

\newpage
\tableofcontents{}

\newpage


\section{Intro}
\section{\emph{Type Level Programming}}
\subsection{Antes ({\tt MultiparamTypeClasses, FunctionalDependencies})}

%include ./src/Old.lhs

\subsection{Ahora ({\tt TypeFamilies, DataKinds, GADTs ...})}

\section{AspectAG}
\subsection{Gram\'aticas de atributos} 
\subsection{algunas construcciones en AspectAG}
\subsection{Ejemplo: {\tt repmin}}

\section{Reimplementación de AAG}
\subsection{Listas Heterogeneas Fuertemente tipadas}
\subsection{\emph{Records} heterogeneos Fuertemente Tipados}
\subsection{Implementaci\'on}


\section{Comparaci\'on}



\newpage

\bibliography{bib}{}
\bibliographystyle{plain}


\end{document}
