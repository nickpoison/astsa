\name{upastsa}
\alias{upastsa}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Update astsa to the latest version.
}
\description{
Grabs the current version of astsa from GitHub
}
\usage{
upastsa()
}
\details{
Checks if 'devtools' is installed (installs if not there), then updates astsa to the most
recent version on GitHub. 
}
\references{
\url{http://www.stat.pitt.edu/stoffer/tsa4/
}
\author{
D.S. Stoffer
}
\note{
What does the A in CRAN stand for? The word \emph{asshole} is from the word \emph{arse}, which according to the Oxford English Dictionary has been in use since the 11th century to refer to the  buttocks of an animal. Starting roughly around 14th century it was used to refer to a person's buttocks.

Around 1500 the combined form 'arsehole' was first used in its literal form to refer to the anus. The metaphorical use that refers to the worst place in a region (e.g., "the asshole of the world") is first attested in print in 1865. Its use to refer to a despicable person is first record in 1933.

To the rest of the English speaking world, the word ass is still interpreted as donkey.
}
\examples{
## The function is currently defined as
function () 
{
    if (!"devtools" \%in\% installed.packages()[, 1]) 
        install.packages(devtools)
    devtools::install_github("nickpoison/astsa")
  }
}
\keyword{ utilities }% use one of  RShowDoc("KEYWORDS")

