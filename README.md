
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OntarioGeoHubR

An R package that will make it easy to fetch resources from Ontario
geohub and pull them into R for subsequent analysis and reporting.
Currently supported endpoints include:

- Fisheries Management Zones
- MNR Districts
- Conservation Authorities
- Waterbodies
- Provincial Parks
- Townships

More endpoints and improved filters can be added in the future.

The functions in the package do not perform any calculations, they
simply fetch the data from the specified endpoint and can be thought of
as a short cut for manually access geohub, downloading the resources and
reading the files in.

``` r
# ggplot2 isn't required, but used here for plotting.

library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 4.4.3

``` r
library(OntarioGeohubR)
```

# Fisheries Management Zones

Fisheries Management Zones are the main spatial unit used by the Ontario
Ministry of Natural Resource to manage fisheries resources across the
province.

the function `fetch_fmz()` can be used to retrieved one or more
fisheries management units and return them as a sf (simple feature)
which can then be used for plotting or subsequent analysis.

``` r
fmz <- fetch_fmz(10)
unique(fmz$FISHERIES_MANAGEMENT_ZONE_ID)
```

    ## [1] 10

``` r
fmz <- fetch_fmz(c(10, 11, 12))
unique(fmz$FISHERIES_MANAGEMENT_ZONE_ID)
```

    ## [1] 12 10 11

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = fmz, aes(fill = FISHERIES_MANAGEMENT_ZONE_ID))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/fmz-1.png"
alt="Simple map of Fisheries Management Zones 10,11, and 12." />
<figcaption aria-hidden="true">Simple map of Fisheries Management Zones
10,11, and 12.</figcaption>
</figure>

# MNR Districts

MNR Districts divide the Regions of the province into smaller
organizational units for the purpose of managing Ministry programs and
resources at a district level.

The function `fetch_mnr_district()` can be used to retrieved one or more
districts that match a string (or vector of strings).

``` r
dist <- fetch_mnr_district(name_like = "Aurora")
unique(dist$DISTRICT_NAME)
```

    ## [1] "Aurora Midhurst Owen Sound District"

``` r
dist <- fetch_mnr_district(name_like = c("Aurora", "Guelph"))
unique(dist$DISTRICT_NAME)
```

    ## [1] "Aurora Midhurst Owen Sound District" "Aylmer Guelph District"

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = dist, aes(fill = DISTRICT_NAME))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/district-1.png"
alt="Simple map of Aurora and Guelph Districts." />
<figcaption aria-hidden="true">Simple map of Aurora and Guelph
Districts.</figcaption>
</figure>

# Conservation Authorities

The function `fetch_conservation_authority()` accesses the geohub
endpoint for conservation authority administrative areas and returns
geometries that represent lands under the jurisdiction of a Conservation
Authority. The function `fetch_conservation_authority()` can be given a
string or a vector of strings and will return conservation area
object(s) with names that match.

``` r
ca <- fetch_conservation_authority(name_like = "Saugeen")
unique(ca$COMMON_NAME)
```

    ## [1] "Saugeen Conservation"

``` r
ca <- fetch_conservation_authority(name_like = c("Saugeen", "Maitland"))
unique(ca$COMMON_NAME)
```

    ## [1] "Maitland Valley Conservation Authority"
    ## [2] "Saugeen Conservation"

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = ca, aes(fill = COMMON_NAME))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/conservation_authority-1.png"
alt="Simple map of Saugeen and Maitland Con. Auth." />
<figcaption aria-hidden="true">Simple map of Saugeen and Maitland Con.
Auth.</figcaption>
</figure>

# Waterbodies

The function `fetch_waterbody()` accesses the geohub endpoint ‘Ontario
waterbody location identifier’ which represents unique Ontario waterbody
location identification information. The function `fetch_waterbody()`
can be used to retrieve waterbodies by Waterbody Identifier or partial
matches to various name fields.

``` r
wby <- fetch_waterbody(name_like = "Lake of the")
print(
  wby[
    ,
    c(
      "WATERBODY_IDENT",
      "OFFICIAL_NAME",
      "WATERBODY_IDENT",
      "UNOFFICIAL_NAME",
      "OFFICIAL_ALTERNATE_NAME",
      "EQUIVALENT_FRENCH_NAME"
    )
  ]
)
```

    ## Simple feature collection with 7 features and 6 fields
    ## Geometry type: GEOMETRY
    ## Dimension:     XY
    ## Bounding box:  xmin: -95.07566 ymin: 44.34254 xmax: -75.94861 ymax: 49.77069
    ## Geodetic CRS:  WGS 84
    ##   WATERBODY_IDENT         OFFICIAL_NAME WATERBODY_IDENT.1 UNOFFICIAL_NAME
    ## 1   15-3911-54691      Lake of the Bays     15-3911-54691            <NA>
    ## 2   17-4463-51322 Lake of the Mountains     17-4463-51322            <NA>
    ## 3   18-3445-50161     Lake of the Hills     18-3445-50161            <NA>
    ## 4   17-4845-51050     Lake of the Woods     17-4845-51050            <NA>
    ## 5   18-3773-49580     Lake of the Hills     18-3773-49580            <NA>
    ## 6   18-4229-49091     Lake of the Isles     18-4229-49091            <NA>
    ## 7   15-3726-54565     Lake of the Woods     15-3726-54565            <NA>
    ##   OFFICIAL_ALTERNATE_NAME EQUIVALENT_FRENCH_NAME                       geometry
    ## 1                    <NA>       Lake of the Bays MULTIPOLYGON (((-94.50013 4...
    ## 2                    <NA>  Lake of the Mountains POLYGON ((-81.69381 46.3453...
    ## 3                    <NA>      Lake of the Hills POLYGON ((-76.97788 45.2868...
    ## 4                    <NA>      Lake of the Woods POLYGON ((-81.20571 46.1021...
    ## 5                    <NA>      Lake of the Hills POLYGON ((-76.552 44.76174,...
    ## 6                    <NA>      Lake of the Isles POLYGON ((-75.95064 44.3497...
    ## 7            lac des Bois                   <NA> POLYGON ((-95.07566 49.3717...

``` r
wby <- fetch_waterbody(name_like = c("Shanty Bay", "Begman"))

