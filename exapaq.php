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
 * @author    EXAPAQ S.A.S. <support@icirelais.com>
 * @copyright 2015 EXAPAQ S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 */

if (!defined('_PS_VERSION_'))
	exit;

class Exapaq extends CarrierModule
{
	private $config_carrier_icirelais = array(
		'name' 					=> 'ICI relais par EXAPAQ',
		'id_tax_rules_group' 	=> 0,
		'url' 					=> 'http://webtrace.exapaq.com/ici-webtrace/webclients.aspx?verknr=@&cmd=VERKNR_SEARCH',
		'active' 				=> true,
		'deleted' 				=> 0,
		'shipping_handling' 	=> false,
		'range_behavior' 		=> 1,
		'is_module'				=> true,
		'delay' 				=> array(	'fr'=>'Livraison en 24-48h vers plus de 5 000 commerces de proximité.',
											'en'=>'24-48h delivery in one of our 5000 pick-up points.',
											'es'=>'Entrega en 24 a 48 horas en una de nuestras 5000 tiendas.',
											'it'=>'Consegna in 24 a 48 ore in uno dei nostri 5.000 negozi.',
											'de'=>'24-48 Stunden Lieferung in einem unserer 5.000 Geschäften.'),
		'id_zone' 				=> 1,
		'shipping_external'		=> true,
		'external_module_name'	=> 'exapaq',
		'need_range' 			=> true,
		'grade' 				=> 9,
		);

	private $config_carrier_predict = array(
		'name' 					=> 'Predict par EXAPAQ',
		'id_tax_rules_group' 	=> 0,
		'url' 					=> 'http://webtrace.exapaq.com/exa-webtrace/webclients.aspx?verknr=@&cmd=VERKNR_SEARCH',
		'active' 				=> true,
		'deleted' 				=> 0,
		'shipping_handling' 	=> false,
		'range_behavior' 		=> 1,
		'is_module'				=> true,
		'delay' 				=> array(	'fr'=>'Livraison en 24-48h dans un créneau horaire précis.',
											'en'=>'24-48h delivery in a specific time window.',
											'es'=>'Entrega en 24 a 48 horas en una ventana horaria especifica.',
											'it'=>'Consegna in 24 a 48 ore in un intervallo di tempo specifico.',
											'de'=>'24-48 Stunden Lieferung in einem bestimmten Zeitfenster.'),
		'id_zone' 				=> 1,
		'shipping_external'		=> true,
		'external_module_name'	=> 'exapaq',
		'need_range' 			=> true,
		'grade' 				=> 9,
		);

	private $config_carrier_classic = array(
		'name' 					=> 'Classic par EXAPAQ',
		'id_tax_rules_group' 	=> 0,
		'url' 					=> 'http://webtrace.exapaq.com/exa-webtrace/webclients.aspx?verknr=@&cmd=VERKNR_SEARCH',
		'active' 				=> true,
		'deleted' 				=> 0,
		'shipping_handling' 	=> false,
		'range_behavior' 		=> 1,
		'is_module'				=> true,
		'delay' 				=> array(	'fr'=>'Livraison en 24-48h sur lieu de travail uniquement.',
											'en'=>'24-48h delivery at your workplace only.',
											'es'=>'Entrega en 24 a 48 horas en su sitio de trabajo.',
											'it'=>'Consegna in 24 a 48 ore sul posto di lavoro.',
											'de'=>'24-48 Stunden Lieferung an Ihrem Arbeitsplatz.'),
		'id_zone' 				=> 1,
		'shipping_external'		=> true,
		'external_module_name'	=> 'exapaq',
		'need_range' 			=> true,
		'grade' 				=> 9,
		);

	public $config_carrier_world = array(
		'name' 					=> 'DPD Delivery',
		'id_tax_rules_group' 	=> 0,
		'url' 					=> 'http://webtrace.exapaq.com/exa-webtrace/webclients.aspx?verknr=@&cmd=VERKNR_SEARCH',
		'active' 				=> true,
		'deleted' 				=> 0,
		'shipping_handling' 	=> false,
		'range_behavior' 		=> 1,
		'is_module'				=> true,
		'delay' 				=> array(	'fr'=>'Livraison dans le monde entier avec la fiabilité du réseau DPD.',
											'en'=>'Delivery all over the world with the reliability of DPD network.',
											'es'=>'Entrega mundial con la confiabilidad de la red DPD.',
											'it'=>'Consegna in tutto il mondo con l affidabilità della rete di DPD.',
											'de'=>'Lieferung in der ganzen Welt mit der Zuverlässigkeit der DPD Netzwerk.'),
		'id_zone' 				=> 1,
		'shipping_external'		=> true,
		'external_module_name'	=> 'exapaq',
		'need_range' 			=> true,
		'grade' 				=> 9,
		);

