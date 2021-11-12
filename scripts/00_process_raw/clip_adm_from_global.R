# ========================================================================================
# Project:  MAPSPAMC_ZMB
# Subject:  Script clip Malawi adm maps from global map
# Author:   Michiel van Dijk
# Contact:  michiel.vandijk@wur.nl
# ========================================================================================

# ========================================================================================
# SETUP ----------------------------------------------------------------------------------
# ========================================================================================

# Load pacman for p_load
if(!require(pacman)) install.packages("pacman")
library(pacman)

# Load key packages
p_load(here, tidyverse, readxl, stringr, scales, glue)

# Load additional packages
p_load(countrycode, sf)

# R options
options(scipen = 999)
options(digits = 4)


# ========================================================================================
# LOAD DATA ------------------------------------------------------------------------------
# ========================================================================================

adm_sel <- 2
glob_path <- file.path("C:/Users/dijk158/Dropbox/crop_map_global")
iso3c_sel <- "MWI"
country_sel <- countrycode(iso3c_sel, "iso3c", "country.name")
year_sel <- 2010

if(adm_sel == 1) adm0 <- st_read(file.path(glob_path, paste0("SPAM_2010/GAUL_GADM_SPAM/gg_SPAM_0/g2008_0.shp")))
if(adm_sel %in% c(1,2)) adm1 <- st_read(file.path(glob_path, paste0("SPAM_2010/GAUL_GADM_SPAM/gg_SPAM_1/g2008_1.shp")))
if(adm_sel %in% c(2)) adm2 <- st_read(file.path(glob_path, paste0("SPAM_2010/GAUL_GADM_SPAM/gg_SPAM_2/g2008_2.shp")))


# ========================================================================================
# PROCESS --------------------------------------------------------------------------------
# ========================================================================================

# Gaul adm1
if(adm_sel %in% c(0, 1,2)) {
  adm1_sel <- adm1 %>%
    filter(ADM0_NAME == country_sel)
  plot(adm1_sel$geometry)

  # Remove adms that are not relevant (e.g. lakes, etc).
  # Not relevant

  # Gaul adm0
  # union adm1 to account for possible unwanted areas
  adm0_sel <- adm1_sel %>%
    st_union()
  plot(adm0_sel)
}

# Gaul adm2
if(adm_sel %in% c(2)){
  adm2_sel <- adm2 %>%
    filter(ADM0_NAME == country_sel)
  plot(adm2_sel$geometry)

  # Remove adms that are not relevant (e.g. lakes, etc).
  # Not relevant
}

# ========================================================================================
# SAVE -----------------------------------------------------------------------------------
# ========================================================================================

adm_path <- glue("C:/Users/dijk158/OneDrive - Wageningen University & Research/data/mapspamc_db/adm/{iso3c_sel}")
dir.create(adm_path, recursive = T, showWarnings = F)

if(adm_sel %in% c(0,1,2)){
  saveRDS(adm0_sel, file.path(adm_path, paste0("adm0_", year_sel, "_", iso3c_sel, ".rds")))
  saveRDS(adm1_sel, file.path(adm_path, paste0("adm1_", year_sel, "_", iso3c_sel, ".rds")))
}

if(adm_sel %in% c(2)){
  saveRDS(adm2_sel, file.path(adm_path, paste0("adm2_", year_sel, "_", iso3c_sel, ".rds")))
}

# SELECT ADM------------------------------------------------------------------------------
if (adm_sel == 0) {
  adm <- adm0_sel
} else if (adm_sel == 1) {
  adm <- adm1_sel
} else {
  adm <- adm2_sel
}
plot(adm)


# SAVE ADM LIST --------------------------------------------------------------------------
# adm_list <- adm@data
#
# # Save
# temp_path <- file.path(iso3c_path, paste0("lists"))
# dir.create(temp_path, recursive = T, showWarnings = F)
#
# write_csv(adm_list, file.path(temp_path, paste0("gaul_gadm_spam_adm_list_", year_sel, "_", iso3c_sel, ".csv")))


# SAVE ADM MAPS ------------------------------------------------------------------------
# Save maps in .rds and shapefile format
saveRDS(adm, file.path(adm_path, paste0("adm_", year_sel, "_", iso3c_sel, ".rds")))
st_write(adm, file.path(adm_path, paste0("adm_", year_sel, "_", iso3c_sel, ".shp")))


### CLEAN UP
rm(adm1, adm2, adm_path, adm_list, adm, adm0_sel, adm1_sel, adm2_sel)