print(
  wby[
    ,
    c(
      "WATERBODY_IDENT",
      "OFFICIAL_NAME",
      "WATERBODY_IDENT",
      "UNOFFICIAL_NAME",
      "OFFICIAL_ALTERNATE_NAME",
      "EQUIVALENT_FRENCH_NAME"
    )
  ]
)
```

    ## Simple feature collection with 7 features and 6 fields
    ## Geometry type: GEOMETRY
    ## Dimension:     XY
    ## Bounding box:  xmin: -92.77238 ymin: 45.01518 xmax: -77.63065 ymax: 51.15783
    ## Geodetic CRS:  WGS 84
    ##   WATERBODY_IDENT          OFFICIAL_NAME WATERBODY_IDENT.1 UNOFFICIAL_NAME
    ## 1   17-5752-50666       Shanty Bay Lakes     17-5752-50666            <NA>
    ## 2   17-6195-49857             Shanty Bay     17-6195-49857            <NA>
    ## 3   17-5752-50668 Middle Shanty Bay Lake     17-5752-50668            <NA>
    ## 4   17-5752-50667             Shanty Bay     17-5752-50667            <NA>
    ## 5   17-5480-51138             Shanty Bay     17-5480-51138            <NA>
    ## 6   15-5163-56645             Shanty Bay     15-5163-56645            <NA>
    ## 7   18-2949-50620       Burnt Shanty Bay     18-2949-50620            <NA>
    ##   OFFICIAL_ALTERNATE_NAME EQUIVALENT_FRENCH_NAME                       geometry
    ## 1                    <NA> lacs de la baie Shanty MULTIPOLYGON (((-80.03624 4...
    ## 2                    <NA>            baie Shanty POLYGON ((-79.48439 45.0152...
    ## 3                    <NA>  lac Middle Shanty Bay POLYGON ((-80.02483 45.7531...
    ## 4                    <NA>            baie Shanty POLYGON ((-80.02659 45.7473...
    ## 5                    <NA>            baie Shanty POLYGON ((-80.37812 46.1778...
    ## 6                    <NA>            baie Shanty POLYGON ((-92.76747 51.1578...
    ## 7                    <NA>      baie Burnt Shanty POLYGON ((-77.63095 45.6869...

``` r
wby <- fetch_waterbody(wbylid = "15-3726-54565")
print(
  wby[
    ,
    c(
      "WATERBODY_IDENT",
      "OFFICIAL_NAME",
      "WATERBODY_IDENT",
      "UNOFFICIAL_NAME",
      "OFFICIAL_ALTERNATE_NAME",
      "EQUIVALENT_FRENCH_NAME"
    )
  ]
)
```

    ## Simple feature collection with 1 feature and 6 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -95.07566 ymin: 48.84562 xmax: -93.82818 ymax: 49.77069
    ## Geodetic CRS:  WGS 84
    ##   WATERBODY_IDENT     OFFICIAL_NAME WATERBODY_IDENT.1 UNOFFICIAL_NAME
    ## 1   15-3726-54565 Lake of the Woods     15-3726-54565            <NA>
    ##   OFFICIAL_ALTERNATE_NAME EQUIVALENT_FRENCH_NAME                       geometry
    ## 1            lac des Bois                   <NA> POLYGON ((-95.07566 49.3717...

``` r
# three lakes in close proximity to each other:
# "15-4877-53939" Rainy Lake
# "15-3726-54565" Lake of the woods
# "15-4390-54514" Kakagi Lake