	/* Get Postal Code from an address ID */
	public static function getPostcodeByAddress($id_address)
	{
		$row = Db::getInstance()->getRow('
			SELECT `postcode`
			FROM '._DB_PREFIX_.'address a
			WHERE a.`id_address` = '.(int)$id_address);
		if (!empty($row['postcode']))
			return $row['postcode'];
		else
			return false;
	}

	/* Island and Mountain zones overcost calculation functions */
	public function getOrderShippingCost($params, $shipping_cost)
	{
		if (!$this->context->cart instanceof Cart)
			$this->context->cart = new Cart((int)$params->id);

		if ($this->context->country->iso_code != 'FR')
			return $shipping_cost;

		$exa_iles = array('17111','17123','17190','17310','17370','17410','17480','17550','17580','17590','17630','17650','17670','17740','17840','17880','17940','22870','29242','29253','29259','29980','29990','56360','56590','56780','56840','85350');
		$exa_montagne = array('04120','04130','04140','04160','04170','04200','04240','04260','04300','04310','04330','04360','04370','04400','04510','04530','04600','04700','04850','05100','05110','05120','05130','05150','05160','05170','05200','05220','05240','05250','05260','05290','05300','05310','05320','05330','05340','05350','05400','05460','05470','05500','05560','05600','05700','05800','06140','06380','06390','06410','06420','06430','06450','06470','06530','06540','06620','06710','06750','06910','09110','09140','09300','09460','25120','25140','25240','25370','25450','25500','25650','30570','31110','38112','38114','38142','38190','38250','38350','38380','38410','38580','38660','38700','38750','38860','38880','39220','39310','39400','63113','63210','63240','63610','63660','63690','63840','63850','64440','64490','64560','64570','65110','65120','65170','65200','65240','65400','65510','65710','66210','66760','66800','68140','68610','68650','73110','73120','73130','73140','73150','73160','73170','73190','73210','73220','73230','73250','73260','73270','73300','73320','73340','73350','73390','73400','73440','73450','73460','73470','73500','73530','73550','73590','73600','73620','73630','73640','73710','73720','73870','74110','74120','74170','74220','74230','74260','74310','74340','74350','74360','74390','74400','74420','74430','74440','74450','74470','74480','74660','74740','74920','83111','83440','83530','83560','83630','83690','83830','83840','84390','88310','88340','88370','88400','90200');

		$id_address = (int)$this->context->cart->id_address_delivery;
		$postcode = self::getPostcodeByAddress($id_address);

		if (Tools::substr($postcode, 0, 2) == '20')
		{
			$shipping_cost += (float)Configuration::get('EXAPAQ_SUPP_ILES');
			if ((float)Configuration::get('EXAPAQ_SUPP_ILES') < 0)
				return false;
		}
		if (in_array($postcode, $exa_iles))
		{
			$shipping_cost += (float)Configuration::get('EXAPAQ_SUPP_ILES');
			if ((float)Configuration::get('EXAPAQ_SUPP_ILES') < 0)
				return false;
		}
		if (in_array($postcode, $exa_montagne))
		{
			$shipping_cost += (float)Configuration::get('EXAPAQ_SUPP_MONTAGNE');
			if ((float)Configuration::get('EXAPAQ_SUPP_MONTAGNE') < 0)
				return false;
		}
		return $shipping_cost;
	}

	public function getOrderShippingCostExternal($params)
	{
		return $params;
	}

	public function __construct()
	{
		$this->name = 'exapaq';
		if (_PS_VERSION_ < '1.4')
			$this->tab = 'Carriers';
		else
			$this->tab = 'shipping_logistics';
		$this->version = '5.0.1';
		$this->author = 'EXAPAQ S.A.S';
		$this->need_instance = 1;

		if (version_compare(_PS_VERSION_, '1.5.0.0 ', '>='))
		{
			$this->multishop_context = Shop::CONTEXT_ALL | Shop::CONTEXT_GROUP | Shop::CONTEXT_SHOP;
			$this->multishop_context_group = Shop::CONTEXT_GROUP;
		}

		parent::__construct();

		$this->displayName = $this->l('EXAPAQ');
		$this->description = $this->l('Offer EXAPAQ\'s fast and reliable delivery services to your customers');
		$this->confirmUninstall = $this->l('Warning: all the data saved in your database will be deleted. Are you sure you want uninstall this module?');

		/* Backward compatibility */
		if (_PS_VERSION_ < '1.5')
			require_once(_PS_MODULE_DIR_.$this->name.'/backward_compatibility/backward.php');

		if (Configuration::get('EXAPAQ_PARAM') == 0)
			$this->warning = $this->l('Please proceed to the configuration of the EXAPAQ plugin');

		if (!extension_loaded('soap'))
			$this->warning = $this->l('Warning! The PHP extension SOAP is not installed on this server. You must activate it in order to use the EXAPAQ plugin');
	}

	public function install()
	{
		if (!parent::install() || !$this->installModuleTab('AdminExapaq', 'EXAPAQ', Tab::getIdFromClassName('AdminOrders')) || !$this->registerHookByVersion() || !Configuration::updateValue('EXAPAQ_PARAM', 0) || !Configuration::updateValue('EXAPAQ_NOM_EXP', '') || !Configuration::updateValue('EXAPAQ_ADDRESS_EXP', '') || !Configuration::updateValue('EXAPAQ_ADDRESS2_EXP', '') || !Configuration::updateValue('EXAPAQ_CP_EXP', '') || !Configuration::updateValue('EXAPAQ_VILLE_EXP', '') || !Configuration::updateValue('EXAPAQ_TEL_EXP', '') || !Configuration::updateValue('EXAPAQ_GSM_EXP', '') || !Configuration::updateValue('EXAPAQ_EMAIL_EXP', '') || !Configuration::updateValue('EXAPAQ_ICIRELAIS_CARRIER_ID', '') || !Configuration::updateValue('EXAPAQ_ICIRELAIS_DEPOT_CODE', '') || !Configuration::updateValue('EXAPAQ_ICIRELAIS_SHIPPER_CODE', '') || !Configuration::updateValue('EXAPAQ_PREDICT_CARRIER_ID', '') || !Configuration::updateValue('EXAPAQ_PREDICT_DEPOT_CODE', '') || !Configuration::updateValue('EXAPAQ_PREDICT_SHIPPER_CODE', '') || !Configuration::updateValue('EXAPAQ_CLASSIC_CARRIER_ID', '') || !Configuration::updateValue('EXAPAQ_CLASSIC_DEPOT_CODE', '') || !Configuration::updateValue('EXAPAQ_CLASSIC_SHIPPER_CODE', '') || !Configuration::updateValue('EXAPAQ_SUPP_ILES', '') || !Configuration::updateValue('EXAPAQ_SUPP_MONTAGNE', '') || !Configuration::updateValue('EXAPAQ_ETAPE_EXPEDITION', '3') || !Configuration::updateValue('EXAPAQ_ETAPE_EXPEDIEE', '4') || !Configuration::updateValue('EXAPAQ_ETAPE_LIVRE', '5') || !Configuration::updateValue('EXAPAQ_AD_VALOREM', ''))
			return false;
		return $this->installConfigDB();
	}

	private function registerHookByVersion()
	{
		if (_PS_VERSION_ >= '1.0' && (!$this->registerHook('extraCarrier') || !$this->registerHook('updateCarrier') || !$this->registerHook('newOrder')))
			return false;

		if (_PS_VERSION_ >= '1.4' && (!$this->registerHook('header') || !$this->registerHook('paymentTop')))
			return false;
		return true;
	}

	public function installConfigDB()
	{
		// Database alteration : stretching the shipping_number field from 32 to 64 chars.
		$sql = 'ALTER TABLE `'._DB_PREFIX_.'orders` CHANGE `shipping_number`  `shipping_number` VARCHAR( 64 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL';
		Db::getInstance()->Execute($sql);

		$query = Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'exapaq_france` (
		`id_customer` int(10) unsigned DEFAULT NULL,
		`id_cart` int(10) unsigned DEFAULT NULL,
		`id_carrier` int(5) unsigned DEFAULT NULL,
		`service` varchar(3) DEFAULT NULL,
		`relay_id` varchar(8) DEFAULT NULL,
		`company` varchar(23) DEFAULT NULL,
		`address2` varchar(128) DEFAULT NULL,
		`postcode` varchar(10) DEFAULT NULL,
		`city` varchar(100) DEFAULT NULL,
		`id_country` int(11) DEFAULT NULL,
		`gsm_dest` varchar(14) DEFAULT NULL) 
		ENGINE=MyISAM DEFAULT CHARSET=utf8;');

		if (!$query)
			return false;

		// Get "France" zone ID and set it as $id_zone_france
		$sql = 'SELECT id_zone FROM '._DB_PREFIX_.'zone WHERE name LIKE \'%France%\'';
		$res = Db::getInstance()->ExecuteS($sql);
		if (!empty($res))
		{
			foreach ($res as $zone)
				$id_zone_france = $zone['id_zone'];
		}

		// If France zone ID is empty : Create a France zone, fetch its ID, and assign the France country to this zone
		if (!$id_zone_france)
		{
			Db::getInstance()->execute('INSERT INTO '._DB_PREFIX_.'zone (name, active) VALUES (\'France\',1)');
			$sql = 'SELECT id_zone FROM '._DB_PREFIX_.'zone WHERE name = \'France\'';
			$res = Db::getInstance()->ExecuteS($sql);
			if (!empty($res))
			{
				foreach ($res as $zone)
				{
					$id_zone_france = $zone['id_zone'];
					Db::getInstance()->execute('UPDATE '._DB_PREFIX_.'country SET id_zone='.$id_zone_france.' WHERE iso_code = \'FR\' and active = 1');
				}
			}
		}
		$sql = 'UPDATE '._DB_PREFIX_.'country SET id_zone='.(int)$id_zone_france.' WHERE iso_code = \'FR\' and active = 1';
		if (!Db::getInstance()->Execute($sql))
			return false;
		return true;
	}

