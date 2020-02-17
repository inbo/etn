# ETN <img src="man/figures/logo.png" align="right" alt="" width="120">

<!-- badges: start -->
[![Funding](https://img.shields.io/static/v1?label=powered+by&message=lifewatch.be&labelColor=1a4e8a&color=f15922)](http://lifewatch.be)
<!-- badges: end -->

This package provides functionality to access and process data from the [European Tracking Network (ETN)](http://www.lifewatch.be/etn/) database hosted by the Flanders Marine Institute (VLIZ) as part of the Flemish contribution to LifeWatch. ETN data is subject to the [ETN data policy](http://www.lifewatch.be/etn/assets/docs/ETN-DataPolicy.pdf) and can be:
 
- restricted: under moratorium and only accessible to logged-in data owners/collaborators
- unrestricted: publicly accessible without login and routinely published to international biodiversity facilities
 
The ETN infrastructure currently requires the package to be run within the [LifeWatch.be RStudio server](http://rstudio.lifewatch.be/), which is password protected. A login can be requested at http://www.lifewatch.be/etn/contact.

## Installation

You can install this package from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("inbo/etn")
```

And then load with:

```r
library(etn)
```

## Contributors

[List of contributors](https://github.com/inbo/etn/contributors)

## License

[MIT License](LICENSE)