wbylids <- c("15-4877-53939",
  "15-3726-54565",
  "15-4390-54514")

wby <- fetch_waterbody(wbylid = wbylids)
print(
  wby[
    ,
    c(
      "WATERBODY_IDENT",
      "OFFICIAL_NAME",
      "WATERBODY_IDENT",
      "UNOFFICIAL_NAME",
      "OFFICIAL_ALTERNATE_NAME",
      "EQUIVALENT_FRENCH_NAME"
    )
  ]
)
```

    ## Simple feature collection with 3 features and 6 fields
    ## Geometry type: GEOMETRY
    ## Dimension:     XY
    ## Bounding box:  xmin: -95.07566 ymin: 48.48244 xmax: -92.54676 ymax: 49.77069
    ## Geodetic CRS:  WGS 84
    ##   WATERBODY_IDENT     OFFICIAL_NAME WATERBODY_IDENT.1 UNOFFICIAL_NAME
    ## 1   15-4390-54514       Kakagi Lake     15-4390-54514            <NA>
    ## 2   15-4877-53939        Rainy Lake     15-4877-53939            <NA>
    ## 3   15-3726-54565 Lake of the Woods     15-3726-54565            <NA>
    ##   OFFICIAL_ALTERNATE_NAME EQUIVALENT_FRENCH_NAME                       geometry
    ## 1                    <NA>             lac Kakagi POLYGON ((-93.67178 49.2067...
    ## 2          lac à la Pluie                   <NA> MULTIPOLYGON (((-93.63527 4...
    ## 3            lac des Bois                   <NA> POLYGON ((-95.07566 49.3717...

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = wby, aes(fill = WATERBODY_IDENT))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/waterbody-1.png"
alt="Simple map of some selected waterbodies." />
<figcaption aria-hidden="true">Simple map of some selected
waterbodies.</figcaption>
</figure>

# Provincial Parks

Areas regulated under the provincial Parks Act (2006) can be retrieved
using the function `fetch_provincial_parks()`. This function can be
given a string or a vector of strings and will return parks with names
that match those strings

``` r
ppark <- fetch_provincial_park(name_like = "Algonquin")
unique(ppark$COMMON_SHORT_NAME)
```

    ## [1] "ALGONQUIN"

``` r
ppark <- fetch_provincial_park(name_like = c("MacGregor", "Inverhuron"))
unique(ppark$COMMON_SHORT_NAME)
```

    ## [1] "MACGREGOR POINT  " "INVERHURON  "

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = ppark, aes(fill = COMMON_SHORT_NAME))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/parks-1.png"
alt="Simple map of some selected provincial parks." />
<figcaption aria-hidden="true">Simple map of some selected provincial
parks.</figcaption>
</figure>

# Townships

Townships are the fundamental land subdivision for the province of
Ontario. The function `fetch_township()` can be given a string or a
vector of strings and will return township object with names that match.

``` r
twnshp <- fetch_township(name_like = "Saugeen")
unique(twnshp$OFFICIAL_NAME)
```

    ## [1] "SAUGEEN"

``` r
twnshp <- fetch_township(name_like = c("Saugeen", "Bruce"))
unique(twnshp$OFFICIAL_NAME)
```

    ## [1] "BRUCE"   "SAUGEEN"

``` r
my_plot <- ggplot2::ggplot() +
  ggplot2::geom_sf(data = twnshp, aes(fill = OFFICIAL_NAME))
print(my_plot)
```

<figure>
<img src="Readme_files/figure-gfm/townships-1.png"
alt="Simple map of some selected townships." />
<figcaption aria-hidden="true">Simple map of some selected
townships.</figcaption>
</figure>
