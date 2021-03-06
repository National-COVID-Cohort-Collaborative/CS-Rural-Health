`data-public/raw/` Directory
=========

Contents
-----------------

* **hospital.csv**:  One row per hospital, updated on the ArcGIS site Dec 2020.  Downloaded by [Jared Anzalone](https://github.com/jerrodanzalone) from <https://hifld-geoplatform.opendata.arcgis.com/datasets/geoplatform::hospitals/about>.

* **zipcode-zcta-2019.csv**:  One row per zcta (*i.e.*, the Census's version of a zipcode).  Downloaded by [Will Beasley](https://github.com/wibeasley) from <https://www.census.gov/programs-surveys/geography/technical-documentation/records-layout/gaz-record-layouts.html>

* **zipcode-zcta-2020.csv**:  One row per zcta (*i.e.*, the Census's version of a zipcode).  Downloaded by [Will Beasley](https://github.com/wibeasley) from <https://www.census.gov/programs-surveys/geography/technical-documentation/records-layout/gaz-record-layouts.html>

* **zipcode-zcta-2021.csv**:  One row per zcta (*i.e.*, the Census's version of a zipcode).  Downloaded by [Will Beasley](https://github.com/wibeasley) from <https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html>.  An alternative was found by  [Jared Anzalone](https://github.com/jerrodanzalone), with a slightly different file format.

Comments
-----------------


This directory should contain the raw, unmodified files that serve as an input to the project.  In theory the schema of these data files shouldn't change when new data arrive.  But of course this is frequently violated, so at minimum, our code should assert that the required columns are present, and contain reasonable values.  More thorough checking can be warranted.

For the sake of long-term reproducibility, these files are ideally in a nonproprietary format that is human readable.  Plain text files (*e.g.*, CSVs & XML) are preferred. Binary & proprietary formats (*e.g.*, Excel & SAS) may not be readable if certain software is missing from the user's computer; or they might be able to be read by only old versions of software (*e.g.*, Excel 97).

No PHI
---------

Files with PHI should **not** be stored in a GitHub repository, even a private GitHub repository.  We recommend using an enterprise database (such as MySQL or SQL Server) to store the data, and read & write the information to/from the software right before and after it's used.  If a database isn't feasible, consider storing the files in [`data-unshared/`](../../data-unshared/), whose contents are not committed to the repository; a line in [`.gitignore`](../../.gitignore) keeps the files uncommitted/unstaged.  However, there could be some information that is sensitive enough that it shouldn't even be stored locally without encryption (such as PHI).
