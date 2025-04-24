-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema routerdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema routerdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `routerdb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema routerdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema routerdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `routerdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `routerdb` ;

-- -----------------------------------------------------
-- Table `routerdb`.`SITUACAO_SERVICO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`SITUACAO_SERVICO` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DESCRICAO` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `routerdb`.`FINALIDADE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`FINALIDADE` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DESCRICAO` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `routerdb`.`SITUACAO_ROTA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`SITUACAO_ROTA` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NOME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'SITUAÇÃO DA ROTA';


-- -----------------------------------------------------
-- Table `routerdb`.`ROTA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`ROTA` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` VARCHAR(45) NOT NULL,
  `DATACRIACAO` DATETIME NOT NULL,
  `DATAFECHAMENTO` DATETIME NULL DEFAULT NULL,
  `OBSERVACAO` VARCHAR(200) NULL DEFAULT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1' COMMENT 'COLUNA PARA VALIDAR SE A ROTA ESTÁ ATIVA OU NÃO.',
  `SITUACAO_ROTA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_ROTA_SITUACAO_ROTA1_idx` (`SITUACAO_ROTA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_ROTA_SITUACAO_ROTA1`
    FOREIGN KEY (`SITUACAO_ROTA_ID`)
    REFERENCES `routerdb`.`SITUACAO_ROTA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DAS ROTAS';


-- -----------------------------------------------------
-- Table `routerdb`.`ENDERECO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`ENDERECO` (
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
-- Table `routerdb`.`PESSOAJURIDICA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`PESSOAJURIDICA` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` CHAR(5) NOT NULL,
  `NOME` VARCHAR(200) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1',
  `IDENDERECO` INT NOT NULL,
  `TELEFONE` CHAR(12) NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_rta_pessoajuridica_rta_endereco1_idx` (`IDENDERECO` ASC) VISIBLE,
  CONSTRAINT `fk_rta_pessoajuridica_rta_endereco1`
    FOREIGN KEY (`IDENDERECO`)
    REFERENCES `routerdb`.`ENDERECO` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DAS PESSOAS JURÍDICAS';