	public function uninstall()
	{
		if (!parent::uninstall() || !$this->uninstallModuleTab('AdminExapaq') || !Configuration::deleteByName('EXAPAQ_NOM_EXP') || !Configuration::deleteByName('EXAPAQ_ADDRESS_EXP') || !Configuration::deleteByName('EXAPAQ_ADDRESS2_EXP') || !Configuration::deleteByName('EXAPAQ_CP_EXP') || !Configuration::deleteByName('EXAPAQ_VILLE_EXP') || !Configuration::deleteByName('EXAPAQ_TEL_EXP') || !Configuration::deleteByName('EXAPAQ_EMAIL_EXP') || !Configuration::deleteByName('EXAPAQ_GSM_EXP') || !Configuration::deleteByName('EXAPAQ_ICIRELAIS_CARRIER_ID', '') || !Configuration::deleteByName('EXAPAQ_ICIRELAIS_DEPOT_CODE', '') || !Configuration::deleteByName('EXAPAQ_ICIRELAIS_SHIPPER_CODE', '') || !Configuration::deleteByName('EXAPAQ_PREDICT_CARRIER_ID', '') || !Configuration::deleteByName('EXAPAQ_PREDICT_DEPOT_CODE', '') || !Configuration::deleteByName('EXAPAQ_PREDICT_SHIPPER_CODE', '') || !Configuration::deleteByName('EXAPAQ_CLASSIC_CARRIER_ID', '') || !Configuration::deleteByName('EXAPAQ_CLASSIC_DEPOT_CODE', '') || !Configuration::deleteByName('EXAPAQ_CLASSIC_SHIPPER_CODE', '') || !Configuration::deleteByName('EXAPAQ_ICIRELAIS_MYPUDO_URL') || !Configuration::deleteByName('EXAPAQ_SUPP_ILES') || !Configuration::deleteByName('EXAPAQ_SUPP_MONTAGNE') || !Configuration::deleteByName('EXAPAQ_ETAPE_EXPEDITION') || !Configuration::deleteByName('EXAPAQ_ETAPE_EXPEDIEE') || !Configuration::deleteByName('EXAPAQ_ETAPE_LIVRE') || !Configuration::deleteByName('EXAPAQ_AD_VALOREM') || !Configuration::deleteByName('EXAPAQ_PARAM'))
			return false;
		return true;
	}

