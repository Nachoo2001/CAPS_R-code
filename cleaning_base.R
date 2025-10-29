
### ============= Mise en forme de la base de données ELIPSS =============================

# Packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(janitor)
library(here)



# ---- First we load and clean the codebook (to be able to rename variables more easily) ------ # 

codebook <- read_delim(
  file   = here("Données", "caps_CB.csv"), # adjust name
  delim  = ";",
  quote  = "\"",
  escape_double = TRUE,
  locale = locale(encoding = "UTF-8"),
  trim_ws = FALSE,
  show_col_types = FALSE,
  col_names = TRUE       
)

 
## Données

dat <- read_delim(
  file   = here("Données", "caps_postprod_260925_115149.csv"),
  delim  = ";",
  locale = locale(encoding = "UTF-8"),
  show_col_types = FALSE,
  col_names = TRUE        # <- use TRUE or omit (TRUE is the default)
)


# ====== PLAN DE RENOMMAGE (à éditer à GAUCHE uniquement) ======

rename_map <- c(
  # --- Identifiant & données techniques ---
  Identifiant                = "UID_caps",
  device             = "caps_Device",
  version            = "caps_Version",
  slider_order       = "caps_SliderOrder",
  slider_s1          = "caps_Slider_S1",
  slider_s2          = "caps_Slider_S2",
  slider_s3          = "caps_Slider_S3",
  slider_s4          = "caps_Slider_S4",
  slider_s5          = "caps_Slider_S5",
  Treated             = "caps_ALEA_C",
  
  # ========= Variables expé ==========#
  ILLNESS              = "caps_QC01A",
  has_child              = "caps_QC02A",
  USECHILDCARE               = "caps_QC02",
  CHILDCAREOP            = "caps_QC03",
  GOVELDER               = "caps_QC04A",
  GOVUNEMP                  = "caps_QC04B",
  GOVDAYCARE               = "caps_QC04C",
  GOVCHILD              = "caps_QC04D",
  GOVIMMIG              = "caps_QC04E",
  CONTROLMIG             = "caps_QC05_1",
  CONTROLMIG2             = "caps_QC05_2",
  POLFAM_transfer              = "caps_QC06A",
  POLFAM_transfer_poor              = "caps_QC06B",
  POLFAM_daycare              = "caps_QC06C",
  POLFAM_daycare_poor              = "caps_QC06D",
  MISPERCEPTION               = "caps_QC07",
  CASHDISAB_pre              = "caps_QC08_1",
  CASHUENUMP_pre             = "caps_QC08_2",
  CASHELD_pre              = "caps_QC08_3",
  CASHIMMIG_pre              = "caps_QC08_4",
  CASHCHILD_pre             = "caps_QC08_5",
  # ----- Bloc Activation vs Compensation ------ #
  POLDISABLED_pre               = "caps_QC09A",
  POLUNEMP_pre               = "caps_QC09B",
  POLMONO_pre               = "caps_QC09C",
  POLPOOR_pre               = "caps_QC09D",
  UNEMPCONCEPT_pre              = "caps_QC09E",
  # ----- Austerity Treatment -----------#
  CASHDISAB_post             = "caps_QC08B_1",
  CASHUENUMP_post             = "caps_QC08B_2",
  CASHELD_post            = "caps_QC08B_3",
  CASHIMMIG_post             = "caps_QC08B_4",
  CASHCHILD_post             = "caps_QC08B_5",
  POLDISABLED_post             = "caps_QC09A_2",
  POLUNEMP_post             = "caps_QC09B_2",
  POLMONO_post             = "caps_QC09C_2",
  POLPOOR_post             = "caps_QC09D_2",
  UNEMPCONCEPT_post            = "caps_QC09E_2",
  
  # --- Choix/derive autour des QC09  ---
  choix_qc09a        = "caps_Choix_QC09A",
  choix_qc09b        = "caps_Choix_QC09B",
  choix_qc09c        = "caps_Choix_QC09C",
  choix_qc09d        = "caps_Choix_QC09D",
  choix_qc09e        = "caps_Choix_QC09E",
  choix_qc09a_2      = "caps_Choix_QC09A_2",
  choix_qc09b_2      = "caps_Choix_QC09B_2",
  choix_qc09c_2      = "caps_Choix_QC09C_2",
  choix_qc09d_2      = "caps_Choix_QC09D_2",
  choix_qc09e_2      = "caps_Choix_QC09E_2",
  
  # --- Ordre des variables shiftées aléatoirmeent (dans le questionnaire) ---
  GOVIMMIG_order      = "caps_QC04_DO_QC04E",
  GOVCHILD_order      = "caps_QC04_DO_QC04D",
  GOVCHILDCARE_order     = "caps_QC04_DO_QC04C",
  GOVUNEMP_order      = "caps_QC04_DO_QC04B",
  GOVELDER_order      = "caps_QC04_DO_QC04A",
  qc04_do_transition = "caps_QC04_DO_transition",
  CONTROLMIG_order     = "caps_QC05_DO_QC05_1",
  CONTROLMIG2_order     = "caps_QC05_DO_QC05_2",
  qc06_do_transition = "caps_QC06_DO_transition",
  POLFAM_daycare_poor_order      = "caps_caps_QC06_DO_QC06D",
  POLFAM_daycare_order      = "caps_QC06_DO_QC06C",
  POLFAM_transfer_poor_order      = "caps_QC06_DO_QC06B",
  POLFAM_transfer_order      = "caps_QC06_DO_QC06A",
  
  # --- Conclu ---
  LIKED_survey            = "caps_ccl_q01",
  DIFFICULT_survey            = "caps_ccl_q02",
  QUESTION_survey            = "caps_ccl_q03",
  REMARKS_survey            = "caps_ccl_q04",
  INTERESTING_survey          = "caps_ccl_q05_1",
  IMPORTANT_survey          = "caps_ccl_q05_2",
  LONG_survey          = "caps_ccl_q05_3",
  TOOPERSONAL_survey          = "caps_ccl_q05_4",
  ORIGINAL_survey          = "caps_ccl_q05_5",
  REPETITIVE_survey          = "caps_ccl_q05_6",
  
  # --- Socio-démo ELIPSS  ---
  age                = "cal_AGE",
  education          = "cal_DIPL",
  sexe                = "cal_SEXE",
  tuu                = "cal_TUU",     
  region               = "cal_ZEAT",    
  
  # --- Pondérations ---
  pdsplt_init        = "PDSPLT_INIT",
  poids_init         = "POIDS_INIT",
  panel              = "panel",
  poids_caps         = "POIDS_caps",
  pdsplt_caps        = "PDSPLT_caps",
  
  # --- Socio-démo ELIPSS ---
  is_french        = "eayy_a3_rec",
  marital_status        = "eayy_a4_rev",
  live_together            = "eayy_a5",
  old_couple       = "eayy_a5c_rec",
  pro_status        = "eayy_b1_rev",
  job_seeking          = "eayy_b10a",
  has_worked           = "eayy_b11",
  partner_has_worked        = "eayy_b11cjt",
  diploma       = "eayy_b18_rec",
  diploma_rec          = "eayy_b18c",
  partner_diploma_rec       = "eayy_b18ccjt",
  partner_diploma    = "eayy_b18cjt_rec",
  is_working           = "eayy_b1b",
  partner_is_working        = "eayy_b1bcjt",
  partner_situation     = "eayy_b1cjt_rev",
  job_status    = "eayy_b2_11a_rec",
  partner_job_status = "eayy_b2_11acjt_rec",
  is_manager       = "eayy_b25_rec",
  partner_is_manager    = "eayy_b25cjt_rec",
  job_contract            = "eayy_b5",
  full_time_job       = "eayy_b5a_rec",
  partner_full_time        = "eayy_b5acjt",
  job_seniority       = "eayy_b5d_rec",
  socioprofessional_cat   = "eayy_b6a_12a_rec",
  current_job_cat   = "eayy_b6b_12b_rec",
  job_type       = "eayy_b7b_rec",
  company_size        = "eayy_b8_rec",
  partner_company_size     = "eayy_b8cjt_rec",
  household_size        = "eayy_c1_rec",
  young_in_household         = "eayy_c1jeu",
  adopted_yes            = "eayy_c8",
  number_adopted       = "eayy_c8a_rec",
  adopted_in_household       = "eayy_c8b_rec",
  house_status            = "eayy_d1",
  house_owner        = "eayy_d2_rev",
  house_type            = "eayy_d3",
  house_years_lived           = "eayy_d5a",
  house_neighborhood            = "eayy_d6",
  problems_neighborhood    = "eayy_d7_rev_som",
  receives_salary           = "eayy_e1a",
  receives_independant           = "eayy_e1b",
  receives_unemployed_allowance           = "eayy_e1c",
  receives_pension           = "eayy_e1d",
  receives_disability_aid           = "eayy_e1e",
  receives_family_allowances          = "eayy_e1f1",
  receives_grant          = "eayy_e1f2",
  receives_housing_aid           = "eayy_e1g",
  receives_RSA           = "eayy_e1h",
  receives_rent           = "eayy_e1i",
  receives_family_aid           = "eayy_e1j",
  income      = "eayy_e2a_rec2",
  income_per_unityC       = "eayy_e2auc2",
  income_info_source = "eayy_e2auc_source2",
  has_financial_invest        = "eayy_e3_som",
  second_housing            = "eayy_e4",
  financial_situation            = "eayy_e5",
  has_debt            = "eayy_e6",
  happiness        = "eayy_f1_rev",
  friends_freq          = "eayy_f1a1",
  has_intimate_people        = "eayy_f3_rev",
  loneliness            = "eayy_f4",
  family_freq           = "eayy_f6a",
  member_asso        = "eayy_f7_som",
  member_labour_union         = "eayy_f7ter",
  trust            = "eayy_f9",
  TV_use          = "eayy_g1_1",
  TV_use_other          = "eayy_g1_2",
  cinema_use           = "eayy_g3a",
  theater_use           = "eayy_g3b",
  museum_use           = "eayy_g3c",
  sports_use           = "eayy_g3d",
  bilingual            = "eayy_g5",
  reason_no_vacation          = "eayy_g6_1",
  reason_vacation_region          = "eayy_g6_2",
  reason_vacation_other_region          = "eayy_g6_3",
  reason_vacation_abroad          = "eayy_g6_4",
  house_tasks            = "eayy_g7",
  in_charge_house_tasks           = "eayy_g8a",
  partner_in_charge_house_tasks           = "eayy_g8b",
  other_in_charge_house_tasks           = "eayy_g8c",
  religious         = "eayy_h_c11",
  religious_importance        = "eayy_h_teo1",
  pray_freq        = "eayy_h5_rev",
  politics            = "eayy_i1",
  french_demo            = "eayy_i2",
  right_left            = "eayy_i8",
  voted_first_term    = "eayy_i11_rev_22",
  who_first_term       = "eayy_i11a_22",
  voted_second_term    = "eayy_i12_rev_22",
  who_second_term       = "eayy_i12a_22",
  health            = "eayy_j1",
  height        = "eayy_k1_rec",
  weight        = "eayy_k2_rec",
  sports_freq            = "eayy_k3",
  sociopro_cat_29    = "eayy_pcs29_2020",
  sociopro_cat_18    = "eayy_pcs18_2020",
  sociopro_cat_6     = "eayy_pcs6_2020",
  partner_sociopro_cat  = "eayy_pcs6cjt_2020",
  household_type       = "eayy_typmen5",
  wave         = "eayy_vague"
)

# Check 
map_tbl <- tibble(
  new  = names(rename_map),
  old  = unname(rename_map)
)

# Dataset with variables renamed
data <- dat %>%
  rename(!!!rename_map) %>%
  select(all_of(names(rename_map)))



# ================== Recodage des variables expérimentales ====================== #














