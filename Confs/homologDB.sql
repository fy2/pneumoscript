SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `pathogen_fy2_test` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `pathogen_fy2_test` ;

-- -----------------------------------------------------
-- Table `hom_isolates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hom_isolates` ;

CREATE  TABLE IF NOT EXISTS `hom_isolates` (
  `id` INT(5) NOT NULL AUTO_INCREMENT ,
  `remarks` VARCHAR(200) NULL COMMENT 'isolates involved in a particular experiment' ,
  `sanger_id` VARCHAR(45) NULL ,
  `sanger_study_id` VARCHAR(45) NULL ,
  `species` VARCHAR(45) NULL ,
  `serotype` VARCHAR(45) NULL ,
  `site` VARCHAR(45) NULL ,
  `country_contact` VARCHAR(45) NULL ,
  `mta_agreement` VARCHAR(45) NULL ,
  `strain_id` VARCHAR(45) NULL ,
  `strain_id_sanger` VARCHAR(45) NULL ,
  `top_serotype` VARCHAR(45) NULL ,
  `top_serotype_perc` VARCHAR(25) NULL COMMENT 'for some reason, float and text is mixed in this column' ,
  `second_serotype` VARCHAR(45) NULL ,
  `second_serotype_perc` VARCHAR(25) NULL COMMENT 'for some reason, float and text is mixed in this column' ,
  `mlst` VARCHAR(45) NULL ,
  `analysis_status` VARCHAR(45) NULL ,
  `analysis_comment` VARCHAR(45) NULL ,
  `gender` VARCHAR(45) NULL COMMENT 'most of the columns are text/varchar as the import excel sheet was not filled in consistently with one type.' ,
  `age_in_years` TEXT NULL ,
  `age_in_months` TEXT NULL ,
  `body_source` VARCHAR(45) NULL ,
  `meningitis_outbreak_isolate` VARCHAR(45) NULL ,
  `hiv` VARCHAR(45) NULL ,
  `date_of_isolation` VARCHAR(20) NULL COMMENT 'yyyy-mm-dd' ,
  `context` VARCHAR(45) NULL COMMENT 'surveillance? hospital?' ,
  `country_of_origin` VARCHAR(45) NULL ,
  `region` VARCHAR(45) NULL ,
  `city` VARCHAR(45) NULL ,
  `hospital` VARCHAR(45) NULL ,
  `latitude` FLOAT NULL DEFAULT -1 ,
  `longitude` FLOAT NULL DEFAULT -1 ,
  `location_country` VARCHAR(45) NULL ,
  `location_city` VARCHAR(45) NULL ,
  `cd4_count` TEXT NULL ,
  `age_category` TEXT NULL ,
  `no` TEXT NULL ,
  `lab_no` TEXT NULL ,
  `country_st` TEXT NULL ,
  `country` TEXT NULL ,
  `date_received` TEXT NULL ,
  `culture_received` TEXT NULL ,
  `sa_st` TEXT NULL ,
  `sa_penz` TEXT NULL ,
  `sa_eryz` TEXT NULL ,
  `sa_cliz` TEXT NULL ,
  `sa_tetz` TEXT NULL ,
  `sa_chlz` TEXT NULL ,
  `sa_rifz` TEXT NULL ,
  `sa_optz` TEXT NULL ,
  `sa_penmic` TEXT NULL ,
  `sa_amomic` TEXT NULL ,
  `sa_furmic` TEXT NULL ,
  `sa_cromic` TEXT NULL ,
  `sa_taxmic` TEXT NULL ,
  `sa_mermic` TEXT NULL ,
  `sa_vanmic` TEXT NULL ,
  `sa_erymic` TEXT NULL ,
  `sa_telmic` TEXT NULL ,
  `sa_climic` TEXT NULL ,
  `sa_tetmic` TEXT NULL ,
  `sa_cotmic` TEXT NULL ,
  `sa_chlmic` TEXT NULL ,
  `sa_cipmic` TEXT NULL ,
  `sa_levmic` TEXT NULL ,
  `sa_rifmic` TEXT NULL ,
  `sa_linmic` TEXT NULL ,
  `sa_synmic` TEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hom_analysis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hom_analysis` ;

CREATE  TABLE IF NOT EXISTS `hom_analysis` (
  `id` INT(3) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  `date` DATETIME NULL COMMENT 'a single orthology with orthomcl analysis will constitute an experiment' ,
  `user` VARCHAR(45) NULL ,
  `remarks` VARCHAR(200) NULL ,
  `software_params` VARCHAR(200) NULL ,
  `software_versions` VARCHAR(200) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hom_features`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hom_features` ;

CREATE  TABLE IF NOT EXISTS `hom_features` (
  `id` INT(7) NOT NULL AUTO_INCREMENT COMMENT 'most the \'heavy\' columns to home_feature_contents table as this table can grow very large and querying could be slowed down by bigger columns.' ,
  `isolate_id` INT(5) NOT NULL ,
  `analysis_id` INT(3) NOT NULL ,
  `product` VARCHAR(80) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `analysis_fkey_idx` (`analysis_id` ASC) ,
  INDEX `isolate_fkey_idx` (`isolate_id` ASC) ,
  CONSTRAINT `isolate_fkey`
    FOREIGN KEY (`isolate_id` )
    REFERENCES `hom_isolates` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `analysis_fkey`
    FOREIGN KEY (`analysis_id` )
    REFERENCES `hom_analysis` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hom_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hom_groups` ;

CREATE  TABLE IF NOT EXISTS `hom_groups` (
  `id` INT(5) NOT NULL AUTO_INCREMENT ,
  `analysis_id` INT(3) NOT NULL ,
  `remarks` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `analysis_id_fkey_idx` (`analysis_id` ASC) ,
  CONSTRAINT `analysis_id_fkey`
    FOREIGN KEY (`analysis_id` )
    REFERENCES `hom_analysis` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hom_group_compositions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hom_group_compositions` ;

CREATE  TABLE IF NOT EXISTS `hom_group_compositions` (
  `feature_id` INT(7) NOT NULL ,
  `group_id` INT(5) NOT NULL ,
  INDEX `group_fkey_idx` (`group_id` ASC) ,
  INDEX `feature_fkey_idx` (`feature_id` ASC) ,
  CONSTRAINT `group_fkey`
    FOREIGN KEY (`group_id` )
    REFERENCES `hom_groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `feature_fkey`
    FOREIGN KEY (`feature_id` )
    REFERENCES `hom_features` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_feature_contents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `home_feature_contents` ;

CREATE  TABLE IF NOT EXISTS `home_feature_contents` (
  `feature_id` INT(7) NOT NULL ,
  `dna` TEXT NULL ,
  `translation` TEXT NULL ,
  `description` TEXT NULL ,
  PRIMARY KEY (`feature_id`) ,
  CONSTRAINT `feature_to_contents`
    FOREIGN KEY (`feature_id` )
    REFERENCES `hom_features` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `pathogen_fy2_test` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