	/* Called in administration -> module -> configure */
	public function getContent()
	{
		$output = '<h2>'.$this->displayName.'</h2>';

		if (_PS_VERSION_ < '1.4')
			$output .= '<script type="text/javascript" src="../modules/'.$this->name.'/js/admin/jquery/jquery-1.4.3.min.js"></script>';

		$output .= 	'<link rel="stylesheet" type="text/css" href="../modules/'.$this->name.'/js/admin/jquery/plugins/fancybox/jquery.fancybox-1.3.4.css" media="screen"/>
					<script type="text/javascript" src="../modules/'.$this->name.'/js/admin/jquery/plugins/fancybox/jquery.fancybox-1.3.4.js"></script>
					<link rel="stylesheet" type="text/css" href="../modules/'.$this->name.'/css/admin/exapaq_config.css"/>';

		// Contact form if not customer
		if (Tools::isSubmit('submitContactForm'))
		{
			$lead_content = array();
			$lead_content['{raison_sociale}'] = (Tools::getValue('raison_sociale') ? Tools::getValue('raison_sociale') : 'Non renseigné');
			$lead_content['{site_web}'] = Configuration::get('PS_SHOP_DOMAIN');
			$lead_content['{nom_contact}'] = (Tools::getValue('nom_contact') ? Tools::getValue('nom_contact') : 'Non renseigné');
			$lead_content['{code_postal}'] = (Tools::getValue('code_postal') ? Tools::getValue('code_postal') : 'Non renseigné');
			$lead_content['{ville}'] = (Tools::getValue('ville') ? Tools::getValue('ville') : 'Non renseigné');
			$lead_content['{coordonnees}'] = (Tools::getValue('coordonnees') ? Tools::getValue('coordonnees') : 'Non renseigné');
			$lead_content['{volume_colis}'] = (Tools::getValue('volume_colis') ? Tools::getValue('volume_colis') : 'Non renseigné');

			$iso = Language::getIsoById((int)$this->context->cookie->id_lang);
			if (file_exists(dirname(__FILE__).'/mails/'.$iso.'/contact.txt') && file_exists(dirname(__FILE__).'/mails/'.$iso.'/contact.html'))
				if (!Mail::Send((int)$this->context->cookie->id_lang, 'contact', 'Lead entrant Prestashop', $lead_content, 'marco.brentini@exapaq.com', null, Configuration::get('PS_SHOP_EMAIL'), null, null, null, dirname(__FILE__).'/mails/'))
					$output .= '<div class="error">'.$this->l('An error occured while sending your information. Please try again or visit www.exapaq.com').'</div>';
				else
					$output .= '<div class="conf confirm">'.$this->l('Thank you! Your information are successfully sent, we will keep you in touch as soon as possible.').'</div>';
		}

		// Create ICI relais carrier
		if (Tools::isSubmit('submitCreateCarrierIcirelais'))
		{
			$this->createCarrier($this->config_carrier_icirelais, 'icirelais');
			$output .= '<div class="conf confirm">'.$this->l('ICI relais carrier created').'</div>';
			$output .= '<script language="javascript">$(document).ready(function(){$("#onglet2").click();});</script>';
		}
		// Create Predict carrier
		if (Tools::isSubmit('submitCreateCarrierPredict'))
		{
			$this->createCarrier($this->config_carrier_predict, 'predict');
			$output .= '<div class="conf confirm">'.$this->l('Predict carrier created').'</div>';
			$output .= '<script language="javascript">$(document).ready(function(){$("#onglet2").click();});</script>';
		}
		// Create Classic carrier
		if (Tools::isSubmit('submitCreateCarrierClassic'))
		{
			$this->createCarrier($this->config_carrier_classic, 'classic');
			$output .= '<div class="conf confirm">'.$this->l('Classic carrier created').'</div>';
			$output .= '<script language="javascript">$(document).ready(function(){$("#onglet2").click();});</script>';
		}
		// Create World carrier
		if (Tools::isSubmit('submitCreateCarrierWorld'))
		{
			$this->createCarrier($this->config_carrier_world, 'world');
			$output .= '<div class="conf confirm">'.$this->l('Europe carrier created').'</div>';
			$output .= '<script language="javascript">$(document).ready(function(){$("#onglet2").click();});</script>';
		}

		if (Tools::isSubmit('submitRcReferer'))
		{
			Configuration::updateValue('EXAPAQ_NOM_EXP', Tools::getValue('nom_exp'));
			Configuration::updateValue('EXAPAQ_ADDRESS_EXP', Tools::getValue('address_exp'));
			Configuration::updateValue('EXAPAQ_ADDRESS2_EXP', Tools::getValue('address2_exp'));
			Configuration::updateValue('EXAPAQ_CP_EXP', Tools::getValue('cp_exp'));
			Configuration::updateValue('EXAPAQ_VILLE_EXP', Tools::getValue('ville_exp'));
			Configuration::updateValue('EXAPAQ_TEL_EXP', Tools::getValue('tel_exp'));
			Configuration::updateValue('EXAPAQ_EMAIL_EXP', Tools::getValue('email_exp'));
			Configuration::updateValue('EXAPAQ_GSM_EXP', Tools::getValue('gsm_exp'));

			// Log ID ICI relais
			if (!in_array((int)Tools::getValue('icirelais_carrier_id'), explode('|', Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_LOG'))))
				Configuration::updateValue('EXAPAQ_ICIRELAIS_CARRIER_LOG', Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_LOG').'|'.(int)Tools::getValue('icirelais_carrier_id'));

			// ICI relais carrier reassignment
			if ((int)Tools::getValue('icirelais_carrier_id') != (int)Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'))
			{
				Configuration::updateValue('EXAPAQ_ICIRELAIS_CARRIER_ID', (int)Tools::getValue('icirelais_carrier_id'));
				if (_PS_VERSION_ >= '1.4')
					$this->reaffectationCarrier((int)Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'));
			}
			Configuration::updateValue('EXAPAQ_ICIRELAIS_DEPOT_CODE', Tools::getValue('icirelais_depot_code'));
			Configuration::updateValue('EXAPAQ_ICIRELAIS_SHIPPER_CODE', Tools::getValue('icirelais_shipper_code'));

			// Log ID Predict
			if (!in_array((int)Tools::getValue('predict_carrier_id'), explode('|', Configuration::get('EXAPAQ_PREDICT_CARRIER_LOG'))))
				Configuration::updateValue('EXAPAQ_PREDICT_CARRIER_LOG', Configuration::get('EXAPAQ_PREDICT_CARRIER_LOG').'|'.(int)Tools::getValue('predict_carrier_id'));

			// Predict carrier reassignment
			if ((int)Tools::getValue('predict_carrier_id') != (int)Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'))
			{
				Configuration::updateValue('EXAPAQ_PREDICT_CARRIER_ID', (int)Tools::getValue('predict_carrier_id'));
				if (_PS_VERSION_ >= '1.4')
					$this->reaffectationCarrier((int)Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'));
			}
			Configuration::updateValue('EXAPAQ_PREDICT_DEPOT_CODE', Tools::getValue('predict_depot_code'));
			Configuration::updateValue('EXAPAQ_PREDICT_SHIPPER_CODE', Tools::getValue('predict_shipper_code'));

			// Log ID Predict
			if (!in_array((int)Tools::getValue('classic_carrier_id'), explode('|', Configuration::get('EXAPAQ_CLASSIC_CARRIER_LOG'))))
				Configuration::updateValue('EXAPAQ_CLASSIC_CARRIER_LOG', Configuration::get('EXAPAQ_CLASSIC_CARRIER_LOG').'|'.(int)Tools::getValue('classic_carrier_id'));

			// Classic carrier reassignment
			if ((int)Tools::getValue('classic_carrier_id') != (int)Configuration::get('EXAPAQ_CLASSIC_CARRIER_ID'))
			{
				Configuration::updateValue('EXAPAQ_CLASSIC_CARRIER_ID', (int)Tools::getValue('classic_carrier_id'));
				if (_PS_VERSION_ >= '1.4')
					$this->reaffectationCarrier((int)Configuration::get('EXAPAQ_CLASSIC_CARRIER_ID'));
			}
			Configuration::updateValue('EXAPAQ_CLASSIC_DEPOT_CODE', Tools::getValue('classic_depot_code'));
			Configuration::updateValue('EXAPAQ_CLASSIC_SHIPPER_CODE', Tools::getValue('classic_shipper_code'));

			Configuration::updateValue('EXAPAQ_ICIRELAIS_MYPUDO_URL', preg_replace('/\s+/', '', Tools::getValue('mypudo_url')));
			Configuration::updateValue('EXAPAQ_SUPP_ILES', (int)Tools::getValue('supp_iles'));
			Configuration::updateValue('EXAPAQ_SUPP_MONTAGNE', (int)Tools::getValue('supp_montagne'));

			Configuration::updateValue('EXAPAQ_ETAPE_EXPEDITION', (int)Tools::getValue('id_expedition'));
			Configuration::updateValue('EXAPAQ_ETAPE_EXPEDIEE', (int)Tools::getValue('id_expedie'));
			Configuration::updateValue('EXAPAQ_ETAPE_LIVRE', (int)Tools::getValue('id_livre'));
			Configuration::updateValue('EXAPAQ_AD_VALOREM', Tools::getValue('ad_valorem'));

			Configuration::updateValue('EXAPAQ_PARAM', 1);

			$output .= '<div class="conf confirm">'.$this->l('Settings updated').'</div>';
		}
		return $output.$this->displayForm();
	}

	public function displayForm()
	{
		if (!extension_loaded('soap'))
			echo '<div class="error">'.$this->l('Warning! The PHP extension SOAP is not installed on this server. You must activate it in order to use the EXAPAQ plugin').'</div>';
		else
		{
		$this->context->smarty->assign(array(
			'nom_exp' 				=> Tools::getValue('nom_exp', Configuration::get('EXAPAQ_NOM_EXP')),
			'address_exp' 			=> Tools::getValue('address_exp', Configuration::get('EXAPAQ_ADDRESS_EXP')),
			'address2_exp' 			=> Tools::getValue('address2_exp', Configuration::get('EXAPAQ_ADDRESS2_EXP')),
			'cp_exp' 				=> Tools::getValue('cp_exp', Configuration::get('EXAPAQ_CP_EXP')),
			'ville_exp'				=> Tools::getValue('ville_exp', Configuration::get('EXAPAQ_VILLE_EXP')),
			'tel_exp' 				=> Tools::getValue('tel_exp', Configuration::get('EXAPAQ_TEL_EXP')),
			'email_exp' 			=> Tools::getValue('email_exp', Configuration::get('EXAPAQ_EMAIL_EXP')),
			'gsm_exp' 				=> Tools::getValue('gsm_exp', Configuration::get('EXAPAQ_GSM_EXP')),
			'icirelais_depot_code' 	=> Tools::getValue('icirelais_depot_code', Configuration::get('EXAPAQ_ICIRELAIS_DEPOT_CODE')),
			'predict_depot_code' 	=> Tools::getValue('predict_depot_code', Configuration::get('EXAPAQ_PREDICT_DEPOT_CODE')),
			'classic_depot_code' 	=> Tools::getValue('classic_depot_code', Configuration::get('EXAPAQ_CLASSIC_DEPOT_CODE')),
			'icirelais_shipper_code'=> Tools::getValue('icirelais_shipper_code', Configuration::get('EXAPAQ_ICIRELAIS_SHIPPER_CODE')),
			'predict_shipper_code' 	=> Tools::getValue('predict_shipper_code', Configuration::get('EXAPAQ_PREDICT_SHIPPER_CODE')),
			'classic_shipper_code' 	=> Tools::getValue('classic_shipper_code', Configuration::get('EXAPAQ_CLASSIC_SHIPPER_CODE')),
			'carriers' 				=> Carrier::getCarriers($this->context->language->id, false, false, false, null, (defined('ALL_CARRIERS') ? ALL_CARRIERS : null)),
			'icirelais_carrier_id'	=> Tools::getValue('icirelais_carrier_id', Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID')),
			'predict_carrier_id' 	=> Tools::getValue('predict_carrier_id', Configuration::get('EXAPAQ_PREDICT_CARRIER_ID')),
			'classic_carrier_id' 	=> Tools::getValue('classic_carrier_id', Configuration::get('EXAPAQ_CLASSIC_CARRIER_ID')),
			'mypudo_url'			=> Tools::getValue('mypudo_url', Configuration::get('EXAPAQ_ICIRELAIS_MYPUDO_URL')),
			'supp_iles' 			=> Tools::getValue('supp_iles', Configuration::get('EXAPAQ_SUPP_ILES')),
			'supp_montagne' 		=> Tools::getValue('supp_montagne', Configuration::get('EXAPAQ_SUPP_MONTAGNE')),
			'etats_factures' 		=> OrderState::getOrderStates((int)$this->context->language->id),
			'exapaq_etape_expedition'=> (int)Configuration::get('EXAPAQ_ETAPE_EXPEDITION'),
			'exapaq_etape_expediee'	=> (int)Configuration::get('EXAPAQ_ETAPE_EXPEDIEE'),
			'exapaq_etape_livre'	=> (int)Configuration::get('EXAPAQ_ETAPE_LIVRE'),
			'exapaq_ad_valorem'		=> (int)Configuration::get('EXAPAQ_AD_VALOREM'),
			'optvd'					=> array($this->l('Integrated parcel insurance service (23 € / kg)'), $this->l('Ad Valorem insurance service')),
			'ps_version' 			=> (float)_PS_VERSION_,
			'form_submit_url' 		=> $_SERVER['REQUEST_URI'],
			));
		return $this->display(__FILE__, 'views/templates/admin/config.tpl');
		}
	}
	/* Calls CSS and JS files on header of front-office pages */
	public function hookHeader()
	{
		$this->context->controller->addCSS($this->_path.'css/front/icirelais/exapaq_icirelais.css');
		$this->context->controller->addCSS($this->_path.'css/front/predict/exapaq_predict.css');
		$this->context->controller->addJS($this->_path.'js/front/icirelais/exapaq_icirelais.js');
		$this->context->controller->addJS('https://maps.googleapis.com/maps/api/js?sensor=false');
	}

	/* Calls TPL files and executes ICI relais webservice call upon carrier selection */
	public function hookExtraCarrier($params)
	{
		$address = new Address((int)$this->context->cart->id_address_delivery);
		$address_details = $address->getFields();
		$delivery_infos = $this->getDeliveryInfos((int)$this->context->cart->id);

		if (_PS_VERSION_ < '1.5')
			$this->context->country->iso_code = Db::getInstance()->getValue('SELECT iso_code FROM '._DB_PREFIX_.'country WHERE id_country = '.(int)$address_details['id_country'].'');

		if ($this->context->country->iso_code == 'FR')
		{
			$ici_relais_points = $this->getPoints($address_details);

			$this->context->smarty->assign(array(
				'ps_version' => (float)_PS_VERSION_,
				'opc' => (int)Configuration::get('PS_ORDER_PROCESS_TYPE'),
				'ssl' => (int)Configuration::get('PS_SSL_ENABLED'),
				'tpl_path' => str_replace('\\', '/', _PS_MODULE_DIR_).'exapaq/views/templates/front/ps14',
				'ici_relais_points' => (!isset($ici_relais_points['error']) ? $ici_relais_points : null),
				'error' => (isset($ici_relais_points['error']) ? $this->l($ici_relais_points['error']) : null),
				'urlIci' => _MODULE_DIR_.'exapaq/validation.php',
				'urlExaPredict' => _MODULE_DIR_.'exapaq/validation.php',
				'selectedrelay' => (isset($delivery_infos['relay_id']) ? $delivery_infos['relay_id'] : null),
				'icirelais_status' => (Tools::getValue('icirelais') ? Tools::getValue('icirelais') : null),
				'icirelais_carrier_id' => (int)Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'),
				'exapredict_gsm_dest' => (isset($delivery_infos['gsm_dest']) ? $delivery_infos['gsm_dest'] : null),
				'predict_status' => (Tools::getValue('predict') ? Tools::getValue('predict') : null),
				'predict_carrier_id' => (int)Configuration::get('EXAPAQ_PREDICT_CARRIER_ID')));
			if (_PS_VERSION_ < '1.4') // PS 1.3
				return $this->display(__FILE__, 'views/templates/front/ps13/hookextracarrier.tpl');
			if (_PS_VERSION_ < '1.5') // PS 1.4
				return $this->display(__FILE__, 'views/templates/front/ps14/hookextracarrier.tpl');
			else // PS 1.5+
			{
				if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 0) // STD
				{
					if ($this->context->cart->id_carrier == Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'))
						return $this->display(__FILE__, 'views/templates/front/ps15/icirelais/icirelais.tpl');
					if ($this->context->cart->id_carrier == Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'))
						return $this->display(__FILE__, 'views/templates/front/ps15/predict/exapredict.tpl');
				}
				else // OPC
				{
					if ($this->context->cart->id_carrier == Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'))
						return $this->display(__FILE__, 'views/templates/front/ps15/icirelais/icirelaisopc.tpl');
					if ($this->context->cart->id_carrier == Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'))
						return $this->display(__FILE__, 'views/templates/front/ps15/predict/exapredictopc.tpl');
				}
			}
		}
	}

	/* In OPC mode, shows or blocks payment methods upon carrier selection and customer data presence */
	public function hookPaymentTop($params)
	{
		if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 1)
		{
			switch ($this->context->cart->id_carrier)
			{
				case Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'):
					$delivery_infos = $this->getDeliveryInfos((int)$this->context->cart->id);
					if ($delivery_infos['relay_id'])
						return $this->display(__FILE__, 'views/templates/front/ps15/icirelais/showhookpayment.tpl');
					else
						return $this->display(__FILE__, 'views/templates/front/ps15/icirelais/icirelaiserror.tpl');
					break;
				case Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'):
					$delivery_infos = $this->getDeliveryInfos((int)$this->context->cart->id);
					if ($delivery_infos['gsm_dest'])
						return $this->display(__FILE__, 'views/templates/front/ps15/predict/showhookpayment.tpl');
					else
						return $this->display(__FILE__, 'views/templates/front/ps15/predict/exapredicterror.tpl');
					break;
				default:
					return $this->display(__FILE__, 'views/templates/front/ps15/predict/showhookpayment.tpl');
			}
		}
	}

	/* Get delivery information from a Cart ID */
	public static function getDeliveryInfos($id_cart)
	{
		return Db::getInstance()->getRow('SELECT id_customer, id_cart, service, relay_id, company, address1, address2, postcode, city, id_country, gsm_dest FROM '._DB_PREFIX_.'exapaq_france WHERE id_cart = '.(int)$id_cart);
	}

	/* If ICI relais carrier is selected, replaces customer shipping address by pudo's */
	public function hooknewOrder($params)
	{
		switch ($params['order']->id_carrier)
		{
			case (Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID')):
				$order = $params['order'];
				$cart = $params['cart'];
				$id_address_delivery = 0;

				// ICI relais address will become one of customer's
				$address_icirelais = self::getDeliveryInfos($cart->id);
				if (is_array($address_icirelais) && !empty($address_icirelais['relay_id']))
				{
					// Check if the ICI relais address already exists
					$return = Db::getInstance()->GetRow('SELECT id_address, company, lastname, firstname, address1, address2, postcode, city
										FROM '._DB_PREFIX_.'address
										WHERE id_customer = '.(int)$order->id_customer.'
											AND alias LIKE "ICI RELAIS '.pSQL($address_icirelais['relay_id']).'"
										ORDER BY id_address DESC');

					// ICI Relais address already exists for this customer => get id_address
					if (is_array($return))
					{
						$ps_address = new Address((int)$return['id_address']);
						if ($ps_address->company == Tools::substr($address_icirelais['company'], 0, 23).' ('.$address_icirelais['relay_id'].')'
													&& $ps_address->address1 == Tools::substr($address_icirelais['address1'], 0, 128)
													&& $ps_address->address2 == Tools::substr($address_icirelais['address2'], 0, 128)
													&& $ps_address->postcode == $address_icirelais['postcode']
													&& $ps_address->city == $address_icirelais['city']
													&& $ps_address->id_country == $address_icirelais['id_country'])
							$id_address_delivery = (int)$ps_address->id;
					}

					// ICI Relais address does not exist for this customer => create it
					if ($id_address_delivery == 0)
					{
						$ps_address = new Address($cart->id_address_delivery);
						$new_address = new Address();
						$new_address->id_customer 	= $ps_address->id_customer;
						$new_address->lastname 		= $ps_address->lastname;
						$new_address->firstname 	= $ps_address->firstname;
						$new_address->company 		= Tools::substr($address_icirelais['company'], 0, 23).' ('.$address_icirelais['relay_id'].')';
						$new_address->address1 		= Tools::substr($address_icirelais['address1'], 0, 128);
						$new_address->address2 		= Tools::substr($address_icirelais['address2'], 0, 128);
						$new_address->postcode		= $address_icirelais['postcode'];
						$new_address->city 			= $address_icirelais['city'];
						$new_address->phone 		= $ps_address->phone;
						$new_address->phone_mobile 	= $ps_address->phone_mobile;
						$new_address->id_country 	= $address_icirelais['id_country'];
						$new_address->alias 		= 'ICI RELAIS '.$address_icirelais['relay_id'];
						$new_address->deleted 		= 1;
						$new_address->add();
						$id_address_delivery = (int)$new_address->id;
					}
				}
				// Update order
				$order->id_address_delivery = $id_address_delivery;
				$order->update();
			break;

			case (Configuration::get('EXAPAQ_PREDICT_CARRIER_ID')):
				$order = $params['order'];
				$cart = $params['cart'];
				$id_address_delivery = 0;

				// Predict address will become one of customer's
				$address_predict = self::getDeliveryInfos($cart->id);
				if (is_array($address_predict) && !empty($address_predict['gsm_dest']))
				{
					// Check if the Predict address already exists
					$return = Db::getInstance()->GetRow('SELECT id_address, company, lastname, firstname, address1, address2, postcode, city, phone_mobile
									FROM '._DB_PREFIX_.'address
									WHERE id_customer = '.(int)$order->id_customer.'
										AND alias LIKE "PREDICT '.pSQL($address_predict['gsm_dest']).'"
									ORDER BY id_address DESC');

					// Predict address already exists for this customer => get id_address
					if (is_array($return))
					{
						$ps_address = new Address((int)$return['id_address']);
						if ($ps_address->phone_mobile == $address_predict['gsm_dest'])
							$id_address_delivery = (int)$ps_address->id;
					}

					// Predict address does not exist for this customer => create it
					if ($id_address_delivery == 0)
					{
						$ps_address = new Address($cart->id_address_delivery);
						$new_address = new Address();
						$new_address->id_customer 	= $ps_address->id_customer;
						$new_address->lastname 		= $ps_address->lastname;
						$new_address->firstname 	= $ps_address->firstname;
						$new_address->company 		= $ps_address->company;
						$new_address->address1 		= $ps_address->address1;
						$new_address->address2 		= $ps_address->address2;
						$new_address->postcode		= $ps_address->postcode;
						$new_address->city 			= $ps_address->city;
						$new_address->id_country 	= $ps_address->id_country;
						$new_address->phone 		= $ps_address->phone;
						$new_address->phone_mobile 	= $address_predict['gsm_dest'];
						$new_address->alias 		= 'PREDICT '.$address_predict['gsm_dest'];
						$new_address->deleted 		= 1;
						$new_address->add();
						$id_address_delivery = (int)$new_address->id;
					}
				}
				// Update order
				$order->id_address_delivery = $id_address_delivery;
				$order->update();
			break;
		}
	}

	/* Maintains EXAPAQ Carriers' ID up to date */
	public function hookupdateCarrier($params)
	{
		if ((int)$params['id_carrier'] == (int)Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_ID'))
		{
			Configuration::updateValue('EXAPAQ_ICIRELAIS_CARRIER_ID', (int)$params['carrier']->id);
			Configuration::updateValue('EXAPAQ_ICIRELAIS_CARRIER_LOG', Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_LOG').'|'.(int)$params['carrier']->id);
		}
		if ((int)$params['id_carrier'] == (int)Configuration::get('EXAPAQ_PREDICT_CARRIER_ID'))
		{
			Configuration::updateValue('EXAPAQ_PREDICT_CARRIER_ID', (int)$params['carrier']->id);
			Configuration::updateValue('EXAPAQ_PREDICT_CARRIER_LOG', Configuration::get('EXAPAQ_PREDICT_CARRIER_LOG').'|'.(int)$params['carrier']->id);
		}
		if ((int)$params['id_carrier'] == (int)Configuration::get('EXAPAQ_CLASSIC_CARRIER_ID'))
		{
			Configuration::updateValue('EXAPAQ_CLASSIC_CARRIER_ID', (int)$params['carrier']->id);
			Configuration::updateValue('EXAPAQ_CLASSIC_CARRIER_LOG', Configuration::get('EXAPAQ_CLASSIC_CARRIER_LOG').'|'.(int)$params['carrier']->id);
		}
	}

	/* Replaces accented characters and symbols */
	public static function stripAccents($str)
	{
		$str = preg_replace('/[\x{00C0}\x{00C1}\x{00C2}\x{00C3}\x{00C4}\x{00C5}]/u', 'A', $str);
		$str = preg_replace('/[\x{0105}\x{0104}\x{00E0}\x{00E1}\x{00E2}\x{00E3}\x{00E4}\x{00E5}]/u', 'a', $str);
		$str = preg_replace('/[\x{00C7}\x{0106}\x{0108}\x{010A}\x{010C}]/u', 'C', $str);
		$str = preg_replace('/[\x{00E7}\x{0107}\x{0109}\x{010B}\x{010D}}]/u', 'c', $str);
		$str = preg_replace('/[\x{010E}\x{0110}]/u', 'D', $str);
		$str = preg_replace('/[\x{010F}\x{0111}]/u', 'd', $str);
		$str = preg_replace('/[\x{00C8}\x{00C9}\x{00CA}\x{00CB}\x{0112}\x{0114}\x{0116}\x{0118}\x{011A}]/u', 'E', $str);
		$str = preg_replace('/[\x{00E8}\x{00E9}\x{00EA}\x{00EB}\x{0113}\x{0115}\x{0117}\x{0119}\x{011B}]/u', 'e', $str);
		$str = preg_replace('/[\x{00CC}\x{00CD}\x{00CE}\x{00CF}\x{0128}\x{012A}\x{012C}\x{012E}\x{0130}]/u', 'I', $str);
		$str = preg_replace('/[\x{00EC}\x{00ED}\x{00EE}\x{00EF}\x{0129}\x{012B}\x{012D}\x{012F}\x{0131}]/u', 'i', $str);
		$str = preg_replace('/[\x{0142}\x{0141}\x{013E}\x{013A}]/u', 'l', $str);
		$str = preg_replace('/[\x{00F1}\x{0148}]/u', 'n', $str);
		$str = preg_replace('/[\x{00D2}\x{00D3}\x{00D4}\x{00D5}\x{00D6}\x{00D8}]/u', 'O', $str);
		$str = preg_replace('/[\x{00F2}\x{00F3}\x{00F4}\x{00F5}\x{00F6}\x{00F8}]/u', 'o', $str);
		$str = preg_replace('/[\x{0159}\x{0155}]/u', 'r', $str);
		$str = preg_replace('/[\x{015B}\x{015A}\x{0161}]/u', 's', $str);
		$str = preg_replace('/[\x{00DF}]/u', 'ss', $str);
		$str = preg_replace('/[\x{0165}]/u', 't', $str);
		$str = preg_replace('/[\x{00D9}\x{00DA}\x{00DB}\x{00DC}\x{016E}\x{0170}\x{0172}]/u', 'U', $str);
		$str = preg_replace('/[\x{00F9}\x{00FA}\x{00FB}\x{00FC}\x{016F}\x{0171}\x{0173}]/u', 'u', $str);
		$str = preg_replace('/[\x{00FD}\x{00FF}]/u', 'y', $str);
		$str = preg_replace('/[\x{017C}\x{017A}\x{017B}\x{0179}\x{017E}]/u', 'z', $str);
		$str = preg_replace('/[\x{00C6}]/u', 'AE', $str);
		$str = preg_replace('/[\x{00E6}]/u', 'ae', $str);
		$str = preg_replace('/[\x{0152}]/u', 'OE', $str);
		$str = preg_replace('/[\x{0153}]/u', 'oe', $str);
		$str = preg_replace('/[\x{0022}\x{0025}\x{0026}\x{0027}\x{00A1}\x{00A2}\x{00A3}\x{00A4}\x{00A5}\x{00A6}\x{00A7}\x{00A8}\x{00AA}\x{00AB}\x{00AC}\x{00AD}\x{00AE}\x{00AF}\x{00B0}\x{00B1}\x{00B2}\x{00B3}\x{00B4}\x{00B5}\x{00B6}\x{00B7}\x{00B8}\x{00BA}\x{00BB}\x{00BC}\x{00BD}\x{00BE}\x{00BF}]/u', ' ', $str);
		$str = Tools::strtoupper($str);
		return $str;
	}

	/* MyPudo webservice calling method */
	public function getPoints($input)
	{
		$ici_relais_points = array();
		$serviceurl = Configuration::get('EXAPAQ_ICIRELAIS_MYPUDO_URL');
		$date = date('d/m/Y');
		$this->address 	= self::stripAccents($input['address1']);
		$this->zipcode 	= $input['postcode'];
		$this->city 	= self::stripAccents($input['city']);
		// Zip code is mandatory
		if (empty($this->zipcode))
		{
			$ici_relais_points['error'] = $this->l('Postal code in missing in the address. Please, modify it.');
			return $ici_relais_points;
		}

		// MyPudo call parameters
		$variables = array(
			'carrier'=>'EXA',
			'key'=> 'deecd7bc81b71fcc0e292b53e826c48f',
			'address'=> $this->address,
			'zipCode'=> $this->zipcode,
			'city'=> $this->city,
			'countrycode'=>'FR',
			'requestID'=>'1234',
			'request_id'=>'1234',
			'date_from'=>$date,
			'max_pudo_number'=>'',
			'max_distance_search'=>'',
			'weight'=>'',
			'category'=>'',
			'holiday_tolerant'=>''
		);

		try{
			ini_set('default_socket_timeout', 5);
			$soappudo = new SoapClient($serviceurl, array('connection_timeout' => 5, 'cache_wsdl' => WSDL_CACHE_NONE, 'exceptions' => true));
			$GetPudoList = $soappudo->getPudoList($variables)->GetPudoListResult->any;

			// Get the webservice XML response and parse its values
			$xml = new SimpleXMLElement($GetPudoList);
				if (Tools::strlen($xml->ERROR) > 0)
					$ici_relais_points['error'] = $this->l('ICI relais is not available at the moment, please try again shortly.');
				else
				{
					$relais_items = $xml->PUDO_ITEMS;
					// Loop through each pudo
					$i = 0;
					foreach ($relais_items->PUDO_ITEM as $item)
					{
						$point = array();
						$item = (array)$item;
						$point['relay_id']		 = $item['PUDO_ID'];
						$point['shop_name']		 = self::stripAccents($item['NAME']);
						$point['address1']		 = self::stripAccents($item['ADDRESS1']);
						if ($item['ADDRESS2'] != '')
							$point['address2']	 = self::stripAccents($item['ADDRESS2']);
						if ($item['ADDRESS3'] != '')
							$point['address3']	 = self::stripAccents($item['ADDRESS3']);
						if ($item['LOCAL_HINT'] != '')
							$point['local_hint'] = self::stripAccents($item['LOCAL_HINT']);
						$point['postal_code']	 = $item['ZIPCODE'];
						$point['city']			 = self::stripAccents($item['CITY']);
						$point['id_country']	 = $input['id_country'];
						Context::getContext()->cookie->$point['relay_id'] = serialize($point);
						$point['distance']		 = number_format($item['DISTANCE'] / 1000, 2);
						$point['coord_lat']		 = (float)strtr($item['LATITUDE'], ',', '.');
						$point['coord_long']	 = (float)strtr($item['LONGITUDE'], ',', '.');
						$days = array(1=>'monday', 2=>'tuesday', 3=>'wednesday', 4=>'thursday', 5=>'friday', 6=>'saturday', 7=>'sunday');
						if (count($item['OPENING_HOURS_ITEMS']->OPENING_HOURS_ITEM) > 0)
							foreach ($item['OPENING_HOURS_ITEMS']->OPENING_HOURS_ITEM as $oh_item)
							{
								$oh_item = (array)$oh_item;
								$point[$days[$oh_item['DAY_ID']]][] = $oh_item['START_TM'].' - '.$oh_item['END_TM'];
							}
						if (count($item['HOLIDAY_ITEMS']->HOLIDAY_ITEM) > 0)
							$x = 0;
							foreach ($item['HOLIDAY_ITEMS']->HOLIDAY_ITEM as $holiday_item)
							{
								$holiday_item = (array)$holiday_item;
								$point['closing_period'][$x] = $holiday_item['START_DTM'].' - '.$holiday_item['END_DTM'];
								++$x;
							}
						array_push($ici_relais_points, $point);
						if (++$i == 5)
							break;
					}
				}
		} catch (Exception $e){
			$ici_relais_points['error'] = $this->l('ICI relais is not available at the moment, please try again shortly.');
		}
		return $ici_relais_points;
	}

	private function installModuleTab($tab_class, $tab_name, $id_tab_parent)
	{
		if (!copy(_PS_MODULE_DIR_.$this->name.'/AdminExapaq.gif', _PS_IMG_DIR_.'t/'.$tab_class.'.gif'))
			return false;
		$tab = new Tab();

		$languages = Language::getLanguages(false);
		foreach ($languages as $language)
			$tab->name[$language['id_lang']] = $tab_name;
		$tab->class_name = $tab_class;
		$tab->module = $this->name;
		$tab->id_parent = $id_tab_parent;

		if (!$tab->save())
			return false;
		return true;
	}

	private function uninstallModuleTab($tab_class)
	{
		$id_tab = Tab::getIdFromClassName($tab_class);
		if ($id_tab != 0)
		{
			$tab = new Tab($id_tab);
			$tab->delete();
			return true;
		}
		return false;
	}

	/* Carrier creation function */
	public static function createCarrier($config, $type)
	{
		$carrier = new Carrier();
		$carrier->name = $config['name'];
		$carrier->id_tax_rules_group = $config['id_tax_rules_group'];
		$carrier->id_zone = $config['id_zone'];
		$carrier->url = $config['url'];
		$carrier->active = $config['active'];
		$carrier->deleted = $config['deleted'];
		$carrier->delay = $config['delay'];
		$carrier->shipping_handling = $config['shipping_handling'];
		$carrier->range_behavior = $config['range_behavior'];
		$carrier->is_module = ((_PS_VERSION_ < '1.4') ? false : true);
		$carrier->shipping_external = $config['shipping_external'];
		$carrier->external_module_name = $config['external_module_name'];
		$carrier->need_range = $config['need_range'];
		$carrier->grade = $config['grade'];

		$languages = Language::getLanguages(true);
		foreach ($languages as $language)
		{
			if ($language['iso_code'] == 'fr')
				$carrier->delay[$language['id_lang']] = $config['delay'][$language['iso_code']];
			if ($language['iso_code'] == 'en')
				$carrier->delay[$language['id_lang']] = $config['delay'][$language['iso_code']];
			if ($language['iso_code'] == 'es')
				$carrier->delay[$language['id_lang']] = $config['delay'][$language['iso_code']];
			if ($language['iso_code'] == 'it')
				$carrier->delay[$language['id_lang']] = $config['delay'][$language['iso_code']];
			if ($language['iso_code'] == 'de')
				$carrier->delay[$language['id_lang']] = $config['delay'][$language['iso_code']];
		}

		if ($carrier->add())
		{
			$groups = Group::getgroups(true);
			foreach ($groups as $group)
				Db::getInstance()->execute('INSERT INTO '._DB_PREFIX_.'carrier_group VALUE (\''.(int)$carrier->id.'\',\''.(int)$group['id_group'].'\')');
			// Price range creation
			$range_price = new RangePrice();
			$range_price->id_carrier = $carrier->id;
			$range_price->delimiter1 = '0';
			$range_price->delimiter2 = '10000';
			$range_price->add();
			// Weight range creation
			$range_weight = new RangeWeight();
			$range_weight->id_carrier = $carrier->id;
			$range_weight->delimiter1 = '0';
			if ($type == 'icirelais')
				$range_weight->delimiter2 = '20';
			else
				$range_weight->delimiter2 = '30';
			$range_weight->add();
			// Assign carrier to France zone but DPD World carrier
			if ($type == 'world')
				$sql = 'SELECT id_zone FROM '._DB_PREFIX_.'zone WHERE name NOT LIKE \'%France%\'';
			else
				$sql = 'SELECT id_zone FROM '._DB_PREFIX_.'zone WHERE name LIKE \'%France%\'';
			$res = Db::getInstance()->ExecuteS($sql);
			foreach ($res as $zone)
			{
				Db::getInstance()->execute('INSERT INTO '._DB_PREFIX_.'carrier_zone  (id_carrier, id_zone) VALUE (\''.(int)$carrier->id.'\',\''.(int)$zone['id_zone'].'\')');
				Db::getInstance()->execute('INSERT INTO '._DB_PREFIX_.'delivery (id_carrier, id_range_price, id_range_weight, id_zone, price) VALUE (\''.(int)$carrier->id.'\',\''.(int)$range_price->id.'\',NULL,\''.(int)$zone['id_zone'].'\',\'5.95\')');
				Db::getInstance()->execute('INSERT INTO '._DB_PREFIX_.'delivery (id_carrier, id_range_price, id_range_weight, id_zone, price) VALUE (\''.(int)$carrier->id.'\',NULL,\''.(int)$range_weight->id.'\',\''.(int)$zone['id_zone'].'\',\'5.95\')');
			}
			// Logo copy
			if (!copy(dirname(__FILE__).'/img/front/'.$type.'/carrier_logo.jpg', _PS_SHIP_IMG_DIR_.'/'.$carrier->id.'.jpg'))
				return false;
			return true;
		}
		return false;
	}

	/* When a carrier is hooked to EXAPAQ module, sets some parameters */
	public function reaffectationCarrier($id_carrier)
	{
		Db::getInstance()->execute('
			UPDATE '._DB_PREFIX_.'carrier 
			SET	shipping_handling = 0,
				is_module = 1,
				shipping_external = 1,
				need_range = 1,
				external_module_name = "exapaq"
			WHERE  id_carrier = '.(int)$id_carrier);
	}
}
