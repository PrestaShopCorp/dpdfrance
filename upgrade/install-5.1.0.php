<?php
/**
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
* @author    DPD S.A.S. <ensavoirplus.ecommerce@dpd.fr>
* @copyright 2015 DPD S.A.S.
* @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*/

if (!defined('_PS_VERSION_'))
	exit;

function upgrade_module_5_1_0($object)
{
	// Update DB configuration values EXAPAQ_* to DPDFRANCE_*
	Configuration::updateValue('DPDFRANCE_NOM_EXP', Configuration::getValue('EXAPAQ_NOM_EXP'));
	Configuration::updateValue('DPDFRANCE_ADDRESS_EXP', Configuration::getValue('EXAPAQ_ADDRESS_EXP'));
	Configuration::updateValue('DPDFRANCE_ADDRESS2_EXP', Configuration::getValue('EXAPAQ_ADDRESS2_EXP'));
	Configuration::updateValue('DPDFRANCE_CP_EXP', Configuration::getValue('EXAPAQ_CP_EXP'));
	Configuration::updateValue('DPDFRANCE_VILLE_EXP', Configuration::getValue('EXAPAQ_VILLE_EXP'));
	Configuration::updateValue('DPDFRANCE_TEL_EXP', Configuration::getValue('EXAPAQ_TEL_EXP'));
	Configuration::updateValue('DPDFRANCE_EMAIL_EXP', Configuration::getValue('EXAPAQ_EMAIL_EXP'));
	Configuration::updateValue('DPDFRANCE_GSM_EXP', Configuration::getValue('EXAPAQ_GSM_EXP'));
	Configuration::updateValue('DPDFRANCE_RELAIS_DEPOT_CODE', Configuration::getValue('EXAPAQ_ICIRELAIS_DEPOT_CODE'));
	Configuration::updateValue('DPDFRANCE_RELAIS_SHIPPER_CODE', Configuration::getValue('EXAPAQ_ICIRELAIS_SHIPPER_CODE'));
	Configuration::updateValue('DPDFRANCE_PREDICT_DEPOT_CODE', Configuration::getValue('EXAPAQ_PREDICT_DEPOT_CODE'));
	Configuration::updateValue('DPDFRANCE_PREDICT_SHIPPER_CODE', Configuration::getValue('EXAPAQ_PREDICT_SHIPPER_CODE'));
	Configuration::updateValue('DPDFRANCE_CLASSIC_DEPOT_CODE', Configuration::getValue('EXAPAQ_CLASSIC_DEPOT_CODE'));
	Configuration::updateValue('DPDFRANCE_CLASSIC_SHIPPER_CODE', Configuration::getValue('EXAPAQ_CLASSIC_SHIPPER_CODE'));
	Configuration::updateValue('DPDFRANCE_SUPP_ILES', Configuration::getValue('EXAPAQ_SUPP_ILES'));
	Configuration::updateValue('DPDFRANCE_SUPP_MONTAGNE', Configuration::getValue('EXAPAQ_SUPP_MONTAGNE'));
	Configuration::updateValue('DPDFRANCE_ETAPE_EXPEDITION', Configuration::getValue('EXAPAQ_ETAPE_EXPEDITION'));
	Configuration::updateValue('DPDFRANCE_ETAPE_EXPEDIEE', Configuration::getValue('EXAPAQ_ETAPE_EXPEDIEE'));
	Configuration::updateValue('DPDFRANCE_ETAPE_LIVRE', Configuration::getValue('EXAPAQ_ETAPE_LIVRE'));
	Configuration::updateValue('DPDFRANCE_AD_VALOREM', Configuration::getValue('EXAPAQ_AD_VALOREM'));
	Configuration::updateValue('DPDFRANCE_RELAIS_MYPUDO_URL', Configuration::getValue('EXAPAQ_ICIRELAIS_MYPUDO_URL'));

	// Delete old DB configuration values
	Configuration::deleteByName('EXAPAQ_NOM_EXP');
	Configuration::deleteByName('EXAPAQ_ADDRESS_EXP');
	Configuration::deleteByName('EXAPAQ_ADDRESS2_EXP');
	Configuration::deleteByName('EXAPAQ_CP_EXP');
	Configuration::deleteByName('EXAPAQ_VILLE_EXP');
	Configuration::deleteByName('EXAPAQ_TEL_EXP');
	Configuration::deleteByName('EXAPAQ_EMAIL_EXP');
	Configuration::deleteByName('EXAPAQ_GSM_EXP');
	Configuration::deleteByName('EXAPAQ_ICIRELAIS_CARRIER_ID', '');
	Configuration::deleteByName('EXAPAQ_ICIRELAIS_DEPOT_CODE', '');
	Configuration::deleteByName('EXAPAQ_ICIRELAIS_SHIPPER_CODE', '');
	Configuration::deleteByName('EXAPAQ_PREDICT_CARRIER_ID', '');
	Configuration::deleteByName('EXAPAQ_PREDICT_DEPOT_CODE', '');
	Configuration::deleteByName('EXAPAQ_PREDICT_SHIPPER_CODE', '');
	Configuration::deleteByName('EXAPAQ_CLASSIC_CARRIER_ID', '');
	Configuration::deleteByName('EXAPAQ_CLASSIC_DEPOT_CODE', '');
	Configuration::deleteByName('EXAPAQ_CLASSIC_SHIPPER_CODE', '');
	Configuration::deleteByName('EXAPAQ_ICIRELAIS_MYPUDO_URL');
	Configuration::deleteByName('EXAPAQ_SUPP_ILES');
	Configuration::deleteByName('EXAPAQ_SUPP_MONTAGNE');
	Configuration::deleteByName('EXAPAQ_ETAPE_EXPEDITION');
	Configuration::deleteByName('EXAPAQ_ETAPE_EXPEDIEE');
	Configuration::deleteByName('EXAPAQ_ETAPE_LIVRE');
	Configuration::deleteByName('EXAPAQ_AD_VALOREM');
	Configuration::deleteByName('EXAPAQ_PARAM'))

	// Install new DB table
	$query = Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'dpdfrance_shipping` (
		`id_customer` int(10) unsigned DEFAULT NULL,
		`id_cart` int(10) unsigned DEFAULT NULL,
		`id_carrier` int(5) unsigned DEFAULT NULL,
		`service` varchar(3) DEFAULT NULL,
		`relay_id` varchar(8) DEFAULT NULL,
		`company` varchar(23) DEFAULT NULL,
		`address1` varchar(128) DEFAULT NULL,
		`address2` varchar(128) DEFAULT NULL,
		`postcode` varchar(10) DEFAULT NULL,
		`city` varchar(100) DEFAULT NULL,
		`id_country` int(11) DEFAULT NULL,
		`gsm_dest` varchar(14) DEFAULT NULL) 
		ENGINE=MyISAM DEFAULT CHARSET=utf8;');

	if (!$query)
		return false;

	return true;
}
?>