-- -----------------------------------------------------
-- Table `routerdb`.`SERVICO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`SERVICO` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DATACRIACAO` DATETIME NULL,
  `DATAFECHAMENTO` DATETIME NULL,
  `SITUACAO_SERVICO_ID` INT NOT NULL,
  `FINALIDADE_ID` INT NOT NULL,
  `ROTA_ID` INT NOT NULL,
  `PESSOAJURIDICA_ID` INT NOT NULL,
  `OBSERVACAO` VARCHAR(255) NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_SERVICO_SITUACAO_SERVICO_idx` (`SITUACAO_SERVICO_ID` ASC) VISIBLE,
  INDEX `fk_SERVICO_FINALIDADE1_idx` (`FINALIDADE_ID` ASC) VISIBLE,
  INDEX `fk_SERVICO_ROTA1_idx` (`ROTA_ID` ASC) VISIBLE,
  INDEX `fk_SERVICO_PESSOAJURIDICA1_idx` (`PESSOAJURIDICA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_SERVICO_SITUACAO_SERVICO`
    FOREIGN KEY (`SITUACAO_SERVICO_ID`)
    REFERENCES `routerdb`.`SITUACAO_SERVICO` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SERVICO_FINALIDADE1`
    FOREIGN KEY (`FINALIDADE_ID`)
    REFERENCES `routerdb`.`FINALIDADE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SERVICO_ROTA1`
    FOREIGN KEY (`ROTA_ID`)
    REFERENCES `routerdb`.`ROTA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SERVICO_PESSOAJURIDICA1`
    FOREIGN KEY (`PESSOAJURIDICA_ID`)
    REFERENCES `routerdb`.`PESSOAJURIDICA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `routerdb` ;

-- -----------------------------------------------------
-- Table `routerdb`.`TIPOPESSOA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`TIPOPESSOA` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DESCRICAO` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DOS TIPOS DE PESSOA';


-- -----------------------------------------------------
-- Table `routerdb`.`PESSOAFISICA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`PESSOAFISICA` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `CODIGO` CHAR(5) NOT NULL,
  `NOME` VARCHAR(100) NOT NULL,
  `CPF` CHAR(11) NULL DEFAULT NULL,
  `ATIVO` TINYINT NOT NULL DEFAULT '1',
  `TELEFONE` CHAR(12) NULL,
  `SENHA` CHAR(4) NULL,
  `TIPOPESSOA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_PESSOAFISICA_TIPOPESSOA1_idx` (`TIPOPESSOA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PESSOAFISICA_TIPOPESSOA1`
    FOREIGN KEY (`TIPOPESSOA_ID`)
    REFERENCES `routerdb`.`TIPOPESSOA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'CADASTRO DE PESSOAS FÍSICAS';


-- -----------------------------------------------------
-- Table `routerdb`.`PESSOAJURIDICA_PESSOAFISICA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `routerdb`.`PESSOAJURIDICA_PESSOAFISICA` (
  `PESSOAJURIDICA_ID` INT NOT NULL,
  `PESSOAFISICA_ID` INT NOT NULL,
  PRIMARY KEY (`PESSOAJURIDICA_ID`, `PESSOAFISICA_ID`),
  INDEX `fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAFISICA1_idx` (`PESSOAFISICA_ID` ASC) VISIBLE,
  INDEX `fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAJURIDICA1_idx` (`PESSOAJURIDICA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAJURIDICA1`
    FOREIGN KEY (`PESSOAJURIDICA_ID`)
    REFERENCES `routerdb`.`PESSOAJURIDICA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAFISICA1`
    FOREIGN KEY (`PESSOAFISICA_ID`)
    REFERENCES `routerdb`.`PESSOAFISICA` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `routerdb`.`SITUACAO_SERVICO`
-- -----------------------------------------------------
START TRANSACTION;
USE `routerdb`;
INSERT INTO `routerdb`.`SITUACAO_SERVICO` (`ID`, `DESCRICAO`) VALUES (1, 'CRIADO');
INSERT INTO `routerdb`.`SITUACAO_SERVICO` (`ID`, `DESCRICAO`) VALUES (2, 'FECHADO');
INSERT INTO `routerdb`.`SITUACAO_SERVICO` (`ID`, `DESCRICAO`) VALUES (3, 'CANCELADO');

COMMIT;


-- -----------------------------------------------------
-- Data for table `routerdb`.`FINALIDADE`
-- -----------------------------------------------------
START TRANSACTION;
USE `routerdb`;
INSERT INTO `routerdb`.`FINALIDADE` (`ID`, `DESCRICAO`) VALUES (1, 'ENTREGA');
INSERT INTO `routerdb`.`FINALIDADE` (`ID`, `DESCRICAO`) VALUES (2, 'COLETA');
INSERT INTO `routerdb`.`FINALIDADE` (`ID`, `DESCRICAO`) VALUES (3, 'ENTREGA/COLETA');

COMMIT;


-- -----------------------------------------------------
-- Data for table `routerdb`.`SITUACAO_ROTA`
-- -----------------------------------------------------
START TRANSACTION;
USE `routerdb`;
INSERT INTO `routerdb`.`SITUACAO_ROTA` (`ID`, `NOME`) VALUES (1, 'CRIADA');
INSERT INTO `routerdb`.`SITUACAO_ROTA` (`ID`, `NOME`) VALUES (2, 'EXECUÇÃO');
INSERT INTO `routerdb`.`SITUACAO_ROTA` (`ID`, `NOME`) VALUES (3, 'FECHADA');
INSERT INTO `routerdb`.`SITUACAO_ROTA` (`ID`, `NOME`) VALUES (4, 'CANCELADA');

COMMIT;


-- -----------------------------------------------------
-- Data for table `routerdb`.`TIPOPESSOA`
-- -----------------------------------------------------
START TRANSACTION;
USE `routerdb`;
INSERT INTO `routerdb`.`TIPOPESSOA` (`ID`, `DESCRICAO`) VALUES (1, 'USUÁRIO');
INSERT INTO `routerdb`.`TIPOPESSOA` (`ID`, `DESCRICAO`) VALUES (2, 'CLIENTE');

COMMIT;

