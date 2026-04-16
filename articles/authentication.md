# Configure credentials

etn functions require credentials (username and password) to connect to
the ETN database.

## Where do you find your credentials?

1.  Go to the [ETN Data Platform](https://www.lifewatch.be/etn/).
2.  Log in with your MarinePass account.
3.  In the top right, click your name, then choose `ETN R access`.
4.  See your credentials to connect to the ETN database.

Use these for the next section “Store your credentials”. Note that the
password is different than the one for your MarinePass account.

## Store your credentials

By default, all functions will ask you for your credentials. Very
tedious! You can avoid this by storing them in a local `.Renviron` file.
etn will use those rather than asking every time.

1.  Open your `.Renviron` file with:

    ``` r
    # install.packages("usethis")
    usethis::edit_r_environ()
    ```

2.  Add the following lines to the file and save:

    ``` bash
    ETN_USER = "your email address"
    ETN_PWD = "your password"
    ```

3.  Restart R.

4.  Try:

    ``` r
    library(etn)
    get_animal_projects() # This should return a data frame
    ```

## Forgot your credentials?

Forgot the credentials to your MarinePass account? Use the [password
reset
form](https://rstudio.europeantrackingnetwork.org/account.php?p=lostpass).

Forgot the credentials to connect to the ETN database? See the section
above “Where do you find your credentials?”.

## Don’t have an account to ETN?

1.  [Register for a MarinePass
    account](https://rstudio.europeantrackingnetwork.org/account.php?p=register).
    It grants you access to several services at VLIZ: the [Marine Data
    Archive](https://mda.vliz.be/) and [the ETN Data
    Platform](https://www.lifewatch.be/etn/). You can request additional
    access to the [ETN RStudio
    server](https://rstudio.europeantrackingnetwork.org).
2.  Select access to `ETN_data` and (optional) `rstudio_etn`.
3.  Confirm registration via email.
4.  Wait for an email indicating that your account was approved by a
    human.
