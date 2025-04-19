-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema routerdatabase
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema routerdatabase
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `routerdatabase` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `routerdatabase` ;

-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_endereco` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `LOGRADOURO` VARCHAR(45) NOT NULL,
  `NUMERO` VARCHAR(45) NOT NULL,
  `BAIRRO` VARCHAR(45) NOT NULL,
  `CIDADE` VARCHAR(45) NOT NULL,
  `ESTADO` VARCHAR(45) NOT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DOS ENDEREÇOS';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_tipopessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_tipopessoa` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DESCRICAO` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DOS TIPOS DE PESSOA';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_pessoafisica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_pessoafisica` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` CHAR(5) NOT NULL,
  `NOME` VARCHAR(100) NOT NULL,
  `CPF` CHAR(11) NULL DEFAULT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1',
  `IDTIPOPESSOA` INT NOT NULL,
  PRIMARY KEY (`ID`, `IDTIPOPESSOA`),
  INDEX `fk_rta_pessoafisica_rta_tipopessoa1_idx` (`IDTIPOPESSOA` ASC) VISIBLE,
  CONSTRAINT `fk_rta_pessoafisica_rta_tipopessoa1`
    FOREIGN KEY (`IDTIPOPESSOA`)
    REFERENCES `routerdatabase`.`rta_tipopessoa` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DE PESSOAS FÍSICAS';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_pessoajuridica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_pessoajuridica` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` CHAR(5) NOT NULL,
  `NOME` VARCHAR(200) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1',
  `IDTIPOPESSOA` INT NOT NULL,
  `IDENDERECO` INT NOT NULL,
  PRIMARY KEY (`ID`, `IDTIPOPESSOA`, `IDENDERECO`),
  INDEX `fk_rta_pessoajuridica_rta_tipopessoa1_idx` (`IDTIPOPESSOA` ASC) VISIBLE,
  INDEX `fk_rta_pessoajuridica_rta_endereco1_idx` (`IDENDERECO` ASC) VISIBLE,
  CONSTRAINT `fk_rta_pessoajuridica_rta_tipopessoa1`
    FOREIGN KEY (`IDTIPOPESSOA`)
    REFERENCES `routerdatabase`.`rta_tipopessoa` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rta_pessoajuridica_rta_endereco1`
    FOREIGN KEY (`IDENDERECO`)
    REFERENCES `routerdatabase`.`rta_endereco` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DAS PESSOAS JURÍDICAS';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_situacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_situacao` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NOME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'SITUAÇÃO DA ROTA';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_rota`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_rota` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` VARCHAR(45) NOT NULL,
  `DATACRIACAO` DATETIME NOT NULL,
  `DATAFECHAMENTO` DATETIME NULL DEFAULT NULL,
  `OBSERVACAO` VARCHAR(200) NULL DEFAULT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1' COMMENT 'COLUNA PARA VALIDAR SE A ROTA ESTÁ ATIVA OU NÃO.',
  `IDSITUACAO` INT NOT NULL,
  PRIMARY KEY (`ID`, `IDSITUACAO`),
  INDEX `fk_rta_rota_rta_situacao_idx` (`IDSITUACAO` ASC) VISIBLE,
  CONSTRAINT `fk_rta_rota_rta_situacao`
    FOREIGN KEY (`IDSITUACAO`)
    REFERENCES `routerdatabase`.`rta_situacao` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DAS ROTAS';


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_pessoajuridica_pessoafisica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_pessoajuridica_pessoafisica` (
  `IDPJ` INT NOT NULL,
  `IDPF` INT NOT NULL,
  PRIMARY KEY (`IDPJ`, `IDPF`),
  INDEX `fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoafisica_idx` (`IDPF` ASC) VISIBLE,
  INDEX `fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoajuridi_idx` (`IDPJ` ASC) VISIBLE,
  CONSTRAINT `fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoajuridica1`
    FOREIGN KEY (`IDPJ`)
    REFERENCES `routerdatabase`.`rta_pessoajuridica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoafisica1`
    FOREIGN KEY (`IDPF`)
    REFERENCES `routerdatabase`.`rta_pessoafisica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `routerdatabase`.`rta_rota_pessoajuridica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdatabase`.`rta_rota_pessoajuridica` (
  `IDROTA` INT NOT NULL,
  `IDPESSOAJURIDICA` INT NOT NULL,
  PRIMARY KEY (`IDROTA`, `IDPESSOAJURIDICA`),
  INDEX `fk_rta_rota_has_rta_pessoajuridica_rta_pessoajuridica1_idx` (`IDPESSOAJURIDICA` ASC) VISIBLE,
  INDEX `fk_rta_rota_has_rta_pessoajuridica_rta_rota1_idx` (`IDROTA` ASC) VISIBLE,
  CONSTRAINT `fk_rta_rota_has_rta_pessoajuridica_rta_rota1`
    FOREIGN KEY (`IDROTA`)
    REFERENCES `routerdatabase`.`rta_rota` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rta_rota_has_rta_pessoajuridica_rta_pessoajuridica1`
    FOREIGN KEY (`IDPESSOAJURIDICA`)
    REFERENCES `routerdatabase`.`rta_pessoajuridica` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
