\name{fmri}
\alias{fmri}
\docType{data}
\title{fMRI - complete data set
} 
\description{Data (as a vector list) from an fMRI experiment in pain, listed  by location and stimulus.  The data are BOLD signals when a stimulus was applied for 32 seconds and then stopped for 32 seconds. The signal period is 64 seconds and the sampling rate was one observation every 2 seconds for 256 seconds (\eqn{n = 128}).  The number of subjects under each condition varies.
}


\details{The LOCATIONS of the brain where the signal was measured were [1] Cortex 1: Primary Somatosensory, Contralateral, [2] Cortex 2: Primary Somatosensory, Ipsilateral, [3] Cortex 3: Secondary Somatosensory, Contralateral, [4] Cortex 4: Secondary Somatosensory, Ipsilateral, [5] Caudate, [6] Thalamus 1: Contralateral, [7] Thalamus 2: Ipsilateral, [8] Cerebellum 1: Contralateral and [9] Cerebellum 2: Ipsilateral.

The TREATMENTS or stimuli (and number of subjects in each condition) are [1] Awake-Brush (5 subjects), [2] Awake-Heat (4 subjects), [3] Awake-Shock (5 subjects), [4] Low-Brush (3 subjects), [5] Low-Heat (5 subjects), and [6] Low-Shock (4 subjects). Issue the command \code{summary(fmri)} for further details.  In particular, awake (Awake) or mildly anesthetized (Low) subjects  were subjected  levels of periodic brushing (Brush), application of heat (Heat), and mild shock (Shock) effects.

As an example, \code{fmri$L1T6} (Location 1, Treatment 6) will show the data for the four subjects receiving the Low-Shock treatment at the Cortex 1 location; note that \code{fmri[[6]]} will display the same data.
}

\source{Joseph F. Antognini, Michael H. Buonocore, Elizabeth A. Disbrow, Earl Carstens,
Isoflurane anesthesia blunts cerebral responses to noxious and innocuous stimuli: a fMRI study,
Life Sciences, Volume 61, Issue 24, 1997, Pages PL349-PL354, ISSN 0024-3205, \cr
\kbd{https://doi.org/10.1016/S0024-3205(97)00960-0}.
}

\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\keyword{datasets}